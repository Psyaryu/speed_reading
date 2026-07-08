import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/data/official_question_loader.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';

void main() {
  test('parses official question asset format', () {
    const rawJson = '''
[
  {
    "id": "q1",
    "passageId": "p1",
    "type": "mainIdea",
    "prompt": "What is the main idea?",
    "options": ["A", "B", "C", "D"],
    "correctOptionIndex": 1,
    "explanation": "Because B is correct."
  }
]
''';

    final questions = const OfficialQuestionLoader().parse(rawJson);

    expect(questions.single.id, 'q1');
    expect(questions.single.passageId, 'p1');
    expect(questions.single.type, QuestionType.mainIdea);
    expect(questions.single.correctOptionIndex, 1);
    expect(questions.single.explanation, contains('B'));
  });

  test('bundled question JSON includes required categories', () {
    final questions = const OfficialQuestionLoader().parse(_bundledFixture);
    final types = questions.map((question) => question.type).toSet();

    expect(types, contains(QuestionType.mainIdea));
    expect(types, contains(QuestionType.detailRecall));
    expect(types, contains(QuestionType.inference));
    expect(types, contains(QuestionType.vocabularyInContext));
  });
}

const _bundledFixture = '''
[
  {
    "id": "treasure-island-001-main-idea",
    "passageId": "treasure-island-001",
    "type": "mainIdea",
    "prompt": "What is Jim Hawkins preparing to record?",
    "options": ["The complete account", "A list", "A letter", "Rules"],
    "correctOptionIndex": 0,
    "explanation": "The narrator writes the whole particulars."
  },
  {
    "id": "treasure-island-001-detail-inn",
    "passageId": "treasure-island-001",
    "type": "detailRecall",
    "prompt": "Where was the inn?",
    "options": ["Spy-glass", "Admiral Benbow", "Bristol", "Island"],
    "correctOptionIndex": 1,
    "explanation": "The inn was the Admiral Benbow."
  },
  {
    "id": "treasure-island-001-inference-secret",
    "passageId": "treasure-island-001",
    "type": "inference",
    "prompt": "Why keep back the bearings?",
    "options": ["Forgot", "No treasure", "Treasure remains", "Destroyed"],
    "correctOptionIndex": 2,
    "explanation": "Treasure is still not lifted."
  },
  {
    "id": "treasure-island-001-vocabulary-bearings",
    "passageId": "treasure-island-001",
    "type": "vocabularyInContext",
    "prompt": "What does bearings mean?",
    "options": ["Parts", "Posture", "Directions", "Meal"],
    "correctOptionIndex": 2,
    "explanation": "Bearings are location details."
  }
]
''';
