import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/domain/certification_progress.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';

void main() {
  test('tracks standard certification progress and remaining gap', () {
    final progress = CertificationProgressBuilder.fromHistory(
      sessions: [
        _session(
          id: 'cert-one-session',
          passageId: 'cert-one',
          mode: ReadingMode.rsvp,
          wordCount: 800,
        ),
        _session(
          id: 'cert-two-session',
          passageId: 'cert-two',
          mode: ReadingMode.manual,
          wordCount: 840,
        ),
        _session(
          id: 'imported-session',
          passageId: 'imported',
          mode: ReadingMode.manual,
          wordCount: 900,
        ),
      ],
      quizResults: [
        _quiz(
          id: 'cert-one-quiz',
          sessionId: 'cert-one-session',
          passageId: 'cert-one',
          correctCount: 7,
        ),
        _quiz(
          id: 'cert-two-quiz',
          sessionId: 'cert-two-session',
          passageId: 'cert-two',
          correctCount: 8,
        ),
        _quiz(
          id: 'imported-quiz',
          sessionId: 'imported-session',
          passageId: 'imported',
          correctCount: 10,
        ),
      ],
      passages: [
        _passage(id: 'cert-one', title: 'Certification One'),
        _passage(
          id: 'cert-two',
          title: 'Certification Two',
          difficulty: PassageDifficulty.hard,
        ),
        _passage(
          id: 'imported',
          title: 'Imported',
          source: PassageSource.imported,
        ),
      ],
    );

    expect(progress.certificationEarned, isFalse);
    expect(progress.qualifiedPassageCount, 2);
    expect(progress.remainingPassageCount, 1);
    expect(progress.hasNonRsvpAttempt, isTrue);
    expect(progress.remainingGapLabel, '1 more official passage');
    expect(progress.bestQualifiedAttempt?.passageTitle, 'Certification Two');
    expect(progress.bestQualifiedAttempt?.wpm, 840);
  });

  test('marks certification earned after three eligible passages', () {
    final progress = CertificationProgressBuilder.fromHistory(
      sessions: [
        _session(id: 's1', passageId: 'p1', mode: ReadingMode.rsvp),
        _session(id: 's2', passageId: 'p2', mode: ReadingMode.rsvp),
        _session(id: 's3', passageId: 'p3', mode: ReadingMode.manual),
      ],
      quizResults: [
        _quiz(id: 'q1', sessionId: 's1', passageId: 'p1'),
        _quiz(id: 'q2', sessionId: 's2', passageId: 'p2'),
        _quiz(id: 'q3', sessionId: 's3', passageId: 'p3'),
      ],
      passages: [
        _passage(id: 'p1', title: 'One'),
        _passage(id: 'p2', title: 'Two'),
        _passage(id: 'p3', title: 'Three'),
      ],
    );

    expect(progress.certificationEarned, isTrue);
    expect(progress.statusLabel, '800 WPM Certified');
    expect(progress.remainingGapLabel, 'Certification complete');
  });

  test('reports non-RSVP gap when qualified attempts are RSVP-only', () {
    final progress = CertificationProgressBuilder.fromHistory(
      sessions: [
        _session(id: 's1', passageId: 'p1', mode: ReadingMode.rsvp),
        _session(id: 's2', passageId: 'p2', mode: ReadingMode.rsvp),
        _session(id: 's3', passageId: 'p3', mode: ReadingMode.rsvp),
      ],
      quizResults: [
        _quiz(id: 'q1', sessionId: 's1', passageId: 'p1'),
        _quiz(id: 'q2', sessionId: 's2', passageId: 'p2'),
        _quiz(id: 'q3', sessionId: 's3', passageId: 'p3'),
      ],
      passages: [
        _passage(id: 'p1', title: 'One'),
        _passage(id: 'p2', title: 'Two'),
        _passage(id: 'p3', title: 'Three'),
      ],
    );

    expect(progress.certificationEarned, isFalse);
    expect(progress.remainingPassageCount, 0);
    expect(progress.needsNonRsvpAttempt, isTrue);
    expect(progress.remainingGapLabel, '1 non-RSVP attempt');
  });
}

ReadingSession _session({
  required String id,
  required String passageId,
  required ReadingMode mode,
  int wordCount = 800,
}) {
  return ReadingSession(
    id: id,
    passageId: passageId,
    mode: mode,
    startedAt: DateTime.utc(2026, 7, 8, 12),
    activeReadingSeconds: 60,
    wordCount: wordCount,
    status: AttemptQualificationStatus.qualified,
  );
}

QuizResult _quiz({
  required String id,
  required String sessionId,
  required String passageId,
  int correctCount = 7,
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

Passage _passage({
  required String id,
  required String title,
  PassageDifficulty difficulty = PassageDifficulty.standard,
  PassageSource source = PassageSource.official,
}) {
  return Passage(
    id: id,
    title: title,
    body: '$title body.',
    metadata: PassageMetadata(
      wordCount: 800,
      difficulty: difficulty,
      topic: 'Reference',
      source: source,
      license: source == PassageSource.official ? 'Public domain' : 'User',
      type: PassageType.nonFiction,
      vocabularyDensity: 0.2,
      tags: const ['certification'],
      isCertificationEligible: source == PassageSource.official,
      isMasteryEligible: false,
    ),
  );
}
