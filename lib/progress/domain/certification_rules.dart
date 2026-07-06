import '../../core/domain/reading_enums.dart';

class CertificationSessionResult {
  const CertificationSessionResult({
    required this.passageId,
    required this.wpm,
    required this.comprehensionScore,
    required this.mode,
    required this.difficulty,
    required this.passageType,
    required this.source,
    required this.status,
  });

  final String passageId;
  final double wpm;
  final double comprehensionScore;
  final ReadingMode mode;
  final PassageDifficulty difficulty;
  final PassageType passageType;
  final PassageSource source;
  final AttemptQualificationStatus status;
}

class CertificationRules {
  const CertificationRules._();

  static bool isEligibleSession(CertificationSessionResult result) {
    return result.source == PassageSource.official &&
        result.passageType == PassageType.nonFiction &&
        result.difficulty != PassageDifficulty.easy &&
        result.wpm >= 800 &&
        result.comprehensionScore >= 0.7 &&
        result.status == AttemptQualificationStatus.qualified;
  }

  static bool isCertified(List<CertificationSessionResult> results) {
    final eligible = results.where(isEligibleSession).toList();
    final uniquePassageIds = eligible.map((result) => result.passageId).toSet();
    final hasThreePassages = uniquePassageIds.length >= 3;
    final hasNonRsvpAttempt = eligible.any(
      (result) => result.mode != ReadingMode.rsvp,
    );

    return hasThreePassages && hasNonRsvpAttempt;
  }
}

