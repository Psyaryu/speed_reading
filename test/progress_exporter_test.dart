import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/quiz.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/progress/domain/progress_snapshot.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';
import 'package:speed_reading/settings/domain/progress_exporter.dart';

void main() {
  test('exports progress data as JSON', () {
    final json = ProgressExporter.toJson(
      sessions: [_session()],
      quizResults: [_quizResult()],
      snapshots: [_snapshot()],
    );

    final decoded = jsonDecode(json) as Map<String, Object?>;

    expect(decoded['sessions'], isA<List<Object?>>());
    expect(decoded['quizResults'], isA<List<Object?>>());
    expect(decoded['snapshots'], isA<List<Object?>>());
  });

  test('exports sessions as CSV', () {
    final csv = ProgressExporter.sessionsToCsv([_session()]);

    expect(csv, contains('id,passageId,mode'));
    expect(csv, contains('s1,p1,manual'));
    expect(csv, contains('800.00'));
  });
}

ReadingSession _session() {
  return ReadingSession(
    id: 's1',
    passageId: 'p1',
    mode: ReadingMode.manual,
    startedAt: DateTime.utc(2026, 7, 6, 12),
    completedAt: DateTime.utc(2026, 7, 6, 12, 1),
    activeReadingSeconds: 60,
    wordCount: 800,
    status: AttemptQualificationStatus.qualified,
  );
}

QuizResult _quizResult() {
  return QuizResult(
    id: 'q1',
    sessionId: 's1',
    passageId: 'p1',
    correctCount: 7,
    totalQuestions: 10,
    answersByQuestionId: const {'a': 1},
    completedAt: DateTime.utc(2026, 7, 6, 12, 2),
  );
}

ProgressSnapshot _snapshot() {
  return ProgressSnapshot(
    id: 'ps1',
    createdAt: DateTime.utc(2026, 7, 6, 12, 3),
    latestWpm: 800,
    latestComprehension: 0.7,
    effectiveReadingScore: 560,
    readinessPercent: 70,
    level: 4,
    streakDays: 1,
  );
}

