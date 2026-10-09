import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:song_sheets/core/database/app_database.dart';
import 'package:song_sheets/core/ocr/ocr_service.dart';
import 'package:song_sheets/core/storage/saf_storage.dart';
import 'package:song_sheets/features/import/import_coordinator.dart';

class CountingStorage extends SafStorage {
  CountingStorage(this.documents);

  final List<SafDocument> documents;
  var previewReads = 0;
  var fullReads = 0;
  var listings = 0;

  @override
  Future<List<SafDocument>> listImages(
    String treeUri, {
    required bool includeSubfolders,
  }) async {
    listings++;
    return documents;
  }

  @override
  Future<Uint8List> readPreview(String uri, {int maxDimension = 900}) async {
    previewReads++;
    throw StateError('Preview must not be read for this fixture.');
  }

  @override
  Future<SafImageRead> readImage(String uri) async {
    fullReads++;
    throw StateError('Full image must not be read for this fixture.');
  }
}

void main() {
  late AppDatabase database;

  setUp(() => database = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('date range is inclusive in local calendar days', () {
    final config = ScanConfiguration(
      startDate: DateTime(2026, 10, 1, 23, 59),
      endDate: DateTime(2026, 10, 9, 0, 1),
      endAtToday: false,
    );

    expect(config.includes(DateTime(2026, 10, 1)), isTrue);
    expect(config.includes(DateTime(2026, 10, 9, 23, 59)), isTrue);
    expect(config.includes(DateTime(2026, 9, 30, 23, 59)), isFalse);
    expect(config.includes(DateTime(2026, 10, 10)), isFalse);
  });

  test(
    'out-of-range images are ledgered without opening image content',
    () async {
      final storage = CountingStorage([
        _document(
          uri: 'content://fixture/outside',
          identity: 'outside',
          added: DateTime(2026, 9, 30),
        ),
      ]);
      await _insertSource(database);
      final coordinator = ImportCoordinator(database, storage, OcrService());
      await coordinator.saveConfiguration(
        ScanConfiguration(
          startDate: DateTime(2026, 10, 1),
          endDate: DateTime(2026, 10, 9),
          endAtToday: false,
        ),
      );

      final summary = await coordinator.refresh();

      expect(summary.excluded, 1);
      expect(storage.previewReads, 0);
      expect(storage.fullReads, 0);
      final ledger = await database
          .select(database.discoveryLedger)
          .getSingle();
      expect(ledger.processingState, 'excluded');
      expect(ledger.dateSource, 'provider_added');
    },
  );

  test('unknown download dates are excluded without OCR', () async {
    final storage = CountingStorage([
      _document(uri: 'content://fixture/unknown', identity: 'unknown'),
    ]);
    await _insertSource(database);
    final coordinator = ImportCoordinator(database, storage, OcrService());
    await coordinator.saveConfiguration(ScanConfiguration(
      startDate: DateTime(2026, 10, 9),
      endDate: DateTime(2026, 10, 9),
      endAtToday: false,
    ));
    final summary = await coordinator.refresh();
    expect(summary.excluded, 1);
    expect(storage.previewReads, 0);
    expect(storage.fullReads, 0);
    final ledger = await database.select(database.discoveryLedger).getSingle();
    expect(ledger.dateSource, 'unknown');
    expect(ledger.processingState, 'excluded');
  });

  test('unchanged examined and renamed identities skip content work', () async {
    final day = DateTime(2026, 10, 9);
    final storage = CountingStorage([
      _document(
        uri: 'content://fixture/renamed',
        identity: 'stable-one',
        added: day,
      ),
      _document(
        uri: 'content://fixture/rejected',
        identity: 'stable-two',
        added: day,
      ),
    ]);
    await _insertSource(database);
    await _insertDiscovery(
      database,
      day,
      id: 'one',
      uri: 'content://fixture/original-name',
      identity: 'stable-one',
      state: 'completed',
    );
    await _insertDiscovery(
      database,
      day,
      id: 'two',
      uri: 'content://fixture/rejected',
      identity: 'stable-two',
      state: 'non_song_sheet',
    );
    final coordinator = ImportCoordinator(database, storage, OcrService());
    await coordinator.saveConfiguration(
      ScanConfiguration(startDate: day, endDate: day, endAtToday: false),
    );

    final summary = await coordinator.refresh();

    expect(summary.unchangedSkipped, 2);
    expect(storage.previewReads, 0);
    expect(storage.fullReads, 0);
    final renamed = await database.discoveryByIdentityOrUri(
      'stable-one',
      'content://fixture/renamed',
    );
    expect(renamed!.documentUri, 'content://fixture/renamed');
    expect(renamed.processingState, 'completed');
  });
}

SafDocument _document({
  required String uri,
  required String identity,
  DateTime? added,
}) => SafDocument(
  uri: uri,
  stableIdentity: identity,
  parentUri: 'content://fixture/tree/document/root',
  name: '${uri.split('/').last}.png',
  mimeType: 'image/png',
  size: 100,
  lastModified: DateTime(2026, 10, 8),
  providerAddedAt: added,
  canRead: true,
  canWrite: true,
  canRename: true,
  canDelete: true,
);

Future<void> _insertSource(AppDatabase database) => database
    .into(database.sourceFolders)
    .insert(
      SourceFoldersCompanion.insert(
        id: 'source',
        treeUri: 'content://fixture/tree',
        displayName: 'Fixture',
        addedAt: DateTime(2026, 10, 1),
      ),
    );

Future<void> _insertDiscovery(
  AppDatabase database,
  DateTime day, {
  required String id,
  required String uri,
  required String identity,
  required String state,
}) => database
    .into(database.discoveryLedger)
    .insert(
      DiscoveryLedgerCompanion.insert(
        id: id,
        stableIdentity: identity,
        sourceFolderId: const Value('source'),
        documentUri: uri,
        parentUri: const Value('content://fixture/tree/document/root'),
        filename: '${uri.split('/').last}.png',
        mimeType: 'image/png',
        byteSize: 100,
        providerAddedAt: Value(day),
        firstSeenAt: day,
        eligibilityDate: day,
        dateSource: 'provider_added',
        modifiedAt: Value(DateTime(2026, 10, 8)),
        metadataFingerprint:
            '100:${DateTime(2026, 10, 8).millisecondsSinceEpoch}',
        processingState: Value(state),
        currentUri: uri,
        updatedAt: day,
      ),
    );
