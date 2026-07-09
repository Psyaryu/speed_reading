import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/settings/domain/local_user_profile.dart';

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
    expect(
        await container.read(localDataStoreProvider).loadProfile(), isNotNull);
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

  test('updates reading preferences on local profile', () async {
    final controller = container.read(localProfileControllerProvider);

    final updated = await controller.updateReadingPreferences(
      preferredFontSize: 24,
      preferredLineHeight: 1.8,
      preferredColumnWidth: 820,
      preferredThemeMode: LocalThemeMode.dark,
      reducedMotion: true,
    );

    expect(updated.preferredFontSize, 24);
    expect(updated.preferredLineHeight, 1.8);
    expect(updated.preferredColumnWidth, 820);
    expect(updated.preferredThemeMode, LocalThemeMode.dark);
    expect(updated.reducedMotion, isTrue);

    final stored = await container.read(localDataStoreProvider).loadProfile();
    expect(stored?.preferredFontSize, 24);
    expect(stored?.preferredLineHeight, 1.8);
    expect(stored?.preferredColumnWidth, 820);
    expect(stored?.preferredThemeMode, LocalThemeMode.dark);
    expect(stored?.reducedMotion, isTrue);
  });

  test('updates onboarding goals and preferences', () async {
    final controller = container.read(localProfileControllerProvider);

    final updated = await controller.updateOnboarding(
      goals: const [TrainingGoal.school, TrainingGoal.exam],
      preferredFontSize: 22,
      reducedMotion: true,
    );

    expect(updated.goals, [TrainingGoal.school, TrainingGoal.exam]);
    expect(updated.preferredFontSize, 22);
    expect(updated.reducedMotion, isTrue);
  });
}
