import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_reading/core/providers/app_providers.dart';
import 'package:speed_reading/main.dart';
import 'package:speed_reading/settings/domain/local_user_profile.dart';

void main() {
  testWidgets('renders dashboard placeholder', (tester) async {
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

    expect(find.text('Dashboard'), findsOneWidget);
    expect(
      find.text('Comprehension-first speed reading practice starts here.'),
      findsOneWidget,
    );
  });
}
