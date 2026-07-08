import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/data/official_question_loader.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/content/data/official_passage_loader.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/settings/domain/local_user_profile.dart';

void main() {
  test('local data store provider can be backed by test database', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);

    final store = container.read(localDataStoreProvider);
    await store.saveProfile(
      LocalUserProfile.initial(
        id: 'local',
        createdAt: DateTime.utc(2026, 7, 7),
      ),
    );

    final profile = await store.loadProfile();
    expect(profile?.id, 'local');
  });

  test('passage repository provider can use overridden official source', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        officialPassageSourceProvider.overrideWithValue(
          const _FakeOfficialPassageSource(),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);

    final repository = container.read(passageRepositoryProvider);
    final passages = await repository.loadOfficialPassages();

    expect(passages.single.id, 'official');
  });

  test('official question provider can be overridden', () async {
    final container = ProviderContainer(
      overrides: [
        officialQuestionSourceProvider.overrideWithValue(
          const _FakeOfficialQuestionSource(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final questions = await container.read(officialQuestionSourceProvider).load();

    expect(questions.single.passageId, 'official');
  });
}

class _FakeOfficialPassageSource implements OfficialPassageSource {
  const _FakeOfficialPassageSource();

  @override
  Future<List<Passage>> load() async {
    return const [
      Passage(
        id: 'official',
        title: 'Official',
        body: 'A public domain adventure.',
        metadata: PassageMetadata(
          wordCount: 4,
          difficulty: PassageDifficulty.standard,
          topic: 'Adventure',
          source: PassageSource.official,
          license: 'Public Domain',
          type: PassageType.fiction,
          vocabularyDensity: 0.2,
          tags: ['adventure'],
          isCertificationEligible: false,
          isMasteryEligible: false,
        ),
      ),
    ];
  }
}

class _FakeOfficialQuestionSource implements OfficialQuestionSource {
  const _FakeOfficialQuestionSource();

  @override
  Future<List<QuizQuestion>> load() async {
    return const [
      QuizQuestion(
        id: 'q1',
        passageId: 'official',
        type: QuestionType.mainIdea,
        prompt: 'Question?',
        options: ['A', 'B'],
        correctOptionIndex: 0,
      ),
    ];
  }
}
