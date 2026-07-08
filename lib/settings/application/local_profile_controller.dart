import '../domain/local_user_profile.dart';
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
}

