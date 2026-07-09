import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/data/official_question_loader.dart';
import 'package:speed_reading/assessment/domain/question_count_policy.dart';
import 'package:speed_reading/content/data/official_passage_loader.dart';
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

  test('bundled official passages have length-scaled questions', () {
    final passages = const OfficialPassageLoader().parse(
      File('assets/passages/official_passages.json').readAsStringSync(),
    );
    final questions = const OfficialQuestionLoader().parse(
      File('assets/passages/official_questions.json').readAsStringSync(),
    );
    final questionsByPassageId = <String, List<Object>>{};

    for (final question in questions) {
      questionsByPassageId
          .putIfAbsent(question.passageId, () => <Object>[])
          .add(question);
    }

    for (final passage in passages) {
      final passageQuestions = questionsByPassageId[passage.id] ?? <Object>[];
      final expectedMinimum = QuestionCountPolicy.countForWordCount(
        passage.metadata.wordCount,
      );

      expect(
        passageQuestions,
        hasLength(greaterThanOrEqualTo(expectedMinimum)),
        reason: '${passage.id} should have enough bundled questions',
      );
    }
  });

  test('bundled official questions include practical category coverage', () {
    final passages = const OfficialPassageLoader().parse(
      File('assets/passages/official_passages.json').readAsStringSync(),
    );
    final questions = const OfficialQuestionLoader().parse(
      File('assets/passages/official_questions.json').readAsStringSync(),
    );
    final passageIds = passages.map((passage) => passage.id).toSet();
    final questionIds = <String>{};

    for (final question in questions) {
      expect(questionIds.add(question.id), isTrue);
      expect(passageIds, contains(question.passageId));
      expect(question.prompt, isNotEmpty);
      expect(question.options, hasLength(4));
      expect(question.correctOptionIndex, inInclusiveRange(0, 3));
      expect(question.explanation, isNotEmpty);
    }

    for (final passage in passages) {
      final types = questions
          .where((question) => question.passageId == passage.id)
          .map((question) => question.type)
          .toSet();

      expect(types, contains(QuestionType.mainIdea));
      expect(types, contains(QuestionType.detailRecall));
      expect(types, contains(QuestionType.inference));
      expect(types, contains(QuestionType.vocabularyInContext));
    }
  });
}
