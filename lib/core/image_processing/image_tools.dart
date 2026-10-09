import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;

enum SheetClassification { songSheet, nonSongSheet, uncertain }

class ClassificationResult {
  const ClassificationResult({
    required this.classification,
    required this.score,
    required this.staffGroups,
    required this.evidence,
  });

  final SheetClassification classification;
  final double score;
  final int staffGroups;
  final List<String> evidence;
}

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

class SheetInspection {
  const SheetInspection({required this.facts, required this.normalHeaderPng});
  final ImageFacts facts;
  final Uint8List normalHeaderPng;
}

ClassificationResult classifyPreview(Uint8List previewBytes) {
  final decoded = img.decodeImage(previewBytes);
  if (decoded == null) {
    throw const FormatException('Unsupported or damaged image preview.');
  }
  final oriented = img.bakeOrientation(decoded);
  final preview = oriented.width > 640
      ? img.copyResize(oriented, width: 640)
      : oriented;
  final rowDarkFractions = List<double>.filled(preview.height, 0);
  var saturationTotal = 0.0;
  var sampled = 0;
  var headerDark = 0;
  var headerSamples = 0;
  final step = max(1, preview.width ~/ 480);
  for (var y = 0; y < preview.height; y++) {
    var dark = 0;
    var rowSamples = 0;
    for (var x = 0; x < preview.width; x += step) {
      final pixel = preview.getPixel(x, y);
      final luminance = (pixel.r + pixel.g + pixel.b) / (3 * 255);
      if (luminance < .43) dark++;
      final high = max(pixel.r, max(pixel.g, pixel.b)).toDouble();
      final low = min(pixel.r, min(pixel.g, pixel.b)).toDouble();
      saturationTotal += high == 0 ? 0 : (high - low) / high;
      sampled++;
      rowSamples++;
      if (y < preview.height * .3) {
        if (luminance < .55) headerDark++;
        headerSamples++;
      }
    }
    rowDarkFractions[y] = rowSamples == 0 ? 0 : dark / rowSamples;
  }

  final horizontalCenters = <int>[];
  var runStart = -1;
  for (var y = 0; y <= rowDarkFractions.length; y++) {
    final candidate = y < rowDarkFractions.length && rowDarkFractions[y] >= .42;
    if (candidate && runStart < 0) runStart = y;
    if (!candidate && runStart >= 0) {
      if (y - runStart <= max(4, preview.height ~/ 120)) {
        horizontalCenters.add((runStart + y - 1) ~/ 2);
      }
      runStart = -1;
    }
  }

  var staffGroups = 0;
  for (var index = 0; index + 4 < horizontalCenters.length; index++) {
    final gaps = <int>[
      for (var offset = 0; offset < 4; offset++)
        horizontalCenters[index + offset + 1] -
            horizontalCenters[index + offset],
    ];
    final average = gaps.reduce((a, b) => a + b) / gaps.length;
    final tolerance = max(1.5, average * .35);
    if (average >= 2 &&
        average <= max(24, preview.height * .035) &&
        gaps.every((gap) => (gap - average).abs() <= tolerance)) {
      staffGroups++;
      index += 4;
    }
  }

  final saturation = sampled == 0 ? 0.0 : saturationTotal / sampled;
  final headerDensity = headerSamples == 0 ? 0.0 : headerDark / headerSamples;
  final headerStructure = headerDensity >= .008 && headerDensity <= .28;
  final lineEvidence = min(1.0, staffGroups / 2);
  final layoutEvidence = min(1.0, horizontalCenters.length / 12);
  final score =
      (lineEvidence * .72 + layoutEvidence * .18 + (headerStructure ? .10 : 0))
          .clamp(0.0, 1.0);
  final evidence = <String>[
    '$staffGroups staff-line group${staffGroups == 1 ? '' : 's'}',
    '${horizontalCenters.length} long horizontal line candidates',
    headerStructure ? 'structured header region' : 'no strong header structure',
  ];
  if (staffGroups >= 1 && score >= .52) {
    return ClassificationResult(
      classification: SheetClassification.songSheet,
      score: score,
      staffGroups: staffGroups,
      evidence: evidence,
    );
  }
  if (staffGroups == 0 &&
      score < .16 &&
      (saturation > .12 || horizontalCenters.length < 3)) {
    return ClassificationResult(
      classification: SheetClassification.nonSongSheet,
      score: score,
      staffGroups: staffGroups,
      evidence: evidence,
    );
  }
  return ClassificationResult(
    classification: SheetClassification.uncertain,
    score: score,
    staffGroups: staffGroups,
    evidence: evidence,
  );
}

SheetInspection inspectSheet(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw const FormatException('Unsupported or damaged image.');
  }
  final oriented = img.bakeOrientation(decoded);
  final facts = _facts(oriented);
  final headerHeight = (oriented.height * .38).round().clamp(
    1,
    oriented.height,
  );
  var header = img.copyCrop(
    oriented,
    x: 0,
    y: 0,
    width: oriented.width,
    height: headerHeight,
  );
  if (header.width > 2200) header = img.copyResize(header, width: 2200);
  return SheetInspection(
    facts: facts,
    normalHeaderPng: Uint8List.fromList(img.encodePng(header, level: 3)),
  );
}

Uint8List enhanceHeader(Uint8List normalHeaderPng, int stage) {
  final decoded = img.decodePng(normalHeaderPng);
  if (decoded == null) {
    throw const FormatException('Could not decode the bounded OCR header.');
  }
  final enhanced = switch (stage) {
    1 => img.adjustColor(decoded, contrast: 1.35, brightness: 1.08),
    _ => img.convolution(
      img.adjustColor(img.grayscale(decoded), contrast: 1.45, gamma: .82),
      filter: const [0, -1, 0, -1, 5, -1, 0, -1, 0],
      amount: .55,
    ),
  };
  return Uint8List.fromList(img.encodePng(enhanced, level: 3));
}

ImageFacts inspectDecodedPixels(Uint8List bytes) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw const FormatException('Unsupported or damaged image.');
  }
  return _facts(img.bakeOrientation(decoded));
}

ImageFacts _facts(img.Image oriented) {
  final rgba = oriented.getBytes(order: img.ChannelOrder.rgba);
  return ImageFacts(
    width: oriented.width,
    height: oriented.height,
    pixelFingerprint: sha256.convert([
      ...utf8.encode('${oriented.width}x${oriented.height}:'),
      ...rgba,
    ]).toString(),
  );
}
