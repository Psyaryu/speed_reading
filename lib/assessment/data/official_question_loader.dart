import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/quiz.dart';

abstract interface class OfficialQuestionSource {
  Future<List<QuizQuestion>> load();
}

class OfficialQuestionLoader implements OfficialQuestionSource {
  const OfficialQuestionLoader({
    this.assetPath = 'assets/passages/official_questions.json',
  });

  final String assetPath;

  @override
  Future<List<QuizQuestion>> load() async {
    final rawJson = await rootBundle.loadString(assetPath);
    return parse(rawJson);
  }

  List<QuizQuestion> parse(String rawJson) {
    final decoded = jsonDecode(rawJson) as List<Object?>;
    return decoded
        .map((item) => QuizQuestion.fromJson(item as Map<String, Object?>))
        .toList(growable: false);
  }
}
