import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/content/presentation/library_screen.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';

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

