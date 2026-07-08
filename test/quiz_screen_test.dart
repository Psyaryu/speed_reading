import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/assessment/presentation/quiz_screen.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';

void main() {
  testWidgets('shows empty state when no session exists', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
        ],
        child: const MaterialApp(home: QuizScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Complete a reading session first.'), findsOneWidget);
  });

  testWidgets('scores and saves quiz result', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          currentDateTimeProvider.overrideWithValue(
            () => DateTime.utc(2026, 7, 8, 12, 2),
          ),
          latestQuizSessionProvider.overrideWith((ref) async => _session()),
          quizQuestionsProvider('passage-1').overrideWith(
            (ref) async => _questions(),
          ),
          quizResultIdProvider.overrideWithValue(() => 'quiz-1'),
        ],
        child: const MaterialApp(home: QuizScreen()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('The signal fire'));
    await tester.pump();
    await tester.tap(find.text('A hidden map'));
    await tester.pump();
    await tester.tap(find.text('Submit Quiz'));
    await tester.pumpAndSettle();

    expect(find.text('Comprehension: 50%'), findsOneWidget);
    expect(find.text('1/2 correct'), findsOneWidget);

    final rows = await database.select(database.quizResultRecords).get();
    expect(rows.single.id, 'quiz-1');
    expect(rows.single.sessionId, 'session-1');
    expect(rows.single.correctCount, 1);
    expect(rows.single.totalQuestions, 2);
  });
}

ReadingSession _session() {
  return ReadingSession(
    id: 'session-1',
    passageId: 'passage-1',
    mode: ReadingMode.manual,
    startedAt: DateTime.utc(2026, 7, 8, 12),
    activeReadingSeconds: 60,
    wordCount: 800,
    status: AttemptQualificationStatus.qualified,
  );
}

List<QuizQuestion> _questions() {
  return const [
    QuizQuestion(
      id: 'q1',
      passageId: 'passage-1',
      type: QuestionType.mainIdea,
      prompt: 'What pulled the runner onward?',
      options: ['The signal fire', 'A quiet garden'],
      correctOptionIndex: 0,
    ),
    QuizQuestion(
      id: 'q2',
      passageId: 'passage-1',
      type: QuestionType.detailRecall,
      prompt: 'What did the runner carry?',
      options: ['A compass', 'A hidden map'],
      correctOptionIndex: 0,
    ),
  ];
}
