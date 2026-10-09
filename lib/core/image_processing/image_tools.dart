import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;

class ImageFacts {
  const ImageFacts({
    required this.width,
    required this.height,
    required this.pixelFingerprint,
  });

  final int width;
  final int height;
  final String pixelFingerprint;
}

class PreparedOcrImages {
  const PreparedOcrImages({required this.facts, required this.pngVariants});

  final ImageFacts facts;
  final List<Uint8List> pngVariants;
}

ImageFacts inspectDecodedPixels(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw const FormatException('Unsupported or damaged image.');
  }
  final oriented = img.bakeOrientation(decoded);
  final rgba = oriented.getBytes(order: img.ChannelOrder.rgba);
  final dimensions = utf8.encode('${oriented.width}x${oriented.height}:');
  final fingerprint = sha256.convert([...dimensions, ...rgba]).toString();
  return ImageFacts(
    width: oriented.width,
    height: oriented.height,
    pixelFingerprint: fingerprint,
  );
}

PreparedOcrImages prepareHeaderVariants(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw const FormatException('Unsupported or damaged image.');
  }
  final oriented = img.bakeOrientation(decoded);
  final facts = ImageFacts(
    width: oriented.width,
    height: oriented.height,
    pixelFingerprint: sha256.convert([
      ...utf8.encode('${oriented.width}x${oriented.height}:'),
      ...oriented.getBytes(order: img.ChannelOrder.rgba),
    ]).toString(),
  );
  final headerHeight = (oriented.height * .38).round().clamp(
    1,
    oriented.height,
  );
  final header = img.copyCrop(
    oriented,
    x: 0,
    y: 0,
    width: oriented.width,
    height: headerHeight,
  );
  final maxWidth = header.width > 2200 ? 2200 : header.width;
  final scaled = header.width == maxWidth
      ? header
      : img.copyResize(header, width: maxWidth);

  Uint8List encode(img.Image value) =>
      Uint8List.fromList(img.encodePng(value, level: 3));
  final normal = img.Image.from(scaled);
  final contrast = img.adjustColor(
    img.Image.from(scaled),
    contrast: 1.35,
    brightness: 1.08,
  );
  final grayscale = img.grayscale(img.Image.from(scaled));
  final gamma = img.adjustColor(
    img.Image.from(grayscale),
    contrast: 1.45,
    gamma: .82,
  );
  final sharpened = img.convolution(
    img.Image.from(gamma),
    filter: const [0, -1, 0, -1, 5, -1, 0, -1, 0],
    amount: .55,
  );
  return PreparedOcrImages(
    facts: facts,
    pngVariants: [encode(normal), encode(contrast), encode(sharpened)],
  );
}
