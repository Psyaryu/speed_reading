import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/progress/domain/shareable_progress_summary.dart';

void main() {
  test('formats public progress summary', () {
    const summary = ShareableProgressSummary(
      levelName: 'Fast Reader',
      effectiveReadingScore: 512.4,
      qualifiedWpm: 640,
      comprehensionScore: 0.8,
      streakDays: 7,
      certificationStatus: 'Not certified yet',
    );

    final text = summary.toShareText();

    expect(text, contains('Fast Reader'));
    expect(text, contains('640 WPM'));
    expect(text, contains('80% comprehension'));
    expect(text, contains('7 day streak'));
  });

  test('does not include passage text', () {
    const summary = ShareableProgressSummary(
      levelName: 'Rapid Reader',
      effectiveReadingScore: 650,
      qualifiedWpm: 800,
      comprehensionScore: 0.75,
      streakDays: 3,
      certificationStatus: 'Certified',
    );

    expect(summary.toShareText(), isNot(contains('passage')));
  });
}

