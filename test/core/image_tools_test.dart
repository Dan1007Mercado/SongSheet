import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:song_sheets/core/image_processing/image_tools.dart';

void main() {
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
