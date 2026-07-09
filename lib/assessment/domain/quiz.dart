import '../../core/domain/reading_enums.dart';

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.passageId,
    required this.type,
    required this.prompt,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
  });

  final String id;
  final String passageId;
  final QuestionType type;
  final String prompt;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'passageId': passageId,
      'type': type.name,
      'prompt': prompt,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
    };
  }

  factory QuizQuestion.fromJson(Map<String, Object?> json) {
    return QuizQuestion(
      id: json['id'] as String,
      passageId: json['passageId'] as String,
      type: QuestionType.values.byName(json['type'] as String),
      prompt: json['prompt'] as String,
      options: (json['options'] as List<Object?>).cast<String>(),
      correctOptionIndex: json['correctOptionIndex'] as int,
      explanation: json['explanation'] as String?,
    );
  }
}

class QuizResult {
  const QuizResult({
    required this.id,
    required this.sessionId,
    required this.passageId,
    required this.correctCount,
    required this.totalQuestions,
    required this.answersByQuestionId,
    required this.completedAt,
    this.questionTypesByQuestionId = const {},
    this.writtenSummary,
  });

  final String id;
  final String sessionId;
  final String passageId;
  final int correctCount;
  final int totalQuestions;
  final Map<String, int> answersByQuestionId;
  final DateTime completedAt;
  final Map<String, QuestionType> questionTypesByQuestionId;
  final String? writtenSummary;

  double get comprehensionScore {
    if (totalQuestions == 0) {
      return 0;
    }
    return correctCount / totalQuestions;
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'passageId': passageId,
      'correctCount': correctCount,
      'totalQuestions': totalQuestions,
      'answersByQuestionId': answersByQuestionId,
      'questionTypesByQuestionId': questionTypesByQuestionId.map(
        (questionId, type) => MapEntry(questionId, type.name),
      ),
      'completedAt': completedAt.toIso8601String(),
      'writtenSummary': writtenSummary,
    };
  }

  factory QuizResult.fromJson(Map<String, Object?> json) {
    final questionTypesJson =
        json['questionTypesByQuestionId'] as Map<String, Object?>?;
    return QuizResult(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      passageId: json['passageId'] as String,
      correctCount: json['correctCount'] as int,
      totalQuestions: json['totalQuestions'] as int,
      answersByQuestionId: (json['answersByQuestionId'] as Map<String, Object?>)
          .cast<String, int>(),
      completedAt: DateTime.parse(json['completedAt'] as String),
      questionTypesByQuestionId: questionTypesJson == null
          ? const {}
          : questionTypesJson.map(
              (questionId, type) => MapEntry(
                questionId,
                QuestionType.values.byName(type as String),
              ),
            ),
      writtenSummary: json['writtenSummary'] as String?,
    );
  }
}
