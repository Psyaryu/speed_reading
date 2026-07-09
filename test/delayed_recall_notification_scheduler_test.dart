import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/progress/data/delayed_recall_notification_scheduler.dart';
import 'package:speed_reading/progress/domain/delayed_recall_reminder.dart';

void main() {
  test('local notification scheduler delegates reminder details', () async {
    final client = _FakeDelayedRecallLocalNotificationClient();
    final scheduler = LocalNotificationDelayedRecallReminderScheduler(
      client: client,
    );
    final reminder = DelayedRecallReminder(
      id: 'delayed-recall-mastery-1-passage-1',
      masteryAttemptId: 'mastery-1',
      passageId: 'passage-1',
      dueAt: DateTime.utc(2026, 7, 9, 12),
      message: 'That passage thinks you forgot it. Go prove it wrong.',
    );

    await scheduler.schedule(reminder);

    expect(client.initializeCalls, 1);
    expect(client.scheduled.single.id, greaterThan(0));
    expect(client.scheduled.single.title, 'Delayed recall check');
    expect(client.scheduled.single.body, reminder.message);
    expect(client.scheduled.single.scheduledAt, reminder.dueAt);
    expect(
      client.scheduled.single.payload,
      'delayed_recall:mastery-1:passage-1',
    );
  });

  test('local notification scheduler cancels by stable hashed id', () async {
    final client = _FakeDelayedRecallLocalNotificationClient();
    final scheduler = LocalNotificationDelayedRecallReminderScheduler(
      client: client,
    );

    await scheduler.cancel('reminder-1');

    expect(
      client.cancelled.single,
      LocalNotificationDelayedRecallReminderScheduler.notificationIdFor(
        'reminder-1',
      ),
    );
  });
}

class _FakeDelayedRecallLocalNotificationClient
    implements DelayedRecallLocalNotificationClient {
  int initializeCalls = 0;
  final List<_ScheduledNotification> scheduled = [];
  final List<int> cancelled = [];

  @override
  Future<void> initialize() async {
    initializeCalls += 1;
  }

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String payload,
  }) async {
    scheduled.add(
      _ScheduledNotification(
        id: id,
        title: title,
        body: body,
        scheduledAt: scheduledAt,
        payload: payload,
      ),
    );
  }

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
  }
}

class _ScheduledNotification {
  const _ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledAt,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final DateTime scheduledAt;
  final String payload;
}
