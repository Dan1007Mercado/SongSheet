import 'package:flutter_test/flutter_test.dart';
import 'package:song_sheets/features/services/song_matcher.dart';

void main() {
  test(
    'exact titles score one',
    () => expect(similarity('the prayer', 'the prayer'), 1),
  );

  test('fuzzy score proposes close text without being exact', () {
    final score = similarity('amazing grace', 'amzing grace');
    expect(score, greaterThan(.8));
    expect(score, lessThan(1));
  });

  test('unrelated titles do not meet proposal threshold', () {
    expect(similarity('holy holy holy', 'the prayer'), lessThan(.62));
  });
}
