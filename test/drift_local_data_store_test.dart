import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/domain/imported_passage_factory.dart';
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

