import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:song_sheets/core/database/app_database.dart';
import 'package:song_sheets/core/ocr/ocr_service.dart';
import 'package:song_sheets/core/storage/saf_storage.dart';
import 'package:song_sheets/features/import/import_coordinator.dart';

class FakeStorage extends SafStorage {
  FakeStorage(this.files, {this.aliases = const {}});

  final Map<String, Uint8List> files;
  final Map<String, String> aliases;

  @override
  Future<bool> exists(String uri) async => files.containsKey(uri);

  @override
  Future<Uint8List> readBytes(String uri) async => files[uri]!;

  @override
  Future<bool> delete(String uri) async => files.remove(uri) != null;

  @override
  Future<bool> sameDocument(String firstUri, String secondUri) async =>
      firstUri == secondUri ||
      aliases[firstUri] == secondUri ||
      aliases[secondUri] == firstUri;

  @override
  Future<String> rename(String uri, String displayName) async {
    final target = 'content://fixture/$displayName';
    files[target] = files.remove(uri)!;
    return target;
  }

  @override
  Future<SafDocument> metadata(String uri) async => SafDocument(
    uri: uri,
    name: uri.split('/').last,
    mimeType: 'image/png',
    size: files[uri]!.length,
    lastModified: DateTime(2026, 10, 9),
    canRead: true,
    canWrite: true,
    canRename: true,
    canDelete: true,
  );
}

void main() {
  late AppDatabase database;
  late OcrService ocr;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    ocr = OcrService();
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'crash recovery deletes only after both byte-identical files are revalidated',
    () async {
      final now = DateTime(2026, 10, 9);
      final bytes = Uint8List.fromList([1, 2, 3, 4]);
      final digest = sha256.convert(bytes).toString();
      final storage = FakeStorage({
        'retained': bytes,
        'duplicate': Uint8List.fromList(bytes),
      });
      await _insertRetained(database, now, digest);
      await database
          .into(database.fileOperations)
          .insert(
            FileOperationsCompanion.insert(
              id: 'operation',
              kind: 'delete',
              sourceUri: 'duplicate',
              retainedAssetId: const Value('retained-asset'),
              expectedFingerprint: 'sha:$digest',
              state: 'references_committed',
              createdAt: now,
              updatedAt: now,
            ),
          );

      await ImportCoordinator(
        database,
        storage,
        ocr,
      ).recoverPendingOperations();

      expect(storage.files, contains('retained'));
      expect(storage.files, isNot(contains('duplicate')));
      expect(
        (await database.select(database.fileOperations).getSingle()).state,
        'filesystem_done',
      );
    },
  );

  test('crash recovery keeps duplicate when retained master changed', () async {
    final now = DateTime(2026, 10, 9);
    final original = Uint8List.fromList([1, 2, 3, 4]);
    final digest = sha256.convert(original).toString();
    final storage = FakeStorage({
      'retained': Uint8List.fromList([9, 9, 9]),
      'duplicate': original,
    });
    await _insertRetained(database, now, digest);
    await database
        .into(database.fileOperations)
        .insert(
          FileOperationsCompanion.insert(
            id: 'operation',
            kind: 'delete',
            sourceUri: 'duplicate',
            retainedAssetId: const Value('retained-asset'),
            expectedFingerprint: 'sha:$digest',
            state: 'cleanup_pending',
            createdAt: now,
            updatedAt: now,
          ),
        );

    await ImportCoordinator(database, storage, ocr).recoverPendingOperations();

    expect(storage.files, contains('duplicate'));
    expect(
      (await database.select(database.fileOperations).getSingle()).state,
      'cleanup_pending',
    );
  });

  test('URI aliases of the retained document are never deleted', () async {
    final now = DateTime(2026, 10, 9);
    final bytes = Uint8List.fromList([1, 2, 3, 4]);
    final digest = sha256.convert(bytes).toString();
    final storage = FakeStorage(
      {'retained': bytes, 'alias': bytes},
      aliases: const {'alias': 'retained'},
    );
    await _insertRetained(database, now, digest);
    await database
        .into(database.fileOperations)
        .insert(
          FileOperationsCompanion.insert(
            id: 'operation',
            kind: 'delete',
            sourceUri: 'alias',
            retainedAssetId: const Value('retained-asset'),
            expectedFingerprint: 'sha:$digest',
            state: 'references_committed',
            createdAt: now,
            updatedAt: now,
          ),
        );

    await ImportCoordinator(database, storage, ocr).recoverPendingOperations();

    expect(storage.files, contains('alias'));
  });
}

Future<void> _insertRetained(
  AppDatabase database,
  DateTime now,
  String digest,
) => database
    .into(database.sheetAssets)
    .insert(
      SheetAssetsCompanion.insert(
        id: 'retained-asset',
        documentUri: 'retained',
        filename: 'retained.png',
        mimeType: 'image/png',
        byteSize: 4,
        sha256: digest,
        contentFingerprint: '4:1',
        createdAt: now,
        updatedAt: now,
      ),
    );
