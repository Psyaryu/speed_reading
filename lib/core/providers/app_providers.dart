import 'package:flutter_riverpod/flutter_riverpod.dart';

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

