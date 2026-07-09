import '../../content/domain/passage.dart';
import '../../core/domain/reading_enums.dart';
import '../../reading/domain/reading_session.dart';

class PassageDifficultyDistribution {
  const PassageDifficultyDistribution({
    required this.entries,
    required this.unmatchedSessionCount,
  });

  final List<PassageDifficultyDistributionEntry> entries;
  final int unmatchedSessionCount;

  int get totalClassifiedSessions {
    return entries.fold(0, (total, entry) => total + entry.totalCount);
  }

  bool get hasClassifiedSessions => totalClassifiedSessions > 0;
}

class PassageDifficultyDistributionEntry {
  const PassageDifficultyDistributionEntry({
    required this.difficulty,
    required this.officialCount,
    required this.importedCount,
  });

  final PassageDifficulty difficulty;
  final int officialCount;
  final int importedCount;

  int get totalCount => officialCount + importedCount;

  String get label {
    return switch (difficulty) {
      PassageDifficulty.easy => 'Easy',
      PassageDifficulty.standard => 'Standard',
      PassageDifficulty.hard => 'Hard',
      PassageDifficulty.technical => 'Technical',
    };
  }
}

class PassageDifficultyDistributionBuilder {
  const PassageDifficultyDistributionBuilder._();

  static PassageDifficultyDistribution fromHistory({
    required List<ReadingSession> sessions,
    required List<Passage> passages,
  }) {
    final passagesById = {
      for (final passage in passages) passage.id: passage,
    };
    final officialCounts = {
      for (final difficulty in PassageDifficulty.values) difficulty: 0,
    };
    final importedCounts = {
      for (final difficulty in PassageDifficulty.values) difficulty: 0,
    };

    var unmatchedSessionCount = 0;
    for (final session in sessions.where(_isCompletedPractice)) {
      final passage = passagesById[session.passageId];
      if (passage == null) {
        unmatchedSessionCount += 1;
        continue;
      }

      final difficulty = passage.metadata.difficulty;
      switch (passage.metadata.source) {
        case PassageSource.official:
          officialCounts[difficulty] = officialCounts[difficulty]! + 1;
        case PassageSource.imported:
          importedCounts[difficulty] = importedCounts[difficulty]! + 1;
      }
    }

    return PassageDifficultyDistribution(
      entries: [
        for (final difficulty in PassageDifficulty.values)
          PassageDifficultyDistributionEntry(
            difficulty: difficulty,
            officialCount: officialCounts[difficulty]!,
            importedCount: importedCounts[difficulty]!,
          ),
      ],
      unmatchedSessionCount: unmatchedSessionCount,
    );
  }

  static bool _isCompletedPractice(ReadingSession session) {
    return switch (session.status) {
      AttemptQualificationStatus.qualified ||
      AttemptQualificationStatus.unqualified =>
        true,
      AttemptQualificationStatus.interrupted ||
      AttemptQualificationStatus.incomplete =>
        false,
    };
  }
}
