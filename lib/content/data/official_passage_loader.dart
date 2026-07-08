import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/passage.dart';

abstract interface class OfficialPassageSource {
  Future<List<Passage>> load();
}

class OfficialPassageLoader implements OfficialPassageSource {
  const OfficialPassageLoader({
    this.assetPath = 'assets/passages/official_passages.json',
  });

  final String assetPath;

  @override
  Future<List<Passage>> load() async {
    final rawJson = await rootBundle.loadString(assetPath);
    return parse(rawJson);
  }

  List<Passage> parse(String rawJson) {
    final decoded = jsonDecode(rawJson) as List<Object?>;
    return decoded
        .map((item) => Passage.fromJson(item as Map<String, Object?>))
        .toList(growable: false);
  }
}
