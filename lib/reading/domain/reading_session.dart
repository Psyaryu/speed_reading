import '../../core/domain/reading_enums.dart';

class ReadingSession {
  const ReadingSession({
    required this.id,
    required this.passageId,
    required this.mode,
    required this.startedAt,
    required this.activeReadingSeconds,
    required this.wordCount,
    required this.status,
    this.completedAt,
    this.targetWpm,
    this.pauseCount = 0,
    this.userConfidenceRating,
    this.selfRatedFocus,
  });

  final String id;
  final String passageId;
  final ReadingMode mode;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int activeReadingSeconds;
  final int wordCount;
  final AttemptQualificationStatus status;
  final int? targetWpm;
  final int pauseCount;
  final int? userConfidenceRating;
  final int? selfRatedFocus;

  double get wpm {
    if (activeReadingSeconds <= 0) {
      return 0;
    }
    return wordCount / (activeReadingSeconds / 60);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'passageId': passageId,
      'mode': mode.name,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'activeReadingSeconds': activeReadingSeconds,
      'wordCount': wordCount,
      'status': status.name,
      'targetWpm': targetWpm,
      'pauseCount': pauseCount,
      'userConfidenceRating': userConfidenceRating,
      'selfRatedFocus': selfRatedFocus,
    };
  }

  factory ReadingSession.fromJson(Map<String, Object?> json) {
    return ReadingSession(
      id: json['id'] as String,
      passageId: json['passageId'] as String,
      mode: ReadingMode.values.byName(json['mode'] as String),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      activeReadingSeconds: json['activeReadingSeconds'] as int,
      wordCount: json['wordCount'] as int,
      status: AttemptQualificationStatus.values.byName(json['status'] as String),
      targetWpm: json['targetWpm'] as int?,
      pauseCount: json['pauseCount'] as int,
      userConfidenceRating: json['userConfidenceRating'] as int?,
      selfRatedFocus: json['selfRatedFocus'] as int?,
    );
  }
}

