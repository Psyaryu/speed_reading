import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/data/passage_repository.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/content/domain/passage_filter.dart';
import 'package:speed_reading/content/presentation/import_passage_screen.dart';
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

