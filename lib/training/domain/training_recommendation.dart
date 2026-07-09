import '../../assessment/domain/quiz.dart';
import '../../core/domain/reading_enums.dart';
import '../../reading/domain/reading_session.dart';

enum TrainingDrill {
  pacedReading,
  chunking,
  regressionControl,
  subvocalizationAwareness,
  skimming,
  scanning,
  rsvp,
  comprehensionReview,
  nonRsvpTransfer,
}

class TrainingRecommendationInput {
  const TrainingRecommendationInput({
    required this.recentComprehension,
    required this.wpmPlateaued,
    required this.detailRecallWeak,
    required this.scanningAccuracy,
    required this.rsvpOnlyProgress,
  });

  final double recentComprehension;
  final bool wpmPlateaued;
  final bool detailRecallWeak;
  final double? scanningAccuracy;
  final bool rsvpOnlyProgress;

  factory TrainingRecommendationInput.fromHistory({
    required List<ReadingSession> sessions,
    required List<QuizResult> quizResults,
    required List<QuizQuestion> questions,
  }) {
    final quizBySessionId = {
      for (final result in quizResults) result.sessionId: result,
    };
    final newestSessions = [...sessions]
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

    final recentQuizScores = newestSessions
        .map((session) => quizBySessionId[session.id])
        .whereType<QuizResult>()
        .map((quiz) => quiz.comprehensionScore)
        .take(3)
        .toList(growable: false);

    final recentQualifiedSessions = newestSessions
        .where((session) => _isQualifiedSignal(session, quizBySessionId))
        .take(3)
        .toList(growable: false);
    final recentWpms =
        recentQualifiedSessions.map((session) => session.wpm).toList();
    final wpmPlateaued =
        recentWpms.length >= 3 && (_max(recentWpms) - _min(recentWpms)) <= 25;

    final scanQuizScores = newestSessions
        .where((session) => session.mode == ReadingMode.scan)
        .map((session) => quizBySessionId[session.id])
        .whereType<QuizResult>()
        .map((quiz) => quiz.comprehensionScore)
        .take(3)
        .toList(growable: false);

    final qualifiedSessions = newestSessions
        .where((session) => _isQualifiedSignal(session, quizBySessionId))
        .toList(growable: false);
    final rsvpWpms = qualifiedSessions
        .where((session) => session.mode == ReadingMode.rsvp)
        .map((session) => session.wpm)
        .toList(growable: false);
    final nonRsvpWpms = qualifiedSessions
        .where((session) => session.mode != ReadingMode.rsvp)
        .map((session) => session.wpm)
        .toList(growable: false);
    final bestRsvpWpm = rsvpWpms.isEmpty ? 0.0 : _max(rsvpWpms);
    final bestNonRsvpWpm = nonRsvpWpms.isEmpty ? 0.0 : _max(nonRsvpWpms);

    return TrainingRecommendationInput(
      recentComprehension: _averageOrDefault(recentQuizScores, 1),
      wpmPlateaued: wpmPlateaued,
      detailRecallWeak: _questionTypeAccuracy(
            quizResults: quizResults,
            questions: questions,
            type: QuestionType.detailRecall,
          ) <
          0.7,
      scanningAccuracy:
          scanQuizScores.isEmpty ? null : _averageOrDefault(scanQuizScores, 1),
      rsvpOnlyProgress: bestRsvpWpm > 0 && bestNonRsvpWpm < bestRsvpWpm * 0.9,
    );
  }
}

class TrainingRecommendationEngine {
  const TrainingRecommendationEngine._();

  static TrainingDrill recommend(TrainingRecommendationInput input) {
    if (input.recentComprehension < 0.7 || input.detailRecallWeak) {
      return TrainingDrill.comprehensionReview;
    }
    if (input.rsvpOnlyProgress) {
      return TrainingDrill.nonRsvpTransfer;
    }
    if (input.scanningAccuracy != null && input.scanningAccuracy! < 0.8) {
      return TrainingDrill.scanning;
    }
    if (input.wpmPlateaued) {
      return TrainingDrill.chunking;
    }
    return TrainingDrill.pacedReading;
  }
}

bool _isQualifiedSignal(
  ReadingSession session,
  Map<String, QuizResult> quizBySessionId,
) {
  final quiz = quizBySessionId[session.id];
  return session.status == AttemptQualificationStatus.qualified &&
      quiz != null &&
      quiz.comprehensionScore >= 0.7;
}

double _questionTypeAccuracy({
  required List<QuizResult> quizResults,
  required List<QuizQuestion> questions,
  required QuestionType type,
}) {
  final questionsById = {
    for (final question in questions) question.id: question,
  };
  var answeredCount = 0;
  var correctCount = 0;

  final newestResults = [...quizResults]
    ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  for (final result in newestResults.take(5)) {
    for (final answer in result.answersByQuestionId.entries) {
      final question = questionsById[answer.key];
      if (question == null || question.type != type) {
        continue;
      }

      answeredCount += 1;
      if (answer.value == question.correctOptionIndex) {
        correctCount += 1;
      }
    }
  }

  if (answeredCount == 0) {
    return 1;
  }
  return correctCount / answeredCount;
}

double _averageOrDefault(List<double> values, double defaultValue) {
  if (values.isEmpty) {
    return defaultValue;
  }
  return values.fold(0.0, (sum, value) => sum + value) / values.length;
}

double _max(List<double> values) {
  return values.reduce((a, b) => a > b ? a : b);
}

double _min(List<double> values) {
  return values.reduce((a, b) => a < b ? a : b);
}
