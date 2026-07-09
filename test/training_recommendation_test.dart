import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';
import 'package:speed_reading/training/domain/training_recommendation.dart';

void main() {
  test('prioritizes comprehension when below threshold', () {
    expect(
      TrainingRecommendationEngine.recommend(
        const TrainingRecommendationInput(
          recentComprehension: 0.69,
          wpmPlateaued: true,
          detailRecallWeak: false,
          scanningAccuracy: 1,
          rsvpOnlyProgress: true,
        ),
      ),
      TrainingDrill.comprehensionReview,
    );
  });

  test('recommends non-RSVP transfer for RSVP-only progress', () {
    expect(
      TrainingRecommendationEngine.recommend(
        const TrainingRecommendationInput(
          recentComprehension: 0.8,
          wpmPlateaued: false,
          detailRecallWeak: false,
          scanningAccuracy: 1,
          rsvpOnlyProgress: true,
        ),
      ),
      TrainingDrill.nonRsvpTransfer,
    );
  });

  test('recommends scanning when accuracy is weak', () {
    expect(
      TrainingRecommendationEngine.recommend(
        const TrainingRecommendationInput(
          recentComprehension: 0.8,
          wpmPlateaued: false,
          detailRecallWeak: false,
          scanningAccuracy: 0.79,
          rsvpOnlyProgress: false,
        ),
      ),
      TrainingDrill.scanning,
    );
  });

  test('recommends chunking when WPM plateaus', () {
    expect(
      TrainingRecommendationEngine.recommend(
        const TrainingRecommendationInput(
          recentComprehension: 0.8,
          wpmPlateaued: true,
          detailRecallWeak: false,
          scanningAccuracy: 1,
          rsvpOnlyProgress: false,
        ),
      ),
      TrainingDrill.chunking,
    );
  });

  test('derives comprehension slowdown from recent quiz history', () {
    final input = TrainingRecommendationInput.fromHistory(
      sessions: [
        _session(
          id: 'session-1',
          startedAt: DateTime.utc(2026, 7, 8),
          activeReadingSeconds: 120,
          wordCount: 800,
          status: AttemptQualificationStatus.unqualified,
        ),
      ],
      quizResults: [
        _quiz(
          sessionId: 'session-1',
          correctCount: 6,
          totalQuestions: 10,
        ),
      ],
      questions: const [],
    );

    expect(
      TrainingRecommendationEngine.recommend(input),
      TrainingDrill.comprehensionReview,
    );
  });

  test('derives WPM plateau from recent qualified attempts', () {
    final input = TrainingRecommendationInput.fromHistory(
      sessions: [
        _session(
          id: 'session-1',
          startedAt: DateTime.utc(2026, 7, 8),
          activeReadingSeconds: 120,
          wordCount: 800,
        ),
        _session(
          id: 'session-2',
          startedAt: DateTime.utc(2026, 7, 7),
          activeReadingSeconds: 117,
          wordCount: 800,
        ),
        _session(
          id: 'session-3',
          startedAt: DateTime.utc(2026, 7, 6),
          activeReadingSeconds: 123,
          wordCount: 800,
        ),
      ],
      quizResults: [
        _quiz(sessionId: 'session-1'),
        _quiz(sessionId: 'session-2'),
        _quiz(sessionId: 'session-3'),
      ],
      questions: const [],
    );

    expect(
      TrainingRecommendationEngine.recommend(input),
      TrainingDrill.chunking,
    );
  });

  test('derives weak detail recall from question category misses', () {
    final input = TrainingRecommendationInput.fromHistory(
      sessions: [
        _session(
          id: 'session-1',
          startedAt: DateTime.utc(2026, 7, 8),
          activeReadingSeconds: 120,
          wordCount: 800,
        ),
      ],
      quizResults: [
        _quiz(
          sessionId: 'session-1',
          answersByQuestionId: const {
            'detail-1': 0,
            'detail-2': 1,
            'main-1': 1,
          },
        ),
      ],
      questions: [
        _question(
          id: 'detail-1',
          type: QuestionType.detailRecall,
          correctOptionIndex: 1,
        ),
        _question(
          id: 'detail-2',
          type: QuestionType.detailRecall,
          correctOptionIndex: 1,
        ),
        _question(
          id: 'main-1',
          type: QuestionType.mainIdea,
          correctOptionIndex: 1,
        ),
      ],
    );

    expect(
      TrainingRecommendationEngine.recommend(input),
      TrainingDrill.comprehensionReview,
    );
  });

  test('derives weak scanning only from scan-mode quiz data', () {
    final input = TrainingRecommendationInput.fromHistory(
      sessions: [
        _session(
          id: 'scan-1',
          startedAt: DateTime.utc(2026, 7, 8),
          activeReadingSeconds: 100,
          wordCount: 800,
          mode: ReadingMode.scan,
        ),
      ],
      quizResults: [
        _quiz(
          sessionId: 'scan-1',
          correctCount: 3,
          totalQuestions: 4,
        ),
      ],
      questions: const [],
    );

    expect(
      TrainingRecommendationEngine.recommend(input),
      TrainingDrill.scanning,
    );
  });

  test('does not invent weak scanning when no scan-mode data exists', () {
    final input = TrainingRecommendationInput.fromHistory(
      sessions: [
        _session(
          id: 'manual-1',
          startedAt: DateTime.utc(2026, 7, 8),
          activeReadingSeconds: 120,
          wordCount: 800,
          mode: ReadingMode.manual,
        ),
      ],
      quizResults: [
        _quiz(sessionId: 'manual-1'),
      ],
      questions: const [],
    );

    expect(input.scanningAccuracy, isNull);
    expect(
      TrainingRecommendationEngine.recommend(input),
      TrainingDrill.pacedReading,
    );
  });

  test('derives RSVP-only progress without non-RSVP transfer', () {
    final input = TrainingRecommendationInput.fromHistory(
      sessions: [
        _session(
          id: 'rsvp-1',
          startedAt: DateTime.utc(2026, 7, 8),
          activeReadingSeconds: 60,
          wordCount: 800,
          mode: ReadingMode.rsvp,
        ),
        _session(
          id: 'manual-1',
          startedAt: DateTime.utc(2026, 7, 7),
          activeReadingSeconds: 120,
          wordCount: 800,
          mode: ReadingMode.manual,
        ),
      ],
      quizResults: [
        _quiz(sessionId: 'rsvp-1'),
        _quiz(sessionId: 'manual-1'),
      ],
      questions: const [],
    );

    expect(
      TrainingRecommendationEngine.recommend(input),
      TrainingDrill.nonRsvpTransfer,
    );
  });

  test('history-derived recommendations change when performance changes', () {
    final stableInput = TrainingRecommendationInput.fromHistory(
      sessions: [
        _session(
          id: 'stable-1',
          startedAt: DateTime.utc(2026, 7, 8),
          activeReadingSeconds: 100,
          wordCount: 800,
        ),
      ],
      quizResults: [
        _quiz(sessionId: 'stable-1'),
      ],
      questions: const [],
    );
    final weakInput = TrainingRecommendationInput.fromHistory(
      sessions: [
        _session(
          id: 'weak-1',
          startedAt: DateTime.utc(2026, 7, 8),
          activeReadingSeconds: 120,
          wordCount: 800,
          status: AttemptQualificationStatus.unqualified,
        ),
      ],
      quizResults: [
        _quiz(
          sessionId: 'weak-1',
          correctCount: 6,
          totalQuestions: 10,
        ),
      ],
      questions: const [],
    );

    expect(
      TrainingRecommendationEngine.recommend(stableInput),
      TrainingDrill.pacedReading,
    );
    expect(
      TrainingRecommendationEngine.recommend(weakInput),
      TrainingDrill.comprehensionReview,
    );
    expect(
      TrainingRecommendationEngine.recommend(stableInput),
      TrainingRecommendationEngine.recommend(stableInput),
    );
  });
}

ReadingSession _session({
  required String id,
  required DateTime startedAt,
  required int activeReadingSeconds,
  required int wordCount,
  ReadingMode mode = ReadingMode.manual,
  AttemptQualificationStatus status = AttemptQualificationStatus.qualified,
}) {
  return ReadingSession(
    id: id,
    passageId: 'passage-1',
    mode: mode,
    startedAt: startedAt,
    activeReadingSeconds: activeReadingSeconds,
    wordCount: wordCount,
    status: status,
  );
}

QuizResult _quiz({
  required String sessionId,
  int correctCount = 8,
  int totalQuestions = 10,
  Map<String, int> answersByQuestionId = const {},
}) {
  return QuizResult(
    id: 'quiz-$sessionId',
    sessionId: sessionId,
    passageId: 'passage-1',
    correctCount: correctCount,
    totalQuestions: totalQuestions,
    answersByQuestionId: answersByQuestionId,
    completedAt: DateTime.utc(2026, 7, 8),
  );
}

QuizQuestion _question({
  required String id,
  required QuestionType type,
  required int correctOptionIndex,
}) {
  return QuizQuestion(
    id: id,
    passageId: 'passage-1',
    type: type,
    prompt: 'Question?',
    options: const ['A', 'B'],
    correctOptionIndex: correctOptionIndex,
  );
}
