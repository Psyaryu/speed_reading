import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/domain/progression.dart';

void main() {
  test('qualifies attempts at 70 percent comprehension and 600 words', () {
    const input = QualifiedAttemptInput(
      wpm: 800,
      comprehensionScore: 0.7,
      wordCount: 600,
      difficulty: PassageDifficulty.standard,
      status: AttemptQualificationStatus.qualified,
      excessivePausing: false,
    );

    expect(Progression.isQualifiedAttempt(input), isTrue);
  });

  test('rejects attempts below comprehension threshold', () {
    const input = QualifiedAttemptInput(
      wpm: 800,
      comprehensionScore: 0.69,
      wordCount: 600,
      difficulty: PassageDifficulty.standard,
      status: AttemptQualificationStatus.qualified,
      excessivePausing: false,
    );

    expect(Progression.isQualifiedAttempt(input), isFalse);
  });

  test('rejects short attempts', () {
    const input = QualifiedAttemptInput(
      wpm: 800,
      comprehensionScore: 0.7,
      wordCount: 599,
      difficulty: PassageDifficulty.standard,
      status: AttemptQualificationStatus.qualified,
      excessivePausing: false,
    );

    expect(Progression.isQualifiedAttempt(input), isFalse);
  });

  test('caps readiness at 100 percent', () {
    expect(Progression.readinessPercent(900), 100);
  });

  test('maps ERS thresholds to levels', () {
    expect(Progression.levelForQualifiedErs(249), 1);
    expect(Progression.levelForQualifiedErs(250), 2);
    expect(Progression.levelForQualifiedErs(350), 3);
    expect(Progression.levelForQualifiedErs(450), 4);
    expect(Progression.levelForQualifiedErs(600), 5);
    expect(Progression.levelForQualifiedErs(700), 6);
    expect(Progression.levelForQualifiedErs(800), 7);
  });
}

