import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../core/image_processing/image_tools.dart';
import '../../core/ocr/ocr_service.dart';
import '../../core/storage/saf_storage.dart';

const currentProcessingVersion = 2;

class ScanConfiguration {
  const ScanConfiguration({
    required this.startDate,
    required this.endDate,
    required this.endAtToday,
  });

  final DateTime startDate;
  final DateTime endDate;
  final bool endAtToday;

  DateTime get effectiveEnd {
    final value = endAtToday ? DateTime.now() : endDate;
    return DateTime(value.year, value.month, value.day);
  }

  bool includes(DateTime value) {
    final day = DateTime(value.year, value.month, value.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = effectiveEnd;
    return !day.isBefore(start) && !day.isAfter(end);
  }
}

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
    required this.nonSongSheets,
    required this.excluded,
    required this.unchangedSkipped,
    required this.failures,
    required this.timingsMicros,
  });
  final int imported;
  final int duplicatesDeleted;
  final int pendingReview;
  final int nonSongSheets;
  final int excluded;
  final int unchangedSkipped;
  final List<String> failures;
  final Map<String, int> timingsMicros;
}

class ScanCancelledException implements Exception {
  const ScanCancelledException();
  @override
  String toString() => 'Scan cancelled because its configuration changed';
}

class ImportCoordinator {
  ImportCoordinator(this.database, this.storage, this.ocr);

  final AppDatabase database;
  final SafStorage storage;
  final OcrService ocr;
  final _uuid = const Uuid();
  Future<void> _mutationTail = Future.value();
  int _scanGeneration = 0;

  void cancelActiveScan() => _scanGeneration++;

  void _checkScan(int generation) {
    if (generation != _scanGeneration) throw const ScanCancelledException();
  }

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

  Future<ScanConfiguration> loadConfiguration() async {
    final now = DateTime.now();
    final startText = await database.setting('scan_start_date');
    final endText = await database.setting('scan_end_date');
    final todayText = await database.setting('scan_end_today');
    return ScanConfiguration(
      startDate:
          DateTime.tryParse(startText ?? '') ??
          DateTime(now.year, now.month, now.day),
      endDate:
          DateTime.tryParse(endText ?? '') ??
          DateTime(now.year, now.month, now.day),
      endAtToday: todayText == null || todayText == 'true',
    );
  }

  Future<void> saveConfiguration(ScanConfiguration value) async {
    cancelActiveScan();
    await database.transaction(() async {
      await database.setSetting('scan_start_date', _dateKey(value.startDate));
      await database.setSetting('scan_end_date', _dateKey(value.endDate));
      await database.setSetting('scan_end_today', '${value.endAtToday}');
    });
  }

  Future<ImportSummary> refresh({
    void Function(ImportProgress progress)? onProgress,
  }) {
    final generation = _scanGeneration;
    return _serialize(() async {
    _checkScan(generation);
    final totalWatch = Stopwatch()..start();
    final totals = <String, int>{};
    final config = await loadConfiguration();
    await recoverPendingOperations(config: config);
    _checkScan(generation);
    final folders = await database.select(database.sourceFolders).get();
    final documents = <({SourceFolderRecord folder, SafDocument document})>[];
    final discoveryWatch = Stopwatch()..start();
    for (final folder in folders) {
      _checkScan(generation);
      final found = await storage.listImages(
        folder.treeUri,
        includeSubfolders: folder.includeSubfolders,
      );
      _checkScan(generation);
      documents.addAll(
        found.map((document) => (folder: folder, document: document)),
      );
    }
    totals['discovery'] = discoveryWatch.elapsedMicroseconds;

    var imported = 0;
    var deleted = 0;
    var pending = 0;
    var nonSongs = 0;
    var excluded = 0;
    var skipped = 0;
    final failures = <String>[];
    for (var index = 0; index < documents.length; index++) {
      _checkScan(generation);
      final item = documents[index];
      final document = item.document;
      onProgress?.call(
        ImportProgress(
          completed: index,
          total: documents.length,
          message: 'Checking ${document.name}',
        ),
      );
      final eligibilityWatch = Stopwatch()..start();
      final existing = await database.discoveryByIdentityOrUri(
        document.stableIdentity,
        document.uri,
      );
      final firstSeen = existing?.firstSeenAt ?? DateTime.now();
      final eligibilityDate = document.providerAddedAt ?? firstSeen;
      final dateSource = document.providerAddedAt == null
          ? 'first_seen'
          : 'provider_added';
      final fingerprint =
          '${document.size}:${document.lastModified?.millisecondsSinceEpoch ?? 0}';
      final eligible = config.includes(eligibilityDate);
      final eligibilityMicros = eligibilityWatch.elapsedMicroseconds;

      _checkScan(generation);
      var discovery = await _upsertDiscoveryMetadata(
        existing: existing,
        folder: item.folder,
        document: document,
        firstSeen: firstSeen,
        eligibilityDate: eligibilityDate,
        dateSource: dateSource,
        fingerprint: fingerprint,
        eligible: eligible,
        eligibilityMicros: eligibilityMicros,
      );
      if (!eligible) {
        excluded++;
        continue;
      }
      final unchanged =
          existing != null && existing.metadataFingerprint == fingerprint;
      if (unchanged &&
          const {
            'completed',
            'non_song_sheet',
            'uncertain',
            'duplicate_deleted',
            'failed',
          }.contains(existing.processingState)) {
        skipped++;
        continue;
      }
      try {
        _checkScan(generation);
        final outcome = await _classifyAndProcess(document, discovery, config, generation);
        imported += outcome == _Outcome.imported ? 1 : 0;
        deleted += outcome == _Outcome.duplicateDeleted ? 1 : 0;
        pending += outcome == _Outcome.pendingReview ? 1 : 0;
        nonSongs += outcome == _Outcome.nonSong ? 1 : 0;
      } on ScanCancelledException {
        rethrow;
      } catch (error) {
        failures.add('${document.name}: $error');
        await _updateDiscovery(
          discovery.id,
          DiscoveryLedgerCompanion(
            processingState: const Value('failed'),
            failureReason: Value(error.toString()),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    }
    _checkScan(generation);
    totalWatch.stop();
    totals['total'] = totalWatch.elapsedMicroseconds;
    final summary = ImportSummary(
      imported: imported,
      duplicatesDeleted: deleted,
      pendingReview: pending,
      nonSongSheets: nonSongs,
      excluded: excluded,
      unchangedSkipped: skipped,
      failures: failures,
      timingsMicros: totals,
    );
    _checkScan(generation);
    await database.setSetting(
      'last_scan_summary',
      jsonEncode({
        'at': DateTime.now().toIso8601String(),
        'discovered': documents.length,
        'imported': imported,
        'duplicatesDeleted': deleted,
        'pendingReview': pending,
        'nonSongSheets': nonSongs,
        'excluded': excluded,
        'unchangedSkipped': skipped,
        'failures': failures.length,
        'timingsMicros': totals,
      }),
    );
    onProgress?.call(
      ImportProgress(
        completed: documents.length,
        total: documents.length,
        message: 'Source scan is up to date',
      ),
    );
    return summary;
  });
  }

  Future<DiscoveryRecord> _upsertDiscoveryMetadata({
    required DiscoveryRecord? existing,
    required SourceFolderRecord folder,
    required SafDocument document,
    required DateTime firstSeen,
    required DateTime eligibilityDate,
    required String dateSource,
    required String fingerprint,
    required bool eligible,
    required int eligibilityMicros,
  }) async {
    final now = DateTime.now();
    final timings = _mergeTimings(existing?.stageTimingsJson, {
      'eligibility': eligibilityMicros,
    });
    if (existing == null) {
      final id = _uuid.v4();
      await database
          .into(database.discoveryLedger)
          .insert(
            DiscoveryLedgerCompanion.insert(
              id: id,
              stableIdentity: document.stableIdentity,
              sourceFolderId: Value(folder.id),
              documentUri: document.uri,
              parentUri: Value(document.parentUri),
              filename: document.name,
              mimeType: document.mimeType,
              byteSize: document.size,
              providerAddedAt: Value(document.providerAddedAt),
              firstSeenAt: firstSeen,
              eligibilityDate: eligibilityDate,
              dateSource: dateSource,
              modifiedAt: Value(document.lastModified),
              metadataFingerprint: fingerprint,
              processingVersion: const Value(currentProcessingVersion),
              processingState: Value(eligible ? 'discovered' : 'excluded'),
              currentUri: document.uri,
              stageTimingsJson: Value(timings),
              updatedAt: now,
            ),
          );
      return (database.select(
        database.discoveryLedger,
      )..where((row) => row.id.equals(id))).getSingle();
    }
    final changed = existing.metadataFingerprint != fingerprint;
    final nextState = !eligible
        ? 'excluded'
        : changed || existing.processingState == 'excluded'
        ? 'discovered'
        : existing.processingState;
    await _updateDiscovery(
      existing.id,
      DiscoveryLedgerCompanion(
        stableIdentity: Value(document.stableIdentity),
        sourceFolderId: Value(folder.id),
        documentUri: Value(document.uri),
        parentUri: Value(document.parentUri),
        filename: Value(document.name),
        mimeType: Value(document.mimeType),
        byteSize: Value(document.size),
        providerAddedAt: Value(document.providerAddedAt),
        eligibilityDate: Value(eligibilityDate),
        dateSource: Value(dateSource),
        modifiedAt: Value(document.lastModified),
        metadataFingerprint: Value(fingerprint),
        processingState: Value(nextState),
        failureReason: changed ? const Value(null) : const Value.absent(),
        currentUri: Value(document.uri),
        stageTimingsJson: Value(timings),
        updatedAt: Value(now),
      ),
    );
    return (database.select(
      database.discoveryLedger,
    )..where((row) => row.id.equals(existing.id))).getSingle();
  }

  Future<_Outcome> _classifyAndProcess(
    SafDocument document,
    DiscoveryRecord discovery,
    ScanConfiguration config,
    int generation,
  ) async {
    _checkScan(generation);
    await _updateDiscovery(
      discovery.id,
      DiscoveryLedgerCompanion(
        processingState: const Value('processing'),
        failureReason: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
    final timings = _decodeTimings(discovery.stageTimingsJson);
    final classifyWatch = Stopwatch()..start();
    final preview = await storage.readPreview(document.uri);
    final classification = await Isolate.run(() => classifyPreview(preview));
    _checkScan(generation);
    timings['classification'] = classifyWatch.elapsedMicroseconds;
    if (classification.classification == SheetClassification.nonSongSheet) {
      await _updateDiscovery(
        discovery.id,
        DiscoveryLedgerCompanion(
          classification: const Value('non_song_sheet'),
          classificationScore: Value(classification.score),
          processingState: const Value('non_song_sheet'),
          stageTimingsJson: Value(jsonEncode(timings)),
          lastProcessedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return _Outcome.nonSong;
    }
    if (classification.classification == SheetClassification.uncertain) {
      await _updateDiscovery(
        discovery.id,
        DiscoveryLedgerCompanion(
          classification: const Value('uncertain'),
          classificationScore: Value(classification.score),
          processingState: const Value('uncertain'),
          stageTimingsJson: Value(jsonEncode(timings)),
          lastProcessedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return _Outcome.pendingReview;
    }
    await _updateDiscovery(
      discovery.id,
      DiscoveryLedgerCompanion(
        classification: const Value('song_sheet'),
        classificationScore: Value(classification.score),
        stageTimingsJson: Value(jsonEncode(timings)),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return _processConfirmedSong(document, discovery.id, config, timings, generation);
  }

  Future<_Outcome> _processConfirmedSong(
    SafDocument document,
    String discoveryId,
    ScanConfiguration config,
    Map<String, int> timings,
    int generation,
  ) async {
    _checkScan(generation);
    if (!await _isEligibleDiscovery(discoveryId, config)) {
      await _updateDiscovery(
        discoveryId,
        DiscoveryLedgerCompanion(
          processingState: const Value('excluded'),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return _Outcome.excluded;
    }
    final existingAtUri = await database.assetByUri(document.uri);
    final readWatch = Stopwatch()..start();
    final read = await storage.readImage(document.uri);
    _checkScan(generation);
    timings['read'] = readWatch.elapsedMicroseconds;
    timings['hash'] = timings['read']!;
    final digest = read.sha256;

    final byteMatches = (await database.assetsBySha(
      digest,
    )).where((asset) => asset.documentUri != document.uri).toList();
    for (final retained in byteMatches) {
      if (await _verifiedRetained(retained, digest)) {
        final deletionWatch = Stopwatch()..start();
        final removed = await _deleteVerifiedDuplicate(
          document,
          retained,
          digest,
          existingAtUri,
          discoveryId: discoveryId,
          config: config,
        );
        timings['duplicate_deletion'] = deletionWatch.elapsedMicroseconds;
        if (removed) {
          await _finishDiscovery(
            discoveryId,
            state: 'duplicate_deleted',
            sha: digest,
            timings: timings,
          );
          return _Outcome.duplicateDeleted;
        }
      }
    }

    final preprocessingWatch = Stopwatch()..start();
    final inspection = await Isolate.run(() => inspectSheet(read.bytes));
    _checkScan(generation);
    timings['preprocessing'] = preprocessingWatch.elapsedMicroseconds;
    final pixelMatches =
        (await database.assetsByPixelFingerprint(
              inspection.facts.pixelFingerprint,
            ))
            .where(
              (asset) =>
                  asset.documentUri != document.uri &&
                  asset.width == inspection.facts.width &&
                  asset.height == inspection.facts.height,
            )
            .toList();
    for (final retained in pixelMatches) {
      if (await _verifiedPixels(retained, inspection.facts.pixelFingerprint)) {
        final deletionWatch = Stopwatch()..start();
        final removed = await _deleteVerifiedDuplicate(
          document,
          retained,
          digest,
          existingAtUri,
          discoveryId: discoveryId,
          config: config,
          expectedPixelFingerprint: inspection.facts.pixelFingerprint,
        );
        timings['duplicate_deletion'] = deletionWatch.elapsedMicroseconds;
        if (removed) {
          await _finishDiscovery(
            discoveryId,
            state: 'duplicate_deleted',
            sha: digest,
            pixel: inspection.facts.pixelFingerprint,
            timings: timings,
          );
          return _Outcome.duplicateDeleted;
        }
      }
    }

    final analysis = await ocr.recognizeSheet(read.bytes, inspection);
    _checkScan(generation);
    timings['ocr'] = analysis.ocrMicros;
    timings['preprocessing'] =
        (timings['preprocessing'] ?? 0) + analysis.enhancementMicros;
    final now = DateTime.now();
    final assetId = existingAtUri?.id ?? _uuid.v4();
    String uri = document.uri;
    String filename = document.name;
    String stableIdentity = document.stableIdentity;
    var finalMetadata = document;
    String? editionId = existingAtUri?.editionId;
    if (!analysis.needsReview && analysis.title != null) {
      editionId = await _ensureEdition(
        analysis.title!,
        analysis.keyLabel,
        existingAtUri?.editionId,
      );
      if (document.canRename &&
          document.parentUri != null &&
          await _isEligibleDiscovery(discoveryId, config)) {
        final desired = buildFilename(
          analysis.title!,
          keyLabel: analysis.keyLabel,
          page: existingAtUri?.pageOrder ?? 1,
          stableSuffix: assetId.replaceAll('-', '').substring(0, 4),
          extension: p.extension(document.name),
        );
        final renameWatch = Stopwatch()..start();
        final renamed = await _renameJournaled(
          document.uri,
          document.parentUri!,
          desired,
          digest,
          discoveryId,
          config,
        );
        timings['rename'] = renameWatch.elapsedMicroseconds;
        uri = renamed.uri;
        filename = renamed.name;
        stableIdentity = renamed.stableIdentity;
        finalMetadata = renamed;
      }
    }
    final companion = SheetAssetsCompanion.insert(
      id: assetId,
      editionId: Value(editionId),
      documentUri: uri,
      filename: filename,
      mimeType: document.mimeType,
      byteSize: read.bytes.length,
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
      contentFingerprint:
          '${finalMetadata.size}:${finalMetadata.lastModified?.millisecondsSinceEpoch ?? 0}',
      modifiedAt: Value(finalMetadata.lastModified),
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
    await _updateDiscovery(
      discoveryId,
      DiscoveryLedgerCompanion(
        stableIdentity: Value(stableIdentity),
        documentUri: Value(uri),
        filename: Value(filename),
        metadataFingerprint: Value(
          '${finalMetadata.size}:${finalMetadata.lastModified?.millisecondsSinceEpoch ?? 0}',
        ),
        sha256: Value(digest),
        pixelFingerprint: Value(analysis.facts.pixelFingerprint),
        processingVersion: const Value(currentProcessingVersion),
        processingState: Value(
          analysis.needsReview ? 'uncertain' : 'completed',
        ),
        stageTimingsJson: Value(jsonEncode(timings)),
        lastProcessedAt: Value(now),
        currentUri: Value(uri),
        updatedAt: Value(now),
      ),
    );
    return analysis.needsReview ? _Outcome.pendingReview : _Outcome.imported;
  }

  Future<void> confirmClassification(
    DiscoveryRecord discovery, {
    required bool isSongSheet,
  }) => _serialize(() async {
    if (!isSongSheet) {
      await _updateDiscovery(
        discovery.id,
        DiscoveryLedgerCompanion(
          classification: const Value('non_song_sheet'),
          classificationScore: const Value(0),
          processingState: const Value('non_song_sheet'),
          lastProcessedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return;
    }
    final config = await loadConfiguration();
    if (!await _isEligibleDiscovery(discovery.id, config)) {
      throw StateError(
        'This image is outside the current source or date scope.',
      );
    }
    final metadata = await storage.metadata(
      discovery.currentUri,
      parentUri: discovery.parentUri,
    );
    await _updateDiscovery(
      discovery.id,
      DiscoveryLedgerCompanion(
        classification: const Value('song_sheet'),
        processingState: const Value('processing'),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _processConfirmedSong(
      metadata,
      discovery.id,
      config,
      _decodeTimings(discovery.stageTimingsJson),
      _scanGeneration,
    );
  });

  Future<void> markAllForExplicitReprocess() => database.transaction(() async {
    await (database.update(database.discoveryLedger)..where(
          (row) => row.processingState.isIn([
            'completed',
            'non_song_sheet',
            'uncertain',
            'failed',
          ]),
        ))
        .write(
          DiscoveryLedgerCompanion(
            processingState: const Value('discovered'),
            failureReason: const Value(null),
            updatedAt: Value(DateTime.now()),
          ),
        );
  });

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
    required String discoveryId,
    required ScanConfiguration config,
    String? expectedPixelFingerprint,
  }) async {
    if (!duplicate.canDelete ||
        duplicate.uri == retained.documentUri ||
        await storage.sameDocument(duplicate.uri, retained.documentUri) ||
        !await storage.exists(retained.documentUri) ||
        !await _isEligibleDiscovery(discoveryId, config)) {
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
      if (!await _isEligibleDiscovery(discoveryId, await loadConfiguration())) {
        throw StateError('The source or date scope changed before deletion.');
      }
      final current = await storage.readBytes(duplicate.uri);
      if (sha256.convert(current).toString() != expectedSha) {
        throw StateError('The duplicate changed before deletion.');
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
      if (!await storage.delete(duplicate.uri)) {
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

  Future<SafDocument> _renameJournaled(
    String sourceUri,
    String parentUri,
    String desiredName,
    String expectedSha,
    String discoveryId,
    ScanConfiguration config,
  ) async {
    if (!await _isEligibleDiscovery(discoveryId, config)) {
      throw StateError('The image left the configured scope before rename.');
    }
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
    if (!await _isEligibleDiscovery(discoveryId, await loadConfiguration())) {
      throw StateError('The source or date scope changed before rename.');
    }
    final renamed = await storage.rename(
      sourceUri,
      desiredName,
      parentUri: parentUri,
    );
    await (database.update(
      database.fileOperations,
    )..where((row) => row.id.equals(operationId))).write(
      FileOperationsCompanion(
        resultUri: Value(renamed.uri),
        state: const Value('filesystem_done'),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return renamed;
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
    final discovery =
        await (database.select(database.discoveryLedger)
              ..where((row) => row.currentUri.equals(asset.documentUri)))
            .getSingleOrNull();
    final config = await loadConfiguration();
    if (discovery == null ||
        !await _isEligibleDiscovery(discovery.id, config)) {
      throw StateError(
        'This image is outside the current source or date scope.',
      );
    }
    final bytes = await storage.readBytes(asset.documentUri);
    final currentSha = sha256.convert(bytes).toString();
    if (currentSha != asset.sha256) {
      throw StateError('The image changed; refresh before confirming it.');
    }
    final editionId = await _ensureEdition(title, keyLabel, asset.editionId);
    var uri = asset.documentUri;
    var filename = asset.filename;
    var stableIdentity = discovery.stableIdentity;
    final metadata = await storage.metadata(
      uri,
      parentUri: discovery.parentUri,
    );
    if (metadata.canRename && discovery.parentUri != null) {
      final desired = buildFilename(
        title,
        keyLabel: keyLabel,
        page: page,
        stableSuffix: asset.id.replaceAll('-', '').substring(0, 4),
        extension: p.extension(asset.filename),
      );
      final renamed = await _renameJournaled(
        uri,
        discovery.parentUri!,
        desired,
        currentSha,
        discovery.id,
        config,
      );
      uri = renamed.uri;
      filename = renamed.name;
      stableIdentity = renamed.stableIdentity;
    }
    await database.transaction(() async {
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
      await _updateDiscovery(
        discovery.id,
        DiscoveryLedgerCompanion(
          stableIdentity: Value(stableIdentity),
          documentUri: Value(uri),
          currentUri: Value(uri),
          filename: Value(filename),
          processingState: const Value('completed'),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  });

  Future<void> recoverPendingOperations({ScanConfiguration? config}) async {
    final activeConfig = config ?? await loadConfiguration();
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
      final discovery =
          await (database.select(database.discoveryLedger)..where(
                (row) =>
                    row.currentUri.equals(operation.sourceUri) |
                    row.documentUri.equals(operation.sourceUri),
              ))
              .getSingleOrNull();
      if (discovery == null ||
          !await _isEligibleDiscovery(discovery.id, activeConfig)) {
        continue;
      }
      try {
        if (operation.kind == 'rename') {
          if (!await storage.exists(operation.sourceUri)) {
            if (operation.resultUri != null &&
                await storage.exists(operation.resultUri!)) {
              await _setOperation(operation.id, 'filesystem_done');
            }
            continue;
          }
          if (discovery.parentUri == null) continue;
          final bytes = await storage.readBytes(operation.sourceUri);
          if (sha256.convert(bytes).toString() !=
              operation.expectedFingerprint) {
            continue;
          }
          final renamed = await storage.rename(
            operation.sourceUri,
            operation.destinationName!,
            parentUri: discovery.parentUri!,
          );
          await database.transaction(() async {
            await (database.update(
              database.fileOperations,
            )..where((row) => row.id.equals(operation.id))).write(
              FileOperationsCompanion(
                resultUri: Value(renamed.uri),
                state: const Value('filesystem_done'),
                updatedAt: Value(DateTime.now()),
              ),
            );
            await _updateDiscovery(
              discovery.id,
              DiscoveryLedgerCompanion(
                stableIdentity: Value(renamed.stableIdentity),
                documentUri: Value(renamed.uri),
                currentUri: Value(renamed.uri),
                filename: Value(renamed.name),
                updatedAt: Value(DateTime.now()),
              ),
            );
          });
        } else if (operation.kind == 'delete' &&
            await storage.exists(operation.sourceUri)) {
          final retained = operation.retainedAssetId == null
              ? null
              : await (database.select(database.sheetAssets)..where(
                      (row) => row.id.equals(operation.retainedAssetId!),
                    ))
                    .getSingleOrNull();
          if (retained == null ||
              !await storage.exists(retained.documentUri) ||
              await storage.sameDocument(
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
          if (sourceSha != expectedSourceSha) continue;
          final retainedBytes = await storage.readBytes(retained.documentUri);
          if (expected.startsWith('sha:')) {
            if (sha256.convert(retainedBytes).toString() !=
                expectedSourceSha) {
              continue;
            }
          } else if (expected.startsWith('pixel:')) {
            final separator = expected.indexOf(';source:');
            if (separator < 0) continue;
            final pixelFingerprint = expected.substring(6, separator);
            final facts = await Isolate.run(
              () => inspectDecodedPixels(retainedBytes),
            );
            if (facts.pixelFingerprint != pixelFingerprint) continue;
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

  Future<bool> _isEligibleDiscovery(String id, ScanConfiguration config) async {
    final discovery = await (database.select(
      database.discoveryLedger,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (discovery == null || !config.includes(discovery.eligibilityDate)) {
      return false;
    }
    if (discovery.sourceFolderId == null) return false;
    final source =
        await (database.select(database.sourceFolders)
              ..where((row) => row.id.equals(discovery.sourceFolderId!)))
            .getSingleOrNull();
    return source != null;
  }

  Future<void> _finishDiscovery(
    String id, {
    required String state,
    required String sha,
    String? pixel,
    required Map<String, int> timings,
  }) => _updateDiscovery(
    id,
    DiscoveryLedgerCompanion(
      processingState: Value(state),
      sha256: Value(sha),
      pixelFingerprint: Value(pixel),
      processingVersion: const Value(currentProcessingVersion),
      stageTimingsJson: Value(jsonEncode(timings)),
      lastProcessedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ),
  );

  Future<void> _updateDiscovery(String id, DiscoveryLedgerCompanion values) =>
      (database.update(
        database.discoveryLedger,
      )..where((row) => row.id.equals(id))).write(values);

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

enum _Outcome { imported, duplicateDeleted, pendingReview, nonSong, excluded }

Map<String, int> _decodeTimings(String value) {
  try {
    final decoded = jsonDecode(value);
    if (decoded is Map) {
      return decoded.map(
        (key, value) => MapEntry('$key', (value as num).toInt()),
      );
    }
  } catch (_) {
    // A corrupt timing payload never blocks image processing.
  }
  return <String, int>{};
}

String _mergeTimings(String? current, Map<String, int> additions) {
  final values = current == null ? <String, int>{} : _decodeTimings(current);
  values.addAll(additions);
  return jsonEncode(values);
}

String _dateKey(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

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
