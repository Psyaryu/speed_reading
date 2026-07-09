import '../domain/local_user_profile.dart';
import '../../assessment/domain/quiz.dart';
import '../../content/domain/passage.dart';
import '../../core/domain/reading_enums.dart';
import '../../core/services/local_data_store.dart';
import '../../progress/domain/effective_reading_score.dart';
import '../../reading/domain/reading_session.dart';

class LocalProfileController {
  const LocalProfileController({
    required this.localDataStore,
    required this.now,
  });

  final LocalDataStore localDataStore;
  final DateTime Function() now;

  Future<LocalUserProfile> loadOrCreate() async {
    final existing = await localDataStore.loadProfile();
    if (existing != null) {
      return existing;
    }

    final profile = LocalUserProfile.initial(
      id: 'local',
      createdAt: now(),
    );
    await localDataStore.saveProfile(profile);
    return profile;
  }

  Future<LocalUserProfile> updateReadingPreferences({
    required double preferredFontSize,
    required double preferredLineHeight,
    required double preferredColumnWidth,
    required LocalThemeMode preferredThemeMode,
    required bool reducedMotion,
  }) async {
    final profile = await loadOrCreate();
    final updated = profile.copyWith(
      preferredFontSize: preferredFontSize,
      preferredLineHeight: preferredLineHeight,
      preferredColumnWidth: preferredColumnWidth,
      preferredThemeMode: preferredThemeMode,
      reducedMotion: reducedMotion,
    );
    await localDataStore.saveProfile(updated);
    return updated;
  }

  Future<LocalUserProfile> updateOnboarding({
    required List<TrainingGoal> goals,
    required double preferredFontSize,
    required LocalThemeMode preferredThemeMode,
    required bool reducedMotion,
  }) async {
    final profile = await loadOrCreate();
    final updated = profile.copyWith(
      goals: goals.isEmpty ? const [TrainingGoal.generalImprovement] : goals,
      preferredFontSize: preferredFontSize,
      preferredThemeMode: preferredThemeMode,
      reducedMotion: reducedMotion,
    );
    await localDataStore.saveProfile(updated);
    return updated;
  }

  Future<LocalUserProfile> updateBaselineFromResult({
    required ReadingSession session,
    required QuizResult quizResult,
    required Passage passage,
  }) async {
    final profile = await loadOrCreate();
    final comprehensionScore = quizResult.comprehensionScore;
    final updated = profile.copyWith(
      baselineWpm: session.wpm,
      baselineComprehension: comprehensionScore,
      baselineEffectiveReadingScore: EffectiveReadingScore.calculate(
        wpm: session.wpm,
        comprehensionScore: comprehensionScore,
        difficulty: passage.metadata.difficulty,
        mode: session.mode,
      ),
    );
    await localDataStore.saveProfile(updated);
    return updated;
  }
}
