import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/content/presentation/library_screen.dart';
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
          libraryPassagesProvider.overrideWith((ref) async => const []),
          libraryAvailablePassagesProvider.overrideWith(
            (ref) async => const [],
          ),
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
    await tester.scrollUntilVisible(find.text('Reader'), 300);
    expect(find.text('Reader'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Progress'), 300);
    expect(find.text('Progress'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Settings'), 300);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('dashboard routes provide back navigation', (tester) async {
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

    await tester.tap(find.widgetWithText(ListTile, 'Library'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byTooltip('Back'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Dashboard'), findsOneWidget);
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
    expect(find.text('Daily Practice Plan'), findsOneWidget);
    expect(find.text('Recommended next drill: Paced Reading'), findsOneWidget);
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

  testWidgets('dashboard shows ERS trend and practice streak from local data',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          _profileOverride(),
          _dashboardSummaryOverride(_twoDayTrendHistory()),
        ],
        child: const SpeedReadingApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('ERS trend: up 80 from previous session.'),
      findsOneWidget,
    );
    expect(find.text('Practice streak: 2 days'), findsOneWidget);
  });

  testWidgets('dashboard recommends comprehension review for weak quizzes',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          _profileOverride(),
          _dashboardSummaryOverride(_weakComprehensionHistory()),
        ],
        child: const SpeedReadingApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Recommended next drill: Comprehension Review'),
      findsOneWidget,
    );
    expect(
      find.text('Run one comprehension review drill.'),
      findsOneWidget,
    );
  });

  testWidgets('dashboard daily plan reacts to RSVP-only progress',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          _profileOverride(),
          _dashboardSummaryOverride(_rsvpOnlyHistory()),
        ],
        child: const SpeedReadingApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Recommended next drill: Non-RSVP Transfer'),
      findsOneWidget,
    );
    expect(
      find.text('Run one non-rsvp transfer drill.'),
      findsOneWidget,
    );
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

ProgressHistory _weakComprehensionHistory() {
  return ProgressHistory(
    sessions: [
      ReadingSession(
        id: 'session-weak',
        passageId: 'passage-1',
        mode: ReadingMode.manual,
        startedAt: DateTime.utc(2026, 7, 8),
        activeReadingSeconds: 120,
        wordCount: 800,
        status: AttemptQualificationStatus.unqualified,
      ),
    ],
    quizResults: [
      QuizResult(
        id: 'quiz-weak',
        sessionId: 'session-weak',
        passageId: 'passage-1',
        correctCount: 6,
        totalQuestions: 10,
        answersByQuestionId: const {},
        completedAt: DateTime.utc(2026, 7, 8, 0, 2),
      ),
    ],
  );
}

ProgressHistory _rsvpOnlyHistory() {
  return ProgressHistory(
    sessions: [
      ReadingSession(
        id: 'rsvp-fast',
        passageId: 'passage-1',
        mode: ReadingMode.rsvp,
        startedAt: DateTime.utc(2026, 7, 8),
        activeReadingSeconds: 60,
        wordCount: 800,
        status: AttemptQualificationStatus.qualified,
      ),
      ReadingSession(
        id: 'manual-slower',
        passageId: 'passage-1',
        mode: ReadingMode.manual,
        startedAt: DateTime.utc(2026, 7, 7),
        activeReadingSeconds: 120,
        wordCount: 800,
        status: AttemptQualificationStatus.qualified,
      ),
    ],
    quizResults: [
      QuizResult(
        id: 'quiz-rsvp-fast',
        sessionId: 'rsvp-fast',
        passageId: 'passage-1',
        correctCount: 8,
        totalQuestions: 10,
        answersByQuestionId: const {},
        completedAt: DateTime.utc(2026, 7, 8, 0, 2),
      ),
      QuizResult(
        id: 'quiz-manual-slower',
        sessionId: 'manual-slower',
        passageId: 'passage-1',
        correctCount: 8,
        totalQuestions: 10,
        answersByQuestionId: const {},
        completedAt: DateTime.utc(2026, 7, 7, 0, 2),
      ),
    ],
  );
}

ProgressHistory _twoDayTrendHistory() {
  return ProgressHistory(
    sessions: [
      ReadingSession(
        id: 'session-latest',
        passageId: 'passage-1',
        mode: ReadingMode.manual,
        startedAt: DateTime.utc(2026, 7, 8),
        activeReadingSeconds: 60,
        wordCount: 800,
        status: AttemptQualificationStatus.qualified,
      ),
      ReadingSession(
        id: 'session-previous',
        passageId: 'passage-1',
        mode: ReadingMode.manual,
        startedAt: DateTime.utc(2026, 7, 7),
        activeReadingSeconds: 80,
        wordCount: 800,
        status: AttemptQualificationStatus.qualified,
      ),
    ],
    quizResults: [
      QuizResult(
        id: 'quiz-latest',
        sessionId: 'session-latest',
        passageId: 'passage-1',
        correctCount: 7,
        totalQuestions: 10,
        answersByQuestionId: const {},
        completedAt: DateTime.utc(2026, 7, 8, 0, 2),
      ),
      QuizResult(
        id: 'quiz-previous',
        sessionId: 'session-previous',
        passageId: 'passage-1',
        correctCount: 8,
        totalQuestions: 10,
        answersByQuestionId: const {},
        completedAt: DateTime.utc(2026, 7, 7, 0, 2),
      ),
    ],
  );
}
