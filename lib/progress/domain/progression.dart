import 'dart:math';

import '../../core/domain/reading_enums.dart';

class QualifiedAttemptInput {
  const QualifiedAttemptInput({
    required this.wpm,
    required this.comprehensionScore,
    required this.wordCount,
    required this.difficulty,
    required this.status,
    required this.excessivePausing,
  });

  final double wpm;
  final double comprehensionScore;
  final int wordCount;
  final PassageDifficulty difficulty;
  final AttemptQualificationStatus status;
  final bool excessivePausing;
}

class Progression {
  const Progression._();

  static bool isQualifiedAttempt(QualifiedAttemptInput input) {
    return input.comprehensionScore >= 0.7 &&
        input.wordCount >= 600 &&
        input.difficulty != PassageDifficulty.easy &&
        input.status == AttemptQualificationStatus.qualified &&
        !input.excessivePausing;
  }

  static double readinessPercent(double qualifiedEffectiveReadingScore) {
    return min(100, (qualifiedEffectiveReadingScore / 800) * 100);
  }

  static int levelForQualifiedErs(double qualifiedEffectiveReadingScore) {
    if (qualifiedEffectiveReadingScore >= 800) {
      return 7;
    }
    if (qualifiedEffectiveReadingScore >= 700) {
      return 6;
    }
    if (qualifiedEffectiveReadingScore >= 600) {
      return 5;
    }
    if (qualifiedEffectiveReadingScore >= 450) {
      return 4;
    }
    if (qualifiedEffectiveReadingScore >= 350) {
      return 3;
    }
    if (qualifiedEffectiveReadingScore >= 250) {
      return 2;
    }
    return 1;
  }

  static String levelName(int level) {
    return switch (level) {
      1 => 'Baseline Reader',
      2 => 'Focused Reader',
      3 => 'Efficient Reader',
      4 => 'Fast Reader',
      5 => 'Rapid Reader',
      6 => '800 WPM Candidate',
      7 => '800 WPM Certified',
      _ => 'Unknown',
    };
  }
}

