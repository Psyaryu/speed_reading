import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/domain/skill_breakdown.dart';

void main() {
  test('summarizes answered quiz accuracy by skill', () {
    final breakdown = SkillBreakdownBuilder.fromQuizHistory(
      quizResults: [
        QuizResult(
          id: 'quiz-1',
          sessionId: 'session-1',
          passageId: 'passage-1',
          correctCount: 2,
          totalQuestions: 4,
          answersByQuestionId: const {
            'main-idea-1': 1,
            'detail-1': 0,
            'detail-2': 3,
            'unknown-question': 0,
          },
          completedAt: DateTime.utc(2026, 7, 8),
        ),
      ],
      questions: const [
        QuizQuestion(
          id: 'main-idea-1',
          passageId: 'passage-1',
          type: QuestionType.mainIdea,
          prompt: 'Main idea?',
          options: ['A', 'B'],
          correctOptionIndex: 1,
        ),
        QuizQuestion(
          id: 'detail-1',
          passageId: 'passage-1',
          type: QuestionType.detailRecall,
          prompt: 'Detail?',
          options: ['A', 'B'],
          correctOptionIndex: 0,
        ),
        QuizQuestion(
          id: 'detail-2',
          passageId: 'passage-1',
          type: QuestionType.detailRecall,
          prompt: 'Another detail?',
          options: ['A', 'B', 'C', 'D'],
          correctOptionIndex: 2,
        ),
      ],
    );

    expect(breakdown.hasAnsweredQuestions, isTrue);
    expect(breakdown.totalAnsweredQuestions, 3);
    expect(breakdown.unmatchedAnswerCount, 1);

    final mainIdea = breakdown.entries.singleWhere(
      (entry) => entry.type == QuestionType.mainIdea,
    );
    expect(mainIdea.correctCount, 1);
    expect(mainIdea.answeredCount, 1);
    expect(mainIdea.accuracy, 1);

    final detailRecall = breakdown.entries.singleWhere(
      (entry) => entry.type == QuestionType.detailRecall,
    );
    expect(detailRecall.correctCount, 1);
    expect(detailRecall.answeredCount, 2);
    expect(detailRecall.accuracy, 0.5);
  });

  test('reports empty state when answers cannot be matched to skills', () {
    final breakdown = SkillBreakdownBuilder.fromQuizHistory(
      quizResults: [
        QuizResult(
          id: 'quiz-1',
          sessionId: 'session-1',
          passageId: 'imported-passage',
          correctCount: 1,
          totalQuestions: 1,
          answersByQuestionId: const {'custom-question': 0},
          completedAt: DateTime.utc(2026, 7, 8),
        ),
      ],
      questions: const [],
    );

    expect(breakdown.hasAnsweredQuestions, isFalse);
    expect(breakdown.totalAnsweredQuestions, 0);
    expect(breakdown.unmatchedAnswerCount, 1);
  });
}
