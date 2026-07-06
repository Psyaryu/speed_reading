import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/training/domain/training_recommendation.dart';

void main() {
  test('prioritizes comprehension when below threshold', () {
    expect(
      TrainingRecommendationEngine.recommend(
        const TrainingRecommendationInput(
          recentComprehension: 0.69,
          wpmPlateaued: true,
          detailRecallWeak: false,
          scanningAccuracy: 1,
          rsvpOnlyProgress: true,
        ),
      ),
      TrainingDrill.comprehensionReview,
    );
  });

  test('recommends non-RSVP transfer for RSVP-only progress', () {
    expect(
      TrainingRecommendationEngine.recommend(
        const TrainingRecommendationInput(
          recentComprehension: 0.8,
          wpmPlateaued: false,
          detailRecallWeak: false,
          scanningAccuracy: 1,
          rsvpOnlyProgress: true,
        ),
      ),
      TrainingDrill.nonRsvpTransfer,
    );
  });

  test('recommends scanning when accuracy is weak', () {
    expect(
      TrainingRecommendationEngine.recommend(
        const TrainingRecommendationInput(
          recentComprehension: 0.8,
          wpmPlateaued: false,
          detailRecallWeak: false,
          scanningAccuracy: 0.79,
          rsvpOnlyProgress: false,
        ),
      ),
      TrainingDrill.scanning,
    );
  });

  test('recommends chunking when WPM plateaus', () {
    expect(
      TrainingRecommendationEngine.recommend(
        const TrainingRecommendationInput(
          recentComprehension: 0.8,
          wpmPlateaued: true,
          detailRecallWeak: false,
          scanningAccuracy: 1,
          rsvpOnlyProgress: false,
        ),
      ),
      TrainingDrill.chunking,
    );
  });
}

