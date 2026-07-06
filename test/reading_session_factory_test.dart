import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/reading/domain/reading_session_factory.dart';

void main() {
  test('creates completed session with active reading seconds', () {
    final session = ReadingSessionFactory.complete(
      id: 's1',
      passageId: 'p1',
      mode: ReadingMode.manual,
      startedAt: DateTime.utc(2026, 7, 6, 12),
      completedAt: DateTime.utc(2026, 7, 6, 12, 1),
      wordCount: 800,
      pausedDuration: const Duration(seconds: 15),
      pauseCount: 1,
    );

    expect(session.activeReadingSeconds, 45);
    expect(session.wpm, closeTo(1066.67, 0.01));
    expect(session.pauseCount, 1);
  });

  test('marks interrupted sessions unqualified', () {
    final session = ReadingSessionFactory.complete(
      id: 's1',
      passageId: 'p1',
      mode: ReadingMode.manual,
      startedAt: DateTime.utc(2026, 7, 6, 12),
      completedAt: DateTime.utc(2026, 7, 6, 12, 1),
      wordCount: 800,
      interrupted: true,
    );

    expect(session.status, AttemptQualificationStatus.interrupted);
  });
}

