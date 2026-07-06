class ProgressSnapshot {
  const ProgressSnapshot({
    required this.id,
    required this.createdAt,
    required this.latestWpm,
    required this.latestComprehension,
    required this.effectiveReadingScore,
    required this.readinessPercent,
    required this.level,
    required this.streakDays,
  });

  final String id;
  final DateTime createdAt;
  final double latestWpm;
  final double latestComprehension;
  final double effectiveReadingScore;
  final double readinessPercent;
  final int level;
  final int streakDays;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'latestWpm': latestWpm,
      'latestComprehension': latestComprehension,
      'effectiveReadingScore': effectiveReadingScore,
      'readinessPercent': readinessPercent,
      'level': level,
      'streakDays': streakDays,
    };
  }

  factory ProgressSnapshot.fromJson(Map<String, Object?> json) {
    return ProgressSnapshot(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      latestWpm: (json['latestWpm'] as num).toDouble(),
      latestComprehension: (json['latestComprehension'] as num).toDouble(),
      effectiveReadingScore: (json['effectiveReadingScore'] as num).toDouble(),
      readinessPercent: (json['readinessPercent'] as num).toDouble(),
      level: json['level'] as int,
      streakDays: json['streakDays'] as int,
    );
  }
}

