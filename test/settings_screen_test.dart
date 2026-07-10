import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/domain/imported_passage_factory.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/reading/domain/reading_session.dart';
import 'package:speed_reading/settings/domain/local_user_profile.dart';
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
    sliders[2].onChanged?.call(820);
    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Electric Cyan').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();

    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings saved.'), findsOneWidget);

    final profile = await database.select(database.localProfiles).getSingle();
    expect(profile.preferredFontSize, 24);
    expect(profile.preferredLineHeight, 1.8);
    expect(profile.preferredColumnWidth, 820);
    expect(profile.preferredThemeMode, LocalThemeMode.electricCyan.name);
    expect(profile.reducedMotion, isTrue);
  });

  testWidgets('resets progress only after confirmation', (tester) async {
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

    final store = ProviderScope.containerOf(
      tester.element(find.byType(SettingsScreen)),
    ).read(localDataStoreProvider);
    await store.saveImportedPassage(
      ImportedPassageFactory.create(
        id: 'import-1',
        title: 'Saved Passage',
        body: 'This imported passage should stay on this device.',
      ),
    );
    await store.saveReadingSession(
      ReadingSession(
        id: 'session-1',
        passageId: 'import-1',
        mode: ReadingMode.manual,
        startedAt: DateTime.utc(2026, 7, 8),
        activeReadingSeconds: 60,
        wordCount: 800,
        status: AttemptQualificationStatus.qualified,
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Reset Progress'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView), const Offset(0, -80));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset Progress'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(await store.loadReadingSessions(), hasLength(1));

    await tester.scrollUntilVisible(
      find.text('Reset Progress'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(find.byType(ListView), const Offset(0, -80));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset Progress'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(find.text('Progress reset.'), findsOneWidget);
    expect(await store.loadReadingSessions(), isEmpty);
    expect(await store.loadPassages(), hasLength(1));
    expect((await store.loadPassages()).single.id, 'import-1');
  });

  testWidgets('shows JSON and CSV export previews', (tester) async {
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

    final store = ProviderScope.containerOf(
      tester.element(find.byType(SettingsScreen)),
    ).read(localDataStoreProvider);
    await store.saveReadingSession(
      ReadingSession(
        id: 'session-1',
        passageId: 'passage-1',
        mode: ReadingMode.manual,
        startedAt: DateTime.utc(2026, 7, 8),
        activeReadingSeconds: 60,
        wordCount: 800,
        status: AttemptQualificationStatus.qualified,
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Export JSON'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Export JSON'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Export Preview'));
    expect(find.text('Export Preview'), findsOneWidget);
    expect(find.text('Share Export'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    final jsonPreview = tester.widget<SelectableText>(
      find.byKey(const ValueKey('settings-export-preview-text')),
    );
    expect(jsonPreview.data, contains('"sessions"'));
    expect(jsonPreview.data, contains('session-1'));

    await tester.scrollUntilVisible(
      find.text('Export CSV'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Export CSV'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    final csvPreview = tester.widget<SelectableText>(
      find.byKey(const ValueKey('settings-export-preview-text')),
    );
    expect(csvPreview.data, contains('id,passageId,mode'));
    expect(csvPreview.data, contains('session-1,passage-1,manual'));
  });
}
