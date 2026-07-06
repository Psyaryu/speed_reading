import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/assessment/domain/question_count_policy.dart';

void main() {
  test('returns zero for empty passages', () {
    expect(QuestionCountPolicy.countForWordCount(0), 0);
  });

  test('uses five questions for short passages', () {
    expect(QuestionCountPolicy.countForWordCount(599), 5);
  });

  test('uses ten questions for certification-length passages', () {
    expect(QuestionCountPolicy.countForWordCount(600), 10);
    expect(QuestionCountPolicy.countForWordCount(1199), 10);
  });

  test('uses fifteen questions for long passages', () {
    expect(QuestionCountPolicy.countForWordCount(1200), 15);
    expect(QuestionCountPolicy.countForWordCount(2399), 15);
  });

  test('caps at twenty questions for very long passages', () {
    expect(QuestionCountPolicy.countForWordCount(2400), 20);
  });
}

