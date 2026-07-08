import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/assessment/presentation/results_screen.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/presentation/progress_screen.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';

void main() {
  testWidgets('shows empty results state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          progressHistoryProvider.overrideWith(
            (ref) async => const ProgressHistory(
              sessions: [],
              quizResults: [],
            ),
          ),
        ],
        child: const MaterialApp(home: ResultsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No results yet.'), findsOneWidget);
  });

  testWidgets('shows latest WPM and comprehension gate', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          progressHistoryProvider.overrideWith(
            (ref) async => ProgressHistory(
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
            ),
          ),
        ],
        child: const MaterialApp(home: ResultsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Latest Result'), findsOneWidget);
    expect(find.text('800 WPM'), findsOneWidget);
    expect(find.text('70%'), findsOneWidget);
    expect(find.text('Qualified'), findsOneWidget);
  });
}
