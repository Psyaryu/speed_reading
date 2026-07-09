import '../../assessment/domain/quiz.dart';
import '../../content/domain/passage.dart';
import '../../core/domain/reading_enums.dart';
import '../../reading/domain/reading_session.dart';
import 'effective_reading_score.dart';

class ProgressTrend {
  const ProgressTrend({
    required this.points,
    required this.unmatchedSessionCount,
  });

  final List<ProgressTrendPoint> points;
  final int unmatchedSessionCount;

  bool get hasEnoughData => points.length >= 2;
}

class ProgressTrendPoint {
  const ProgressTrendPoint({
    required this.sessionId,
    required this.startedAt,
    required this.wpm,
    required this.comprehensionScore,
    required this.effectiveReadingScore,
    required this.source,
  });

  final String sessionId;
  final DateTime startedAt;
  final double wpm;
  final double comprehensionScore;
  final double effectiveReadingScore;
  final PassageSource source;
}

class ProgressTrendBuilder {
  const ProgressTrendBuilder._();

  static ProgressTrend fromHistory({
    required List<ReadingSession> sessions,
    required List<QuizResult> quizResults,
    required List<Passage> passages,
  }) {
    final quizzesBySessionId = {
      for (final quiz in quizResults) quiz.sessionId: quiz,
    };
    final passagesById = {
      for (final passage in passages) passage.id: passage,
    };

    final points = <ProgressTrendPoint>[];
    var unmatchedSessionCount = 0;

    for (final session in sessions.where(_isCompletedPractice)) {
      final quiz = quizzesBySessionId[session.id];
      if (quiz == null) {
        continue;
      }

      final passage = passagesById[session.passageId];
      if (passage == null) {
        unmatchedSessionCount += 1;
        continue;
      }

      points.add(
        ProgressTrendPoint(
          sessionId: session.id,
          startedAt: session.startedAt,
          wpm: session.wpm,
          comprehensionScore: quiz.comprehensionScore,
          effectiveReadingScore: EffectiveReadingScore.calculate(
            wpm: session.wpm,
            comprehensionScore: quiz.comprehensionScore,
            difficulty: passage.metadata.difficulty,
            mode: session.mode,
          ),
          source: passage.metadata.source,
        ),
      );
    }

    points.sort((a, b) => a.startedAt.compareTo(b.startedAt));
    return ProgressTrend(
      points: points,
      unmatchedSessionCount: unmatchedSessionCount,
    );
  }

  static bool _isCompletedPractice(ReadingSession session) {
    return switch (session.status) {
      AttemptQualificationStatus.qualified ||
      AttemptQualificationStatus.unqualified =>
        true,
      AttemptQualificationStatus.interrupted ||
      AttemptQualificationStatus.incomplete =>
        false,
    };
  }
}
