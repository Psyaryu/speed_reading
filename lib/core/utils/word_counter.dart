class WordCounter {
  const WordCounter._();

  static final RegExp _wordPattern = RegExp(
    r"[A-Za-z0-9]+(?:[-'][A-Za-z0-9]+)*",
  );

  static int count(String text) {
    return _wordPattern.allMatches(text).length;
  }
}

