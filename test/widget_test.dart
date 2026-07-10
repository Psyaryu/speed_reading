import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/main.dart';
import 'package:speed_reading/settings/domain/local_user_profile.dart';

void main() {
  testWidgets('renders dashboard placeholder', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          localProfileProvider.overrideWith((ref) async {
            return LocalUserProfile.initial(
              id: 'local',
              createdAt: DateTime.utc(2026, 7, 7),
            );
          }),
        ],
        child: const SpeedReadingApp(),
      ),
    );

    expect(find.text('Dashboard'), findsOneWidget);
    expect(
      find.text('Comprehension-first speed reading practice starts here.'),
      findsOneWidget,
    );
  });

  testWidgets('applies persisted theme mode to MaterialApp', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          localProfileProvider.overrideWith((ref) async {
            return LocalUserProfile.initial(
              id: 'local',
              createdAt: DateTime.utc(2026, 7, 7),
            ).copyWith(preferredThemeMode: LocalThemeMode.dark);
          }),
        ],
        child: const SpeedReadingApp(),
      ),
    );
    await tester.pump();
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
  });

  testWidgets('applies expanded neon theme preset to MaterialApp', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          localProfileProvider.overrideWith((ref) async {
            return LocalUserProfile.initial(
              id: 'local',
              createdAt: DateTime.utc(2026, 7, 10),
            ).copyWith(preferredThemeMode: LocalThemeMode.gxCrimson);
          }),
        ],
        child: const SpeedReadingApp(),
      ),
    );
    await tester.pump();
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.light);
    expect(app.theme?.colorScheme.primary, const Color(0xFFFF2A6D));
    expect(app.theme?.scaffoldBackgroundColor, const Color(0xFF0D080C));
  });

  testWidgets('defines distinct app-wide light and dark theme surfaces', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          localProfileProvider.overrideWith((ref) async {
            return LocalUserProfile.initial(
              id: 'local',
              createdAt: DateTime.utc(2026, 7, 7),
            );
          }),
        ],
        child: const SpeedReadingApp(),
      ),
    );
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(
      app.theme?.scaffoldBackgroundColor,
      isNot(app.darkTheme?.scaffoldBackgroundColor),
    );
    expect(
      app.theme?.appBarTheme.backgroundColor,
      isNot(app.darkTheme?.appBarTheme.backgroundColor),
    );
    expect(app.theme?.cardTheme.color, isNot(app.darkTheme?.cardTheme.color));
  });

  testWidgets('applies reduced motion preference to MediaQuery', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          localProfileProvider.overrideWith((ref) async {
            return LocalUserProfile.initial(
              id: 'local',
              createdAt: DateTime.utc(2026, 7, 8),
            ).copyWith(reducedMotion: true);
          }),
        ],
        child: const SpeedReadingApp(),
      ),
    );
    await tester.pump();
    await tester.pump();

    final context = tester.element(find.text('Dashboard'));
    expect(MediaQuery.of(context).disableAnimations, isTrue);
  });
}
