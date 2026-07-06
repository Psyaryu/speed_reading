import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/progress/domain/delayed_recall_reminder_copy.dart';

void main() {
  test('returns stable message for attempt id', () {
    final first = DelayedRecallReminderCopy.messageForAttempt('attempt-1');
    final second = DelayedRecallReminderCopy.messageForAttempt('attempt-1');

    expect(first, second);
  });

  test('messages are motivating without abusive language', () {
    const bannedTerms = ['hate', 'kill', 'stupid', 'worthless'];

    for (final message in DelayedRecallReminderCopy.messages) {
      expect(message.length, greaterThan(20));
      for (final term in bannedTerms) {
        expect(message.toLowerCase(), isNot(contains(term)));
      }
    }
  });
}

