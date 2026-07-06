import '../../core/domain/reading_enums.dart';
import '../../core/utils/word_counter.dart';
import 'passage.dart';

class ImportedPassageFactory {
  const ImportedPassageFactory._();

  static Passage create({
    required String id,
    required String title,
    required String body,
    String? sourceLabel,
    List<String> tags = const [],
  }) {
    final trimmedBody = body.trim();
    final inferredTags = {
      'imported',
      ...tags.map((tag) => tag.trim().toLowerCase()).where((tag) => tag.isNotEmpty),
    }.toList(growable: false);

    return Passage(
      id: id,
      title: title.trim().isEmpty ? 'Untitled Passage' : title.trim(),
      body: trimmedBody,
      metadata: PassageMetadata(
        wordCount: WordCounter.count(trimmedBody),
        difficulty: PassageDifficulty.standard,
        topic: 'Imported',
        source: PassageSource.imported,
        license: sourceLabel == null || sourceLabel.trim().isEmpty
            ? 'User Provided'
            : sourceLabel.trim(),
        type: PassageType.nonFiction,
        vocabularyDensity: 0,
        tags: inferredTags,
        isCertificationEligible: false,
        isMasteryEligible: false,
      ),
    );
  }
}

