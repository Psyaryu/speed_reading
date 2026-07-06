import '../../core/domain/reading_enums.dart';
import 'passage.dart';

class PassageFilter {
  const PassageFilter({
    this.query,
    this.difficulty,
    this.topic,
    this.tags = const [],
    this.source,
  });

  final String? query;
  final PassageDifficulty? difficulty;
  final String? topic;
  final List<String> tags;
  final PassageSource? source;
}

class PassageFilterService {
  const PassageFilterService._();

  static List<Passage> apply(List<Passage> passages, PassageFilter filter) {
    return passages.where((passage) {
      final metadata = passage.metadata;
      final normalizedQuery = filter.query?.trim().toLowerCase();
      final matchesQuery = normalizedQuery == null ||
          normalizedQuery.isEmpty ||
          passage.title.toLowerCase().contains(normalizedQuery) ||
          passage.body.toLowerCase().contains(normalizedQuery) ||
          metadata.author?.toLowerCase().contains(normalizedQuery) == true;
      final matchesDifficulty =
          filter.difficulty == null || metadata.difficulty == filter.difficulty;
      final matchesTopic = filter.topic == null ||
          metadata.topic.toLowerCase() == filter.topic!.toLowerCase();
      final metadataTags = metadata.tags.map((tag) => tag.toLowerCase()).toSet();
      final matchesTags = filter.tags.every(
        (tag) => metadataTags.contains(tag.toLowerCase()),
      );
      final matchesSource =
          filter.source == null || metadata.source == filter.source;

      return matchesQuery &&
          matchesDifficulty &&
          matchesTopic &&
          matchesTags &&
          matchesSource;
    }).toList(growable: false);
  }
}

