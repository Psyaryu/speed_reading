import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/data/passage_repository.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/content/domain/passage_filter.dart';
import 'package:speed_reading/content/presentation/import_passage_screen.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/providers/app_providers.dart';

void main() {
  testWidgets('saves pasted passage through repository', (tester) async {
    final repository = _FakePassageRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          passageRepositoryProvider.overrideWithValue(repository),
          importedPassageIdProvider.overrideWithValue(() => 'import-1'),
        ],
        child: const MaterialApp(home: ImportPassageScreen()),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'Pasted Adventure');
    await tester.enterText(find.byType(TextField).at(1), 'User Notes');
    await tester.enterText(find.byType(TextField).at(2), 'custom, danger');
    await tester.enterText(
      find.byType(TextField).at(3),
      'Run toward the signal fire.',
    );
    await tester.tap(find.text('Save Passage'));
    await tester.pumpAndSettle();

    expect(repository.saved.single.id, 'import-1');
    expect(repository.saved.single.title, 'Pasted Adventure');
    expect(repository.saved.single.metadata.tags, contains('danger'));
    expect(find.text('Passage saved.'), findsOneWidget);
  });

  testWidgets('requires passage text', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          passageRepositoryProvider.overrideWithValue(_FakePassageRepository()),
        ],
        child: const MaterialApp(home: ImportPassageScreen()),
      ),
    );

    await tester.tap(find.text('Save Passage'));
    await tester.pumpAndSettle();

    expect(find.text('Passage text is required.'), findsOneWidget);
  });

  testWidgets('updates imported passage with same id and recalculated metadata', (
    tester,
  ) async {
    final repository = _FakePassageRepository();
    const initialPassage = Passage(
      id: 'import-1',
      title: 'Draft',
      body: 'Short draft.',
      metadata: PassageMetadata(
        wordCount: 2,
        difficulty: PassageDifficulty.easy,
        topic: 'Imported',
        source: PassageSource.imported,
        license: 'User Provided',
        type: PassageType.nonFiction,
        vocabularyDensity: 0,
        tags: ['imported', 'old'],
        isCertificationEligible: false,
        isMasteryEligible: false,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          passageRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(
          home: ImportPassageScreen(initialPassage: initialPassage),
        ),
      ),
    );

    final updatedBody = List.filled(120, 'word').join(' ');
    await tester.enterText(find.byType(TextField).at(0), 'Updated Draft');
    await tester.enterText(find.byType(TextField).at(1), 'Notebook');
    await tester.enterText(find.byType(TextField).at(2), 'fresh');
    await tester.enterText(find.byType(TextField).at(3), updatedBody);
    await tester.tap(find.text('Update Passage'));
    await tester.pumpAndSettle();

    expect(repository.saved.single.id, 'import-1');
    expect(repository.saved.single.title, 'Updated Draft');
    expect(repository.saved.single.metadata.wordCount, 120);
    expect(repository.saved.single.metadata.difficulty, PassageDifficulty.standard);
    expect(repository.saved.single.metadata.isCertificationEligible, isFalse);
    expect(repository.saved.single.metadata.tags, containsAll(['imported', 'fresh']));
    expect(find.text('Passage updated.'), findsOneWidget);
  });

  testWidgets('does not edit official passage passed as initial passage', (
    tester,
  ) async {
    final repository = _FakePassageRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          passageRepositoryProvider.overrideWithValue(repository),
          importedPassageIdProvider.overrideWithValue(() => 'new-import'),
        ],
        child: MaterialApp(home: ImportPassageScreen(initialPassage: _officialPassage())),
      ),
    );

    expect(find.text('Import Passage'), findsOneWidget);
    expect(find.text('Edit Passage'), findsNothing);

    await tester.enterText(find.byType(TextField).at(0), 'Personal Copy');
    await tester.enterText(find.byType(TextField).at(3), 'Private pasted text.');
    await tester.tap(find.text('Save Passage'));
    await tester.pumpAndSettle();

    expect(repository.saved.single.id, 'new-import');
    expect(repository.saved.single.metadata.source, PassageSource.imported);
  });
}

class _FakePassageRepository implements PassageRepository {
  final saved = <Passage>[];

  @override
  Future<void> deleteImportedPassage(String passageId) async {}

  @override
  Future<List<Passage>> loadImportedPassages() async => saved;

  @override
  Future<List<Passage>> loadOfficialPassages() async => [];

  @override
  Future<void> saveImportedPassage(Passage passage) async {
    saved.add(passage);
  }

  @override
  Future<List<Passage>> search(PassageFilter filter) async => saved;
}

Passage _officialPassage() {
  return const Passage(
    id: 'official-1',
    title: 'Official',
    body: 'Bundled official body.',
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
