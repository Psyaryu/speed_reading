import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/data/default_passage_repository.dart';
import 'package:speed_reading/content/data/official_passage_loader.dart';
import 'package:speed_reading/content/domain/imported_passage_factory.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/content/domain/passage_filter.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/data/drift_local_data_store.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';

void main() {
  late AppDatabase database;
  late DefaultPassageRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DefaultPassageRepository(
      officialPassageSource: _FakeOfficialPassageSource([
        _officialPassage(),
      ]),
      localDataStore: DriftLocalDataStore(database),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('loads official and imported passages separately', () async {
    await repository.saveImportedPassage(
      ImportedPassageFactory.create(
        id: 'import-1',
        title: 'Pasted',
        body: 'A pasted adventure.',
      ),
    );

    expect(await repository.loadOfficialPassages(), hasLength(1));
    expect(await repository.loadImportedPassages(), hasLength(1));
  });

  test('search filters across official and imported passages', () async {
    await repository.saveImportedPassage(
      ImportedPassageFactory.create(
        id: 'import-1',
        title: 'Pasted',
        body: 'A pasted adventure.',
        tags: const ['custom'],
      ),
    );

    final officialResults = await repository.search(
      const PassageFilter(tags: ['pirates']),
    );
    final importedResults = await repository.search(
      const PassageFilter(tags: ['custom']),
    );

    expect(officialResults.single.id, 'official-1');
    expect(importedResults.single.id, 'import-1');
  });
}

class _FakeOfficialPassageSource implements OfficialPassageSource {
  const _FakeOfficialPassageSource(this.passages);

  final List<Passage> passages;

  @override
  Future<List<Passage>> load() async => passages;
}

Passage _officialPassage() {
  return const Passage(
    id: 'official-1',
    title: 'Treasure',
    body: 'Pirates near the cove.',
    metadata: PassageMetadata(
      wordCount: 4,
      difficulty: PassageDifficulty.standard,
      topic: 'Adventure',
      source: PassageSource.official,
      license: 'Public Domain',
      type: PassageType.fiction,
      vocabularyDensity: 0.2,
      tags: ['pirates'],
      isCertificationEligible: false,
      isMasteryEligible: false,
    ),
  );
}

