import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/domain/mastery_rules.dart';

void main() {
  test('awards mastery for three eligible official passages', () {
    final results = [
      _result('p1', ReadingMode.rsvp),
      _result('p2', ReadingMode.rsvp),
      _result('p3', ReadingMode.manual),
    ];

    expect(MasteryRules.isMastered(results), isTrue);
  });

  test('requires perfect immediate comprehension', () {
    final result = _result(
      'p1',
      ReadingMode.manual,
      immediateComprehensionScore: 0.99,
    );

    expect(MasteryRules.isEligibleSession(result), isFalse);
  });

  test('requires delayed recall at or above 90 percent', () {
    final result = _result('p1', ReadingMode.manual, delayedRecallScore: 0.89);

    expect(MasteryRules.isEligibleSession(result), isFalse);
  });

  test('rejects excessively paused attempts', () {
    final result = _result('p1', ReadingMode.manual, excessivePausing: true);

    expect(MasteryRules.isEligibleSession(result), isFalse);
  });

  test('requires at least one non-RSVP attempt', () {
    final results = [
      _result('p1', ReadingMode.rsvp),
      _result('p2', ReadingMode.rsvp),
      _result('p3', ReadingMode.rsvp),
    ];

    expect(MasteryRules.isMastered(results), isFalse);
  });
}

MasterySessionResult _result(
  String passageId,
  ReadingMode mode, {
  double immediateComprehensionScore = 1,
  double delayedRecallScore = 0.9,
  bool excessivePausing = false,
}) {
  return MasterySessionResult(
    passageId: passageId,
    wpm: 800,
    immediateComprehensionScore: immediateComprehensionScore,
    delayedRecallScore: delayedRecallScore,
    mode: mode,
    difficulty: PassageDifficulty.standard,
    source: PassageSource.official,
    status: AttemptQualificationStatus.qualified,
    excessivePausing: excessivePausing,
  );
}

