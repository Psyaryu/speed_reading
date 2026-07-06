import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/content/domain/passage_filter.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';

void main() {
  test('filters passages by tag', () {
    final passages = [_passage(tags: ['pirates', 'danger'])];

    final results = PassageFilterService.apply(
      passages,
      const PassageFilter(tags: ['pirates']),
    );

    expect(results, hasLength(1));
  });

  test('requires all selected tags', () {
    final passages = [_passage(tags: ['pirates'])];

    final results = PassageFilterService.apply(
      passages,
      const PassageFilter(tags: ['pirates', 'treasure']),
    );

    expect(results, isEmpty);
  });

  test('filters by query across title body and author', () {
    final passages = [
      _passage(title: 'The Island', body: 'A map appeared.', author: 'Stevenson'),
    ];

    expect(
      PassageFilterService.apply(passages, const PassageFilter(query: 'map')),
      hasLength(1),
    );
    expect(
      PassageFilterService.apply(
        passages,
        const PassageFilter(query: 'stevenson'),
      ),
      hasLength(1),
    );
  });

  test('filters by source and difficulty', () {
    final passages = [
      _passage(source: PassageSource.official, difficulty: PassageDifficulty.hard),
      _passage(source: PassageSource.imported, difficulty: PassageDifficulty.easy),
    ];

    final results = PassageFilterService.apply(
      passages,
      const PassageFilter(
        source: PassageSource.official,
        difficulty: PassageDifficulty.hard,
      ),
    );

    expect(results, hasLength(1));
  });
}

Passage _passage({
  String title = 'Treasure Island',
  String body = 'The pirates waited near the cove.',
  String author = 'Robert Louis Stevenson',
  List<String> tags = const ['adventure'],
  PassageSource source = PassageSource.official,
  PassageDifficulty difficulty = PassageDifficulty.standard,
}) {
  return Passage(
    id: '$title-$source-$difficulty',
    title: title,
    body: body,
    metadata: PassageMetadata(
      wordCount: 6,
      difficulty: difficulty,
      topic: 'Adventure',
      source: source,
      license: 'Public Domain',
      type: PassageType.fiction,
      vocabularyDensity: 0.2,
      tags: tags,
      isCertificationEligible: false,
      isMasteryEligible: false,
      author: author,
    ),
  );
}

