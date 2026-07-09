import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/data/passage_repository.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/content/domain/passage_filter.dart';
import 'package:speed_reading/content/presentation/library_screen.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/providers/app_providers.dart';

void main() {
  testWidgets('renders loaded passages', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          libraryPassagesProvider.overrideWith((ref) async => [_passage()]),
          libraryAvailablePassagesProvider.overrideWith(
            (ref) async => [_passage()],
          ),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Treasure Island'), findsOneWidget);
    expect(find.widgetWithText(Chip, 'pirates'), findsOneWidget);
  });

  testWidgets('renders empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          libraryPassagesProvider.overrideWith((ref) async => []),
          libraryAvailablePassagesProvider.overrideWith((ref) async => []),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No passages available.'), findsOneWidget);
  });

  testWidgets('shows edit and delete actions only for imported passages', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          libraryPassagesProvider.overrideWith(
            (ref) async => [_passage(), _importedPassage()],
          ),
          libraryAvailablePassagesProvider.overrideWith(
            (ref) async => [_passage(), _importedPassage()],
          ),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Treasure Island'), findsOneWidget);
    expect(find.text('Pasted Notes'), findsOneWidget);
    expect(find.byTooltip('Edit imported passage'), findsOneWidget);
    expect(find.byTooltip('Delete imported passage'), findsOneWidget);
  });

  testWidgets('deletes imported passage after confirmation', (tester) async {
    final repository = _FakePassageRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          libraryPassagesProvider.overrideWith(
            (ref) async => [_importedPassage()],
          ),
          libraryAvailablePassagesProvider.overrideWith(
            (ref) async => [_importedPassage()],
          ),
          passageRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete imported passage'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(repository.deleted, ['import-1']);
    expect(find.text('Passage deleted.'), findsOneWidget);
  });

  testWidgets('searches and filters by difficulty topic and tag', (
    tester,
  ) async {
    final repository = _FakePassageRepository(
      passages: [_passage(), _junglePassage()],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          passageRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Treasure Island'), findsOneWidget);
    expect(find.text('Jungle Trail'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Jungle');
    await tester.pumpAndSettle();

    expect(find.text('Treasure Island'), findsNothing);
    expect(find.text('Jungle Trail'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Hard'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Exploration'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, 'jungle'));
    await tester.pumpAndSettle();

    final latestFilter = repository.filters.last;
    expect(latestFilter.query, 'Jungle');
    expect(latestFilter.difficulty, PassageDifficulty.hard);
    expect(latestFilter.topic, 'Exploration');
    expect(latestFilter.tags, ['jungle']);
    expect(find.text('Jungle Trail'), findsOneWidget);
  });
}

Passage _passage() {
  return const Passage(
    id: 'p1',
    title: 'Treasure Island',
    body: 'Pirates near the cove.',
    metadata: PassageMetadata(
      wordCount: 4,
      difficulty: PassageDifficulty.standard,
      topic: 'Adventure',
      source: PassageSource.official,
      license: 'Public Domain',
      type: PassageType.fiction,
      vocabularyDensity: 0.2,
      tags: ['pirates', 'adventure'],
      isCertificationEligible: false,
      isMasteryEligible: false,
    ),
  );
}

Passage _importedPassage() {
  return const Passage(
    id: 'import-1',
    title: 'Pasted Notes',
    body: 'Private notes near the cove.',
    metadata: PassageMetadata(
      wordCount: 5,
      difficulty: PassageDifficulty.easy,
      topic: 'Imported',
      source: PassageSource.imported,
      license: 'User Provided',
      type: PassageType.nonFiction,
      vocabularyDensity: 0,
      tags: ['imported', 'practice'],
      isCertificationEligible: false,
      isMasteryEligible: false,
    ),
  );
}

Passage _junglePassage() {
  return const Passage(
    id: 'p2',
    title: 'Jungle Trail',
    body: 'Explorers cross the jungle trail.',
    metadata: PassageMetadata(
      wordCount: 5,
      difficulty: PassageDifficulty.hard,
      topic: 'Exploration',
      source: PassageSource.official,
      license: 'Public Domain',
      type: PassageType.fiction,
      vocabularyDensity: 0.25,
      tags: ['jungle', 'adventure'],
      isCertificationEligible: false,
      isMasteryEligible: true,
    ),
  );
}

class _FakePassageRepository implements PassageRepository {
  _FakePassageRepository({List<Passage>? passages})
      : passages = passages ?? const [];

  final List<Passage> passages;
  final deleted = <String>[];
  final filters = <PassageFilter>[];

  @override
  Future<void> deleteImportedPassage(String passageId) async {
    deleted.add(passageId);
  }

  @override
  Future<List<Passage>> loadImportedPassages() async => [];

  @override
  Future<List<Passage>> loadOfficialPassages() async => passages
      .where((passage) => passage.metadata.source == PassageSource.official)
      .toList(growable: false);

  @override
  Future<void> saveImportedPassage(Passage passage) async {}

  @override
  Future<List<Passage>> search(PassageFilter filter) async {
    filters.add(filter);
    return PassageFilterService.apply(passages, filter);
  }
}
