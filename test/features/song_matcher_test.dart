import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:song_sheets/core/database/app_database.dart';
import 'package:song_sheets/core/ocr/ocr_service.dart';
import 'package:song_sheets/features/services/song_matcher.dart';

void main() {
  test(
    'exact titles score one',
    () => expect(similarity('the prayer', 'the prayer'), 1),
  );

  test('fuzzy score proposes close text without being exact', () {
    final score = similarity('amazing grace', 'amzing grace');
    expect(score, greaterThan(.8));
    expect(score, lessThan(1));
  });

  test('unrelated titles do not meet proposal threshold', () {
    expect(similarity('holy holy holy', 'the prayer'), lessThan(.62));
  });

  test('generated filenames participate in exact local matching', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final now = DateTime(2026, 10, 9);
    await database
        .into(database.songs)
        .insert(
          SongsCompanion.insert(
            id: 'song',
            displayTitle: 'Canonical Different Name',
            normalizedTitle: 'canonical different name',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await database
        .into(database.editions)
        .insert(EditionsCompanion.insert(id: 'edition', songId: 'song'));
    await database
        .into(database.sheetAssets)
        .insert(
          SheetAssetsCompanion.insert(
            id: 'asset',
            editionId: const Value('edition'),
            documentUri: 'content://fixture/asset',
            filename: 'The Prayer__Bb__p01__7c2a.jpg',
            mimeType: 'image/jpeg',
            byteSize: 10,
            sha256: 'sha',
            contentFingerprint: '10:1',
            createdAt: now,
            updatedAt: now,
          ),
        );

    final match = await const SongMatcher().match(
      database,
      const SetlistLine(text: 'The Prayer', normalizedTitle: 'the prayer'),
    );

    expect(match.status, MatchStatus.matched);
    expect(match.editionId, 'edition');
  });
}
