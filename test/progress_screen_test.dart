import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/content/data/passage_repository.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/content/domain/passage_filter.dart';
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
          progressShareableSummaryProvider.overrideWith((ref) async => null),
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
        progressShareableSummaryProvider.overrideWith((ref) async => null),
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

  testWidgets('shares progress summary without passage text', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final shared = <String>[];

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        passageRepositoryProvider.overrideWithValue(
          const _FakePassageRepository(
            passages: [
              Passage(
                id: 'passage-1',
                title: 'Private Import',
                body: 'Private imported passage text.',
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
          ),
        ),
        progressShareProvider.overrideWithValue((text) async {
          shared.add(text);
        }),
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
    await container.read(progressShareableSummaryProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ProgressScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Shareable Progress Summary'), findsOneWidget);
    expect(find.text('Fast Reader'), findsOneWidget);
    expect(find.text('560'), findsOneWidget);

    await tester.tap(find.text('Share Progress'));
    await tester.pump();

    expect(shared.single, contains('Fast Reader'));
    expect(shared.single, contains('800 WPM'));
    expect(shared.single, contains('70% comprehension'));
    expect(shared.single, contains('Certification not earned yet'));
    expect(shared.single, contains('Mastery not earned yet'));
    expect(shared.single, isNot(contains('Private imported passage text.')));
  });
}

class _FakePassageRepository implements PassageRepository {
  const _FakePassageRepository({required this.passages});

  final List<Passage> passages;

  @override
  Future<void> deleteImportedPassage(String passageId) async {}

  @override
  Future<List<Passage>> loadImportedPassages() async {
    return passages
        .where((passage) => passage.metadata.source == PassageSource.imported)
        .toList();
  }

  @override
  Future<List<Passage>> loadOfficialPassages() async {
    return passages
        .where((passage) => passage.metadata.source == PassageSource.official)
        .toList();
  }

  @override
  Future<void> saveImportedPassage(Passage passage) async {}

  @override
  Future<List<Passage>> search(PassageFilter filter) async {
    return passages;
  }
}
