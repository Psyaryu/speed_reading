import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/training/domain/curriculum.dart';
import 'package:speed_reading/training/domain/training_recommendation.dart';

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

  test('defines lesson order for every module', () {
    final orderedModules = Curriculum.lessonOrder;

    expect(orderedModules.first.id, 'baseline');
    expect(orderedModules.last.id, 'vocabulary-familiarity');
    expect(
      orderedModules.map((module) => module.lessonOrder),
      orderedEquals(List.generate(orderedModules.length, (index) => index + 1)),
    );
  });

  test('defines guidance about rapid reading versus deep reading', () {
    for (final module in Curriculum.modules) {
      expect(module.conceptSummary, isNotEmpty);
      expect(module.rapidReadingGuidance, isNotEmpty);
    }
  });

  test('unlocks modules by level', () {
    final levelOne = Curriculum.unlockedForLevel(1);
    final levelFour = Curriculum.unlockedForLevel(4);

    expect(levelOne.map((module) => module.id), contains('baseline'));
    expect(levelOne.map((module) => module.id), isNot(contains('rsvp')));
    expect(levelFour.map((module) => module.id), contains('rsvp'));
    expect(
      Curriculum.modules.map((module) => module.unlockCriteria.description),
      everyElement(isNotEmpty),
    );
  });

  test('defines drill templates for every adaptive recommendation drill', () {
    final templateDrills = Curriculum.drillTemplates
        .map((template) => template.drill)
        .toSet();

    expect(templateDrills, TrainingDrill.values.toSet());
    for (final template in Curriculum.drillTemplates) {
      expect(template.durationMinutes, inInclusiveRange(1, 20));
      expect(template.coreConcepts, isNotEmpty);
      expect(template.instructions, isNotEmpty);
    }
  });

  test('generates a 10 to 20 minute daily plan from a recommendation', () {
    final plan = Curriculum.generateDailyPlan(
      level: 3,
      recommendedDrill: TrainingDrill.scanning,
    );

    expect(plan.totalMinutes, inInclusiveRange(10, 20));
    expect(
      plan.steps.map((step) => step.drill),
      orderedEquals([
        TrainingDrill.pacedReading,
        TrainingDrill.scanning,
        TrainingDrill.comprehensionReview,
      ]),
    );
  });

  test('falls back to paced reading when recommendation is still locked', () {
    final plan = Curriculum.generateDailyPlan(
      level: 1,
      recommendedDrill: TrainingDrill.rsvp,
    );

    expect(plan.totalMinutes, inInclusiveRange(10, 20));
    expect(plan.steps[1].drill, TrainingDrill.pacedReading);
  });
}
