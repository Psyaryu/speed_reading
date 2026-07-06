class DelayedRecallReminderCopy {
  const DelayedRecallReminderCopy._();

  static const List<String> messages = [
    'Your 800 WPM claim is looking fragile. Prove it was not a fluke.',
    'That passage thinks you forgot it. Go make it regret the assumption.',
    'Memory check is due. Do not let yesterday beat you this easily.',
    'Your recall score is waiting. Try not to make it embarrassing.',
    'The words moved on. Drag them back.',
  ];

  static String messageForAttempt(String attemptId) {
    final seed = attemptId.codeUnits.fold<int>(
      0,
      (previous, codeUnit) => previous + codeUnit,
    );
    final index = seed.abs() % messages.length;
    return messages[index];
  }
}
