class RsvpToken {
  const RsvpToken({
    required this.text,
    required this.duration,
  });

  final String text;
  final Duration duration;
}

class RsvpTiming {
  const RsvpTiming._();

  static final RegExp _tokenPattern = RegExp(
    r"[A-Za-z0-9]+(?:[-'][A-Za-z0-9]+)*|[^\s]",
  );

  static List<String> tokenize(String text) {
    return _tokenPattern
        .allMatches(text)
        .map((match) => match.group(0)!)
        .toList(growable: false);
  }

  static List<RsvpToken> schedule({
    required String text,
    required int wordsPerMinute,
  }) {
    if (wordsPerMinute <= 0) {
      throw ArgumentError.value(wordsPerMinute, 'wordsPerMinute');
    }

    final baseWordMs = (60000 / wordsPerMinute).round();
    return tokenize(text).map((token) {
      return RsvpToken(
        text: token,
        duration: Duration(milliseconds: _durationMs(token, baseWordMs)),
      );
    }).toList(growable: false);
  }

  static List<RsvpToken> schedulePhrases({
    required String text,
    required int wordsPerMinute,
    int wordsPerPhrase = 3,
  }) {
    if (wordsPerPhrase <= 0) {
      throw ArgumentError.value(wordsPerPhrase, 'wordsPerPhrase');
    }

    final tokens = schedule(text: text, wordsPerMinute: wordsPerMinute);
    final phrases = <RsvpToken>[];
    final buffer = <RsvpToken>[];
    var wordCount = 0;

    for (final token in tokens) {
      buffer.add(token);
      if (!_isPunctuation(token.text)) {
        wordCount += 1;
      }

      if (_isSentenceBoundary(token.text) || wordCount >= wordsPerPhrase) {
        phrases.add(_phraseFrom(buffer));
        buffer.clear();
        wordCount = 0;
      }
    }

    if (buffer.isNotEmpty) {
      phrases.add(_phraseFrom(buffer));
    }

    return phrases;
  }

  static RsvpToken _phraseFrom(List<RsvpToken> tokens) {
    final text = StringBuffer();
    var duration = Duration.zero;

    for (final token in tokens) {
      duration += token.duration;
      if (_isPunctuation(token.text)) {
        text.write(token.text);
      } else {
        if (text.isNotEmpty) {
          text.write(' ');
        }
        text.write(token.text);
      }
    }

    return RsvpToken(text: text.toString(), duration: duration);
  }

  static int _durationMs(String token, int baseWordMs) {
    if (_isSentenceBoundary(token)) {
      return (baseWordMs * 1.8).round();
    }
    if (_isPunctuation(token)) {
      return (baseWordMs * 1.3).round();
    }
    return baseWordMs;
  }

  static bool _isSentenceBoundary(String token) {
    return token == '.' || token == '!' || token == '?';
  }

  static bool _isPunctuation(String token) {
    return token.length == 1 && !RegExp(r'[A-Za-z0-9]').hasMatch(token);
  }
}
