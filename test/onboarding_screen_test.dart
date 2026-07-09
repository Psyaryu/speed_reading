import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_reading/core/data/app_database.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/training/presentation/onboarding_screen.dart';

void main() {
  testWidgets('saves onboarding choices and opens dashboard', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/',
          name: 'dashboard',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Dashboard Route')),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          currentDateTimeProvider.overrideWithValue(
            () => DateTime.utc(2026, 7, 8),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('School'));
    await tester.tap(find.text('Exam'));
    await tester.scrollUntilVisible(find.text('Reduced Motion'), 300);
    await tester.tap(find.text('Reduced Motion'));
    await tester.pump();
    await tester.scrollUntilVisible(find.text('Start Training'), 300);
    await tester.tap(find.text('Start Training'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard Route'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.text('Dashboard Route')),
    );
    final profile = await container.read(localDataStoreProvider).loadProfile();

    expect(profile?.goals, contains(TrainingGoal.school));
    expect(profile?.goals, contains(TrainingGoal.exam));
    expect(profile?.reducedMotion, isTrue);
  });
}
