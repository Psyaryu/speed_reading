import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../assessment/data/official_question_loader.dart';
import '../../content/data/default_passage_repository.dart';
import '../../content/data/official_passage_loader.dart';
import '../../content/data/passage_repository.dart';
import '../../settings/application/local_profile_controller.dart';
import '../../settings/domain/local_user_profile.dart';
import '../data/app_database.dart';
import '../data/database_connection.dart';
import '../data/drift_local_data_store.dart';
import '../services/local_data_store.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = openAppDatabase();
  ref.onDispose(database.close);
  return database;
});

final localDataStoreProvider = Provider<LocalDataStore>((ref) {
  return DriftLocalDataStore(ref.watch(appDatabaseProvider));
});

final officialPassageSourceProvider = Provider<OfficialPassageSource>((ref) {
  return const OfficialPassageLoader();
});

final passageRepositoryProvider = Provider<PassageRepository>((ref) {
  return DefaultPassageRepository(
    officialPassageSource: ref.watch(officialPassageSourceProvider),
    localDataStore: ref.watch(localDataStoreProvider),
  );
});

final officialQuestionSourceProvider = Provider<OfficialQuestionSource>((ref) {
  return const OfficialQuestionLoader();
});

final currentDateTimeProvider = Provider<DateTime Function()>((ref) {
  return DateTime.now;
});

final localProfileControllerProvider = Provider<LocalProfileController>((ref) {
  return LocalProfileController(
    localDataStore: ref.watch(localDataStoreProvider),
    now: ref.watch(currentDateTimeProvider),
  );
});

final localProfileProvider = FutureProvider<LocalUserProfile>((ref) {
  return ref.watch(localProfileControllerProvider).loadOrCreate();
});
