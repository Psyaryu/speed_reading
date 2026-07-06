class ShareableProgressSummary {
  const ShareableProgressSummary({
    required this.levelName,
    required this.effectiveReadingScore,
    required this.qualifiedWpm,
    required this.comprehensionScore,
    required this.streakDays,
    required this.certificationStatus,
  });

  final String levelName;
  final double effectiveReadingScore;
  final double qualifiedWpm;
  final double comprehensionScore;
  final int streakDays;
  final String certificationStatus;

  String toShareText() {
    final comprehensionPercent = (comprehensionScore * 100).round();
    return 'Speed Reading Trainer: $levelName, '
        '${qualifiedWpm.round()} WPM at $comprehensionPercent% comprehension, '
        'ERS ${effectiveReadingScore.round()}, '
        '$streakDays day streak, '
        '$certificationStatus.';
  }
}

