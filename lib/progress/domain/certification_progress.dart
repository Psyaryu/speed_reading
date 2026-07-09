import '../../assessment/domain/quiz.dart';
import '../../content/domain/passage.dart';
import '../../core/domain/reading_enums.dart';
import '../../reading/domain/reading_session.dart';
import 'certification_rules.dart';

class CertificationProgress {
  const CertificationProgress({
    required this.qualifiedAttempts,
    required this.requiredPassageCount,
    required this.hasNonRsvpAttempt,
    required this.certificationEarned,
  });

  final List<CertificationProgressAttempt> qualifiedAttempts;
  final int requiredPassageCount;
  final bool hasNonRsvpAttempt;
  final bool certificationEarned;

  int get qualifiedPassageCount => qualifiedAttempts.length;

  int get remainingPassageCount {
    final remaining = requiredPassageCount - qualifiedPassageCount;
    return remaining < 0 ? 0 : remaining;
  }

  bool get needsNonRsvpAttempt => !hasNonRsvpAttempt;

  CertificationProgressAttempt? get bestQualifiedAttempt {
    if (qualifiedAttempts.isEmpty) {
      return null;
    }

    return qualifiedAttempts.first;
  }

  String get statusLabel {
    if (certificationEarned) {
      return '800 WPM Certified';
    }
    return 'Certification in progress';
  }

  String get remainingGapLabel {
    if (certificationEarned) {
      return 'Certification complete';
    }

    final gaps = <String>[];
    if (remainingPassageCount > 0) {
      final passageLabel = remainingPassageCount == 1 ? 'passage' : 'passages';
      gaps.add('$remainingPassageCount more official $passageLabel');
    }
    if (needsNonRsvpAttempt) {
      gaps.add('1 non-RSVP attempt');
    }

    if (gaps.isEmpty) {
      return 'Review certification requirements';
    }
    return gaps.join(' and ');
  }
}

class CertificationProgressAttempt {
  const CertificationProgressAttempt({
    required this.passageId,
    required this.passageTitle,
    required this.wpm,
    required this.comprehensionScore,
    required this.mode,
    required this.completedAt,
  });

  final String passageId;
  final String passageTitle;
  final double wpm;
  final double comprehensionScore;
  final ReadingMode mode;
  final DateTime completedAt;
}

class CertificationProgressBuilder {
  const CertificationProgressBuilder._();

  static const requiredPassageCount = 3;

  static CertificationProgress fromHistory({
    required List<ReadingSession> sessions,
    required List<QuizResult> quizResults,
    required List<Passage> passages,
  }) {
    final passagesById = {
      for (final passage in passages) passage.id: passage,
    };
    final quizzesBySessionId = {
      for (final quiz in quizResults) quiz.sessionId: quiz,
    };
    final bestAttemptsByPassageId = <String, CertificationProgressAttempt>{};
    final certificationResults = <CertificationSessionResult>[];
    var hasNonRsvpAttempt = false;

    for (final session in sessions) {
      final quiz = quizzesBySessionId[session.id];
      final passage = passagesById[session.passageId];
      if (quiz == null || passage == null) {
        continue;
      }

      final result = CertificationSessionResult(
        passageId: session.passageId,
        wpm: session.wpm,
        comprehensionScore: quiz.comprehensionScore,
        mode: session.mode,
        difficulty: passage.metadata.difficulty,
        passageType: passage.metadata.type,
        source: passage.metadata.source,
        status: session.status,
      );
      certificationResults.add(result);

      if (!CertificationRules.isEligibleSession(result)) {
        continue;
      }

      if (session.mode != ReadingMode.rsvp) {
        hasNonRsvpAttempt = true;
      }

      final attempt = CertificationProgressAttempt(
        passageId: session.passageId,
        passageTitle: passage.title,
        wpm: session.wpm,
        comprehensionScore: quiz.comprehensionScore,
        mode: session.mode,
        completedAt: session.completedAt ?? quiz.completedAt,
      );
      final existing = bestAttemptsByPassageId[session.passageId];
      if (existing == null ||
          attempt.wpm > existing.wpm ||
          (attempt.wpm == existing.wpm &&
              attempt.comprehensionScore > existing.comprehensionScore)) {
        bestAttemptsByPassageId[session.passageId] = attempt;
      }
    }

    final attempts = bestAttemptsByPassageId.values.toList()
      ..sort((a, b) {
        final byWpm = b.wpm.compareTo(a.wpm);
        if (byWpm != 0) {
          return byWpm;
        }
        final byComprehension =
            b.comprehensionScore.compareTo(a.comprehensionScore);
        if (byComprehension != 0) {
          return byComprehension;
        }
        return b.completedAt.compareTo(a.completedAt);
      });

    return CertificationProgress(
      qualifiedAttempts: attempts,
      requiredPassageCount: requiredPassageCount,
      hasNonRsvpAttempt: hasNonRsvpAttempt,
      certificationEarned: CertificationRules.isCertified(
        certificationResults,
      ),
    );
  }
}
