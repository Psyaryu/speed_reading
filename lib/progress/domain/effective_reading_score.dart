import '../../core/domain/reading_enums.dart';

class EffectiveReadingScore {
  const EffectiveReadingScore._();

  static double calculate({
    required double wpm,
    required double comprehensionScore,
    required PassageDifficulty difficulty,
    required ReadingMode mode,
  }) {
    return wpm *
        comprehensionMultiplier(comprehensionScore) *
        difficultyMultiplier(difficulty) *
        modeMultiplier(mode);
  }

  static double comprehensionMultiplier(double comprehensionScore) {
    final normalized = comprehensionScore.clamp(0.0, 1.0).toDouble();
    if (normalized < 0.6) {
      return normalized * 0.5;
    }
    return normalized;
  }

  static double difficultyMultiplier(PassageDifficulty difficulty) {
    return switch (difficulty) {
      PassageDifficulty.easy => 0.85,
      PassageDifficulty.standard => 1.0,
      PassageDifficulty.hard => 1.15,
      PassageDifficulty.technical => 1.3,
    };
  }

  static double modeMultiplier(ReadingMode mode) {
    return switch (mode) {
      ReadingMode.manual => 1.0,
      ReadingMode.paced => 1.0,
      ReadingMode.deepRead => 1.0,
      ReadingMode.rsvp => 0.9,
      ReadingMode.skim => 0.85,
      ReadingMode.scan => 0.8,
    };
  }
}
