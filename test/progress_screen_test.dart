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
import 'package:speed_reading/progress/domain/passage_difficulty_distribution.dart';
import 'package:speed_reading/progress/domain/skill_breakdown.dart';
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
          bestQualifiedAttemptProvider.overrideWith((ref) async => null),
          passageDifficultyDistributionProvider.overrideWith(
            (ref) async => _emptyDifficultyDistribution,
          ),
          skillBreakdownProvider.overrideWith((ref) async => _emptySkillBreakdown),
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
        bestQualifiedAttemptProvider.overrideWith((ref) async => null),
        passageDifficultyDistributionProvider.overrideWith(
          (ref) async => _emptyDifficultyDistribution,
        ),
        skillBreakdownProvider.overrideWith((ref) async => _emptySkillBreakdown),
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
        skillBreakdownProvider.overrideWith((ref) async => _emptySkillBreakdown),
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

  testWidgets('shows best official qualified attempt details', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        passageRepositoryProvider.overrideWithValue(
          const _FakePassageRepository(
            passages: [
              Passage(
                id: 'official-passage',
                title: 'The Official Climb',
                body: 'Official bundled passage body.',
                metadata: PassageMetadata(
                  wordCount: 900,
                  difficulty: PassageDifficulty.hard,
                  topic: 'Adventure',
                  source: PassageSource.official,
                  license: 'Public domain',
                  type: PassageType.fiction,
                  vocabularyDensity: 0.3,
                  tags: ['official'],
                  isCertificationEligible: true,
                  isMasteryEligible: true,
                ),
              ),
              Passage(
                id: 'imported-passage',
                title: 'Private Import',
                body: 'Private imported passage text.',
                metadata: PassageMetadata(
                  wordCount: 1200,
                  difficulty: PassageDifficulty.technical,
                  topic: 'Private',
                  source: PassageSource.imported,
                  license: 'User provided',
                  type: PassageType.workplace,
                  vocabularyDensity: 0.4,
                  tags: ['private'],
                  isCertificationEligible: false,
                  isMasteryEligible: false,
                ),
              ),
            ],
          ),
        ),
        progressShareProvider.overrideWithValue((text) async {}),
        skillBreakdownProvider.overrideWith((ref) async => _emptySkillBreakdown),
      ],
    );
    addTearDown(container.dispose);

    final store = container.read(localDataStoreProvider);
    await store.saveReadingSession(
      ReadingSession(
        id: 'official-session',
        passageId: 'official-passage',
        mode: ReadingMode.manual,
        startedAt: DateTime.utc(2026, 7, 8, 12),
        activeReadingSeconds: 90,
        wordCount: 900,
        status: AttemptQualificationStatus.qualified,
      ),
    );
    await store.saveReadingSession(
      ReadingSession(
        id: 'imported-session',
        passageId: 'imported-passage',
        mode: ReadingMode.manual,
        startedAt: DateTime.utc(2026, 7, 8, 13),
        activeReadingSeconds: 60,
        wordCount: 1200,
        status: AttemptQualificationStatus.qualified,
      ),
    );
    await store.saveQuizResult(
      QuizResult(
        id: 'official-quiz',
        sessionId: 'official-session',
        passageId: 'official-passage',
        correctCount: 8,
        totalQuestions: 10,
        answersByQuestionId: const {},
        completedAt: DateTime.utc(2026, 7, 8, 12, 2),
      ),
    );
    await store.saveQuizResult(
      QuizResult(
        id: 'imported-quiz',
        sessionId: 'imported-session',
        passageId: 'imported-passage',
        correctCount: 10,
        totalQuestions: 10,
        answersByQuestionId: const {},
        completedAt: DateTime.utc(2026, 7, 8, 13, 2),
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ProgressScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Best Qualified Attempt'), findsOneWidget);
    expect(find.text('The Official Climb'), findsOneWidget);
    expect(find.text('600'), findsWidgets);
    expect(find.text('80%'), findsOneWidget);
    expect(find.text('552'), findsOneWidget);
    expect(find.text('2026-07-08'), findsOneWidget);
    expect(find.text('Private imported passage text.'), findsNothing);
  });

  testWidgets('shows passage difficulty distribution by source',
      (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        passageRepositoryProvider.overrideWithValue(
          const _FakePassageRepository(
            passages: [
              Passage(
                id: 'official-easy',
                title: 'Official Easy',
                body: 'Official bundled body.',
                metadata: PassageMetadata(
                  wordCount: 700,
                  difficulty: PassageDifficulty.easy,
                  topic: 'Adventure',
                  source: PassageSource.official,
                  license: 'Public domain',
                  type: PassageType.fiction,
                  vocabularyDensity: 0.2,
                  tags: ['official'],
                  isCertificationEligible: true,
                  isMasteryEligible: false,
                ),
              ),
              Passage(
                id: 'imported-easy',
                title: 'Private Import',
                body: 'Private imported passage text.',
                metadata: PassageMetadata(
                  wordCount: 700,
                  difficulty: PassageDifficulty.easy,
                  topic: 'Private',
                  source: PassageSource.imported,
                  license: 'User provided',
                  type: PassageType.workplace,
                  vocabularyDensity: 0.2,
                  tags: ['private'],
                  isCertificationEligible: false,
                  isMasteryEligible: false,
                ),
              ),
              Passage(
                id: 'official-hard',
                title: 'Official Hard',
                body: 'Official bundled body.',
                metadata: PassageMetadata(
                  wordCount: 900,
                  difficulty: PassageDifficulty.hard,
                  topic: 'Adventure',
                  source: PassageSource.official,
                  license: 'Public domain',
                  type: PassageType.fiction,
                  vocabularyDensity: 0.3,
                  tags: ['official'],
                  isCertificationEligible: true,
                  isMasteryEligible: true,
                ),
              ),
            ],
          ),
        ),
        progressShareProvider.overrideWithValue((text) async {}),
        skillBreakdownProvider.overrideWith((ref) async => _emptySkillBreakdown),
      ],
    );
    addTearDown(container.dispose);

    final store = container.read(localDataStoreProvider);
    await store.saveReadingSession(
      _session(id: 'official-easy-session', passageId: 'official-easy'),
    );
    await store.saveReadingSession(
      _session(id: 'imported-easy-session', passageId: 'imported-easy'),
    );
    await store.saveReadingSession(
      _session(id: 'official-hard-session', passageId: 'official-hard'),
    );
    await store.saveReadingSession(
      _session(id: 'missing-passage-session', passageId: 'missing-passage'),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ProgressScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Passage Difficulty Distribution'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
    expect(find.text('Official 1 / Imported 1'), findsOneWidget);
    expect(find.text('Official 1 / Imported 0'), findsOneWidget);
    expect(
      find.text('1 completed session could not be matched to a passage.'),
      findsOneWidget,
    );
    expect(find.text('Private imported passage text.'), findsNothing);
  });

  testWidgets('shows skill breakdown by question category', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        passageRepositoryProvider.overrideWithValue(
          const _FakePassageRepository(
            passages: [
              Passage(
                id: 'imported-passage',
                title: 'Private Import',
                body: 'Private imported passage text.',
                metadata: PassageMetadata(
                  wordCount: 700,
                  difficulty: PassageDifficulty.standard,
                  topic: 'Private',
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
        progressShareableSummaryProvider.overrideWith((ref) async => null),
        bestQualifiedAttemptProvider.overrideWith((ref) async => null),
        passageDifficultyDistributionProvider.overrideWith(
          (ref) async => _emptyDifficultyDistribution,
        ),
        skillBreakdownProvider.overrideWith(
          (ref) async => const SkillBreakdown(
            entries: [
              SkillBreakdownEntry(
                type: QuestionType.mainIdea,
                correctCount: 1,
                answeredCount: 1,
              ),
              SkillBreakdownEntry(
                type: QuestionType.detailRecall,
                correctCount: 1,
                answeredCount: 2,
              ),
            ],
            unmatchedAnswerCount: 1,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final store = container.read(localDataStoreProvider);
    await store.saveReadingSession(
      _session(id: 'imported-session', passageId: 'imported-passage'),
    );
    await store.saveQuizResult(
      QuizResult(
        id: 'quiz-1',
        sessionId: 'imported-session',
        passageId: 'imported-passage',
        correctCount: 2,
        totalQuestions: 3,
        answersByQuestionId: const {
          'main-idea-1': 1,
          'detail-1': 0,
          'detail-2': 3,
        },
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

    expect(find.text('Skill Breakdown'), findsOneWidget);
    expect(find.text('Main Idea'), findsOneWidget);
    expect(find.text('Detail Recall'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(find.text('1/1 correct'), findsOneWidget);
    expect(find.text('1/2 correct'), findsOneWidget);
    expect(
      find.text('1 answer could not be matched to a skill.'),
      findsOneWidget,
    );
    expect(find.text('Private imported passage text.'), findsNothing);
  });
}

const _emptyDifficultyDistribution = PassageDifficultyDistribution(
  entries: [],
  unmatchedSessionCount: 0,
);

const _emptySkillBreakdown = SkillBreakdown(
  entries: [],
  unmatchedAnswerCount: 0,
);

ReadingSession _session({
  required String id,
  required String passageId,
}) {
  return ReadingSession(
    id: id,
    passageId: passageId,
    mode: ReadingMode.manual,
    startedAt: DateTime.utc(2026, 7, 8, 12),
    activeReadingSeconds: 60,
    wordCount: 700,
    status: AttemptQualificationStatus.qualified,
  );
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
