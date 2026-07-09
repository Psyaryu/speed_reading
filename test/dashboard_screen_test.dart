import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/main.dart';
import 'package:speed_reading/progress/presentation/progress_screen.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';
import 'package:speed_reading/settings/domain/local_user_profile.dart';
import 'package:speed_reading/training/presentation/dashboard_screen.dart';

void main() {
  testWidgets('dashboard exposes main app entry points', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          _profileOverride(),
          _dashboardSummaryOverride(
            const ProgressHistory(
              sessions: [],
              quizResults: [],
            ),
          ),
        ],
        child: const SpeedReadingApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Import Passage'), findsOneWidget);
    expect(find.text('Reader'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Settings'), 300);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('dashboard shows initialized local profile', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          _profileOverride(),
          _dashboardSummaryOverride(
            const ProgressHistory(
              sessions: [],
              quizResults: [],
            ),
          ),
        ],
        child: const SpeedReadingApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Local profile ready'), findsOneWidget);
    expect(find.text('No completed sessions yet.'), findsOneWidget);
  });

  testWidgets('dashboard shows latest WPM with comprehension', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          _profileOverride(),
          _dashboardSummaryOverride(_qualifiedHistory()),
        ],
        child: const SpeedReadingApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('800 WPM Readiness'), findsOneWidget);
    expect(find.text('800 WPM - Comprehension: 70%'), findsOneWidget);
  });

  testWidgets('dashboard shows level and 800 WPM readiness from qualified ERS',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          _profileOverride(),
          _dashboardSummaryOverride(_qualifiedHistory()),
        ],
        child: const SpeedReadingApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Level 4: Fast Reader'), findsOneWidget);
    expect(find.text('Readiness: 70% (560 qualified ERS)'), findsOneWidget);
  });
}

Override _profileOverride() {
  return localProfileProvider.overrideWith((ref) async {
    return LocalUserProfile.initial(
      id: 'local',
      createdAt: DateTime.utc(2026, 7, 7),
    );
  });
}

Override _dashboardSummaryOverride(ProgressHistory history) {
  return dashboardProgressSummaryProvider.overrideWith((ref) async {
    return DashboardProgressSummary.from(
      history: history,
      passages: const [
        Passage(
          id: 'passage-1',
          title: 'Qualified Passage',
          body: 'Long enough practice passage.',
          metadata: PassageMetadata(
            wordCount: 800,
            difficulty: PassageDifficulty.standard,
            topic: 'Adventure',
            source: PassageSource.official,
            license: 'Public Domain',
            type: PassageType.fiction,
            vocabularyDensity: 0.2,
            tags: ['adventure'],
            isCertificationEligible: true,
            isMasteryEligible: true,
          ),
        ),
      ],
    );
  });
}

ProgressHistory _qualifiedHistory() {
  return ProgressHistory(
    sessions: [
      ReadingSession(
        id: 'session-1',
        passageId: 'passage-1',
        mode: ReadingMode.manual,
        startedAt: DateTime.utc(2026, 7, 8),
        activeReadingSeconds: 60,
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
        completedAt: DateTime.utc(2026, 7, 8, 0, 2),
      ),
    ],
  );
}
