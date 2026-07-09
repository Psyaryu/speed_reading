import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/domain/reading_enums.dart';
import 'package:speed_reading/settings/domain/local_user_profile.dart';

void main() {
  test('creates default local-only profile', () {
    final profile = LocalUserProfile.initial(
      id: 'local',
      createdAt: DateTime.utc(2026, 7, 6),
    );

    expect(profile.goals, contains(TrainingGoal.generalImprovement));
    expect(profile.preferredFontSize, 18);
    expect(profile.preferredColumnWidth, 760);
    expect(profile.reducedMotion, isFalse);
  });

  test('serializes profile goals and baseline values', () {
    final profile = LocalUserProfile(
      id: 'local',
      createdAt: DateTime.utc(2026, 7, 6),
      goals: const [TrainingGoal.school, TrainingGoal.work],
      preferredFontSize: 20,
      preferredLineHeight: 1.6,
      preferredColumnWidth: 820,
      reducedMotion: true,
      baselineWpm: 260,
      baselineComprehension: 0.8,
    );

    final roundTrip = LocalUserProfile.fromJson(profile.toJson());

    expect(roundTrip.goals, [TrainingGoal.school, TrainingGoal.work]);
    expect(roundTrip.baselineWpm, 260);
    expect(roundTrip.baselineComprehension, 0.8);
    expect(roundTrip.preferredColumnWidth, 820);
    expect(roundTrip.reducedMotion, isTrue);
  });

  test('deserializes older profile JSON with default column width', () {
    final profile = LocalUserProfile.fromJson({
      'id': 'local',
      'createdAt': DateTime.utc(2026, 7, 6).toIso8601String(),
      'goals': [TrainingGoal.generalImprovement.name],
      'preferredFontSize': 18,
      'preferredLineHeight': 1.5,
      'reducedMotion': false,
      'baselineWpm': null,
      'baselineComprehension': null,
    });

    expect(profile.preferredColumnWidth, 760);
  });

  test('copies reading preferences without changing identity', () {
    final profile = LocalUserProfile.initial(
      id: 'local',
      createdAt: DateTime.utc(2026, 7, 6),
    );

    final updated = profile.copyWith(
      preferredFontSize: 22,
      preferredLineHeight: 1.7,
      preferredColumnWidth: 640,
      reducedMotion: true,
    );

    expect(updated.id, 'local');
    expect(updated.createdAt, DateTime.utc(2026, 7, 6));
    expect(updated.preferredFontSize, 22);
    expect(updated.preferredLineHeight, 1.7);
    expect(updated.preferredColumnWidth, 640);
    expect(updated.reducedMotion, isTrue);
  });
}
