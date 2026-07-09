import '../../core/domain/reading_enums.dart';

class LocalUserProfile {
  const LocalUserProfile({
    required this.id,
    required this.createdAt,
    required this.goals,
    required this.preferredFontSize,
    required this.preferredLineHeight,
    required this.preferredColumnWidth,
    required this.reducedMotion,
    this.baselineWpm,
    this.baselineComprehension,
  });

  final String id;
  final DateTime createdAt;
  final List<TrainingGoal> goals;
  final double preferredFontSize;
  final double preferredLineHeight;
  final double preferredColumnWidth;
  final bool reducedMotion;
  final double? baselineWpm;
  final double? baselineComprehension;

  LocalUserProfile copyWith({
    List<TrainingGoal>? goals,
    double? preferredFontSize,
    double? preferredLineHeight,
    double? preferredColumnWidth,
    bool? reducedMotion,
    double? baselineWpm,
    double? baselineComprehension,
  }) {
    return LocalUserProfile(
      id: id,
      createdAt: createdAt,
      goals: goals ?? this.goals,
      preferredFontSize: preferredFontSize ?? this.preferredFontSize,
      preferredLineHeight: preferredLineHeight ?? this.preferredLineHeight,
      preferredColumnWidth: preferredColumnWidth ?? this.preferredColumnWidth,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      baselineWpm: baselineWpm ?? this.baselineWpm,
      baselineComprehension:
          baselineComprehension ?? this.baselineComprehension,
    );
  }

  factory LocalUserProfile.initial({
    required String id,
    required DateTime createdAt,
  }) {
    return LocalUserProfile(
      id: id,
      createdAt: createdAt,
      goals: const [TrainingGoal.generalImprovement],
      preferredFontSize: 18,
      preferredLineHeight: 1.5,
      preferredColumnWidth: 760,
      reducedMotion: false,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'goals': goals.map((goal) => goal.name).toList(growable: false),
      'preferredFontSize': preferredFontSize,
      'preferredLineHeight': preferredLineHeight,
      'preferredColumnWidth': preferredColumnWidth,
      'reducedMotion': reducedMotion,
      'baselineWpm': baselineWpm,
      'baselineComprehension': baselineComprehension,
    };
  }

  factory LocalUserProfile.fromJson(Map<String, Object?> json) {
    return LocalUserProfile(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      goals: (json['goals'] as List<Object?>)
          .map((goal) => TrainingGoal.values.byName(goal as String))
          .toList(growable: false),
      preferredFontSize: (json['preferredFontSize'] as num).toDouble(),
      preferredLineHeight: (json['preferredLineHeight'] as num).toDouble(),
      preferredColumnWidth:
          (json['preferredColumnWidth'] as num?)?.toDouble() ?? 760,
      reducedMotion: json['reducedMotion'] as bool,
      baselineWpm: (json['baselineWpm'] as num?)?.toDouble(),
      baselineComprehension:
          (json['baselineComprehension'] as num?)?.toDouble(),
    );
  }
}
