import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/domain/delayed_recall_attempt.dart';
import 'package:speed_reading/progress/domain/mastery_progress.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';

void main() {
  test('tracks unique immediate mastery candidates', () {
    final progress = MasteryProgressBuilder.fromHistory(
      sessions: [
        _session(id: 's1', passageId: 'p1', mode: ReadingMode.rsvp),
        _session(id: 's2', passageId: 'p2', mode: ReadingMode.manual),
        _session(id: 's3', passageId: 'p3', mode: ReadingMode.rsvp),
        _session(id: 's4', passageId: 'p1', wordCount: 900),
      ],
      quizResults: [
        _quiz(id: 'q1', sessionId: 's1', passageId: 'p1'),
        _quiz(id: 'q2', sessionId: 's2', passageId: 'p2'),
        _quiz(id: 'q3', sessionId: 's3', passageId: 'p3'),
        _quiz(id: 'q4', sessionId: 's4', passageId: 'p1'),
      ],
      passages: [
        _passage('p1'),
        _passage('p2'),
        _passage('p3'),
      ],
    );

    expect(progress.immediateCandidateCount, 3);
    expect(progress.hasNonRsvpCandidate, isTrue);
    expect(progress.hasEnoughImmediateCandidates, isTrue);
    expect(progress.delayedRecallTracked, isFalse);
    expect(progress.masteryEarned, isFalse);
    expect(progress.immediateCandidates.first.passageId, 'p1');
    expect(progress.immediateCandidates.first.wpm, 900);
  });

  test('rejects attempts that miss immediate mastery rules', () {
    final progress = MasteryProgressBuilder.fromHistory(
      sessions: [
        _session(id: 'too-slow', passageId: 'p1', wordCount: 799),
        _session(id: 'imported', passageId: 'p2'),
        _session(id: 'too-easy', passageId: 'p3'),
        _session(id: 'paused', passageId: 'p4', pauseCount: 4),
        _session(
          id: 'unqualified',
          passageId: 'p5',
          status: AttemptQualificationStatus.unqualified,
        ),
        _session(id: 'not-perfect', passageId: 'p6'),
      ],
      quizResults: [
        _quiz(id: 'q1', sessionId: 'too-slow', passageId: 'p1'),
        _quiz(id: 'q2', sessionId: 'imported', passageId: 'p2'),
        _quiz(id: 'q3', sessionId: 'too-easy', passageId: 'p3'),
        _quiz(id: 'q4', sessionId: 'paused', passageId: 'p4'),
        _quiz(id: 'q5', sessionId: 'unqualified', passageId: 'p5'),
        _quiz(
          id: 'q6',
          sessionId: 'not-perfect',
          passageId: 'p6',
          correctCount: 9,
        ),
      ],
      passages: [
        _passage('p1'),
        _passage('p2', source: PassageSource.imported),
        _passage('p3', difficulty: PassageDifficulty.easy),
        _passage('p4'),
        _passage('p5'),
        _passage('p6'),
      ],
    );

    expect(progress.immediateCandidateCount, 0);
    expect(progress.hasEnoughImmediateCandidates, isFalse);
  });

  test('earns mastery when stored delayed recall attempts qualify', () {
    final immediateAt = DateTime.utc(2026, 7, 8, 12);
    final progress = MasteryProgressBuilder.fromHistory(
      sessions: [
        _session(id: 's1', passageId: 'p1', mode: ReadingMode.rsvp),
        _session(id: 's2', passageId: 'p2', mode: ReadingMode.manual),
        _session(id: 's3', passageId: 'p3', mode: ReadingMode.rsvp),
      ],
      quizResults: [
        _quiz(id: 'q1', sessionId: 's1', passageId: 'p1'),
        _quiz(id: 'q2', sessionId: 's2', passageId: 'p2'),
        _quiz(id: 'q3', sessionId: 's3', passageId: 'p3'),
      ],
      passages: [
        _passage('p1'),
        _passage('p2'),
        _passage('p3'),
      ],
      delayedRecallAttempts: [
        _recall('r1', 'p1', immediateAt),
        _recall('r2', 'p2', immediateAt),
        _recall('r3', 'p3', immediateAt),
      ],
    );

    expect(progress.delayedRecallTracked, isTrue);
    expect(progress.masteryEarned, isTrue);
  });

  test('keeps mastery pending when delayed recall is too early or low', () {
    final immediateAt = DateTime.utc(2026, 7, 8, 12);
    final progress = MasteryProgressBuilder.fromHistory(
      sessions: [
        _session(id: 's1', passageId: 'p1', mode: ReadingMode.rsvp),
        _session(id: 's2', passageId: 'p2', mode: ReadingMode.manual),
        _session(id: 's3', passageId: 'p3', mode: ReadingMode.rsvp),
      ],
      quizResults: [
        _quiz(id: 'q1', sessionId: 's1', passageId: 'p1'),
        _quiz(id: 'q2', sessionId: 's2', passageId: 'p2'),
        _quiz(id: 'q3', sessionId: 's3', passageId: 'p3'),
      ],
      passages: [
        _passage('p1'),
        _passage('p2'),
        _passage('p3'),
      ],
      delayedRecallAttempts: [
        _recall('r1', 'p1', immediateAt, score: 0.89),
        _recall(
          'r2',
          'p2',
          immediateAt,
          recallCompletedAt: immediateAt.add(const Duration(hours: 23)),
        ),
        _recall('r3', 'p3', immediateAt),
      ],
    );

    expect(progress.delayedRecallTracked, isTrue);
    expect(progress.masteryEarned, isFalse);
  });
}

ReadingSession _session({
  required String id,
  required String passageId,
  ReadingMode mode = ReadingMode.manual,
  int wordCount = 800,
  int pauseCount = 0,
  AttemptQualificationStatus status = AttemptQualificationStatus.qualified,
}) {
  return ReadingSession(
    id: id,
    passageId: passageId,
    mode: mode,
    startedAt: DateTime.utc(2026, 7, 8, 12),
    activeReadingSeconds: 60,
    wordCount: wordCount,
    status: status,
    pauseCount: pauseCount,
  );
}

QuizResult _quiz({
  required String id,
  required String sessionId,
  required String passageId,
  int correctCount = 10,
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

DelayedRecallAttempt _recall(
  String id,
  String passageId,
  DateTime immediateAt, {
  double score = 0.9,
  DateTime? recallCompletedAt,
}) {
  return DelayedRecallAttempt(
    id: id,
    passageId: passageId,
    immediateAttemptCompletedAt: immediateAt,
    dueAt: immediateAt.add(const Duration(hours: 24)),
    recallCompletedAt:
        recallCompletedAt ?? immediateAt.add(const Duration(hours: 24)),
    score: score,
  );
}

Passage _passage(
  String id, {
  PassageDifficulty difficulty = PassageDifficulty.standard,
  PassageSource source = PassageSource.official,
}) {
  return Passage(
    id: id,
    title: 'Passage $id',
    body: 'Official bundled body.',
    metadata: PassageMetadata(
      wordCount: 800,
      difficulty: difficulty,
      topic: 'Adventure',
      source: source,
      license: source == PassageSource.official ? 'Public domain' : 'Private',
      type: PassageType.fiction,
      vocabularyDensity: 0.2,
      tags: const ['mastery'],
      isCertificationEligible: source == PassageSource.official,
      isMasteryEligible: source == PassageSource.official &&
          (difficulty == PassageDifficulty.standard ||
              difficulty == PassageDifficulty.hard),
    ),
  );
}
