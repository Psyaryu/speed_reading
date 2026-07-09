import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/domain/passage_difficulty_distribution.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';

void main() {
  test('counts completed sessions by difficulty and source', () {
    final distribution = PassageDifficultyDistributionBuilder.fromHistory(
      sessions: [
        _session(id: 'easy-official-1', passageId: 'easy-official'),
        _session(id: 'easy-official-2', passageId: 'easy-official'),
        _session(id: 'easy-imported-1', passageId: 'easy-imported'),
        _session(id: 'hard-imported-1', passageId: 'hard-imported'),
        _session(
          id: 'standard-incomplete',
          passageId: 'standard-official',
          status: AttemptQualificationStatus.incomplete,
        ),
        _session(id: 'missing-passage', passageId: 'missing'),
      ],
      passages: const [
        _easyOfficial,
        _easyImported,
        _standardOfficial,
        _hardImported,
      ],
    );

    expect(distribution.totalClassifiedSessions, 4);
    expect(distribution.unmatchedSessionCount, 1);

    final easy = distribution.entries.singleWhere(
      (entry) => entry.difficulty == PassageDifficulty.easy,
    );
    expect(easy.officialCount, 2);
    expect(easy.importedCount, 1);
    expect(easy.totalCount, 3);

    final standard = distribution.entries.singleWhere(
      (entry) => entry.difficulty == PassageDifficulty.standard,
    );
    expect(standard.totalCount, 0);

    final hard = distribution.entries.singleWhere(
      (entry) => entry.difficulty == PassageDifficulty.hard,
    );
    expect(hard.officialCount, 0);
    expect(hard.importedCount, 1);
  });

  test('reports no classified sessions when only pending practice exists', () {
    final distribution = PassageDifficultyDistributionBuilder.fromHistory(
      sessions: [
        _session(
          id: 'incomplete',
          passageId: 'easy-official',
          status: AttemptQualificationStatus.incomplete,
        ),
      ],
      passages: const [_easyOfficial],
    );

    expect(distribution.hasClassifiedSessions, isFalse);
    expect(distribution.totalClassifiedSessions, 0);
    expect(distribution.unmatchedSessionCount, 0);
  });
}

ReadingSession _session({
  required String id,
  required String passageId,
  AttemptQualificationStatus status = AttemptQualificationStatus.qualified,
}) {
  return ReadingSession(
    id: id,
    passageId: passageId,
    mode: ReadingMode.manual,
    startedAt: DateTime.utc(2026, 7, 8, 12),
    activeReadingSeconds: 60,
    wordCount: 600,
    status: status,
  );
}

const _easyOfficial = Passage(
  id: 'easy-official',
  title: 'Official Easy',
  body: 'Official body.',
  metadata: PassageMetadata(
    wordCount: 600,
    difficulty: PassageDifficulty.easy,
    topic: 'Adventure',
    source: PassageSource.official,
    license: 'Public domain',
    type: PassageType.fiction,
    vocabularyDensity: 0.2,
    tags: ['official'],
    isCertificationEligible: true,
    isMasteryEligible: false,
  ),
);

const _easyImported = Passage(
  id: 'easy-imported',
  title: 'Imported Easy',
  body: 'Private imported passage body.',
  metadata: PassageMetadata(
    wordCount: 600,
    difficulty: PassageDifficulty.easy,
    topic: 'Private',
    source: PassageSource.imported,
    license: 'User provided',
    type: PassageType.workplace,
    vocabularyDensity: 0.2,
    tags: ['private'],
    isCertificationEligible: false,
    isMasteryEligible: false,
  ),
);

const _standardOfficial = Passage(
  id: 'standard-official',
  title: 'Official Standard',
  body: 'Official body.',
  metadata: PassageMetadata(
    wordCount: 600,
    difficulty: PassageDifficulty.standard,
    topic: 'Adventure',
    source: PassageSource.official,
    license: 'Public domain',
    type: PassageType.fiction,
    vocabularyDensity: 0.2,
    tags: ['official'],
    isCertificationEligible: true,
    isMasteryEligible: true,
  ),
);

const _hardImported = Passage(
  id: 'hard-imported',
  title: 'Imported Hard',
  body: 'Private imported passage body.',
  metadata: PassageMetadata(
    wordCount: 600,
    difficulty: PassageDifficulty.hard,
    topic: 'Private',
    source: PassageSource.imported,
    license: 'User provided',
    type: PassageType.workplace,
    vocabularyDensity: 0.3,
    tags: ['private'],
    isCertificationEligible: false,
    isMasteryEligible: false,
  ),
);
