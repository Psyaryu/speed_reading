import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/data/official_passage_loader.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/utils/word_counter.dart';

void main() {
  test('parses official passage asset format', () {
    const rawJson = '''
[
  {
    "id": "sample",
    "title": "Sample",
    "body": "A quick test passage.",
    "metadata": {
      "wordCount": 4,
      "difficulty": "standard",
      "topic": "Adventure",
      "source": "official",
      "license": "Public Domain",
      "type": "fiction",
      "vocabularyDensity": 0.1,
      "tags": ["adventure", "test"],
      "isCertificationEligible": false,
      "isMasteryEligible": false,
      "gradeLevel": 6.0,
      "author": "Tester",
      "sourceUrl": "https://example.com"
    }
  }
]
''';

    final passages = const OfficialPassageLoader().parse(rawJson);

    expect(passages, hasLength(1));
    expect(passages.single.metadata.source, PassageSource.official);
    expect(passages.single.metadata.tags, contains('adventure'));
  });

  test('bundled JSON is structurally valid', () {
    final rawJson = File(
      'assets/passages/official_passages.json',
    ).readAsStringSync();

    expect(jsonDecode(rawJson), isA<List<Object?>>());
  });

  test('bundled library has official short medium and long adventure fiction', () {
    final rawJson = File(
      'assets/passages/official_passages.json',
    ).readAsStringSync();

    final passages = const OfficialPassageLoader().parse(rawJson);
    final ids = passages.map((passage) => passage.id).toSet();

    expect(passages, hasLength(greaterThanOrEqualTo(3)));
    expect(ids, hasLength(passages.length));
    expect(passages.any((passage) => passage.metadata.wordCount < 150), isTrue);
    expect(
      passages.any(
        (passage) =>
            passage.metadata.wordCount >= 150 &&
            passage.metadata.wordCount < 600,
      ),
      isTrue,
    );
    expect(
      passages.any((passage) => passage.metadata.wordCount >= 600),
      isTrue,
    );

    for (final passage in passages) {
      expect(passage.metadata.source, PassageSource.official);
      expect(passage.metadata.license, 'Public Domain');
      expect(passage.metadata.topic, 'Adventure');
      expect(passage.metadata.type, PassageType.fiction);
      expect(passage.metadata.tags, contains('adventure'));
      expect(passage.metadata.tags, isNotEmpty);
      expect(passage.metadata.author, isNotEmpty);
      expect(passage.metadata.sourceUrl, startsWith('https://'));
      expect(passage.metadata.wordCount, WordCounter.count(passage.body));
    }

    expect(
      passages.where((passage) => passage.metadata.isMasteryEligible),
      isNotEmpty,
    );
  });
}
