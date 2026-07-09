import 'delayed_recall_reminder_copy.dart';

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

class DelayedRecallReminderFactory {
  const DelayedRecallReminderFactory();

  DelayedRecallReminder create({
    required String masteryAttemptId,
    required String passageId,
    required DateTime immediateAttemptCompletedAt,
  }) {
    final id = 'delayed-recall-$masteryAttemptId-$passageId';
    return DelayedRecallReminder(
      id: id,
      masteryAttemptId: masteryAttemptId,
      passageId: passageId,
      dueAt: DelayedRecallReminder.dueAtFor(immediateAttemptCompletedAt),
      message: DelayedRecallReminderCopy.messageForAttempt(id),
    );
  }
}

abstract interface class DelayedRecallReminderScheduler {
  Future<void> schedule(DelayedRecallReminder reminder);

  Future<void> cancel(String reminderId);
}

class InMemoryDelayedRecallReminderScheduler
    implements DelayedRecallReminderScheduler {
  final Map<String, DelayedRecallReminder> _scheduledReminders = {};

  List<DelayedRecallReminder> get scheduledReminders =>
      List.unmodifiable(_scheduledReminders.values);

  @override
  Future<void> schedule(DelayedRecallReminder reminder) async {
    _scheduledReminders[reminder.id] = reminder;
  }

  @override
  Future<void> cancel(String reminderId) async {
    _scheduledReminders.remove(reminderId);
  }
}
