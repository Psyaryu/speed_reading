class QuestionCountPolicy {
  const QuestionCountPolicy._();

  static int countForWordCount(int wordCount) {
    if (wordCount <= 0) {
      return 0;
    }
    if (wordCount < 600) {
      return 5;
    }
    if (wordCount < 1200) {
      return 10;
    }
    if (wordCount < 2400) {
      return 15;
    }
    return 20;
  }
}

