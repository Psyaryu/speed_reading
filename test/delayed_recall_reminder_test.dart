import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/progress/domain/delayed_recall_reminder.dart';

void main() {
  test('delayed recall reminder is due 24 hours after immediate attempt', () {
    final completedAt = DateTime.utc(2026, 7, 6, 12);

    expect(
      DelayedRecallReminder.dueAtFor(completedAt),
      DateTime.utc(2026, 7, 7, 12),
    );
  });

  test('factory creates stable 24-hour reminder with playful copy', () {
    const factory = DelayedRecallReminderFactory();
    final completedAt = DateTime.utc(2026, 7, 8, 14, 30);

    final reminder = factory.create(
      masteryAttemptId: 'mastery-1',
      passageId: 'passage-1',
      immediateAttemptCompletedAt: completedAt,
    );

    expect(reminder.id, 'delayed-recall-mastery-1-passage-1');
    expect(reminder.masteryAttemptId, 'mastery-1');
    expect(reminder.passageId, 'passage-1');
    expect(reminder.dueAt, DateTime.utc(2026, 7, 9, 14, 30));
    expect(reminder.message, isNotEmpty);
  });

  test('in-memory scheduler stores and cancels reminders', () async {
    final scheduler = InMemoryDelayedRecallReminderScheduler();
    final reminder = DelayedRecallReminder(
      id: 'reminder-1',
      masteryAttemptId: 'mastery-1',
      passageId: 'passage-1',
      dueAt: DateTime.utc(2026, 7, 9),
      message: 'The passage is getting smug. Prove it wrong.',
    );

    await scheduler.schedule(reminder);

    expect(scheduler.scheduledReminders, [reminder]);

    await scheduler.cancel(reminder.id);

    expect(scheduler.scheduledReminders, isEmpty);
  });
}
