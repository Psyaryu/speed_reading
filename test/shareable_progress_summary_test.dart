import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/domain/shareable_progress_summary.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';

void main() {
  test('formats public progress summary', () {
    const summary = ShareableProgressSummary(
      levelName: 'Fast Reader',
      effectiveReadingScore: 512.4,
      qualifiedWpm: 640,
      comprehensionScore: 0.8,
      streakDays: 7,
      certificationStatus: 'Not certified yet',
    );

    final text = summary.toShareText();

    expect(text, contains('Fast Reader'));
    expect(text, contains('640 WPM'));
    expect(text, contains('80% comprehension'));
    expect(text, contains('7 day streak'));
  });

  test('does not include passage text', () {
    const summary = ShareableProgressSummary(
      levelName: 'Rapid Reader',
      effectiveReadingScore: 650,
      qualifiedWpm: 800,
      comprehensionScore: 0.75,
      streakDays: 3,
      certificationStatus: 'Certified',
    );

    expect(summary.toShareText(), isNot(contains('passage')));
  });

  test('builds share summary from qualified history only', () {
    final summary = ShareableProgressSummaryBuilder.fromHistory(
      sessions: [
        ReadingSession(
          id: 'session-1',
          passageId: 'passage-1',
          mode: ReadingMode.manual,
          startedAt: DateTime.utc(2026, 7, 8, 12),
          activeReadingSeconds: 60,
          wordCount: 800,
          status: AttemptQualificationStatus.qualified,
        ),
        ReadingSession(
          id: 'session-2',
          passageId: 'passage-1',
          mode: ReadingMode.manual,
          startedAt: DateTime.utc(2026, 7, 7, 12),
          activeReadingSeconds: 120,
          wordCount: 800,
          status: AttemptQualificationStatus.qualified,
        ),
      ],
      quizResults: [
        QuizResult(
          id: 'quiz-1',
          sessionId: 'session-1',
          passageId: 'passage-1',
          correctCount: 7,
          totalQuestions: 10,
          answersByQuestionId: const {},
          completedAt: DateTime.utc(2026, 7, 8, 12, 2),
        ),
        QuizResult(
          id: 'quiz-2',
          sessionId: 'session-2',
          passageId: 'passage-1',
          correctCount: 6,
          totalQuestions: 10,
          answersByQuestionId: const {},
          completedAt: DateTime.utc(2026, 7, 7, 12, 2),
        ),
      ],
      passages: const [
        Passage(
          id: 'passage-1',
          title: 'Private Import',
          body: 'Imported body should never be shared.',
          metadata: PassageMetadata(
            wordCount: 800,
            difficulty: PassageDifficulty.standard,
            topic: 'Practice',
            source: PassageSource.imported,
            license: 'User provided',
            type: PassageType.workplace,
            vocabularyDensity: 0.2,
            tags: ['private'],
            isCertificationEligible: false,
            isMasteryEligible: false,
          ),
        ),
      ],
    );

    expect(summary, isNotNull);
    expect(summary!.levelName, 'Fast Reader');
    expect(summary.effectiveReadingScore, 560);
    expect(summary.qualifiedWpm, 800);
    expect(summary.comprehensionScore, 0.7);
    expect(summary.streakDays, 2);
    expect(summary.certificationStatus, 'Certification not earned yet');
    expect(summary.masteryStatus, 'Mastery not earned yet');
    expect(
      summary.toShareText(),
      isNot(contains('Imported body should never be shared.')),
    );
  });
}
