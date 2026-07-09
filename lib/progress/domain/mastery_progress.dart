import '../../assessment/domain/quiz.dart';
import '../../content/domain/passage.dart';
import '../../core/domain/reading_enums.dart';
import '../../reading/domain/reading_session.dart';
import 'delayed_recall_attempt.dart';
import 'mastery_rules.dart';

class MasteryProgress {
  const MasteryProgress({
    required this.immediateCandidates,
    required this.requiredPassageCount,
    required this.hasNonRsvpCandidate,
    required this.delayedRecallTracked,
    required this.masteryEarned,
  });

  final List<MasteryProgressCandidate> immediateCandidates;
  final int requiredPassageCount;
  final bool hasNonRsvpCandidate;
  final bool delayedRecallTracked;
  final bool masteryEarned;

  int get immediateCandidateCount => immediateCandidates.length;

  bool get hasImmediateCandidateProgress => immediateCandidateCount > 0;

  bool get hasEnoughImmediateCandidates =>
      immediateCandidateCount >= requiredPassageCount && hasNonRsvpCandidate;
}

class MasteryProgressCandidate {
  const MasteryProgressCandidate({
    required this.passageId,
    required this.passageTitle,
    required this.wpm,
    required this.mode,
    required this.completedAt,
  });

  final String passageId;
  final String passageTitle;
  final double wpm;
  final ReadingMode mode;
  final DateTime completedAt;
}

class MasteryProgressBuilder {
  const MasteryProgressBuilder._();

  static const requiredPassageCount = 3;

  static MasteryProgress fromHistory({
    required List<ReadingSession> sessions,
    required List<QuizResult> quizResults,
    required List<Passage> passages,
    List<DelayedRecallAttempt> delayedRecallAttempts = const [],
  }) {
    final passagesById = {
      for (final passage in passages) passage.id: passage,
    };
    final quizzesBySessionId = {
      for (final quiz in quizResults) quiz.sessionId: quiz,
    };
    final bestCandidatesByPassageId = <String, MasteryProgressCandidate>{};
    final masteryResults = <MasterySessionResult>[];
    var hasNonRsvpCandidate = false;

    for (final session in sessions) {
      final quiz = quizzesBySessionId[session.id];
      final passage = passagesById[session.passageId];
      if (quiz == null || passage == null) {
        continue;
      }

      final result = MasterySessionResult(
        passageId: session.passageId,
        wpm: session.wpm,
        immediateComprehensionScore: quiz.comprehensionScore,
        delayedRecallScore: 0,
        mode: session.mode,
        difficulty: passage.metadata.difficulty,
        source: passage.metadata.source,
        status: session.status,
        excessivePausing: session.pauseCount > 3,
      );
      masteryResults.add(result);

      if (!MasteryRules.isImmediateCandidate(result)) {
        continue;
      }

      if (session.mode != ReadingMode.rsvp) {
        hasNonRsvpCandidate = true;
      }

      final completedAt = session.completedAt ?? quiz.completedAt;
      final candidate = MasteryProgressCandidate(
        passageId: session.passageId,
        passageTitle: passage.title,
        wpm: session.wpm,
        mode: session.mode,
        completedAt: completedAt,
      );
      final existing = bestCandidatesByPassageId[session.passageId];
      if (existing == null || candidate.wpm > existing.wpm) {
        bestCandidatesByPassageId[session.passageId] = candidate;
      }
    }

    for (final recallAttempt in delayedRecallAttempts) {
      if (!recallAttempt.qualifiesForMastery) {
        continue;
      }
      final candidate = bestCandidatesByPassageId[recallAttempt.passageId];
      if (candidate == null) {
        continue;
      }
      masteryResults.add(
        MasterySessionResult(
          passageId: candidate.passageId,
          wpm: candidate.wpm,
          immediateComprehensionScore: 1.0,
          delayedRecallScore: recallAttempt.score,
          mode: candidate.mode,
          difficulty: passagesById[candidate.passageId]!.metadata.difficulty,
          source: passagesById[candidate.passageId]!.metadata.source,
          status: AttemptQualificationStatus.qualified,
          excessivePausing: false,
        ),
      );
    }

    final candidates = bestCandidatesByPassageId.values.toList()
      ..sort((a, b) {
        final byDate = b.completedAt.compareTo(a.completedAt);
        if (byDate != 0) {
          return byDate;
        }
        return b.wpm.compareTo(a.wpm);
      });

    return MasteryProgress(
      immediateCandidates: candidates,
      requiredPassageCount: requiredPassageCount,
      hasNonRsvpCandidate: hasNonRsvpCandidate,
      delayedRecallTracked: delayedRecallAttempts.isNotEmpty,
      masteryEarned: MasteryRules.isMastered(masteryResults),
    );
  }
}
