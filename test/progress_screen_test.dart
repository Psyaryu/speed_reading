import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/progress/presentation/progress_screen.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';

void main() {
  testWidgets('shows empty progress state', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
        ],
        child: const MaterialApp(home: ProgressScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No reading sessions yet.'), findsOneWidget);
  });

  testWidgets('shows latest WPM with comprehension context', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
      ],
    );
    addTearDown(container.dispose);

    final store = container.read(localDataStoreProvider);
    await store.saveReadingSession(
      ReadingSession(
        id: 'session-1',
        passageId: 'passage-1',
        mode: ReadingMode.manual,
        startedAt: DateTime.utc(2026, 7, 8, 12),
        activeReadingSeconds: 60,
        wordCount: 800,
        status: AttemptQualificationStatus.qualified,
      ),
    );
    await store.saveQuizResult(
      QuizResult(
        id: 'quiz-1',
        sessionId: 'session-1',
        passageId: 'passage-1',
        correctCount: 7,
        totalQuestions: 10,
        answersByQuestionId: const {},
        completedAt: DateTime.utc(2026, 7, 8, 12, 2),
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ProgressScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Latest Session'), findsOneWidget);
    expect(find.text('800'), findsOneWidget);
    expect(find.text('70%'), findsOneWidget);
    expect(find.text('800 WPM'), findsOneWidget);
    expect(find.text('Comprehension: 70%'), findsOneWidget);
  });
}
