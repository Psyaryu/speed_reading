import '../../core/domain/reading_enums.dart';

class MasterySessionResult {
  const MasterySessionResult({
    required this.passageId,
    required this.wpm,
    required this.immediateComprehensionScore,
    required this.delayedRecallScore,
    required this.mode,
    required this.difficulty,
    required this.source,
    required this.status,
    required this.excessivePausing,
  });

  final String passageId;
  final double wpm;
  final double immediateComprehensionScore;
  final double delayedRecallScore;
  final ReadingMode mode;
  final PassageDifficulty difficulty;
  final PassageSource source;
  final AttemptQualificationStatus status;
  final bool excessivePausing;
}

class MasteryRules {
  const MasteryRules._();

  static bool isEligibleSession(MasterySessionResult result) {
    return isImmediateCandidate(result) &&
        result.delayedRecallScore >= 0.9 &&
        result.status == AttemptQualificationStatus.qualified;
  }

  static bool isImmediateCandidate(MasterySessionResult result) {
    return result.source == PassageSource.official &&
        (result.difficulty == PassageDifficulty.standard ||
            result.difficulty == PassageDifficulty.hard) &&
        result.wpm >= 800 &&
        result.immediateComprehensionScore == 1.0 &&
        result.status == AttemptQualificationStatus.qualified &&
        !result.excessivePausing;
  }

  static bool isMastered(List<MasterySessionResult> results) {
    final eligible = results.where(isEligibleSession).toList();
    final uniquePassageIds = eligible.map((result) => result.passageId).toSet();
    final hasThreePassages = uniquePassageIds.length >= 3;
    final hasNonRsvpAttempt = eligible.any(
      (result) => result.mode != ReadingMode.rsvp,
    );

    return hasThreePassages && hasNonRsvpAttempt;
  }
}
