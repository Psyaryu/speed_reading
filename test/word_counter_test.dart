import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/utils/word_counter.dart';

void main() {
  test('counts plain words', () {
    expect(WordCounter.count('The signal fire burned bright.'), 5);
  });

  test('counts contractions and hyphenated words as single words', () {
    expect(WordCounter.count("Don't waste the moon-lit warning."), 5);
  });

  test('ignores surrounding punctuation and whitespace', () {
    expect(WordCounter.count('  Run. Hide? Read!  '), 3);
  });

  test('returns zero for empty text', () {
    expect(WordCounter.count(''), 0);
  });
}

