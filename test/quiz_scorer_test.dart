import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/assessment/domain/quiz_scorer.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';

void main() {
  test('scores selected answers', () {
    final result = QuizScorer.score(
      id: 'result-1',
      sessionId: 'session-1',
      passageId: 'passage-1',
      questions: const [
        QuizQuestion(
          id: 'q1',
          passageId: 'passage-1',
          type: QuestionType.mainIdea,
          prompt: 'What is the main idea?',
          options: ['A', 'B'],
          correctOptionIndex: 1,
        ),
        QuizQuestion(
          id: 'q2',
          passageId: 'passage-1',
          type: QuestionType.detailRecall,
          prompt: 'What detail was mentioned?',
          options: ['A', 'B'],
          correctOptionIndex: 0,
        ),
      ],
      answersByQuestionId: const {'q1': 1, 'q2': 1},
      completedAt: DateTime.utc(2026, 7, 6),
    );

    expect(result.correctCount, 1);
    expect(result.totalQuestions, 2);
    expect(result.comprehensionScore, 0.5);
  });

  test('treats missing answers as incorrect', () {
    final result = QuizScorer.score(
      id: 'result-1',
      sessionId: 'session-1',
      passageId: 'passage-1',
      questions: const [
        QuizQuestion(
          id: 'q1',
          passageId: 'passage-1',
          type: QuestionType.inference,
          prompt: 'What can be inferred?',
          options: ['A', 'B'],
          correctOptionIndex: 0,
        ),
      ],
      answersByQuestionId: const {},
      completedAt: DateTime.utc(2026, 7, 6),
    );

    expect(result.correctCount, 0);
    expect(result.comprehensionScore, 0);
  });

  test('stores written summary without changing comprehension score', () {
    final result = QuizScorer.score(
      id: 'result-1',
      sessionId: 'session-1',
      passageId: 'passage-1',
      questions: const [
        QuizQuestion(
          id: 'q1',
          passageId: 'passage-1',
          type: QuestionType.mainIdea,
          prompt: 'What is the main idea?',
          options: ['A', 'B'],
          correctOptionIndex: 0,
        ),
      ],
      answersByQuestionId: const {'q1': 1},
      completedAt: DateTime.utc(2026, 7, 6),
      writtenSummary: 'The passage follows a risky search.',
    );

    expect(result.correctCount, 0);
    expect(result.comprehensionScore, 0);
    expect(result.writtenSummary, 'The passage follows a risky search.');
  });
}
