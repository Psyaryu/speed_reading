import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/reading/domain/rsvp_timing.dart';

void main() {
  test('tokenizes words and punctuation', () {
    expect(
      RsvpTiming.tokenize("Run, don't stop."),
      ['Run', ',', "don't", 'stop', '.'],
    );
  });

  test('schedules base word timing from WPM', () {
    final tokens = RsvpTiming.schedule(
      text: 'Run fast',
      wordsPerMinute: 600,
    );

    expect(tokens.first.duration, const Duration(milliseconds: 100));
  });

  test('adds longer pauses for punctuation and sentence boundaries', () {
    final tokens = RsvpTiming.schedule(
      text: 'Run, now.',
      wordsPerMinute: 600,
    );

    final comma = tokens.firstWhere((token) => token.text == ',');
    final period = tokens.firstWhere((token) => token.text == '.');

    expect(comma.duration, const Duration(milliseconds: 130));
    expect(period.duration, const Duration(milliseconds: 180));
  });

  test('schedules phrase chunks while preserving punctuation timing', () {
    final phrases = RsvpTiming.schedulePhrases(
      text: 'Run, now. Go fast.',
      wordsPerMinute: 600,
      wordsPerPhrase: 3,
    );

    expect(phrases.map((phrase) => phrase.text), [
      'Run, now.',
      'Go fast.',
    ]);
    expect(phrases.first.duration, const Duration(milliseconds: 510));
  });

  test('rejects non-positive WPM', () {
    expect(
      () => RsvpTiming.schedule(text: 'Run', wordsPerMinute: 0),
      throwsArgumentError,
    );
  });

  test('rejects non-positive phrase size', () {
    expect(
      () => RsvpTiming.schedulePhrases(
        text: 'Run',
        wordsPerMinute: 600,
        wordsPerPhrase: 0,
      ),
      throwsArgumentError,
    );
  });
}
