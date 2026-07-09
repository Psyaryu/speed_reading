import '../../assessment/domain/quiz.dart';
import '../../core/domain/reading_enums.dart';

class SkillBreakdown {
  const SkillBreakdown({
    required this.entries,
    required this.unmatchedAnswerCount,
  });

  final List<SkillBreakdownEntry> entries;
  final int unmatchedAnswerCount;

  int get totalAnsweredQuestions {
    return entries.fold(0, (total, entry) => total + entry.answeredCount);
  }

  bool get hasAnsweredQuestions => totalAnsweredQuestions > 0;
}

class SkillBreakdownEntry {
  const SkillBreakdownEntry({
    required this.type,
    required this.correctCount,
    required this.answeredCount,
  });

  final QuestionType type;
  final int correctCount;
  final int answeredCount;

  double get accuracy {
    if (answeredCount == 0) {
      return 0;
    }
    return correctCount / answeredCount;
  }

  String get label {
    return switch (type) {
      QuestionType.multipleChoice => 'Multiple Choice',
      QuestionType.mainIdea => 'Main Idea',
      QuestionType.detailRecall => 'Detail Recall',
      QuestionType.inference => 'Inference',
      QuestionType.vocabularyInContext => 'Vocabulary',
      QuestionType.writtenSummary => 'Written Summary',
    };
  }
}

class SkillBreakdownBuilder {
  const SkillBreakdownBuilder._();

  static SkillBreakdown fromQuizHistory({
    required List<QuizResult> quizResults,
    required List<QuizQuestion> questions,
  }) {
    final questionsById = {
      for (final question in questions) question.id: question,
    };
    final correctCounts = {
      for (final type in QuestionType.values) type: 0,
    };
    final answeredCounts = {
      for (final type in QuestionType.values) type: 0,
    };

    var unmatchedAnswerCount = 0;
    for (final result in quizResults) {
      for (final answer in result.answersByQuestionId.entries) {
        final question = questionsById[answer.key];
        if (question == null) {
          unmatchedAnswerCount += 1;
          continue;
        }

        final type = question.type;
        answeredCounts[type] = answeredCounts[type]! + 1;
        if (answer.value == question.correctOptionIndex) {
          correctCounts[type] = correctCounts[type]! + 1;
        }
      }
    }

    return SkillBreakdown(
      entries: [
        for (final type in _displayTypes)
          SkillBreakdownEntry(
            type: type,
            correctCount: correctCounts[type]!,
            answeredCount: answeredCounts[type]!,
          ),
      ],
      unmatchedAnswerCount: unmatchedAnswerCount,
    );
  }

  static const _displayTypes = [
    QuestionType.mainIdea,
    QuestionType.detailRecall,
    QuestionType.inference,
    QuestionType.vocabularyInContext,
    QuestionType.multipleChoice,
    QuestionType.writtenSummary,
  ];
}
