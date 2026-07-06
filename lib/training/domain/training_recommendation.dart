enum TrainingDrill {
  pacedReading,
  chunking,
  regressionControl,
  subvocalizationAwareness,
  skimming,
  scanning,
  rsvp,
  comprehensionReview,
  nonRsvpTransfer,
}

class TrainingRecommendationInput {
  const TrainingRecommendationInput({
    required this.recentComprehension,
    required this.wpmPlateaued,
    required this.detailRecallWeak,
    required this.scanningAccuracy,
    required this.rsvpOnlyProgress,
  });

  final double recentComprehension;
  final bool wpmPlateaued;
  final bool detailRecallWeak;
  final double scanningAccuracy;
  final bool rsvpOnlyProgress;
}

class TrainingRecommendationEngine {
  const TrainingRecommendationEngine._();

  static TrainingDrill recommend(TrainingRecommendationInput input) {
    if (input.recentComprehension < 0.7 || input.detailRecallWeak) {
      return TrainingDrill.comprehensionReview;
    }
    if (input.rsvpOnlyProgress) {
      return TrainingDrill.nonRsvpTransfer;
    }
    if (input.scanningAccuracy < 0.8) {
      return TrainingDrill.scanning;
    }
    if (input.wpmPlateaued) {
      return TrainingDrill.chunking;
    }
    return TrainingDrill.pacedReading;
  }
}

