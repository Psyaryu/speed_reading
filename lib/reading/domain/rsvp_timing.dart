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

