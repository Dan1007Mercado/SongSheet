import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('SongRecord')
class Songs extends Table {
  TextColumn get id => text()();
  TextColumn get displayTitle => text()();
  TextColumn get normalizedTitle => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AliasRecord')
class SongAliases extends Table {
  TextColumn get id => text()();
  TextColumn get songId =>
      text().references(Songs, #id, onDelete: KeyAction.cascade)();
  TextColumn get normalizedAlias => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('EditionRecord')
class Editions extends Table {
  TextColumn get id => text()();
  TextColumn get songId =>
      text().references(Songs, #id, onDelete: KeyAction.cascade)();
  TextColumn get keyLabel => text().nullable()();
  TextColumn get instrument => text().nullable()();
  TextColumn get arrangementLabel => text().nullable()();
  TextColumn get userLabel => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AssetRecord')
class SheetAssets extends Table {
  TextColumn get id => text()();
  TextColumn get editionId => text().nullable().references(
    Editions,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get documentUri => text().unique()();
  TextColumn get filename => text()();
  TextColumn get mimeType => text()();
  IntColumn get byteSize => integer()();
  TextColumn get sha256 => text()();
  TextColumn get pixelFingerprint => text().nullable()();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  IntColumn get pageOrder => integer().nullable()();
  TextColumn get extractedTitle => text().nullable()();
  TextColumn get normalizedTitle => text().nullable()();
  TextColumn get rawOcr => text().nullable()();
  RealColumn get qualityScore => real().withDefault(const Constant(0))();
  TextColumn get reviewState => text().withDefault(const Constant('pending'))();
  TextColumn get availabilityState =>
      text().withDefault(const Constant('available'))();
  TextColumn get contentFingerprint => text()();
  IntColumn get processingVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get modifiedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ServiceRecord')
class ServiceCollections extends Table {
  TextColumn get id => text()();
  DateTimeColumn get localDate => dateTime()();
  TextColumn get displayName => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ServiceEntryRecord')
class ServiceEntries extends Table {
  TextColumn get id => text()();
  TextColumn get serviceId =>
      text().references(ServiceCollections, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get requestedTitle => text()();
  TextColumn get normalizedRequestedTitle => text()();
  TextColumn get requestedKey => text().nullable()();
  TextColumn get editionId => text().nullable().references(
    Editions,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get status => text()();
  TextColumn get candidateEditionIdsJson =>
      text().withDefault(const Constant('[]'))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {serviceId, position},
  ];
}

@DataClassName('ImportJobRecord')
class ImportJobs extends Table {
  TextColumn get id => text()();
  TextColumn get sourceUri => text()();
  TextColumn get inputFingerprint => text()();
  TextColumn get state => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get error => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('FileOperationRecord')
class FileOperations extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get sourceUri => text()();
  TextColumn get destinationName => text().nullable()();
  TextColumn get resultUri => text().nullable()();
  TextColumn get retainedAssetId => text().nullable().references(
    SheetAssets,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get expectedFingerprint => text()();
  TextColumn get state => text()();
  TextColumn get error => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ReaderProgressRecord')
class ReaderProgress extends Table {
  TextColumn get serviceId =>
      text().references(ServiceCollections, #id, onDelete: KeyAction.cascade)();
  TextColumn get entryId =>
      text().references(ServiceEntries, #id, onDelete: KeyAction.cascade)();
  IntColumn get pagePosition => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {serviceId};
}

@DataClassName('SettingRecord')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    Songs,
    SongAliases,
    Editions,
    SheetAssets,
    ServiceCollections,
    ServiceEntries,
    ImportJobs,
    FileOperations,
    ReaderProgress,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'song_sheets'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement(
        'CREATE INDEX assets_sha256 ON sheet_assets (sha256)',
      );
      await customStatement(
        'CREATE INDEX assets_pixel ON sheet_assets (pixel_fingerprint)',
      );
      await customStatement(
        'CREATE INDEX assets_title ON sheet_assets (normalized_title)',
      );
      await customStatement(
        'CREATE INDEX songs_title ON songs (normalized_title)',
      );
      await customStatement('CREATE INDEX jobs_state ON import_jobs (state)');
      await customStatement(
        'CREATE INDEX assets_edition_page ON sheet_assets (edition_id, page_order)',
      );
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Stream<List<AssetRecord>> watchAssets(String query) {
    final normalized = normalizeTitle(query);
    final statement = select(sheetAssets)
      ..orderBy([(row) => OrderingTerm(expression: row.filename)]);
    if (normalized.isNotEmpty) {
      statement.where(
        (row) =>
            row.normalizedTitle.like('%$normalized%') |
            row.filename.lower().like('%${query.toLowerCase()}%'),
      );
    }
    return statement.watch();
  }

  Stream<List<ServiceRecord>> watchServices() => (select(
    serviceCollections,
  )..orderBy([(row) => OrderingTerm.desc(row.localDate)])).watch();

  Stream<List<AssetRecord>> watchPendingReview() =>
      (select(sheetAssets)
            ..where((row) => row.reviewState.equals('pending'))
            ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
          .watch();

  Future<List<AssetRecord>> assetsBySha(String digest) =>
      (select(sheetAssets)..where((row) => row.sha256.equals(digest))).get();

  Future<List<AssetRecord>> assetsByPixelFingerprint(String digest) => (select(
    sheetAssets,
  )..where((row) => row.pixelFingerprint.equals(digest))).get();

  Future<AssetRecord?> assetByUri(String uri) => (select(
    sheetAssets,
  )..where((row) => row.documentUri.equals(uri))).getSingleOrNull();

  Future<List<ServiceEntryRecord>> entriesForService(String serviceId) =>
      (select(serviceEntries)
            ..where((row) => row.serviceId.equals(serviceId))
            ..orderBy([(row) => OrderingTerm(expression: row.position)]))
          .get();

  Future<List<AssetRecord>> assetsForEdition(String editionId) =>
      (select(sheetAssets)
            ..where((row) => row.editionId.equals(editionId))
            ..orderBy([(row) => OrderingTerm(expression: row.pageOrder)]))
          .get();

  Future<List<EditionRecord>> editionsForNormalizedTitle(String title) async {
    final songRows = await (select(
      songs,
    )..where((row) => row.normalizedTitle.equals(title))).get();
    final aliasRows = await (select(
      songAliases,
    )..where((row) => row.normalizedAlias.equals(title))).get();
    final songIds = <String>{
      ...songRows.map((row) => row.id),
      ...aliasRows.map((row) => row.songId),
    };
    if (songIds.isEmpty) return [];
    return (select(editions)..where((row) => row.songId.isIn(songIds))).get();
  }

  Future<List<Map<String, Object?>>> searchableEditions() async {
    final rows = await customSelect(
      'SELECT e.id edition_id, e.key_label, e.user_label, s.display_title, s.normalized_title '
      'FROM editions e INNER JOIN songs s ON s.id = e.song_id ORDER BY s.display_title',
      readsFrom: {editions, songs},
    ).get();
    return rows.map((row) => row.data).toList();
  }

  Future<void> replaceServiceEntries(
    String serviceId,
    List<ServiceEntriesCompanion> entries,
  ) => transaction(() async {
    await (delete(
      serviceEntries,
    )..where((row) => row.serviceId.equals(serviceId))).go();
    await batch((batch) => batch.insertAll(serviceEntries, entries));
  });

  Future<Map<String, Object?>> exportCatalog() async => {
    'format': 'song-sheets-backup',
    'version': 1,
    'exportedAt': DateTime.now().toUtc().toIso8601String(),
    'songs': (await select(songs).get()).map((row) => row.toJson()).toList(),
    'aliases': (await select(
      songAliases,
    ).get()).map((row) => row.toJson()).toList(),
    'editions': (await select(
      editions,
    ).get()).map((row) => row.toJson()).toList(),
    'assets': (await select(
      sheetAssets,
    ).get()).map((row) => row.toJson()).toList(),
    'services': (await select(
      serviceCollections,
    ).get()).map((row) => row.toJson()).toList(),
    'entries': (await select(
      serviceEntries,
    ).get()).map((row) => row.toJson()).toList(),
  };

  Future<void> restoreCatalog(String json) async {
    final root = jsonDecode(json);
    if (root is! Map<String, dynamic> ||
        root['format'] != 'song-sheets-backup' ||
        root['version'] != 1) {
      throw const FormatException(
        'This is not a supported Song Sheets backup.',
      );
    }
    await transaction(() async {
      for (final value in (root['songs'] as List<dynamic>? ?? const [])) {
        await into(songs).insertOnConflictUpdate(
          SongRecord.fromJson((value as Map).cast<String, dynamic>()),
        );
      }
      for (final value in (root['aliases'] as List<dynamic>? ?? const [])) {
        await into(songAliases).insertOnConflictUpdate(
          AliasRecord.fromJson((value as Map).cast<String, dynamic>()),
        );
      }
      for (final value in (root['editions'] as List<dynamic>? ?? const [])) {
        await into(editions).insertOnConflictUpdate(
          EditionRecord.fromJson((value as Map).cast<String, dynamic>()),
        );
      }
      for (final value in (root['assets'] as List<dynamic>? ?? const [])) {
        final restored = AssetRecord.fromJson(
          (value as Map).cast<String, dynamic>(),
        ).copyWith(availabilityState: 'needs_relink');
        await into(sheetAssets).insertOnConflictUpdate(restored);
      }
      for (final value in (root['services'] as List<dynamic>? ?? const [])) {
        await into(serviceCollections).insertOnConflictUpdate(
          ServiceRecord.fromJson((value as Map).cast<String, dynamic>()),
        );
      }
      for (final value in (root['entries'] as List<dynamic>? ?? const [])) {
        await into(serviceEntries).insertOnConflictUpdate(
          ServiceEntryRecord.fromJson((value as Map).cast<String, dynamic>()),
        );
      }
    });
  }
}

String normalizeTitle(String value) => value
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
    .trim()
    .replaceAll(RegExp(r'\s+'), ' ');
