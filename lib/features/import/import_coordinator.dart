import 'dart:async';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../core/image_processing/image_tools.dart';
import '../../core/ocr/ocr_service.dart';
import '../../core/storage/saf_storage.dart';

class ImportProgress {
  const ImportProgress({
    required this.completed,
    required this.total,
    required this.message,
  });
  final int completed;
  final int total;
  final String message;
}

class ImportSummary {
  const ImportSummary({
    required this.imported,
    required this.duplicatesDeleted,
    required this.pendingReview,
    required this.failures,
  });
  final int imported;
  final int duplicatesDeleted;
  final int pendingReview;
  final List<String> failures;
}

class ImportCoordinator {
  ImportCoordinator(this.database, this.storage, this.ocr);

  final AppDatabase database;
  final SafStorage storage;
  final OcrService ocr;
  final _uuid = const Uuid();
  Future<void> _mutationTail = Future.value();

  Future<T> _serialize<T>(Future<T> Function() action) {
    final result = Completer<T>();
    _mutationTail = _mutationTail.catchError((_) {}).then((_) async {
      try {
        result.complete(await action());
      } catch (error, stack) {
        result.completeError(error, stack);
      }
    });
    return result.future;
  }

  Future<ImportSummary> refresh({
    void Function(ImportProgress progress)? onProgress,
  }) => _serialize(() async {
    await recoverPendingOperations();
    final documents = await storage.listImages();
    final known = await database.select(database.sheetAssets).get();
    final liveUris = documents.map((document) => document.uri).toSet();
    for (final asset in known.where(
      (asset) => !liveUris.contains(asset.documentUri),
    )) {
      await (database.update(
        database.sheetAssets,
      )..where((row) => row.id.equals(asset.id))).write(
        SheetAssetsCompanion(
          availabilityState: const Value('missing'),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }

    var imported = 0;
    var deleted = 0;
    var pending = 0;
    final failures = <String>[];
    for (var index = 0; index < documents.length; index++) {
      final document = documents[index];
      onProgress?.call(
        ImportProgress(
          completed: index,
          total: documents.length,
          message: 'Checking ${document.name}',
        ),
      );
      final fingerprint =
          '${document.size}:${document.lastModified?.millisecondsSinceEpoch ?? 0}';
      final existing = await database.assetByUri(document.uri);
      if (existing?.contentFingerprint == fingerprint &&
          existing?.processingVersion == 1) {
        continue;
      }
      try {
        final outcome = await _process(document, fingerprint, existing);
        imported += outcome == _Outcome.imported ? 1 : 0;
        deleted += outcome == _Outcome.duplicateDeleted ? 1 : 0;
        pending += outcome == _Outcome.pendingReview ? 1 : 0;
      } catch (error) {
        failures.add('${document.name}: $error');
      }
    }
    onProgress?.call(
      ImportProgress(
        completed: documents.length,
        total: documents.length,
        message: 'Library is up to date',
      ),
    );
    return ImportSummary(
      imported: imported,
      duplicatesDeleted: deleted,
      pendingReview: pending,
      failures: failures,
    );
  });

  Future<_Outcome> _process(
    SafDocument document,
    String inputFingerprint,
    AssetRecord? existingAtUri,
  ) async {
    final now = DateTime.now();
    final jobId = _uuid.v4();
    await database
        .into(database.importJobs)
        .insert(
          ImportJobsCompanion.insert(
            id: jobId,
            sourceUri: document.uri,
            inputFingerprint: inputFingerprint,
            state: 'reading',
            createdAt: now,
            updatedAt: now,
          ),
        );
    try {
      final bytes = await storage.readBytes(document.uri);
      final digest = await Isolate.run(() => sha256.convert(bytes).toString());
      final byteMatches = (await database.assetsBySha(
        digest,
      )).where((asset) => asset.documentUri != document.uri).toList();
      for (final retained in byteMatches) {
        if (await _verifiedRetained(retained, digest) &&
            await _deleteVerifiedDuplicate(
              document,
              retained,
              digest,
              existingAtUri,
            )) {
          await _completeJob(jobId, 'duplicate_deleted');
          return _Outcome.duplicateDeleted;
        }
      }

      final facts = await Isolate.run(() => inspectDecodedPixels(bytes));
      final pixelMatches =
          (await database.assetsByPixelFingerprint(facts.pixelFingerprint))
              .where(
                (asset) =>
                    asset.documentUri != document.uri &&
                    asset.width == facts.width &&
                    asset.height == facts.height,
              )
              .toList();
      for (final retained in pixelMatches) {
        if (await _verifiedPixels(retained, facts.pixelFingerprint) &&
            await _deleteVerifiedDuplicate(
              document,
              retained,
              digest,
              existingAtUri,
              expectedPixelFingerprint: facts.pixelFingerprint,
            )) {
          await _completeJob(jobId, 'duplicate_deleted');
          return _Outcome.duplicateDeleted;
        }
      }

      await _setJob(jobId, 'ocr');
      final analysis = await ocr.recognizeSheet(bytes);
      final assetId = existingAtUri?.id ?? _uuid.v4();
      String uri = document.uri;
      String filename = document.name;
      String? editionId = existingAtUri?.editionId;
      if (!analysis.needsReview && analysis.title != null) {
        editionId = await _ensureEdition(
          analysis.title!,
          analysis.keyLabel,
          existingAtUri?.editionId,
        );
        if (document.canRename) {
          final desired = buildFilename(
            analysis.title!,
            keyLabel: analysis.keyLabel,
            page: existingAtUri?.pageOrder ?? 1,
            stableSuffix: assetId.replaceAll('-', '').substring(0, 4),
            extension: p.extension(document.name),
          );
          final renamed = await _renameJournaled(document.uri, desired, digest);
          uri = renamed.uri;
          filename = renamed.name;
        }
      }
      final companion = SheetAssetsCompanion.insert(
        id: assetId,
        editionId: Value(editionId),
        documentUri: uri,
        filename: filename,
        mimeType: document.mimeType,
        byteSize: bytes.length,
        sha256: digest,
        pixelFingerprint: Value(analysis.facts.pixelFingerprint),
        width: Value(analysis.facts.width),
        height: Value(analysis.facts.height),
        pageOrder: Value(existingAtUri?.pageOrder ?? 1),
        extractedTitle: Value(analysis.title),
        normalizedTitle: Value(analysis.normalizedTitle),
        rawOcr: Value(analysis.rawText),
        qualityScore: Value(analysis.quality),
        reviewState: Value(analysis.needsReview ? 'pending' : 'confirmed'),
        availabilityState: const Value('available'),
        contentFingerprint: inputFingerprint,
        modifiedAt: Value(document.lastModified),
        createdAt: existingAtUri?.createdAt ?? now,
        updatedAt: now,
      );
      if (existingAtUri == null) {
        await database.into(database.sheetAssets).insert(companion);
      } else {
        await (database.update(
          database.sheetAssets,
        )..where((row) => row.id.equals(existingAtUri.id))).write(companion);
      }
      await _completeJob(
        jobId,
        analysis.needsReview ? 'pending_review' : 'completed',
      );
      return analysis.needsReview ? _Outcome.pendingReview : _Outcome.imported;
    } catch (error) {
      await (database.update(
        database.importJobs,
      )..where((row) => row.id.equals(jobId))).write(
        ImportJobsCompanion(
          state: const Value('failed'),
          error: Value(error.toString()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      rethrow;
    }
  }

  Future<bool> _verifiedRetained(
    AssetRecord retained,
    String expectedSha,
  ) async {
    if (!await storage.exists(retained.documentUri)) return false;
    final bytes = await storage.readBytes(retained.documentUri);
    return sha256.convert(bytes).toString() == expectedSha;
  }

  Future<bool> _verifiedPixels(
    AssetRecord retained,
    String expectedPixelFingerprint,
  ) async {
    if (!await storage.exists(retained.documentUri)) return false;
    final bytes = await storage.readBytes(retained.documentUri);
    final facts = await Isolate.run(() => inspectDecodedPixels(bytes));
    return facts.pixelFingerprint == expectedPixelFingerprint;
  }

  Future<bool> _deleteVerifiedDuplicate(
    SafDocument duplicate,
    AssetRecord retained,
    String expectedSha,
    AssetRecord? existingDuplicate, {
    String? expectedPixelFingerprint,
  }) async {
    if (!duplicate.canDelete ||
        duplicate.uri == retained.documentUri ||
        await storage.sameDocument(duplicate.uri, retained.documentUri) ||
        !await storage.exists(retained.documentUri)) {
      return false;
    }
    final operationId = _uuid.v4();
    final now = DateTime.now();
    await database
        .into(database.fileOperations)
        .insert(
          FileOperationsCompanion.insert(
            id: operationId,
            kind: 'delete',
            sourceUri: duplicate.uri,
            retainedAssetId: Value(retained.id),
            expectedFingerprint: expectedPixelFingerprint == null
                ? 'sha:$expectedSha'
                : 'pixel:$expectedPixelFingerprint;source:$expectedSha',
            state: 'planned',
            createdAt: now,
            updatedAt: now,
          ),
        );
    if (existingDuplicate != null) {
      await database.transaction(() async {
        if (existingDuplicate.editionId != null && retained.editionId != null) {
          await (database.update(database.serviceEntries)..where(
                (row) => row.editionId.equals(existingDuplicate.editionId!),
              ))
              .write(
                ServiceEntriesCompanion(
                  editionId: Value(retained.editionId),
                  status: const Value('matched'),
                ),
              );
        }
        await (database.delete(
          database.sheetAssets,
        )..where((row) => row.id.equals(existingDuplicate.id))).go();
        await _setOperation(operationId, 'references_committed');
      });
    } else {
      await _setOperation(operationId, 'references_committed');
    }
    try {
      final current = await storage.readBytes(duplicate.uri);
      if (sha256.convert(current).toString() != expectedSha) {
        throw StateError('The duplicate changed before deletion.');
      }
      if (!await storage.exists(retained.documentUri)) {
        throw StateError('The retained master is no longer readable.');
      }
      final retainedBytes = await storage.readBytes(retained.documentUri);
      if (expectedPixelFingerprint == null) {
        if (sha256.convert(retainedBytes).toString() != expectedSha) {
          throw StateError('The retained master changed before deletion.');
        }
      } else {
        final retainedFacts = await Isolate.run(
          () => inspectDecodedPixels(retainedBytes),
        );
        if (retainedFacts.pixelFingerprint != expectedPixelFingerprint) {
          throw StateError(
            'The retained master pixels changed before deletion.',
          );
        }
      }
      final removed = await storage.delete(duplicate.uri);
      if (!removed) {
        throw StateError('The document provider did not delete the duplicate.');
      }
      await _setOperation(operationId, 'filesystem_done');
      return true;
    } catch (error) {
      await (database.update(
        database.fileOperations,
      )..where((row) => row.id.equals(operationId))).write(
        FileOperationsCompanion(
          state: const Value('cleanup_pending'),
          error: Value(error.toString()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return false;
    }
  }

  Future<({String uri, String name})> _renameJournaled(
    String sourceUri,
    String desiredName,
    String expectedSha,
  ) async {
    final operationId = _uuid.v4();
    final now = DateTime.now();
    await database
        .into(database.fileOperations)
        .insert(
          FileOperationsCompanion.insert(
            id: operationId,
            kind: 'rename',
            sourceUri: sourceUri,
            destinationName: Value(desiredName),
            expectedFingerprint: expectedSha,
            state: 'planned',
            createdAt: now,
            updatedAt: now,
          ),
        );
    final current = await storage.readBytes(sourceUri);
    if (sha256.convert(current).toString() != expectedSha) {
      throw StateError('The file changed before rename.');
    }
    final resultUri = await storage.rename(sourceUri, desiredName);
    final metadata = await storage.metadata(resultUri);
    await (database.update(
      database.fileOperations,
    )..where((row) => row.id.equals(operationId))).write(
      FileOperationsCompanion(
        resultUri: Value(resultUri),
        state: const Value('filesystem_done'),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return (uri: resultUri, name: metadata.name);
  }

  Future<String> _ensureEdition(
    String title,
    String? keyLabel,
    String? existingEditionId,
  ) async {
    if (existingEditionId != null) return existingEditionId;
    final normalized = normalizeTitle(title);
    final existingSongs = await (database.select(
      database.songs,
    )..where((row) => row.normalizedTitle.equals(normalized))).get();
    final songId = existingSongs.isEmpty ? _uuid.v4() : existingSongs.first.id;
    if (existingSongs.isEmpty) {
      final now = DateTime.now();
      await database
          .into(database.songs)
          .insert(
            SongsCompanion.insert(
              id: songId,
              displayTitle: title.trim(),
              normalizedTitle: normalized,
              createdAt: now,
              updatedAt: now,
            ),
          );
    }
    final existingEditions =
        await (database.select(database.editions)..where(
              (row) =>
                  row.songId.equals(songId) &
                  (keyLabel == null
                      ? row.keyLabel.isNull()
                      : row.keyLabel.equals(keyLabel)),
            ))
            .get();
    if (existingEditions.length == 1) return existingEditions.single.id;
    final editionId = _uuid.v4();
    await database
        .into(database.editions)
        .insert(
          EditionsCompanion.insert(
            id: editionId,
            songId: songId,
            keyLabel: Value(keyLabel),
          ),
        );
    return editionId;
  }

  Future<void> confirmAsset(
    AssetRecord asset, {
    required String title,
    String? keyLabel,
    int page = 1,
  }) => _serialize(() async {
    final bytes = await storage.readBytes(asset.documentUri);
    final currentSha = sha256.convert(bytes).toString();
    if (currentSha != asset.sha256) {
      throw StateError('The image changed; refresh before confirming it.');
    }
    final editionId = await _ensureEdition(title, keyLabel, asset.editionId);
    var uri = asset.documentUri;
    var filename = asset.filename;
    final metadata = await storage.metadata(uri);
    if (metadata.canRename) {
      final desired = buildFilename(
        title,
        keyLabel: keyLabel,
        page: page,
        stableSuffix: asset.id.replaceAll('-', '').substring(0, 4),
        extension: p.extension(asset.filename),
      );
      final renamed = await _renameJournaled(uri, desired, currentSha);
      uri = renamed.uri;
      filename = renamed.name;
    }
    await (database.update(
      database.sheetAssets,
    )..where((row) => row.id.equals(asset.id))).write(
      SheetAssetsCompanion(
        editionId: Value(editionId),
        documentUri: Value(uri),
        filename: Value(filename),
        extractedTitle: Value(title.trim()),
        normalizedTitle: Value(normalizeTitle(title)),
        pageOrder: Value(page),
        reviewState: const Value('confirmed'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  });

  Future<void> recoverPendingOperations() async {
    final operations =
        await (database.select(database.fileOperations)..where(
              (row) => row.state.isIn([
                'planned',
                'references_committed',
                'cleanup_pending',
              ]),
            ))
            .get();
    for (final operation in operations) {
      try {
        if (operation.kind == 'rename') {
          if (!await storage.exists(operation.sourceUri)) {
            if (operation.resultUri != null &&
                await storage.exists(operation.resultUri!)) {
              await _setOperation(operation.id, 'filesystem_done');
            }
            continue;
          }
          final bytes = await storage.readBytes(operation.sourceUri);
          if (sha256.convert(bytes).toString() !=
              operation.expectedFingerprint) {
            continue;
          }
          final uri = await storage.rename(
            operation.sourceUri,
            operation.destinationName!,
          );
          await (database.update(
            database.fileOperations,
          )..where((row) => row.id.equals(operation.id))).write(
            FileOperationsCompanion(
              resultUri: Value(uri),
              state: const Value('filesystem_done'),
              updatedAt: Value(DateTime.now()),
            ),
          );
        } else if (operation.kind == 'delete' &&
            await storage.exists(operation.sourceUri)) {
          final retained = operation.retainedAssetId == null
              ? null
              : await (database.select(database.sheetAssets)..where(
                      (row) => row.id.equals(operation.retainedAssetId!),
                    ))
                    .getSingleOrNull();
          if (retained == null || !await storage.exists(retained.documentUri)) {
            continue;
          }
          if (await storage.sameDocument(
            operation.sourceUri,
            retained.documentUri,
          )) {
            continue;
          }
          final sourceBytes = await storage.readBytes(operation.sourceUri);
          final sourceSha = sha256.convert(sourceBytes).toString();
          final expected = operation.expectedFingerprint;
          final expectedSourceSha = expected.startsWith('sha:')
              ? expected.substring(4)
              : RegExp(r';source:(.+)$').firstMatch(expected)?.group(1);
          if (sourceSha != expectedSourceSha) {
            continue;
          }
          final retainedBytes = await storage.readBytes(retained.documentUri);
          if (expected.startsWith('sha:')) {
            if (sha256.convert(retainedBytes).toString() != expectedSourceSha) {
              continue;
            }
          } else if (expected.startsWith('pixel:')) {
            final separator = expected.indexOf(';source:');
            if (separator < 0) continue;
            final pixelFingerprint = expected.substring(6, separator);
            final retainedFacts = await Isolate.run(
              () => inspectDecodedPixels(retainedBytes),
            );
            if (retainedFacts.pixelFingerprint != pixelFingerprint) continue;
          } else {
            continue;
          }
          if (await storage.delete(operation.sourceUri)) {
            await _setOperation(operation.id, 'filesystem_done');
          }
        }
      } catch (error) {
        await (database.update(
          database.fileOperations,
        )..where((row) => row.id.equals(operation.id))).write(
          FileOperationsCompanion(
            state: const Value('cleanup_pending'),
            error: Value(error.toString()),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    }
  }

  Future<void> _setJob(String id, String state) =>
      (database.update(
        database.importJobs,
      )..where((row) => row.id.equals(id))).write(
        ImportJobsCompanion(
          state: Value(state),
          attempts: const Value(1),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> _completeJob(String id, String state) => _setJob(id, state);

  Future<void> _setOperation(String id, String state) =>
      (database.update(
        database.fileOperations,
      )..where((row) => row.id.equals(id))).write(
        FileOperationsCompanion(
          state: Value(state),
          error: const Value(null),
          updatedAt: Value(DateTime.now()),
        ),
      );
}

enum _Outcome { imported, duplicateDeleted, pendingReview }

String buildFilename(
  String title, {
  String? keyLabel,
  required int page,
  required String stableSuffix,
  required String extension,
}) {
  var safe = title
      .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .replaceAll(RegExp(r'[. ]+$'), '');
  if (safe.isEmpty) safe = 'Untitled';
  if (safe.length > 90) safe = safe.substring(0, 90).trimRight();
  final key = keyLabel == null || keyLabel.trim().isEmpty
      ? ''
      : '__${keyLabel.trim()}';
  final ext = extension.isEmpty ? '.jpg' : extension.toLowerCase();
  return '$safe${key}__p${page.toString().padLeft(2, '0')}__$stableSuffix$ext';
}
