class DelayedRecallReminder {
  const DelayedRecallReminder({
    required this.id,
    required this.masteryAttemptId,
    required this.passageId,
    required this.dueAt,
    required this.message,
  });

  final String id;
  final String masteryAttemptId;
  final String passageId;
  final DateTime dueAt;
  final String message;

  static DateTime dueAtFor(DateTime immediateAttemptCompletedAt) {
    return immediateAttemptCompletedAt.add(const Duration(hours: 24));
  }
}

abstract interface class DelayedRecallReminderScheduler {
  Future<void> schedule(DelayedRecallReminder reminder);

  Future<void> cancel(String reminderId);
}

