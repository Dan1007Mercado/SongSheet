import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:song_sheets/core/database/app_database.dart';
import 'package:song_sheets/features/library/library_entry.dart';

void main() {
  late AppDatabase database;

  setUp(() => database = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('schema 1 migration preserves existing catalog rows', () async {
    await database.close();
    database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute(
            'CREATE TABLE songs ('
            'id TEXT NOT NULL PRIMARY KEY, '
            'display_title TEXT NOT NULL, '
            'normalized_title TEXT NOT NULL, '
            'created_at INTEGER NOT NULL, '
            'updated_at INTEGER NOT NULL)',
          );
          raw.execute(
            "INSERT INTO songs VALUES ('legacy', 'Legacy Song', 'legacy song', 1, 1)",
          );
          raw.execute('PRAGMA user_version = 1');
        },
      ),
    );

    final songs = await database.select(database.songs).get();

    expect(songs.single.displayTitle, 'Legacy Song');
    expect(await database.select(database.sourceFolders).get(), isEmpty);
    expect(await database.select(database.discoveryLedger).get(), isEmpty);
  });

  test(
    'same title supports distinct keys and repeated service entries',
    () async {
      final now = DateTime(2026, 10, 9);
      await database
          .into(database.songs)
          .insert(
            SongsCompanion.insert(
              id: 'song',
              displayTitle: 'The Prayer',
              normalizedTitle: 'the prayer',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.editions)
          .insert(
            EditionsCompanion.insert(
              id: 'bb',
              songId: 'song',
              keyLabel: const Value('Bb'),
            ),
          );
      await database
          .into(database.editions)
          .insert(
            EditionsCompanion.insert(
              id: 'c',
              songId: 'song',
              keyLabel: const Value('C'),
            ),
          );
      await database
          .into(database.serviceCollections)
          .insert(
            ServiceCollectionsCompanion.insert(
              id: 'service',
              localDate: now,
              displayName: 'Songs for Sunday (2026-10-11)',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database.batch(
        (batch) => batch.insertAll(database.serviceEntries, [
          ServiceEntriesCompanion.insert(
            id: 'one',
            serviceId: 'service',
            position: 0,
            requestedTitle: 'The Prayer',
            normalizedRequestedTitle: 'the prayer',
            status: 'matched',
            editionId: const Value('bb'),
          ),
          ServiceEntriesCompanion.insert(
            id: 'two',
            serviceId: 'service',
            position: 1,
            requestedTitle: 'The Prayer',
            normalizedRequestedTitle: 'the prayer',
            status: 'matched',
            editionId: const Value('c'),
          ),
          ServiceEntriesCompanion.insert(
            id: 'three',
            serviceId: 'service',
            position: 2,
            requestedTitle: 'The Prayer',
            normalizedRequestedTitle: 'the prayer',
            status: 'matched',
            editionId: const Value('bb'),
          ),
        ]),
      );

      expect(
        await database.editionsForNormalizedTitle('the prayer'),
        hasLength(2),
      );
      expect(await database.entriesForService('service'), hasLength(3));
    },
  );

  test('deleting a virtual collection does not delete master assets', () async {
    final now = DateTime(2026, 10, 9);
    await database
        .into(database.sheetAssets)
        .insert(
          SheetAssetsCompanion.insert(
            id: 'asset',
            documentUri: 'content://fixture/master',
            filename: 'master.png',
            mimeType: 'image/png',
            byteSize: 10,
            sha256: 'hash',
            contentFingerprint: '10:1',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await database
        .into(database.serviceCollections)
        .insert(
          ServiceCollectionsCompanion.insert(
            id: 'service',
            localDate: now,
            displayName: 'Sunday',
            createdAt: now,
            updatedAt: now,
          ),
        );

    await (database.delete(
      database.serviceCollections,
    )..where((row) => row.id.equals('service'))).go();

    expect(await database.select(database.sheetAssets).get(), hasLength(1));
  });

  test('reader progress is updated without creating image copies', () async {
    final now = DateTime(2026, 10, 9);
    await database
        .into(database.serviceCollections)
        .insert(
          ServiceCollectionsCompanion.insert(
            id: 'service',
            localDate: now,
            displayName: 'Sunday',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await database
        .into(database.serviceEntries)
        .insert(
          ServiceEntriesCompanion.insert(
            id: 'entry',
            serviceId: 'service',
            position: 0,
            requestedTitle: 'Missing',
            normalizedRequestedTitle: 'missing',
            status: 'missing',
          ),
        );
    await database
        .into(database.readerProgress)
        .insert(
          ReaderProgressCompanion.insert(
            serviceId: 'service',
            entryId: 'entry',
            pagePosition: const Value(2),
            updatedAt: now,
          ),
        );

    final progress = await database.select(database.readerProgress).getSingle();
    expect(progress.pagePosition, 2);
    expect(await database.select(database.sheetAssets).get(), isEmpty);
  });

  test(
    'library entries include only confirmed sheets and preserve page order',
    () async {
      final now = DateTime(2026, 10, 9);
      await database
          .into(database.songs)
          .insert(
            SongsCompanion.insert(
              id: 'song',
              displayTitle: 'Amen',
              normalizedTitle: 'amen',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.editions)
          .insert(EditionsCompanion.insert(id: 'edition', songId: 'song'));
      for (final fixture in [
        (id: 'page-2', page: 2),
        (id: 'page-1', page: 1),
      ]) {
        await database
            .into(database.sheetAssets)
            .insert(
              SheetAssetsCompanion.insert(
                id: fixture.id,
                editionId: const Value('edition'),
                documentUri: 'content://fixture/${fixture.id}',
                filename: '${fixture.id}.png',
                mimeType: 'image/png',
                byteSize: 10,
                sha256: fixture.id,
                pageOrder: Value(fixture.page),
                extractedTitle: const Value('Amen'),
                normalizedTitle: const Value('amen'),
                reviewState: const Value('confirmed'),
                contentFingerprint: '${fixture.id}:10',
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
      await database
          .into(database.sheetAssets)
          .insert(
            SheetAssetsCompanion.insert(
              id: 'pending',
              documentUri: 'content://fixture/pending',
              filename: 'pending.png',
              mimeType: 'image/png',
              byteSize: 10,
              sha256: 'pending',
              reviewState: const Value('pending'),
              contentFingerprint: 'pending:10',
              createdAt: now,
              updatedAt: now,
            ),
          );

      final entries = await buildLibraryEntries(
        database,
        await database.select(database.sheetAssets).get(),
      );

      expect(entries, hasLength(1));
      expect(entries.single.assets.map((asset) => asset.id), [
        'page-1',
        'page-2',
      ]);
    },
  );
}
