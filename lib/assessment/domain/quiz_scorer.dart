import 'quiz.dart';

class QuizScorer {
  const QuizScorer._();

  static QuizResult score({
    required String id,
    required String sessionId,
    required String passageId,
    required List<QuizQuestion> questions,
    required Map<String, int> answersByQuestionId,
    required DateTime completedAt,
    String? writtenSummary,
  }) {
    final correctCount = questions.where((question) {
      return answersByQuestionId[question.id] == question.correctOptionIndex;
    }).length;

    return QuizResult(
      id: id,
      sessionId: sessionId,
      passageId: passageId,
      correctCount: correctCount,
      totalQuestions: questions.length,
      answersByQuestionId: answersByQuestionId,
      completedAt: completedAt,
      writtenSummary: writtenSummary,
    );
  }
}
