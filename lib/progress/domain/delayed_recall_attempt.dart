class DelayedRecallAttempt {
  const DelayedRecallAttempt({
    required this.id,
    required this.passageId,
    required this.recallCompletedAt,
    required this.score,
    this.immediateSessionId,
    this.immediateQuizResultId,
    this.immediateAttemptCompletedAt,
    this.dueAt,
  });

  final String id;
  final String passageId;
  final String? immediateSessionId;
  final String? immediateQuizResultId;
  final DateTime recallCompletedAt;
  final DateTime? immediateAttemptCompletedAt;
  final DateTime? dueAt;
  final double score;

  bool get isAtLeast24HoursLater {
    final original = immediateAttemptCompletedAt;
    if (original == null) {
      return false;
    }
    return !recallCompletedAt.isBefore(original.add(const Duration(hours: 24)));
  }

  bool get qualifiesForMastery => isAtLeast24HoursLater && score >= 0.9;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'passageId': passageId,
      'immediateSessionId': immediateSessionId,
      'immediateQuizResultId': immediateQuizResultId,
      'recallCompletedAt': recallCompletedAt.toIso8601String(),
      'immediateAttemptCompletedAt':
          immediateAttemptCompletedAt?.toIso8601String(),
      'dueAt': dueAt?.toIso8601String(),
      'score': score,
      'qualifiesForMastery': qualifiesForMastery,
    };
  }

  factory DelayedRecallAttempt.fromJson(Map<String, Object?> json) {
    return DelayedRecallAttempt(
      id: json['id'] as String,
      passageId: json['passageId'] as String,
      immediateSessionId: json['immediateSessionId'] as String?,
      immediateQuizResultId: json['immediateQuizResultId'] as String?,
      recallCompletedAt: DateTime.parse(json['recallCompletedAt'] as String),
      immediateAttemptCompletedAt: json['immediateAttemptCompletedAt'] == null
          ? null
          : DateTime.parse(json['immediateAttemptCompletedAt'] as String),
      dueAt: json['dueAt'] == null
          ? null
          : DateTime.parse(json['dueAt'] as String),
      score: (json['score'] as num).toDouble(),
    );
  }
}
