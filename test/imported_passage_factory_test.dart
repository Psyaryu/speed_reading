import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/domain/imported_passage_factory.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';

void main() {
  test('creates practice-only imported passage', () {
    final passage = ImportedPassageFactory.create(
      id: 'import-1',
      title: ' Field Notes ',
      body: 'Run toward the signal fire.',
      tags: const ['Practice', 'Adventure'],
    );

    expect(passage.title, 'Field Notes');
    expect(passage.metadata.wordCount, 5);
    expect(passage.metadata.source, PassageSource.imported);
    expect(passage.metadata.isCertificationEligible, isFalse);
    expect(passage.metadata.isMasteryEligible, isFalse);
    expect(passage.metadata.tags, containsAll(['imported', 'practice']));
  });

  test('uses fallback title and license', () {
    final passage = ImportedPassageFactory.create(
      id: 'import-2',
      title: '',
      body: 'A pasted passage.',
    );

    expect(passage.title, 'Untitled Passage');
    expect(passage.metadata.license, 'User Provided');
  });
}

