import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/main.dart';

void main() {
  testWidgets('renders dashboard placeholder', (tester) async {
    await tester.pumpWidget(const SpeedReadingApp());

    expect(find.text('Dashboard'), findsOneWidget);
    expect(
      find.text('Comprehension-first speed reading practice starts here.'),
      findsOneWidget,
    );
  });
}

