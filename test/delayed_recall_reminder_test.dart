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
}

