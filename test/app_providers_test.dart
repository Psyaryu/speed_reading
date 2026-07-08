import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/settings/domain/local_user_profile.dart';

void main() {
  test('local data store provider can be backed by test database', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(database.close);

    final store = container.read(localDataStoreProvider);
    await store.saveProfile(
      LocalUserProfile.initial(
        id: 'local',
        createdAt: DateTime.utc(2026, 7, 7),
      ),
    );

    final profile = await store.loadProfile();
    expect(profile?.id, 'local');
  });
}

