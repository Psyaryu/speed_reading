import '../domain/local_user_profile.dart';
import '../../core/domain/reading_enums.dart';
import '../../core/services/local_data_store.dart';

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
    required bool reducedMotion,
  }) async {
    final profile = await loadOrCreate();
    final updated = profile.copyWith(
      preferredFontSize: preferredFontSize,
      preferredLineHeight: preferredLineHeight,
      reducedMotion: reducedMotion,
    );
    await localDataStore.saveProfile(updated);
    return updated;
  }

  Future<LocalUserProfile> updateOnboarding({
    required List<TrainingGoal> goals,
    required double preferredFontSize,
    required bool reducedMotion,
  }) async {
    final profile = await loadOrCreate();
    final updated = profile.copyWith(
      goals: goals.isEmpty ? const [TrainingGoal.generalImprovement] : goals,
      preferredFontSize: preferredFontSize,
      reducedMotion: reducedMotion,
    );
    await localDataStore.saveProfile(updated);
    return updated;
  }
}
