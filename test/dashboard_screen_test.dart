import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/main.dart';
import 'package:speed_reading/settings/domain/local_user_profile.dart';

void main() {
  testWidgets('dashboard exposes main app entry points', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
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
    await tester.pumpAndSettle();

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Import Passage'), findsOneWidget);
    expect(find.text('Reader'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('dashboard shows initialized local profile', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
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
    await tester.pumpAndSettle();

    expect(find.text('Local profile ready • 1 goal selected'), findsOneWidget);
  });
}
