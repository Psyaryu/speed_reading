import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';
import 'package:speed_reading/settings/domain/local_user_profile.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        currentDateTimeProvider.overrideWithValue(
          () => DateTime.utc(2026, 7, 7),
        ),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test('creates local profile when none exists', () async {
    final controller = container.read(localProfileControllerProvider);

    final profile = await controller.loadOrCreate();

    expect(profile.id, 'local');
    expect(profile.createdAt, DateTime.utc(2026, 7, 7));
    expect(
        await container.read(localDataStoreProvider).loadProfile(), isNotNull);
  });

  test('returns existing profile instead of replacing it', () async {
    final controller = container.read(localProfileControllerProvider);
    final first = await controller.loadOrCreate();
    final second = await controller.loadOrCreate();

    expect(second.createdAt.isAtSameMomentAs(first.createdAt), isTrue);
  });

  test('local profile provider exposes initialized profile', () async {
    final profile = await container.read(localProfileProvider.future);

    expect(profile.id, 'local');
  });

  test('updates reading preferences on local profile', () async {
    final controller = container.read(localProfileControllerProvider);

    final updated = await controller.updateReadingPreferences(
      preferredFontSize: 24,
      preferredLineHeight: 1.8,
      preferredColumnWidth: 820,
      preferredThemeMode: LocalThemeMode.dark,
      reducedMotion: true,
    );

    expect(updated.preferredFontSize, 24);
    expect(updated.preferredLineHeight, 1.8);
    expect(updated.preferredColumnWidth, 820);
    expect(updated.preferredThemeMode, LocalThemeMode.dark);
    expect(updated.reducedMotion, isTrue);

    final stored = await container.read(localDataStoreProvider).loadProfile();
    expect(stored?.preferredFontSize, 24);
    expect(stored?.preferredLineHeight, 1.8);
    expect(stored?.preferredColumnWidth, 820);
    expect(stored?.preferredThemeMode, LocalThemeMode.dark);
    expect(stored?.reducedMotion, isTrue);
  });

  test('updates onboarding goals and preferences', () async {
    final controller = container.read(localProfileControllerProvider);

    final updated = await controller.updateOnboarding(
      goals: const [TrainingGoal.school, TrainingGoal.exam],
      preferredFontSize: 22,
      reducedMotion: true,
    );

    expect(updated.goals, [TrainingGoal.school, TrainingGoal.exam]);
    expect(updated.preferredFontSize, 22);
    expect(updated.reducedMotion, isTrue);
  });

  test('stores derived baseline values from a reading result', () async {
    final controller = container.read(localProfileControllerProvider);
    final session = ReadingSession(
      id: 'session-1',
      passageId: 'passage-1',
      mode: ReadingMode.manual,
      startedAt: DateTime.utc(2026, 7, 7, 12),
      completedAt: DateTime.utc(2026, 7, 7, 12, 2),
      activeReadingSeconds: 120,
      wordCount: 500,
      status: AttemptQualificationStatus.qualified,
    );
    final quiz = QuizResult(
      id: 'quiz-1',
      sessionId: 'session-1',
      passageId: 'passage-1',
      correctCount: 4,
      totalQuestions: 5,
      answersByQuestionId: const {},
      completedAt: DateTime.utc(2026, 7, 7, 12, 3),
    );
    const passage = Passage(
      id: 'passage-1',
      title: 'Baseline',
      body: 'Practice text',
      metadata: PassageMetadata(
        wordCount: 500,
        difficulty: PassageDifficulty.standard,
        topic: 'Baseline',
        source: PassageSource.official,
        license: 'Public domain',
        type: PassageType.fiction,
        vocabularyDensity: 0.2,
        tags: ['baseline'],
        isCertificationEligible: false,
        isMasteryEligible: false,
      ),
    );

    final updated = await controller.updateBaselineFromResult(
      session: session,
      quizResult: quiz,
      passage: passage,
    );

    expect(updated.baselineWpm, 250);
    expect(updated.baselineComprehension, 0.8);
    expect(updated.baselineEffectiveReadingScore, 200);

    final stored = await container.read(localDataStoreProvider).loadProfile();
    expect(stored?.baselineWpm, 250);
    expect(stored?.baselineComprehension, 0.8);
    expect(stored?.baselineEffectiveReadingScore, 200);
  });
}
