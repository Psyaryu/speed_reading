import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../content/data/default_passage_repository.dart';
import '../../content/data/official_passage_loader.dart';
import '../../content/data/passage_repository.dart';
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
