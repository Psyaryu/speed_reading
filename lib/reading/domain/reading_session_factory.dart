import '../../core/domain/reading_enums.dart';
import 'reading_session.dart';

class ReadingSessionFactory {
  const ReadingSessionFactory._();

  static ReadingSession complete({
    required String id,
    required String passageId,
    required ReadingMode mode,
    required DateTime startedAt,
    required DateTime completedAt,
    required int wordCount,
    Duration pausedDuration = Duration.zero,
    int pauseCount = 0,
    int? targetWpm,
    int? userConfidenceRating,
    int? selfRatedFocus,
    bool interrupted = false,
  }) {
    final elapsedSeconds = completedAt.difference(startedAt).inSeconds;
    final activeSeconds = elapsedSeconds - pausedDuration.inSeconds;

    return ReadingSession(
      id: id,
      passageId: passageId,
      mode: mode,
      startedAt: startedAt,
      completedAt: completedAt,
      activeReadingSeconds: activeSeconds <= 0 ? 0 : activeSeconds,
      wordCount: wordCount,
      status: interrupted
          ? AttemptQualificationStatus.interrupted
          : AttemptQualificationStatus.qualified,
      targetWpm: targetWpm,
      pauseCount: pauseCount,
      userConfidenceRating: userConfidenceRating,
      selfRatedFocus: selfRatedFocus,
    );
  }
}

