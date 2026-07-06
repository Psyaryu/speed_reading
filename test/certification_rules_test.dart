import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/domain/certification_rules.dart';

void main() {
  test('certifies three eligible official non-fiction passages', () {
    final results = [
      _result('p1', ReadingMode.rsvp),
      _result('p2', ReadingMode.rsvp),
      _result('p3', ReadingMode.paced),
    ];

    expect(CertificationRules.isCertified(results), isTrue);
  });

  test('requires at least one non-RSVP attempt', () {
    final results = [
      _result('p1', ReadingMode.rsvp),
      _result('p2', ReadingMode.rsvp),
      _result('p3', ReadingMode.rsvp),
    ];

    expect(CertificationRules.isCertified(results), isFalse);
  });

  test('rejects imported passages', () {
    final result = _result('p1', ReadingMode.paced, source: PassageSource.imported);

    expect(CertificationRules.isEligibleSession(result), isFalse);
  });

  test('rejects attempts below 800 WPM', () {
    final result = _result('p1', ReadingMode.paced, wpm: 799);

    expect(CertificationRules.isEligibleSession(result), isFalse);
  });

  test('rejects attempts below 70 percent comprehension', () {
    final result = _result('p1', ReadingMode.paced, comprehensionScore: 0.69);

    expect(CertificationRules.isEligibleSession(result), isFalse);
  });
}

CertificationSessionResult _result(
  String passageId,
  ReadingMode mode, {
  PassageSource source = PassageSource.official,
  double wpm = 800,
  double comprehensionScore = 0.7,
}) {
  return CertificationSessionResult(
    passageId: passageId,
    wpm: wpm,
    comprehensionScore: comprehensionScore,
    mode: mode,
    difficulty: PassageDifficulty.standard,
    passageType: PassageType.nonFiction,
    source: source,
    status: AttemptQualificationStatus.qualified,
  );
}

