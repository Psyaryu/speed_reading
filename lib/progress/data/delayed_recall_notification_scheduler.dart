import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

import '../domain/delayed_recall_reminder.dart';

abstract interface class DelayedRecallLocalNotificationClient {
  Future<void> initialize();

  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String payload,
  });

  Future<void> cancel(int id);
}

class FlutterDelayedRecallLocalNotificationClient
    implements DelayedRecallLocalNotificationClient {
  FlutterDelayedRecallLocalNotificationClient({
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  static bool _timeZonesInitialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    if (!_timeZonesInitialized) {
      timezone_data.initializeTimeZones();
      _timeZonesInitialized = true;
    }
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    _initialized = true;
  }

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String payload,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      timezone.TZDateTime.from(scheduledAt.toUtc(), timezone.UTC),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'delayed_recall_reminders',
          'Delayed recall reminders',
          channelDescription:
              'Reminders to complete 800 WPM Mastery recall checks.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> cancel(int id) {
    return _plugin.cancel(id);
  }
}

class LocalNotificationDelayedRecallReminderScheduler
    implements DelayedRecallReminderScheduler {
  const LocalNotificationDelayedRecallReminderScheduler({
    required DelayedRecallLocalNotificationClient client,
  }) : _client = client;

  final DelayedRecallLocalNotificationClient _client;

  @override
  Future<void> schedule(DelayedRecallReminder reminder) async {
    await _client.initialize();
    await _client.schedule(
      id: notificationIdFor(reminder.id),
      title: 'Delayed recall check',
      body: reminder.message,
      scheduledAt: reminder.dueAt,
      payload: payloadFor(reminder),
    );
  }

  @override
  Future<void> cancel(String reminderId) {
    return _client.cancel(notificationIdFor(reminderId));
  }

  static int notificationIdFor(String reminderId) {
    return reminderId.codeUnits.fold<int>(
      0,
      (hash, codeUnit) => ((hash * 31) + codeUnit) & 0x7fffffff,
    );
  }

  static String payloadFor(DelayedRecallReminder reminder) {
    return 'delayed_recall:${reminder.masteryAttemptId}:${reminder.passageId}';
  }
}

DelayedRecallReminderScheduler createDefaultDelayedRecallReminderScheduler() {
  if (kIsWeb ||
      (defaultTargetPlatform != TargetPlatform.android &&
          defaultTargetPlatform != TargetPlatform.iOS)) {
    return InMemoryDelayedRecallReminderScheduler();
  }

  return LocalNotificationDelayedRecallReminderScheduler(
    client: FlutterDelayedRecallLocalNotificationClient(),
  );
}
