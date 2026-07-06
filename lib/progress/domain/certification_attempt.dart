class CertificationAttempt {
  const CertificationAttempt({
    required this.id,
    required this.sessionIds,
    required this.startedAt,
    required this.isCertified,
    this.completedAt,
  });

  final String id;
  final List<String> sessionIds;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isCertified;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'sessionIds': sessionIds,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isCertified': isCertified,
    };
  }

  factory CertificationAttempt.fromJson(Map<String, Object?> json) {
    return CertificationAttempt(
      id: json['id'] as String,
      sessionIds: (json['sessionIds'] as List<Object?>).cast<String>(),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      isCertified: json['isCertified'] as bool,
    );
  }
}

class MasteryAttempt {
  const MasteryAttempt({
    required this.id,
    required this.sessionIds,
    required this.delayedRecallQuizResultIds,
    required this.startedAt,
    required this.isMastered,
    this.completedAt,
  });

  final String id;
  final List<String> sessionIds;
  final List<String> delayedRecallQuizResultIds;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isMastered;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'sessionIds': sessionIds,
      'delayedRecallQuizResultIds': delayedRecallQuizResultIds,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isMastered': isMastered,
    };
  }

  factory MasteryAttempt.fromJson(Map<String, Object?> json) {
    return MasteryAttempt(
      id: json['id'] as String,
      sessionIds: (json['sessionIds'] as List<Object?>).cast<String>(),
      delayedRecallQuizResultIds:
          (json['delayedRecallQuizResultIds'] as List<Object?>).cast<String>(),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      isMastered: json['isMastered'] as bool,
    );
  }
}

