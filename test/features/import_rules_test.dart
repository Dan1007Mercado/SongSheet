import 'package:flutter_test/flutter_test.dart';
import 'package:song_sheets/features/import/import_coordinator.dart';

void main() {
  test('filename sanitization preserves extension and stable identity', () {
    final name = buildFilename(
      'The Prayer: Duet / Choir?',
      keyLabel: 'Bb',
      page: 1,
      stableSuffix: '7c2a',
      extension: '.JPG',
    );
    expect(name, 'The Prayer Duet Choir__Bb__p01__7c2a.jpg');
  });

  test('different pages produce different names', () {
    final first = buildFilename(
      'Song',
      page: 1,
      stableSuffix: 'abcd',
      extension: '.png',
    );
    final second = buildFilename(
      'Song',
      page: 2,
      stableSuffix: 'abcd',
      extension: '.png',
    );
    expect(first, isNot(second));
  });
}
