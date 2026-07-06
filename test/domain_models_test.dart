import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';

void main() {
  test('passage serializes metadata and tags', () {
    const passage = Passage(
      id: 'p1',
      title: 'The Signal Fire',
      body: 'The cliff burned red under the moon.',
      metadata: PassageMetadata(
        wordCount: 8,
        difficulty: PassageDifficulty.standard,
        topic: 'Adventure',
        source: PassageSource.official,
        license: 'Public Domain',
        type: PassageType.fiction,
        vocabularyDensity: 0.2,
        tags: ['adventure', 'night', 'danger'],
        isCertificationEligible: true,
        isMasteryEligible: true,
      ),
    );

    final roundTrip = Passage.fromJson(passage.toJson());

    expect(roundTrip.id, passage.id);
    expect(roundTrip.metadata.tags, contains('danger'));
    expect(roundTrip.metadata.source, PassageSource.official);
  });

  test('reading session calculates WPM from active reading time', () {
    final session = ReadingSession(
      id: 's1',
      passageId: 'p1',
      mode: ReadingMode.manual,
      startedAt: DateTime.utc(2026, 7, 6),
      activeReadingSeconds: 30,
      wordCount: 400,
      status: AttemptQualificationStatus.qualified,
    );

    expect(session.wpm, 800);
  });

  test('quiz result calculates comprehension score', () {
    final result = QuizResult(
      id: 'q1',
      sessionId: 's1',
      passageId: 'p1',
      correctCount: 7,
      totalQuestions: 10,
      answersByQuestionId: const {'question-1': 0},
      completedAt: DateTime.utc(2026, 7, 6),
    );

    expect(result.comprehensionScore, 0.7);
  });
}

