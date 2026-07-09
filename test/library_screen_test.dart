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
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Treasure Island'), findsOneWidget);
    expect(find.text('pirates'), findsOneWidget);
  });

  testWidgets('renders empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          libraryPassagesProvider.overrideWith((ref) async => []),
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

class _FakePassageRepository implements PassageRepository {
  final deleted = <String>[];

  @override
  Future<void> deleteImportedPassage(String passageId) async {
    deleted.add(passageId);
  }

  @override
  Future<List<Passage>> loadImportedPassages() async => [];

  @override
  Future<List<Passage>> loadOfficialPassages() async => [];

  @override
  Future<void> saveImportedPassage(Passage passage) async {}

  @override
  Future<List<Passage>> search(PassageFilter filter) async => [];
}
