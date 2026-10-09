import 'dart:math';

import '../../core/database/app_database.dart';
import '../../core/ocr/ocr_service.dart';

enum MatchStatus { matched, missing, ambiguous }

class SongMatch {
  const SongMatch({
    required this.line,
    required this.status,
    required this.candidateEditionIds,
    this.editionId,
  });

  final SetlistLine line;
  final MatchStatus status;
  final String? editionId;
  final List<String> candidateEditionIds;
}

class SongMatcher {
  const SongMatcher();

  Future<SongMatch> match(AppDatabase database, SetlistLine line) async {
    var editions = await database.editionsForNormalizedTitle(
      line.normalizedTitle,
    );
    if (line.requestedKey != null) {
      editions = editions
          .where((edition) => _sameKey(edition.keyLabel, line.requestedKey))
          .toList();
    }
    if (editions.length == 1) {
      return SongMatch(
        line: line,
        status: MatchStatus.matched,
        editionId: editions.single.id,
        candidateEditionIds: [editions.single.id],
      );
    }
    if (editions.length > 1) {
      return SongMatch(
        line: line,
        status: MatchStatus.ambiguous,
        candidateEditionIds: editions.map((edition) => edition.id).toList(),
      );
    }

    final searchable = await database.searchableEditions();
    final byEdition = <String, ({String id, double score, String? key})>{};
    for (final row in searchable) {
      var score = similarity(
        line.normalizedTitle,
        row['normalized_title']! as String,
      );
      for (final filename
          in '${row['normalized_filenames'] ?? ''}'
              .split('|')
              .where((value) => value.isNotEmpty)) {
        score = max(score, similarity(line.normalizedTitle, filename));
      }
      final candidate = (
        id: row['edition_id']! as String,
        score: score,
        key: row['key_label'] as String?,
      );
      final current = byEdition[candidate.id];
      if (current == null || candidate.score > current.score) {
        byEdition[candidate.id] = candidate;
      }
    }
    final proposals =
        byEdition.values
            .where(
              (candidate) =>
                  candidate.score >= .62 &&
                  (line.requestedKey == null ||
                      _sameKey(candidate.key, line.requestedKey)),
            )
            .toList()
          ..sort((a, b) => b.score.compareTo(a.score));
    return SongMatch(
      line: line,
      status: proposals.isEmpty ? MatchStatus.missing : MatchStatus.ambiguous,
      candidateEditionIds: proposals
          .take(5)
          .map((candidate) => candidate.id)
          .toList(),
    );
  }
}

bool _sameKey(String? left, String? right) =>
    left?.trim().toLowerCase() == right?.trim().toLowerCase();

double similarity(String left, String right) {
  if (left == right) return 1;
  if (left.isEmpty || right.isEmpty) return 0;
  final distance = _levenshtein(left, right);
  return 1 - distance / max(left.length, right.length);
}

int _levenshtein(String left, String right) {
  var previous = List<int>.generate(right.length + 1, (index) => index);
  for (var row = 1; row <= left.length; row++) {
    final current = <int>[row];
    for (var column = 1; column <= right.length; column++) {
      current.add(
        min(
          min(current[column - 1] + 1, previous[column] + 1),
          previous[column - 1] +
              (left.codeUnitAt(row - 1) == right.codeUnitAt(column - 1)
                  ? 0
                  : 1),
        ),
      );
    }
    previous = current;
  }
  return previous.last;
}
