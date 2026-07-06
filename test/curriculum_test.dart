import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/training/domain/curriculum.dart';

void main() {
  test('covers required PRD learning concepts', () {
    final ids = Curriculum.modules.map((module) => module.id).toSet();

    expect(ids, contains('baseline'));
    expect(ids, contains('pacing'));
    expect(ids, contains('chunking'));
    expect(ids, contains('regression-control'));
    expect(ids, contains('subvocalization-awareness'));
    expect(ids, contains('skimming'));
    expect(ids, contains('scanning'));
    expect(ids, contains('rsvp'));
    expect(ids, contains('vocabulary-familiarity'));
  });

  test('unlocks modules by level', () {
    final levelOne = Curriculum.unlockedForLevel(1);
    final levelFour = Curriculum.unlockedForLevel(4);

    expect(levelOne.map((module) => module.id), contains('baseline'));
    expect(levelOne.map((module) => module.id), isNot(contains('rsvp')));
    expect(levelFour.map((module) => module.id), contains('rsvp'));
  });
}
