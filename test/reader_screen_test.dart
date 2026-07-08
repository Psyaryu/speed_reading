import 'dart:collection';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/content/domain/passage.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/reading/presentation/reader_screen.dart';

void main() {
  testWidgets('completes and saves a manual reading session', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final clock = _FakeClock([
      DateTime.utc(2026, 7, 7, 12),
      DateTime.utc(2026, 7, 7, 12, 1),
    ]);
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          currentDateTimeProvider.overrideWithValue(clock.call),
          readerSessionIdProvider.overrideWithValue(() => 'session-1'),
          readerPassagesProvider.overrideWith((ref) async => [
                _passage(),
              ]),
        ],
        child: const MaterialApp(home: ReaderScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Cliff Signal'), findsOneWidget);
    expect(find.textContaining('A flare tore through the fog'), findsOneWidget);

    await tester.tap(find.text('Start'));
    await tester.pump();

    expect(find.text('Reading session active.'), findsOneWidget);

    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    expect(find.text('WPM: 800'), findsOneWidget);

    final sessions = await database.select(database.readingSessionRecords).get();
    expect(sessions.single.id, 'session-1');
    expect(sessions.single.mode, ReadingMode.manual.name);
    expect(sessions.single.activeReadingSeconds, 60);
    expect(sessions.single.wordCount, 800);
  });

  testWidgets('shows empty state when no passages are available', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          readerPassagesProvider.overrideWith((ref) async => []),
        ],
        child: const MaterialApp(home: ReaderScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No passages available.'), findsOneWidget);
  });
}

Passage _passage() {
  return const Passage(
    id: 'passage-1',
    title: 'Cliff Signal',
    body: 'A flare tore through the fog while the runner climbed higher.',
    metadata: PassageMetadata(
      wordCount: 800,
      difficulty: PassageDifficulty.standard,
      topic: 'Adventure',
      source: PassageSource.official,
      license: 'Public Domain',
      type: PassageType.fiction,
      vocabularyDensity: 0.2,
      tags: ['adventure', 'danger'],
      isCertificationEligible: true,
      isMasteryEligible: true,
    ),
  );
}

class _FakeClock {
  _FakeClock(List<DateTime> times) : _times = Queue.of(times);

  final Queue<DateTime> _times;

  DateTime call() => _times.removeFirst();
}
