import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/domain/best_qualified_attempt.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';

void main() {
  test('selects highest ERS official qualified attempt', () {
    final attempt = BestQualifiedAttemptSelector.fromHistory(
      sessions: [
        _session(
          id: 'imported-fast',
          passageId: 'imported',
          wordCount: 1000,
          activeReadingSeconds: 60,
        ),
        _session(
          id: 'official-fast-low-comp',
          passageId: 'official-standard',
          wordCount: 900,
          activeReadingSeconds: 60,
        ),
        _session(
          id: 'official-best',
          passageId: 'official-hard',
          wordCount: 900,
          activeReadingSeconds: 90,
        ),
        _session(
          id: 'official-short',
          passageId: 'official-standard',
          wordCount: 500,
          activeReadingSeconds: 60,
        ),
      ],
      quizResults: [
        _quiz(
          id: 'imported-fast',
          sessionId: 'imported-fast',
          passageId: 'imported',
          correctCount: 10,
        ),
        _quiz(
          id: 'official-fast-low-comp',
          sessionId: 'official-fast-low-comp',
          passageId: 'official-standard',
          correctCount: 6,
        ),
        _quiz(
          id: 'official-best',
          sessionId: 'official-best',
          passageId: 'official-hard',
          correctCount: 8,
        ),
        _quiz(
          id: 'official-short',
          sessionId: 'official-short',
          passageId: 'official-standard',
          correctCount: 10,
        ),
      ],
      passages: const [
        Passage(
          id: 'imported',
          title: 'Imported Passage',
          body: 'Private imported body.',
          metadata: PassageMetadata(
            wordCount: 1000,
            difficulty: PassageDifficulty.technical,
            topic: 'Private',
            source: PassageSource.imported,
            license: 'User provided',
            type: PassageType.workplace,
            vocabularyDensity: 0.2,
            tags: ['private'],
            isCertificationEligible: false,
            isMasteryEligible: false,
          ),
        ),
        Passage(
          id: 'official-standard',
          title: 'Official Standard',
          body: 'Official body.',
          metadata: PassageMetadata(
            wordCount: 900,
            difficulty: PassageDifficulty.standard,
            topic: 'Adventure',
            source: PassageSource.official,
            license: 'Public domain',
            type: PassageType.fiction,
            vocabularyDensity: 0.2,
            tags: ['official'],
            isCertificationEligible: true,
            isMasteryEligible: true,
          ),
        ),
        Passage(
          id: 'official-hard',
          title: 'Official Hard',
          body: 'Official body.',
          metadata: PassageMetadata(
            wordCount: 900,
            difficulty: PassageDifficulty.hard,
            topic: 'Adventure',
            source: PassageSource.official,
            license: 'Public domain',
            type: PassageType.fiction,
            vocabularyDensity: 0.3,
            tags: ['official'],
            isCertificationEligible: true,
            isMasteryEligible: true,
          ),
        ),
      ],
    );

    expect(attempt, isNotNull);
    expect(attempt!.sessionId, 'official-best');
    expect(attempt.passageTitle, 'Official Hard');
    expect(attempt.wpm, 600);
    expect(attempt.comprehensionScore, 0.8);
    expect(attempt.effectiveReadingScore, 552);
  });

  test('returns null when official attempts are not paired with quizzes', () {
    final attempt = BestQualifiedAttemptSelector.fromHistory(
      sessions: [
        _session(
          id: 'official-no-quiz',
          passageId: 'official-standard',
          wordCount: 900,
          activeReadingSeconds: 60,
        ),
      ],
      quizResults: const [],
      passages: const [
        Passage(
          id: 'official-standard',
          title: 'Official Standard',
          body: 'Official body.',
          metadata: PassageMetadata(
            wordCount: 900,
            difficulty: PassageDifficulty.standard,
            topic: 'Adventure',
            source: PassageSource.official,
            license: 'Public domain',
            type: PassageType.fiction,
            vocabularyDensity: 0.2,
            tags: ['official'],
            isCertificationEligible: true,
            isMasteryEligible: true,
          ),
        ),
      ],
    );

    expect(attempt, isNull);
  });
}

ReadingSession _session({
  required String id,
  required String passageId,
  required int wordCount,
  required int activeReadingSeconds,
}) {
  return ReadingSession(
    id: id,
    passageId: passageId,
    mode: ReadingMode.manual,
    startedAt: DateTime.utc(2026, 7, 8, 12),
    activeReadingSeconds: activeReadingSeconds,
    wordCount: wordCount,
    status: AttemptQualificationStatus.qualified,
  );
}

QuizResult _quiz({
  required String id,
  required String sessionId,
  required String passageId,
  required int correctCount,
}) {
  return QuizResult(
    id: id,
    sessionId: sessionId,
    passageId: passageId,
    correctCount: correctCount,
    totalQuestions: 10,
    answersByQuestionId: const {},
    completedAt: DateTime.utc(2026, 7, 8, 12, 2),
  );
}
