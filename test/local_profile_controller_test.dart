import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/providers/app_providers.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        currentDateTimeProvider.overrideWithValue(
          () => DateTime.utc(2026, 7, 7),
        ),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  test('creates local profile when none exists', () async {
    final controller = container.read(localProfileControllerProvider);

    final profile = await controller.loadOrCreate();

    expect(profile.id, 'local');
    expect(profile.createdAt, DateTime.utc(2026, 7, 7));
    expect(await container.read(localDataStoreProvider).loadProfile(), isNotNull);
  });

  test('returns existing profile instead of replacing it', () async {
    final controller = container.read(localProfileControllerProvider);
    final first = await controller.loadOrCreate();
    final second = await controller.loadOrCreate();

    expect(second.createdAt.isAtSameMomentAs(first.createdAt), isTrue);
  });

  test('local profile provider exposes initialized profile', () async {
    final profile = await container.read(localProfileProvider.future);

    expect(profile.id, 'local');
  });
}
