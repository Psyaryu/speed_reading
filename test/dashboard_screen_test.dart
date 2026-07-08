import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/main.dart';

void main() {
  testWidgets('dashboard exposes main app entry points', (tester) async {
    await tester.pumpWidget(const SpeedReadingApp());
    await tester.pumpAndSettle();

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Import Passage'), findsOneWidget);
    expect(find.text('Reader'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
