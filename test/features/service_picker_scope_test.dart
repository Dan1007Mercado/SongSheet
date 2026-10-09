import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:song_sheets/core/database/app_database.dart';
import 'package:song_sheets/core/ocr/ocr_service.dart';
import 'package:song_sheets/core/storage/saf_storage.dart';
import 'package:song_sheets/features/services/service_coordinator.dart';
import 'package:song_sheets/features/services/song_matcher.dart';

class PickerOnlyStorage extends SafStorage {
  var picks = 0;
  var reads = 0;
  var listings = 0;

  @override
  Future<String?> pickImage() async {
    picks++;
    return 'content://fixture/selected-list';
  }

  @override
  Future<Uint8List> readBytes(String uri) async {
    reads++;
    expect(uri, 'content://fixture/selected-list');
    return Uint8List.fromList([1, 2, 3]);
  }

  @override
  Future<List<SafDocument>> listImages(
    String treeUri, {
    required bool includeSubfolders,
  }) async {
    listings++;
    return const [];
  }
}

class FixtureOcr extends OcrService {
  @override
  Future<List<SetlistLine>> recognizeSetlist(Uint8List bytes) async => const [
    SetlistLine(text: 'Amen', normalizedTitle: 'amen'),
    SetlistLine(text: 'Amen', normalizedTitle: 'amen'),
  ];

  @override
  Future<void> close() async {}
}

void main() {
  test(
    'Sunday import reads only the one image selected by the picker',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final storage = PickerOnlyStorage();
      final ocr = FixtureOcr();
      addTearDown(database.close);
      addTearDown(ocr.close);
      final coordinator = ServiceCoordinator(
        database,
        storage,
        ocr,
        const SongMatcher(),
      );

      final draft = await coordinator.recognizeFromPicker(
        DateTime(2026, 10, 11),
      );

      expect(storage.picks, 1);
      expect(storage.reads, 1);
      expect(storage.listings, 0);
      expect(draft!.entries, hasLength(2));
      expect(draft.entries.map((entry) => entry.match.line.text), [
        'Amen',
        'Amen',
      ]);
      expect(draft.entries.map((entry) => entry.position), [0, 1]);
    },
  );
}
