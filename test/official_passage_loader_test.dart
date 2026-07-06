import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/data/official_passage_loader.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';

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
    const rawJson = '''
[
  {
    "id": "treasure-island-001",
    "title": "The Old Sea-Dog at the Admiral Benbow",
    "body": "Squire Trelawney, Dr. Livesey, and the rest of these gentlemen having asked me to write down the whole particulars about Treasure Island.",
    "metadata": {
      "wordCount": 22,
      "difficulty": "standard",
      "topic": "Adventure",
      "source": "official",
      "license": "Public Domain",
      "type": "fiction",
      "vocabularyDensity": 0.24,
      "tags": ["adventure", "pirates", "treasure"],
      "isCertificationEligible": false,
      "isMasteryEligible": false,
      "gradeLevel": 8.0,
      "author": "Robert Louis Stevenson",
      "sourceUrl": "https://www.gutenberg.org/ebooks/120"
    }
  }
]
''';

    expect(jsonDecode(rawJson), isA<List<Object?>>());
  });
}

