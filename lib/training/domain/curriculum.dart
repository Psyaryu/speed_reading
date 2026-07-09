import 'training_recommendation.dart';

class CurriculumModule {
  const CurriculumModule({
    required this.id,
    required this.title,
    required this.lessonOrder,
    required this.conceptSummary,
    required this.rapidReadingGuidance,
    required this.drills,
    required this.unlockCriteria,
  });

  final String id;
  final String title;
  final int lessonOrder;
  final String conceptSummary;
  final String rapidReadingGuidance;
  final List<TrainingDrill> drills;
  final CurriculumUnlockCriteria unlockCriteria;
}

class CurriculumUnlockCriteria {
  const CurriculumUnlockCriteria({
    required this.minimumLevel,
    required this.description,
  });

  final int minimumLevel;
  final String description;
}

class TrainingDrillTemplate {
  const TrainingDrillTemplate({
    required this.drill,
    required this.title,
    required this.durationMinutes,
    required this.coreConcepts,
    required this.instructions,
  });

  final TrainingDrill drill;
  final String title;
  final int durationMinutes;
  final List<String> coreConcepts;
  final List<String> instructions;
}

class DailyTrainingPlan {
  const DailyTrainingPlan({required this.steps});

  final List<DailyTrainingStep> steps;

  int get totalMinutes {
    return steps.fold(0, (sum, step) => sum + step.durationMinutes);
  }
}

class DailyTrainingStep {
  const DailyTrainingStep({
    required this.title,
    required this.durationMinutes,
    required this.drill,
  });

  final String title;
  final int durationMinutes;
  final TrainingDrill drill;
}

class Curriculum {
  const Curriculum._();

  static const modules = [
    CurriculumModule(
      id: 'baseline',
      title: 'Baseline Reading',
      lessonOrder: 1,
      conceptSummary: 'Establish comfortable WPM, comprehension, recall, '
          'focus, and difficulty tolerance.',
      rapidReadingGuidance: 'Use baseline results to choose when speed work is '
          'appropriate and when deep reading is still the better mode.',
      drills: [TrainingDrill.pacedReading, TrainingDrill.comprehensionReview],
      unlockCriteria: CurriculumUnlockCriteria(
        minimumLevel: 1,
        description: 'Available immediately for initial calibration.',
      ),
    ),
    CurriculumModule(
      id: 'pacing',
      title: 'Pacing',
      lessonOrder: 2,
      conceptSummary: 'Build steady movement through text with guided targets, '
          'timed windows, and comprehension checks.',
      rapidReadingGuidance: 'Use rapid pacing for familiar or survey reading; '
          'slow down when comprehension falls below 70%.',
      drills: [TrainingDrill.pacedReading],
      unlockCriteria: CurriculumUnlockCriteria(
        minimumLevel: 1,
        description: 'Available after baseline so targets can be calibrated.',
      ),
    ),
    CurriculumModule(
      id: 'chunking',
      title: 'Chunking',
      lessonOrder: 3,
      conceptSummary: 'Practice two-word, three-word, and phrase groups to '
          'expand useful fixation span.',
      rapidReadingGuidance: 'Chunk familiar phrases for speed, but return to '
          'deep reading for dense claims or unfamiliar syntax.',
      drills: [TrainingDrill.chunking],
      unlockCriteria: CurriculumUnlockCriteria(
        minimumLevel: 2,
        description: 'Unlocks when early pacing work is stable.',
      ),
    ),
    CurriculumModule(
      id: 'regression-control',
      title: 'Regression Control',
      lessonOrder: 4,
      conceptSummary: 'Reduce unnecessary rereading while preserving '
          'intentional rereading for comprehension.',
      rapidReadingGuidance: 'Use forward-only practice for training; reread '
          'deliberately when accuracy or confidence drops.',
      drills: [TrainingDrill.regressionControl],
      unlockCriteria: CurriculumUnlockCriteria(
        minimumLevel: 2,
        description: 'Unlocks once the user can complete basic paced sessions.',
      ),
    ),
    CurriculumModule(
      id: 'subvocalization-awareness',
      title: 'Subvocalization Awareness',
      lessonOrder: 5,
      conceptSummary: 'Notice when inner speech helps comprehension and when '
          'it slows simple or familiar text.',
      rapidReadingGuidance: 'Do not eliminate subvocalization universally; use '
          'lighter inner speech only when the text supports it.',
      drills: [TrainingDrill.subvocalizationAwareness],
      unlockCriteria: CurriculumUnlockCriteria(
        minimumLevel: 3,
        description: 'Unlocks after chunking and regression-control practice.',
      ),
    ),
    CurriculumModule(
      id: 'skimming',
      title: 'Skimming',
      lessonOrder: 6,
      conceptSummary: 'Extract structure and gist through headings, opening '
          'sentences, previews, and key idea checks.',
      rapidReadingGuidance: 'Skim for triage and gist, not for full retention '
          'or high-stakes detail recall.',
      drills: [TrainingDrill.skimming],
      unlockCriteria: CurriculumUnlockCriteria(
        minimumLevel: 3,
        description: 'Unlocks after foundational accuracy is established.',
      ),
    ),
    CurriculumModule(
      id: 'scanning',
      title: 'Scanning',
      lessonOrder: 7,
      conceptSummary: 'Find dates, numbers, names, claims, and other specific '
          'targets quickly in distractor-heavy text.',
      rapidReadingGuidance: 'Scan when the question is specific; switch to '
          'deep reading around the located answer if context matters.',
      drills: [TrainingDrill.scanning],
      unlockCriteria: CurriculumUnlockCriteria(
        minimumLevel: 3,
        description: 'Unlocks with skimming as a complementary search skill.',
      ),
    ),
    CurriculumModule(
      id: 'rsvp',
      title: 'RSVP Practice',
      lessonOrder: 8,
      conceptSummary: 'Use controlled word or phrase flow to experience faster '
          'presentation with punctuation-aware pauses.',
      rapidReadingGuidance: 'Treat RSVP as practice, then verify transfer with '
          'non-RSVP attempts before certification progress.',
      drills: [TrainingDrill.rsvp, TrainingDrill.nonRsvpTransfer],
      unlockCriteria: CurriculumUnlockCriteria(
        minimumLevel: 4,
        description: 'Unlocks after core text-navigation skills are available.',
      ),
    ),
    CurriculumModule(
      id: 'vocabulary-familiarity',
      title: 'Vocabulary and Familiarity',
      lessonOrder: 9,
      conceptSummary: 'Build word knowledge, topic familiarity, and difficulty '
          'tolerance through review and topic-based practice.',
      rapidReadingGuidance: 'Rapid reading works best with familiar vocabulary; '
          'slow down and capture unknown words when density rises.',
      drills: [TrainingDrill.comprehensionReview],
      unlockCriteria: CurriculumUnlockCriteria(
        minimumLevel: 2,
        description: 'Unlocks early because vocabulary affects every mode.',
      ),
    ),
  ];

  static const drillTemplates = [
    TrainingDrillTemplate(
      drill: TrainingDrill.pacedReading,
      title: 'Paced reading',
      durationMinutes: 8,
      coreConcepts: ['pacing', 'comprehension'],
      instructions: [
        'Read with a steady WPM target.',
        'Check comprehension immediately after the passage.',
      ],
    ),
    TrainingDrillTemplate(
      drill: TrainingDrill.chunking,
      title: 'Chunking',
      durationMinutes: 8,
      coreConcepts: ['chunking', 'fixation span'],
      instructions: [
        'Practice two-word, three-word, and phrase groups.',
        'Increase line width only when accuracy stays above threshold.',
      ],
    ),
    TrainingDrillTemplate(
      drill: TrainingDrill.regressionControl,
      title: 'Regression control',
      durationMinutes: 8,
      coreConcepts: ['regression control', 'confidence'],
      instructions: [
        'Use forward-only reading during the timed window.',
        'Tag uncertainty for delayed review instead of immediate rereading.',
      ],
    ),
    TrainingDrillTemplate(
      drill: TrainingDrill.subvocalizationAwareness,
      title: 'Subvocalization awareness',
      durationMinutes: 8,
      coreConcepts: ['subvocalization', 'mode selection'],
      instructions: [
        'Compare deep reading with rapid reading on familiar text.',
        'Notice when inner speech helps comprehension.',
      ],
    ),
    TrainingDrillTemplate(
      drill: TrainingDrill.skimming,
      title: 'Skimming',
      durationMinutes: 8,
      coreConcepts: ['skimming', 'gist recall'],
      instructions: [
        'Preview structure before reading details.',
        'Select the main idea and confirm gist accuracy.',
      ],
    ),
    TrainingDrillTemplate(
      drill: TrainingDrill.scanning,
      title: 'Scanning',
      durationMinutes: 8,
      coreConcepts: ['scanning', 'target search'],
      instructions: [
        'Search for a specific date, number, name, or claim.',
        'Score both accuracy and time.',
      ],
    ),
    TrainingDrillTemplate(
      drill: TrainingDrill.rsvp,
      title: 'RSVP practice',
      durationMinutes: 8,
      coreConcepts: ['rsvp', 'comprehension'],
      instructions: [
        'Use word or phrase presentation with punctuation-aware pauses.',
        'Pause and resume intentionally; avoid qualifying over-paused attempts.',
      ],
    ),
    TrainingDrillTemplate(
      drill: TrainingDrill.comprehensionReview,
      title: 'Comprehension review',
      durationMinutes: 8,
      coreConcepts: ['main idea', 'detail recall', 'inference', 'vocabulary'],
      instructions: [
        'Review missed questions by skill category.',
        'Capture unfamiliar words and revisit the passage context.',
      ],
    ),
    TrainingDrillTemplate(
      drill: TrainingDrill.nonRsvpTransfer,
      title: 'Non-RSVP transfer',
      durationMinutes: 8,
      coreConcepts: ['paced reading', 'rsvp transfer'],
      instructions: [
        'Repeat a speed target outside RSVP mode.',
        'Require comprehension above 70% before treating gains as durable.',
      ],
    ),
  ];

  static List<CurriculumModule> unlockedForLevel(int level) {
    return modules
        .where((module) => module.unlockCriteria.minimumLevel <= level)
        .toList(growable: false);
  }

  static List<CurriculumModule> get lessonOrder {
    return [...modules]
      ..sort((a, b) => a.lessonOrder.compareTo(b.lessonOrder));
  }

  static TrainingDrillTemplate templateFor(TrainingDrill drill) {
    return drillTemplates.firstWhere((template) => template.drill == drill);
  }

  static DailyTrainingPlan generateDailyPlan({
    required int level,
    required TrainingDrill recommendedDrill,
  }) {
    final unlockedDrills = unlockedForLevel(level)
        .expand((module) => module.drills)
        .toSet();
    final primaryDrill = unlockedDrills.contains(recommendedDrill)
        ? recommendedDrill
        : TrainingDrill.pacedReading;
    final template = templateFor(primaryDrill);

    return DailyTrainingPlan(
      steps: [
        const DailyTrainingStep(
          title: 'Warm up with calibrated pacing',
          durationMinutes: 4,
          drill: TrainingDrill.pacedReading,
        ),
        DailyTrainingStep(
          title: template.title,
          durationMinutes: template.durationMinutes,
          drill: template.drill,
        ),
        const DailyTrainingStep(
          title: 'Finish with comprehension review',
          durationMinutes: 4,
          drill: TrainingDrill.comprehensionReview,
        ),
      ],
    );
  }
}
