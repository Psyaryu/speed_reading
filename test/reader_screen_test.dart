import 'dart:collection';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_reading/assessment/data/official_question_loader.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/assessment/presentation/quiz_screen.dart';
import 'package:speed_reading/assessment/presentation/results_screen.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/reading/presentation/reader_screen.dart';
import 'package:speed_reading/settings/domain/local_user_profile.dart';

void main() {
  testWidgets('completes and saves a manual reading session', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final clock = _FakeClock([
      DateTime.utc(2026, 7, 7, 12),
      DateTime.utc(2026, 7, 7, 12, 1),
    ]);
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          currentDateTimeProvider.overrideWithValue(clock.call),
          localProfileProvider.overrideWith((ref) async => _profile()),
          readerSessionIdProvider.overrideWithValue(() => 'session-1'),
          readerPassagesProvider.overrideWith((ref) async => [
                _passage(),
              ]),
        ],
        child: const MaterialApp(home: ReaderScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Cliff Signal'), findsWidgets);
    expect(find.textContaining('A flare tore through the fog'), findsOneWidget);

    await tester.tap(find.text('Start'));
    await tester.pump();

    expect(find.text('Reading session active.'), findsOneWidget);

    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    expect(find.text('WPM: 800'), findsOneWidget);

    final sessions =
        await database.select(database.readingSessionRecords).get();
    expect(sessions.single.id, 'session-1');
    expect(sessions.single.mode, ReadingMode.manual.name);
    expect(sessions.single.activeReadingSeconds, 60);
    expect(sessions.single.wordCount, 800);
  });

  testWidgets('excludes paused time from manual reading speed', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final clock = _FakeClock([
      DateTime.utc(2026, 7, 7, 12),
      DateTime.utc(2026, 7, 7, 12, 0, 30),
      DateTime.utc(2026, 7, 7, 12, 1, 30),
      DateTime.utc(2026, 7, 7, 12, 2),
    ]);
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          currentDateTimeProvider.overrideWithValue(clock.call),
          localProfileProvider.overrideWith((ref) async => _profile()),
          readerSessionIdProvider.overrideWithValue(() => 'paused-session'),
          readerPassagesProvider.overrideWith((ref) async => [
                _passage(wordCount: 600),
              ]),
        ],
        child: const MaterialApp(home: ReaderScreen()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.tap(find.text('Pause'));
    await tester.pump();

    expect(find.text('Reading session paused.'), findsOneWidget);

    await tester.tap(find.text('Resume'));
    await tester.pump();
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    expect(find.text('WPM: 600'), findsOneWidget);

    final sessions =
        await database.select(database.readingSessionRecords).get();
    expect(sessions.single.id, 'paused-session');
    expect(sessions.single.activeReadingSeconds, 60);
    expect(sessions.single.pauseCount, 1);
  });

  testWidgets('shows empty state when no passages are available',
      (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          localProfileProvider.overrideWith((ref) async => _profile()),
          readerPassagesProvider.overrideWith((ref) async => []),
        ],
        child: const MaterialApp(home: ReaderScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No passages available.'), findsOneWidget);
  });

  testWidgets('selects which passage to read', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          localProfileProvider.overrideWith((ref) async => _profile()),
          readerPassagesProvider.overrideWith((ref) async => [
                _passage(),
                _passage(
                  id: 'passage-2',
                  title: 'Ridge Escape',
                  body: 'The courier crossed the ridge before the searchlight.',
                ),
              ]),
        ],
        child: const MaterialApp(home: ReaderScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('A flare tore through the fog'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ridge Escape').last);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('The courier crossed the ridge'),
      findsOneWidget,
    );
  });

  testWidgets('applies local reader text preferences', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          localProfileProvider.overrideWith(
            (ref) async => _profile(
              fontSize: 24,
              lineHeight: 1.8,
              columnWidth: 640,
            ),
          ),
          readerPassagesProvider.overrideWith((ref) async => [
                _passage(),
              ]),
        ],
        child: const MaterialApp(home: ReaderScreen()),
      ),
    );

    await tester.pumpAndSettle();

    final bodyText = tester.widget<Text>(
      find.textContaining('A flare tore through the fog'),
    );

    expect(bodyText.style?.fontSize, 24);
    expect(bodyText.style?.height, 1.8);

    final readerColumn = tester.widget<ConstrainedBox>(
      find.byKey(const ValueKey('reader-column')),
    );
    expect(readerColumn.constraints.maxWidth, 640);
  });

  testWidgets('navigates to quiz after completing a session', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final clock = _FakeClock([
      DateTime.utc(2026, 7, 7, 12),
      DateTime.utc(2026, 7, 7, 12, 1),
    ]);
    addTearDown(database.close);

    final router = GoRouter(
      initialLocation: '/reader',
      routes: [
        GoRoute(
          path: '/reader',
          name: 'reader',
          builder: (context, state) => const ReaderScreen(),
        ),
        GoRoute(
          path: '/quiz',
          name: 'quiz',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Quiz Route')),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          currentDateTimeProvider.overrideWithValue(clock.call),
          localProfileProvider.overrideWith((ref) async => _profile()),
          readerSessionIdProvider.overrideWithValue(() => 'session-1'),
          readerPassagesProvider.overrideWith((ref) async => [
                _passage(),
              ]),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Take Quiz'));
    await tester.pumpAndSettle();

    expect(find.text('Quiz Route'), findsOneWidget);
  });

  testWidgets('manual session flows through quiz to persisted results',
      (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final clock = _FakeClock([
      DateTime.utc(2026, 7, 9, 12),
      DateTime.utc(2026, 7, 9, 12, 1),
      DateTime.utc(2026, 7, 9, 12, 2),
    ]);
    addTearDown(database.close);

    final router = GoRouter(
      initialLocation: '/reader',
      routes: [
        GoRoute(
          path: '/reader',
          name: 'reader',
          builder: (context, state) => const ReaderScreen(),
        ),
        GoRoute(
          path: '/quiz',
          name: 'quiz',
          builder: (context, state) => const QuizScreen(),
        ),
        GoRoute(
          path: '/results',
          name: 'results',
          builder: (context, state) => const ResultsScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          currentDateTimeProvider.overrideWithValue(clock.call),
          localProfileProvider.overrideWith((ref) async => _profile()),
          readerSessionIdProvider.overrideWithValue(() => 'session-1'),
          readerPassagesProvider.overrideWith((ref) async => [
                _passage(),
              ]),
          officialQuestionSourceProvider.overrideWithValue(
            const _FakeOfficialQuestionSource(),
          ),
          quizResultIdProvider.overrideWithValue(() => 'quiz-1'),
          resultPassagesProvider.overrideWith((ref) async => [
                _passage(),
              ]),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Take Quiz'));
    await tester.pumpAndSettle();

    expect(find.text('Comprehension Check'), findsOneWidget);

    await tester.tap(find.text('The signal fire'));
    await tester.pump();
    await tester.tap(find.text('A hidden map'));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Submit Quiz'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Submit Quiz'));
    await tester.pumpAndSettle();

    expect(find.text('Comprehension: 50%'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('View Results'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('View Results'));
    await tester.pumpAndSettle();

    expect(find.text('Latest Result'), findsOneWidget);
    expect(find.text('800 WPM'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(find.text('Below 70%'), findsOneWidget);

    final sessions =
        await database.select(database.readingSessionRecords).get();
    final results = await database.select(database.quizResultRecords).get();
    expect(sessions.single.id, 'session-1');
    expect(results.single.sessionId, 'session-1');
  });

  testWidgets('runs RSVP mode with WPM, pause, resume, and rewind controls',
      (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final clock = _FakeClock([
      DateTime.utc(2026, 7, 7, 12),
      DateTime.utc(2026, 7, 7, 12, 0, 10),
      DateTime.utc(2026, 7, 7, 12, 0, 20),
      DateTime.utc(2026, 7, 7, 12, 1, 20),
    ]);
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          currentDateTimeProvider.overrideWithValue(clock.call),
          localProfileProvider.overrideWith((ref) async => _profile()),
          readerSessionIdProvider.overrideWithValue(() => 'rsvp-session'),
          readerPassagesProvider.overrideWith((ref) async => [
                _passage(
                  body: 'A flare tore through the fog. The runner climbed.',
                  wordCount: 700,
                ),
              ]),
        ],
        child: const MaterialApp(home: ReaderScreen()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<ReadingMode>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('RSVP').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('rsvp-display')), findsOneWidget);
    expect(find.text('A'), findsOneWidget);

    final slider = tester.widget<Slider>(
      find.byKey(const ValueKey('rsvp-wpm-slider')),
    );
    slider.onChanged?.call(600);
    await tester.pump();

    await tester.drag(find.byType(ListView), const Offset(0, -260));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Phrase chunks'));
    await tester.pump();

    expect(find.text('A flare tore'), findsOneWidget);

    await tester.ensureVisible(find.text('Start'));
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 310));

    expect(find.textContaining('through the fog'), findsOneWidget);

    await tester.tap(find.text('Pause'));
    await tester.pump();

    expect(find.text('Reading session paused.'), findsOneWidget);
    expect(find.text('RSVP playback paused.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));

    expect(find.textContaining('through the fog'), findsOneWidget);

    await tester.tap(find.text('Resume'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 640));

    expect(find.textContaining('The runner climbed'), findsOneWidget);

    await tester.tap(find.text('Rewind').first);
    await tester.pump();

    expect(find.text('A flare tore'), findsOneWidget);

    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    expect(find.text('RSVP target: 600 WPM'), findsOneWidget);

    final sessions =
        await database.select(database.readingSessionRecords).get();
    expect(sessions.single.id, 'rsvp-session');
    expect(sessions.single.mode, ReadingMode.rsvp.name);
    expect(sessions.single.targetWpm, 600);
    expect(sessions.single.pauseCount, 1);
    expect(sessions.single.activeReadingSeconds, 70);
  });

  testWidgets('asks before leaving an active manual session', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final clock = _FakeClock([
      DateTime.utc(2026, 7, 7, 12),
    ]);
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          currentDateTimeProvider.overrideWithValue(clock.call),
          localProfileProvider.overrideWith((ref) async => _profile()),
          readerPassagesProvider.overrideWith((ref) async => [
                _passage(),
              ]),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) => const ReaderScreen(),
                    ),
                  );
                },
                child: const Text('Open Reader'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Reader'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pump();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Discard active session?'), findsOneWidget);

    await tester.tap(find.text('Keep Reading'));
    await tester.pumpAndSettle();

    expect(find.text('Reading session active.'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    expect(find.text('Open Reader'), findsOneWidget);
  });
}

Passage _passage({
  String id = 'passage-1',
  String title = 'Cliff Signal',
  String body = 'A flare tore through the fog while the runner climbed higher.',
  int wordCount = 800,
}) {
  return Passage(
    id: id,
    title: title,
    body: body,
    metadata: PassageMetadata(
      wordCount: wordCount,
      difficulty: PassageDifficulty.standard,
      topic: 'Adventure',
      source: PassageSource.official,
      license: 'Public Domain',
      type: PassageType.fiction,
      vocabularyDensity: 0.2,
      tags: ['adventure', 'danger'],
      isCertificationEligible: true,
      isMasteryEligible: true,
    ),
  );
}

LocalUserProfile _profile({
  double fontSize = 18,
  double lineHeight = 1.5,
  double columnWidth = 760,
}) {
  return LocalUserProfile(
    id: 'local',
    createdAt: DateTime.utc(2026, 7, 7),
    goals: const [TrainingGoal.generalImprovement],
    preferredFontSize: fontSize,
    preferredLineHeight: lineHeight,
    preferredColumnWidth: columnWidth,
    preferredThemeMode: LocalThemeMode.system,
    reducedMotion: false,
  );
}

class _FakeClock {
  _FakeClock(List<DateTime> times) : _times = Queue.of(times);

  final Queue<DateTime> _times;

  DateTime call() => _times.removeFirst();
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

class _FakeOfficialQuestionSource implements OfficialQuestionSource {
  const _FakeOfficialQuestionSource();

  @override
  Future<List<QuizQuestion>> load() async => _questions();
}
