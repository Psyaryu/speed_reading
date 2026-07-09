import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/assessment/presentation/results_screen.dart';
import 'package:speed_reading/content/domain/passage.dart';
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
          resultPassagesProvider.overrideWith((ref) async => const []),
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
          resultPassagesProvider.overrideWith((ref) async => [
                _passage(),
              ]),
        ],
        child: const MaterialApp(home: ResultsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Latest Result'), findsOneWidget);
    expect(find.text('800 WPM'), findsOneWidget);
    expect(find.text('70%'), findsOneWidget);
    expect(find.text('560'), findsOneWidget);
    expect(find.text('Qualified'), findsOneWidget);
  });

  testWidgets('shares public progress summary', (tester) async {
    final shared = <String>[];

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
          resultPassagesProvider.overrideWith((ref) async => [
                _passage(),
              ]),
          resultShareProvider.overrideWithValue((text) async {
            shared.add(text);
          }),
        ],
        child: const MaterialApp(home: ResultsScreen()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Share Progress'));
    await tester.pumpAndSettle();

    expect(shared.single, contains('800 WPM'));
    expect(shared.single, contains('70% comprehension'));
    expect(shared.single, isNot(contains('A public domain passage.')));
  });

  testWidgets('shows written summary when provided', (tester) async {
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
                  writtenSummary: 'A runner follows the signal fire.',
                ),
              ],
            ),
          ),
          resultPassagesProvider.overrideWith((ref) async => [
                _passage(),
              ]),
        ],
        child: const MaterialApp(home: ResultsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Written Summary'), findsOneWidget);
    expect(find.text('A runner follows the signal fire.'), findsOneWidget);
  });
}

Passage _passage() {
  return const Passage(
    id: 'passage-1',
    title: 'Passage',
    body: 'A public domain passage.',
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
      isMasteryEligible: false,
    ),
  );
}
