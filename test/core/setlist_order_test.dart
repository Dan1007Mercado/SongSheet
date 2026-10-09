import 'package:flutter_test/flutter_test.dart';
import 'package:song_sheets/core/ocr/ocr_service.dart';

void main() {
  test(
    'setlist layout reads columns left-to-right and groups continuations',
    () {
      const lines = [
        OcrLayoutLine(
          text: '2. Second',
          left: 10,
          top: 50,
          right: 130,
          bottom: 62,
        ),
        OcrLayoutLine(
          text: '4. Fourth',
          left: 420,
          top: 50,
          right: 550,
          bottom: 62,
        ),
        OcrLayoutLine(
          text: '1. Long',
          left: 10,
          top: 10,
          right: 100,
          bottom: 22,
        ),
        OcrLayoutLine(
          text: 'Song Title',
          left: 18,
          top: 24,
          right: 150,
          bottom: 36,
        ),
        OcrLayoutLine(
          text: '3. Third',
          left: 420,
          top: 10,
          right: 540,
          bottom: 22,
        ),
      ];

      expect(orderAndGroupSetlistLines(lines), [
        '1. Long Song Title',
        '2. Second',
        '3. Third',
        '4. Fourth',
      ]);
    },
  );

  test('setlist layout preserves repeated rows', () {
    const lines = [
      OcrLayoutLine(text: '1. Amen', left: 10, top: 10, right: 100, bottom: 20),
      OcrLayoutLine(text: '2. Amen', left: 10, top: 40, right: 100, bottom: 50),
    ];

    expect(orderAndGroupSetlistLines(lines), ['1. Amen', '2. Amen']);
  });
}
