import 'dart:convert';

import '../../assessment/domain/quiz.dart';
import '../../progress/domain/progress_snapshot.dart';
import '../../reading/domain/reading_session.dart';

class ProgressExporter {
  const ProgressExporter._();

  static String toJson({
    required List<ReadingSession> sessions,
    required List<QuizResult> quizResults,
    required List<ProgressSnapshot> snapshots,
  }) {
    return jsonEncode({
      'sessions': sessions.map((session) => session.toJson()).toList(),
      'quizResults': quizResults.map((result) => result.toJson()).toList(),
      'snapshots': snapshots.map((snapshot) => snapshot.toJson()).toList(),
    });
  }

  static String sessionsToCsv(List<ReadingSession> sessions) {
    final rows = [
      'id,passageId,mode,startedAt,completedAt,activeReadingSeconds,wordCount,wpm,status',
      ...sessions.map((session) {
        return [
          session.id,
          session.passageId,
          session.mode.name,
          session.startedAt.toIso8601String(),
          session.completedAt?.toIso8601String() ?? '',
          session.activeReadingSeconds.toString(),
          session.wordCount.toString(),
          session.wpm.toStringAsFixed(2),
          session.status.name,
        ].map(_escapeCsv).join(',');
      }),
    ];

    return rows.join('\n');
  }

  static String _escapeCsv(String value) {
    if (!value.contains(',') && !value.contains('"') && !value.contains('\n')) {
      return value;
    }
    return '"${value.replaceAll('"', '""')}"';
  }
}

