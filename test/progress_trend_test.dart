import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/domain/progress_trend.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';

void main() {
  test('builds dated WPM comprehension and ERS trend points', () {
    final trend = ProgressTrendBuilder.fromHistory(
      sessions: [
        _session(
          id: 'latest',
          passageId: 'official-hard',
          startedAt: DateTime.utc(2026, 7, 8),
          wordCount: 900,
          activeReadingSeconds: 90,
        ),
        _session(
          id: 'earliest',
          passageId: 'imported-standard',
          startedAt: DateTime.utc(2026, 7, 6),
          wordCount: 600,
          activeReadingSeconds: 60,
        ),
        _session(
          id: 'missing-passage',
          passageId: 'missing',
          startedAt: DateTime.utc(2026, 7, 7),
          wordCount: 700,
          activeReadingSeconds: 60,
        ),
        _session(
          id: 'no-quiz',
          passageId: 'official-hard',
          startedAt: DateTime.utc(2026, 7, 9),
          wordCount: 700,
          activeReadingSeconds: 60,
        ),
        _session(
          id: 'incomplete',
          passageId: 'official-hard',
          startedAt: DateTime.utc(2026, 7, 10),
          wordCount: 700,
          activeReadingSeconds: 60,
          status: AttemptQualificationStatus.incomplete,
        ),
      ],
      quizResults: [
        _quiz(
          sessionId: 'latest',
          passageId: 'official-hard',
          correctCount: 8,
        ),
        _quiz(
          sessionId: 'earliest',
          passageId: 'imported-standard',
          correctCount: 7,
        ),
        _quiz(
          sessionId: 'missing-passage',
          passageId: 'missing',
          correctCount: 9,
        ),
      ],
      passages: const [_officialHard, _importedStandard],
    );

    expect(trend.hasEnoughData, isTrue);
    expect(trend.unmatchedSessionCount, 1);
    expect(trend.points.map((point) => point.sessionId), [
      'earliest',
      'latest',
    ]);

    final earliest = trend.points.first;
    expect(earliest.wpm, 600);
    expect(earliest.comprehensionScore, 0.7);
    expect(earliest.effectiveReadingScore, 420);
    expect(earliest.source, PassageSource.imported);

    final latest = trend.points.last;
    expect(latest.wpm, 600);
    expect(latest.comprehensionScore, 0.8);
    expect(latest.effectiveReadingScore, 552);
    expect(latest.source, PassageSource.official);
  });

  test('requires at least two paired points for trend display', () {
    final trend = ProgressTrendBuilder.fromHistory(
      sessions: [
        _session(
          id: 'only',
          passageId: 'official-hard',
          startedAt: DateTime.utc(2026, 7, 8),
          wordCount: 900,
          activeReadingSeconds: 90,
        ),
      ],
      quizResults: [
        _quiz(
          sessionId: 'only',
          passageId: 'official-hard',
          correctCount: 8,
        ),
      ],
      passages: const [_officialHard],
    );

    expect(trend.points, hasLength(1));
    expect(trend.hasEnoughData, isFalse);
  });
}

ReadingSession _session({
  required String id,
  required String passageId,
  required DateTime startedAt,
  required int wordCount,
  required int activeReadingSeconds,
  AttemptQualificationStatus status = AttemptQualificationStatus.qualified,
}) {
  return ReadingSession(
    id: id,
    passageId: passageId,
    mode: ReadingMode.manual,
    startedAt: startedAt,
    activeReadingSeconds: activeReadingSeconds,
    wordCount: wordCount,
    status: status,
  );
}

QuizResult _quiz({
  required String sessionId,
  required String passageId,
  required int correctCount,
}) {
  return QuizResult(
    id: 'quiz-$sessionId',
    sessionId: sessionId,
    passageId: passageId,
    correctCount: correctCount,
    totalQuestions: 10,
    answersByQuestionId: const {},
    completedAt: DateTime.utc(2026, 7, 8, 12, 2),
  );
}

const _officialHard = Passage(
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
);

const _importedStandard = Passage(
  id: 'imported-standard',
  title: 'Imported Standard',
  body: 'Private imported passage body.',
  metadata: PassageMetadata(
    wordCount: 600,
    difficulty: PassageDifficulty.standard,
    topic: 'Private',
    source: PassageSource.imported,
    license: 'User provided',
    type: PassageType.workplace,
    vocabularyDensity: 0.2,
    tags: ['private'],
    isCertificationEligible: false,
    isMasteryEligible: false,
  ),
);
