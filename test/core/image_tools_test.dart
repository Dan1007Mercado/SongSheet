import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:song_sheets/core/image_processing/image_tools.dart';

void main() {
  test('staff systems classify as a song sheet without OCR text', () {
    final sheet = img.Image(width: 600, height: 800);
    img.fill(sheet, color: img.ColorRgb8(255, 255, 255));
    for (final origin in [180, 430]) {
      for (var line = 0; line < 5; line++) {
        img.drawLine(
          sheet,
          x1: 35,
          y1: origin + line * 10,
          x2: 565,
          y2: origin + line * 10,
          color: img.ColorRgb8(0, 0, 0),
        );
      }
    }

    final result = classifyPreview(Uint8List.fromList(img.encodePng(sheet)));

    expect(result.classification, SheetClassification.songSheet);
    expect(result.staffGroups, greaterThanOrEqualTo(2));
  });

  test('an unrelated color image is rejected before OCR', () {
    final photo = img.Image(width: 320, height: 240);
    img.fill(photo, color: img.ColorRgb8(24, 130, 220));

    final result = classifyPreview(Uint8List.fromList(img.encodePng(photo)));

    expect(result.classification, SheetClassification.nonSongSheet);
    expect(result.staffGroups, 0);
  });

  test(
    'equal decoded pixels have equal fingerprints despite PNG encoding metadata',
    () {
      final source = img.Image(width: 4, height: 4)
        ..setPixelRgb(1, 1, 10, 20, 30);
      final first = Uint8List.fromList(img.encodePng(source, level: 1));
      final second = Uint8List.fromList(img.encodePng(source, level: 9));

      expect(first, isNot(orderedEquals(second)));
      expect(
        inspectDecodedPixels(first).pixelFingerprint,
        inspectDecodedPixels(second).pixelFingerprint,
      );
    },
  );

  test('a visible pixel annotation changes the destructive fingerprint', () {
    final source = img.Image(width: 4, height: 4);
    final annotated = img.Image.from(source)..setPixelRgb(2, 2, 255, 0, 0);

    expect(
      inspectDecodedPixels(
        Uint8List.fromList(img.encodePng(source)),
      ).pixelFingerprint,
      isNot(
        inspectDecodedPixels(
          Uint8List.fromList(img.encodePng(annotated)),
        ).pixelFingerprint,
      ),
    );
  });
}
