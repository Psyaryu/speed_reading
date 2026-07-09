import '../../assessment/domain/quiz.dart';
import '../../content/domain/passage.dart';
import '../../core/domain/reading_enums.dart';
import '../../reading/domain/reading_session.dart';
import 'effective_reading_score.dart';
import 'progression.dart';

class BestQualifiedAttempt {
  const BestQualifiedAttempt({
    required this.sessionId,
    required this.passageId,
    required this.passageTitle,
    required this.wpm,
    required this.comprehensionScore,
    required this.effectiveReadingScore,
    required this.startedAt,
  });

  final String sessionId;
  final String passageId;
  final String passageTitle;
  final double wpm;
  final double comprehensionScore;
  final double effectiveReadingScore;
  final DateTime startedAt;
}

class BestQualifiedAttemptSelector {
  const BestQualifiedAttemptSelector._();

  static BestQualifiedAttempt? fromHistory({
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

    BestQualifiedAttempt? bestAttempt;

    for (final session in sessions) {
      final quiz = quizzesBySessionId[session.id];
      final passage = passagesById[session.passageId];
      if (quiz == null ||
          passage == null ||
          passage.metadata.source != PassageSource.official) {
        continue;
      }

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
      final attempt = BestQualifiedAttempt(
        sessionId: session.id,
        passageId: session.passageId,
        passageTitle: passage.title,
        wpm: session.wpm,
        comprehensionScore: quiz.comprehensionScore,
        effectiveReadingScore: effectiveReadingScore,
        startedAt: session.startedAt,
      );

      if (bestAttempt == null ||
          attempt.effectiveReadingScore >
              bestAttempt.effectiveReadingScore ||
          (attempt.effectiveReadingScore ==
                  bestAttempt.effectiveReadingScore &&
              attempt.wpm > bestAttempt.wpm)) {
        bestAttempt = attempt;
      }
    }

    return bestAttempt;
  }
}
