import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
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
  });

  final String rawText;
  final String? title;
  final String? normalizedTitle;
  final double quality;
  final bool needsReview;
  final String? keyLabel;
  final ImageFacts facts;
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

  Future<OcrAnalysis> recognizeSheet(Uint8List bytes) => _serialized(() async {
    final prepared = await Isolate.run(() => prepareHeaderVariants(bytes));
    RecognizedText? best;
    _TitleCandidate? bestCandidate;
    var bestQuality = 0.0;
    for (var index = 0; index < prepared.pngVariants.length; index++) {
      final recognized = await _recognizePng(
        prepared.pngVariants[index],
        'header_$index.png',
      );
      final candidate = _chooseTitle(recognized);
      final quality = candidate?.quality ?? 0;
      if (quality > bestQuality || best == null) {
        best = recognized;
        bestCandidate = candidate;
        bestQuality = quality;
      }
      if (index == 0 && quality >= .72) break;
    }
    if (bestQuality < .48) {
      final full = await _recognizePng(bytes, 'full${_extension(bytes)}');
      final candidate = _chooseTitle(full);
      if ((candidate?.quality ?? 0) > bestQuality) {
        best = full;
        bestCandidate = candidate;
        bestQuality = candidate?.quality ?? 0;
      }
    }
    final title = bestCandidate?.text.trim();
    return OcrAnalysis(
      rawText: best?.text ?? '',
      title: title?.isEmpty == true ? null : title,
      normalizedTitle: title == null ? null : normalizeTitle(title),
      quality: bestQuality,
      needsReview: title == null || bestQuality < .68,
      keyLabel: _printedKey(best?.text ?? ''),
      facts: prepared.facts,
    );
  });

  Future<List<SetlistLine>> recognizeSetlist(Uint8List bytes) =>
      _serialized(() async {
        final recognized = await _recognizePng(
          bytes,
          'setlist${_extension(bytes)}',
        );
        final lines = recognized.blocks.expand((block) => block.lines).toList()
          ..sort((a, b) {
            final vertical = a.boundingBox.top.compareTo(b.boundingBox.top);
            return vertical.abs() > 8
                ? vertical
                : a.boundingBox.left.compareTo(b.boundingBox.left);
          });
        final output = <SetlistLine>[];
        for (final line in lines) {
          final cleaned = line.text
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

  Future<RecognizedText> _recognizePng(Uint8List bytes, String filename) async {
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
