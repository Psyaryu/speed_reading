import 'training_recommendation.dart';

class CurriculumModule {
  const CurriculumModule({
    required this.id,
    required this.title,
    required this.drills,
    required this.unlockLevel,
  });

  final String id;
  final String title;
  final List<TrainingDrill> drills;
  final int unlockLevel;
}

class Curriculum {
  const Curriculum._();

  static const modules = [
    CurriculumModule(
      id: 'baseline',
      title: 'Baseline Reading',
      drills: [TrainingDrill.pacedReading, TrainingDrill.comprehensionReview],
      unlockLevel: 1,
    ),
    CurriculumModule(
      id: 'pacing',
      title: 'Pacing',
      drills: [TrainingDrill.pacedReading],
      unlockLevel: 1,
    ),
    CurriculumModule(
      id: 'chunking',
      title: 'Chunking',
      drills: [TrainingDrill.chunking],
      unlockLevel: 2,
    ),
    CurriculumModule(
      id: 'regression-control',
      title: 'Regression Control',
      drills: [TrainingDrill.regressionControl],
      unlockLevel: 2,
    ),
    CurriculumModule(
      id: 'subvocalization-awareness',
      title: 'Subvocalization Awareness',
      drills: [TrainingDrill.subvocalizationAwareness],
      unlockLevel: 3,
    ),
    CurriculumModule(
      id: 'skimming',
      title: 'Skimming',
      drills: [TrainingDrill.skimming],
      unlockLevel: 3,
    ),
    CurriculumModule(
      id: 'scanning',
      title: 'Scanning',
      drills: [TrainingDrill.scanning],
      unlockLevel: 3,
    ),
    CurriculumModule(
      id: 'rsvp',
      title: 'RSVP Practice',
      drills: [TrainingDrill.rsvp, TrainingDrill.nonRsvpTransfer],
      unlockLevel: 4,
    ),
    CurriculumModule(
      id: 'vocabulary-familiarity',
      title: 'Vocabulary and Familiarity',
      drills: [TrainingDrill.comprehensionReview],
      unlockLevel: 2,
    ),
  ];

  static List<CurriculumModule> unlockedForLevel(int level) {
    return modules
        .where((module) => module.unlockLevel <= level)
        .toList(growable: false);
  }
}
