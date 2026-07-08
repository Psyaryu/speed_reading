import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/settings/presentation/settings_screen.dart';

void main() {
  testWidgets('saves local reading preferences', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          currentDateTimeProvider.overrideWithValue(
            () => DateTime.utc(2026, 7, 8),
          ),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );

    await tester.pumpAndSettle();

    final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
    sliders[0].onChanged?.call(24);
    sliders[1].onChanged?.call(1.8);
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();

    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings saved.'), findsOneWidget);

    final profile = await database.select(database.localProfiles).getSingle();
    expect(profile.preferredFontSize, 24);
    expect(profile.preferredLineHeight, 1.8);
    expect(profile.reducedMotion, isTrue);
  });
}
