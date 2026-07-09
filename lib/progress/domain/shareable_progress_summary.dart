import '../../assessment/domain/quiz.dart';
import '../../content/domain/passage.dart';
import '../../reading/domain/reading_session.dart';
import 'certification_rules.dart';
import 'effective_reading_score.dart';
import 'mastery_rules.dart';
import 'progression.dart';

class ShareableProgressSummary {
  const ShareableProgressSummary({
    required this.levelName,
    required this.effectiveReadingScore,
    required this.qualifiedWpm,
    required this.comprehensionScore,
    required this.streakDays,
    required this.certificationStatus,
    this.masteryStatus = 'Mastery not earned yet',
  });

  final String levelName;
  final double effectiveReadingScore;
  final double qualifiedWpm;
  final double comprehensionScore;
  final int streakDays;
  final String certificationStatus;
  final String masteryStatus;

  String toShareText() {
    final comprehensionPercent = (comprehensionScore * 100).round();
    return 'Speed Reading Trainer: $levelName, '
        '${qualifiedWpm.round()} WPM at $comprehensionPercent% comprehension, '
        'ERS ${effectiveReadingScore.round()}, '
        '$streakDays day streak, '
        '$certificationStatus, '
        '$masteryStatus.';
  }
}

class ShareableProgressSummaryBuilder {
  const ShareableProgressSummaryBuilder._();

  static ShareableProgressSummary? fromHistory({
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

    _QualifiedShareAttempt? bestAttempt;
    final certificationResults = <CertificationSessionResult>[];
    final masteryResults = <MasterySessionResult>[];

    for (final session in sessions) {
      final quiz = quizzesBySessionId[session.id];
      final passage = passagesById[session.passageId];
      if (quiz == null || passage == null) {
        continue;
      }

      certificationResults.add(
        CertificationSessionResult(
          passageId: session.passageId,
          wpm: session.wpm,
          comprehensionScore: quiz.comprehensionScore,
          mode: session.mode,
          difficulty: passage.metadata.difficulty,
          passageType: passage.metadata.type,
          source: passage.metadata.source,
          status: session.status,
        ),
      );
      masteryResults.add(
        MasterySessionResult(
          passageId: session.passageId,
          wpm: session.wpm,
          immediateComprehensionScore: quiz.comprehensionScore,
          delayedRecallScore: 0,
          mode: session.mode,
          difficulty: passage.metadata.difficulty,
          source: passage.metadata.source,
          status: session.status,
          excessivePausing: session.pauseCount > 3,
        ),
      );

      final input = QualifiedAttemptInput(
        wpm: session.wpm,
        comprehensionScore: quiz.comprehensionScore,
        wordCount: session.wordCount,
        difficulty: passage.metadata.difficulty,
        status: session.status,
        excessivePausing: session.pauseCount > 3,
      );
      if (!Progression.isQualifiedAttempt(input)) {
        continue;
      }

      final effectiveReadingScore = EffectiveReadingScore.calculate(
        wpm: session.wpm,
        comprehensionScore: quiz.comprehensionScore,
        difficulty: passage.metadata.difficulty,
        mode: session.mode,
      );
      final attempt = _QualifiedShareAttempt(
        wpm: session.wpm,
        comprehensionScore: quiz.comprehensionScore,
        effectiveReadingScore: effectiveReadingScore,
      );
      if (bestAttempt == null ||
          attempt.effectiveReadingScore > bestAttempt.effectiveReadingScore) {
        bestAttempt = attempt;
      }
    }

    final attempt = bestAttempt;
    if (attempt == null) {
      return null;
    }

    final level = Progression.levelForQualifiedErs(
      attempt.effectiveReadingScore,
    );
    return ShareableProgressSummary(
      levelName: Progression.levelName(level),
      effectiveReadingScore: attempt.effectiveReadingScore,
      qualifiedWpm: attempt.wpm,
      comprehensionScore: attempt.comprehensionScore,
      streakDays: _currentStreakDays(sessions),
      certificationStatus: CertificationRules.isCertified(
        certificationResults,
      )
          ? '800 WPM certified'
          : 'Certification not earned yet',
      masteryStatus: MasteryRules.isMastered(masteryResults)
          ? '800 WPM mastery earned'
          : 'Mastery not earned yet',
    );
  }

  static int _currentStreakDays(List<ReadingSession> sessions) {
    if (sessions.isEmpty) {
      return 0;
    }

    final days = sessions
        .map((session) => DateTime.utc(
              session.startedAt.year,
              session.startedAt.month,
              session.startedAt.day,
            ))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    var streak = 1;
    var expectedPreviousDay = days.first.subtract(const Duration(days: 1));
    for (final day in days.skip(1)) {
      if (day == expectedPreviousDay) {
        streak += 1;
        expectedPreviousDay = expectedPreviousDay.subtract(
          const Duration(days: 1),
        );
      } else {
        break;
      }
    }

    return streak;
  }
}

class _QualifiedShareAttempt {
  const _QualifiedShareAttempt({
    required this.wpm,
    required this.comprehensionScore,
    required this.effectiveReadingScore,
  });

  final double wpm;
  final double comprehensionScore;
  final double effectiveReadingScore;
}
