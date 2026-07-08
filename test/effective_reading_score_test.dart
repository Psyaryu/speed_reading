import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/domain/effective_reading_score.dart';

void main() {
  test('calculates ERS from PRD example', () {
    final score = EffectiveReadingScore.calculate(
      wpm: 600,
      comprehensionScore: 0.75,
      difficulty: PassageDifficulty.standard,
      mode: ReadingMode.paced,
    );

    expect(score, 450);
  });

  test('penalizes comprehension below 60 percent', () {
    final score = EffectiveReadingScore.calculate(
      wpm: 600,
      comprehensionScore: 0.59,
      difficulty: PassageDifficulty.standard,
      mode: ReadingMode.paced,
    );

    expect(score, 177);
  });

  test('does not penalize comprehension at 60 percent', () {
    final score = EffectiveReadingScore.calculate(
      wpm: 600,
      comprehensionScore: 0.60,
      difficulty: PassageDifficulty.standard,
      mode: ReadingMode.paced,
    );

    expect(score, 360);
  });

  test('applies difficulty and mode multipliers', () {
    final score = EffectiveReadingScore.calculate(
      wpm: 800,
      comprehensionScore: 1,
      difficulty: PassageDifficulty.hard,
      mode: ReadingMode.rsvp,
    );

    expect(score, closeTo(828, 0.001));
  });

  test('clamps comprehension score to valid range', () {
    final score = EffectiveReadingScore.calculate(
      wpm: 800,
      comprehensionScore: 1.2,
      difficulty: PassageDifficulty.standard,
      mode: ReadingMode.manual,
    );

    expect(score, 800);
  });
}
