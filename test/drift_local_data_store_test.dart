import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/content/domain/imported_passage_factory.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/data/drift_local_data_store.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';
import 'package:speed_reading/settings/domain/local_user_profile.dart';

void main() {
  late AppDatabase database;
  late DriftLocalDataStore store;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    store = DriftLocalDataStore(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('saves and loads local profile', () async {
    final profile = LocalUserProfile.initial(
      id: 'local',
      createdAt: DateTime.utc(2026, 7, 7),
    );

    await store.saveProfile(profile);

    final loaded = await store.loadProfile();
    expect(loaded?.id, 'local');
    expect(loaded?.goals, [TrainingGoal.generalImprovement]);
  });

  test('saves and deletes imported passage only', () async {
    final passage = ImportedPassageFactory.create(
      id: 'import-1',
      title: 'Signal Fire',
      body: 'Run toward the signal fire.',
    );

    await store.saveImportedPassage(passage);
    expect(await store.loadPassages(), hasLength(1));

    await store.deleteImportedPassage('import-1');
    expect(await store.loadPassages(), isEmpty);
  });

  test('updates imported passage and keeps recalculated metadata', () async {
    await store.saveImportedPassage(
      ImportedPassageFactory.create(
        id: 'import-1',
        title: 'Draft',
        body: 'Short draft.',
      ),
    );

    await store.saveImportedPassage(
      ImportedPassageFactory.create(
        id: 'import-1',
        title: 'Updated Draft',
        body: List.filled(120, 'word').join(' '),
      ),
    );

    final passages = await store.loadPassages();
    expect(passages, hasLength(1));
    expect(passages.single.title, 'Updated Draft');
    expect(passages.single.metadata.wordCount, 120);
    expect(passages.single.metadata.difficulty, PassageDifficulty.standard);
    expect(passages.single.metadata.isCertificationEligible, isFalse);
  });

  test('rejects official passage saves through imported passage method',
      () async {
    expect(
      () => store.saveImportedPassage(_officialPassage()),
      throwsArgumentError,
    );
    expect(await store.loadPassages(), isEmpty);
  });

  test('saves sessions and exports CSV', () async {
    await store.saveReadingSession(
      ReadingSession(
        id: 's1',
        passageId: 'p1',
        mode: ReadingMode.manual,
        startedAt: DateTime.utc(2026, 7, 7),
        activeReadingSeconds: 60,
        wordCount: 800,
        status: AttemptQualificationStatus.qualified,
      ),
    );

    final sessions = await store.loadReadingSessions();
    final csv = await store.exportCsv();

    expect(sessions.single.wpm, 800);
    expect(csv, contains('s1,p1,manual'));
  });

  test('saves and loads quiz written summary', () async {
    await store.saveQuizResult(
      QuizResult(
        id: 'q1',
        sessionId: 's1',
        passageId: 'p1',
        correctCount: 1,
        totalQuestions: 2,
        answersByQuestionId: const {'question-1': 0},
        completedAt: DateTime.utc(2026, 7, 8),
        writtenSummary: 'The passage is about a signal fire.',
      ),
    );

    final results = await store.loadQuizResults();

    expect(
        results.single.writtenSummary, 'The passage is about a signal fire.');
    expect(results.single.comprehensionScore, 0.5);
  });

  test('reset progress keeps imported passages', () async {
    await store.saveImportedPassage(
      ImportedPassageFactory.create(
        id: 'import-1',
        title: 'Signal Fire',
        body: 'Run toward the signal fire.',
      ),
    );
    await store.saveReadingSession(
      ReadingSession(
        id: 's1',
        passageId: 'import-1',
        mode: ReadingMode.manual,
        startedAt: DateTime.utc(2026, 7, 7),
        activeReadingSeconds: 60,
        wordCount: 800,
        status: AttemptQualificationStatus.qualified,
      ),
    );

    await store.resetProgress();

    expect(await store.loadPassages(), hasLength(1));
    expect(await store.loadReadingSessions(), isEmpty);
  });
}

Passage _officialPassage() {
  return const Passage(
    id: 'official-1',
    title: 'Official',
    body: 'Official bundled body.',
    metadata: PassageMetadata(
      wordCount: 3,
      difficulty: PassageDifficulty.standard,
      topic: 'Adventure',
      source: PassageSource.official,
      license: 'Public Domain',
      type: PassageType.fiction,
      vocabularyDensity: 0.1,
      tags: ['official'],
      isCertificationEligible: true,
      isMasteryEligible: true,
    ),
  );
}
