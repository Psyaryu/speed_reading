import '../../core/domain/reading_enums.dart';

class Passage {
  const Passage({
    required this.id,
    required this.title,
    required this.body,
    required this.metadata,
  });

  final String id;
  final String title;
  final String body;
  final PassageMetadata metadata;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'metadata': metadata.toJson(),
    };
  }

  factory Passage.fromJson(Map<String, Object?> json) {
    return Passage(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      metadata: PassageMetadata.fromJson(
        json['metadata'] as Map<String, Object?>,
      ),
    );
  }
}

class PassageMetadata {
  const PassageMetadata({
    required this.wordCount,
    required this.difficulty,
    required this.topic,
    required this.source,
    required this.license,
    required this.type,
    required this.vocabularyDensity,
    required this.tags,
    required this.isCertificationEligible,
    required this.isMasteryEligible,
    this.gradeLevel,
    this.author,
    this.sourceUrl,
  });

  final int wordCount;
  final PassageDifficulty difficulty;
  final String topic;
  final PassageSource source;
  final String license;
  final PassageType type;
  final double vocabularyDensity;
  final List<String> tags;
  final bool isCertificationEligible;
  final bool isMasteryEligible;
  final double? gradeLevel;
  final String? author;
  final String? sourceUrl;

  Map<String, Object?> toJson() {
    return {
      'wordCount': wordCount,
      'difficulty': difficulty.name,
      'topic': topic,
      'source': source.name,
      'license': license,
      'type': type.name,
      'vocabularyDensity': vocabularyDensity,
      'tags': tags,
      'isCertificationEligible': isCertificationEligible,
      'isMasteryEligible': isMasteryEligible,
      'gradeLevel': gradeLevel,
      'author': author,
      'sourceUrl': sourceUrl,
    };
  }

  factory PassageMetadata.fromJson(Map<String, Object?> json) {
    return PassageMetadata(
      wordCount: json['wordCount'] as int,
      difficulty: PassageDifficulty.values.byName(json['difficulty'] as String),
      topic: json['topic'] as String,
      source: PassageSource.values.byName(json['source'] as String),
      license: json['license'] as String,
      type: PassageType.values.byName(json['type'] as String),
      vocabularyDensity: (json['vocabularyDensity'] as num).toDouble(),
      tags: (json['tags'] as List<Object?>).cast<String>(),
      isCertificationEligible: json['isCertificationEligible'] as bool,
      isMasteryEligible: json['isMasteryEligible'] as bool,
      gradeLevel: (json['gradeLevel'] as num?)?.toDouble(),
      author: json['author'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
    );
  }
}

