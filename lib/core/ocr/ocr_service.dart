import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/app_database.dart';
import '../image_processing/image_tools.dart';

class OcrAnalysis {
  const OcrAnalysis({
    required this.rawText,
    required this.title,
    required this.normalizedTitle,
    required this.quality,
    required this.needsReview,
    required this.keyLabel,
    required this.facts,
    required this.enhancementMicros,
    required this.ocrMicros,
  });

  final String rawText;
  final String? title;
  final String? normalizedTitle;
  final double quality;
  final bool needsReview;
  final String? keyLabel;
  final ImageFacts facts;
  final int enhancementMicros;
  final int ocrMicros;
}

class SetlistLine {
  const SetlistLine({
    required this.text,
    required this.normalizedTitle,
    this.requestedKey,
  });
  final String text;
  final String normalizedTitle;
  final String? requestedKey;
}

class OcrLayoutLine {
  const OcrLayoutLine({
    required this.text,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });
  final String text;
  final double left;
  final double top;
  final double right;
  final double bottom;
  double get height => bottom - top;
}

class OcrService {
  OcrService()
    : _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  final TextRecognizer _recognizer;
  Future<void> _tail = Future.value();

  Future<T> _serialized<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _tail = _tail.catchError((_) {}).then((_) async {
      try {
        completer.complete(await action());
      } catch (error, stack) {
        completer.completeError(error, stack);
      }
    });
    return completer.future;
  }

  Future<OcrAnalysis> recognizeSheet(
    Uint8List originalBytes,
    SheetInspection inspection,
  ) => _serialized(() async {
    final ocrWatch = Stopwatch()..start();
    var enhancementMicros = 0;
    RecognizedText? best;
    _TitleCandidate? bestCandidate;
    var bestQuality = 0.0;

    Future<void> consider(Uint8List bytes, String filename) async {
      final recognized = await _recognizeImage(bytes, filename);
      final candidate = _chooseTitle(recognized);
      final quality = candidate?.quality ?? 0;
      if (quality > bestQuality || best == null) {
        best = recognized;
        bestCandidate = candidate;
        bestQuality = quality;
      }
    }

    await consider(inspection.normalHeaderPng, 'header_normal.png');
    if (bestQuality < .72) {
      for (var stage = 1; stage <= 2 && bestQuality < .72; stage++) {
        final enhancementWatch = Stopwatch()..start();
        final enhanced = await Isolate.run(
          () => enhanceHeader(inspection.normalHeaderPng, stage),
        );
        enhancementMicros += enhancementWatch.elapsedMicroseconds;
        await consider(enhanced, 'header_enhanced_$stage.png');
      }
    }
    if (bestQuality < .48) {
      await consider(originalBytes, 'full${_extension(originalBytes)}');
    }
    ocrWatch.stop();
    final title = bestCandidate?.text.trim();
    return OcrAnalysis(
      rawText: best?.text ?? '',
      title: title?.isEmpty == true ? null : title,
      normalizedTitle: title == null ? null : normalizeTitle(title),
      quality: bestQuality,
      needsReview: title == null || bestQuality < .68,
      keyLabel: _printedKey(best?.text ?? ''),
      facts: inspection.facts,
      enhancementMicros: enhancementMicros,
      ocrMicros: ocrWatch.elapsedMicroseconds,
    );
  });

  Future<List<SetlistLine>> recognizeSetlist(Uint8List bytes) =>
      _serialized(() async {
        final recognized = await _recognizeImage(
          bytes,
          'setlist${_extension(bytes)}',
        );
        final layoutLines = recognized.blocks
            .expand((block) => block.lines)
            .map(
              (line) => OcrLayoutLine(
                text: line.text,
                left: line.boundingBox.left,
                top: line.boundingBox.top,
                right: line.boundingBox.right,
                bottom: line.boundingBox.bottom,
              ),
            )
            .toList();
        final output = <SetlistLine>[];
        for (final raw in orderAndGroupSetlistLines(layoutLines)) {
          final cleaned = raw
              .replaceFirst(RegExp(r'^\s*(?:\d+[.)-]?|[-•])\s*'), '')
              .trim();
          if (cleaned.length < 2 || !RegExp(r'[A-Za-z]').hasMatch(cleaned)) {
            continue;
          }
          final key = _printedKey(cleaned);
          final title = cleaned
              .replaceFirst(
                RegExp(
                  r'\s*[-–—(]\s*(?:key\s*[:=]?\s*)?[A-G](?:#|b)?\)?\s*$',
                  caseSensitive: false,
                ),
                '',
              )
              .trim();
          if (title.isEmpty) continue;
          output.add(
            SetlistLine(
              text: title,
              normalizedTitle: normalizeTitle(title),
              requestedKey: key,
            ),
          );
        }
        return output;
      });

  Future<RecognizedText> _recognizeImage(
    Uint8List bytes,
    String filename,
  ) async {
    final directory = await getTemporaryDirectory();
    final file = File(
      p.join(
        directory.path,
        'song_sheets_${DateTime.now().microsecondsSinceEpoch}_$filename',
      ),
    );
    try {
      await file.writeAsBytes(bytes, flush: true);
      return await _recognizer.processImage(InputImage.fromFilePath(file.path));
    } finally {
      if (await file.exists()) await file.delete();
    }
  }

  Future<void> close() => _recognizer.close();
}

List<String> orderAndGroupSetlistLines(List<OcrLayoutLine> input) {
  final lines = input
      .where((line) => line.text.trim().isNotEmpty && line.height > 0)
      .toList();
  if (lines.isEmpty) return const [];
  final sortedHeights = lines.map((line) => line.height).toList()..sort();
  final medianHeight = sortedHeights[sortedHeights.length ~/ 2];
  final minLeft = lines.map((line) => line.left).reduce(min);
  final maxRight = lines.map((line) => line.right).reduce(max);
  final pageWidth = max(1.0, maxRight - minLeft);
  final columnThreshold = max(medianHeight * 3.5, pageWidth * .14);
  final clusters = <_LayoutColumn>[];
  for (final line in [...lines]..sort((a, b) => a.left.compareTo(b.left))) {
    _LayoutColumn? nearest;
    var distance = double.infinity;
    for (final cluster in clusters) {
      final candidate = (cluster.anchor - line.left).abs();
      if (candidate < distance && candidate <= columnThreshold) {
        distance = candidate;
        nearest = cluster;
      }
    }
    if (nearest == null) {
      clusters.add(_LayoutColumn(line.left, [line]));
    } else {
      nearest.lines.add(line);
      nearest.anchor =
          nearest.lines.map((item) => item.left).reduce((a, b) => a + b) /
          nearest.lines.length;
    }
  }
  clusters.sort((a, b) => a.anchor.compareTo(b.anchor));

  final rows = <String>[];
  final numbered = RegExp(r'^\s*(?:\d+[.)-]?|[-•])\s*');
  for (final cluster in clusters) {
    cluster.lines.sort((a, b) => a.top.compareTo(b.top));
    String? current;
    OcrLayoutLine? previous;
    for (final line in cluster.lines) {
      final text = line.text.trim();
      final startsRow = numbered.hasMatch(text);
      final closeContinuation =
          previous != null &&
          line.top - previous.bottom <= medianHeight * 1.7 &&
          (line.left - cluster.anchor).abs() <= columnThreshold;
      if (!startsRow && current != null && closeContinuation) {
        current = '$current $text';
        rows[rows.length - 1] = current;
      } else {
        current = text;
        rows.add(text);
      }
      previous = line;
    }
  }
  return rows;
}

class _LayoutColumn {
  _LayoutColumn(this.anchor, this.lines);
  double anchor;
  final List<OcrLayoutLine> lines;
}

class _TitleCandidate {
  const _TitleCandidate(this.text, this.quality);
  final String text;
  final double quality;
}

_TitleCandidate? _chooseTitle(RecognizedText text) {
  final lines = text.blocks.expand((block) => block.lines).where((line) {
    final value = line.text.trim();
    return value.length >= 2 && RegExp(r'[A-Za-z]').hasMatch(value);
  }).toList();
  if (lines.isEmpty) return null;
  final maxHeight = lines.map((line) => line.boundingBox.height).reduce(max);
  final maxBottom = lines.map((line) => line.boundingBox.bottom).reduce(max);
  final candidates = <_TitleCandidate>[];
  for (var index = 0; index < lines.length; index++) {
    final line = lines[index];
    final value = line.text.trim();
    final relativeSize = maxHeight == 0
        ? 0.0
        : line.boundingBox.height / maxHeight;
    final position = maxBottom == 0
        ? 0.0
        : 1 - (line.boundingBox.top / maxBottom).clamp(0, 1);
    final words = value.split(RegExp(r'\s+')).length;
    final plausible = RegExp(
      r"^[A-Za-z0-9][A-Za-z0-9&()'.,!?:;\-\s]+$",
    ).hasMatch(value);
    final looksLikeCredit = RegExp(
      r'\b(arranged|composed|lyrics|music|copyright|publisher|words by|music by)\b',
      caseSensitive: false,
    ).hasMatch(value);
    var quality =
        relativeSize * .45 +
        position * .2 +
        min(words, 6) / 6 * .25 +
        (plausible ? .1 : 0) -
        (looksLikeCredit ? .45 : 0);
    var grouped = value;
    if (index + 1 < lines.length) {
      final next = lines[index + 1];
      final gap = next.boundingBox.top - line.boundingBox.bottom;
      if (gap >= 0 &&
          gap < maxHeight * .75 &&
          next.boundingBox.height >= line.boundingBox.height * .65) {
        grouped = '$value ${next.text.trim()}';
        quality += .06;
      }
    }
    candidates.add(_TitleCandidate(grouped, quality.clamp(0, 1)));
  }
  candidates.sort((a, b) => b.quality.compareTo(a.quality));
  return candidates.first;
}

String? _printedKey(String text) {
  final match = RegExp(
    r'\b(?:key\s*[:=]\s*)?([A-G](?:#|b)?)(?=\s*(?:major|minor|maj|min|\)|$))',
    caseSensitive: false,
  ).firstMatch(text);
  if (match == null) return null;
  final value = match.group(1)!;
  return value[0].toUpperCase() + value.substring(1);
}

String _extension(Uint8List bytes) {
  if (bytes.length >= 8 && bytes[0] == 0x89 && bytes[1] == 0x50) return '.png';
  if (bytes.length >= 3 && bytes[0] == 0xff && bytes[1] == 0xd8) return '.jpg';
  return '.img';
}
