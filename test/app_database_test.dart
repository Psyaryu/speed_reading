import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/data/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('creates local profile row', () async {
    await database.into(database.localProfiles).insert(
          LocalProfilesCompanion.insert(
            id: 'local',
            createdAt: DateTime.utc(2026, 7, 7),
            goalsJson: '["generalImprovement"]',
            preferredFontSize: 18,
            preferredLineHeight: 1.5,
            reducedMotion: false,
          ),
        );

    final profile = await database.select(database.localProfiles).getSingle();

    expect(profile.id, 'local');
    expect(profile.preferredFontSize, 18);
  });

  test('creates imported passage row', () async {
    await database.into(database.passageRecords).insert(
          PassageRecordsCompanion.insert(
            id: 'passage-1',
            title: 'Imported',
            body: 'A dangerous map appeared.',
            source: 'imported',
            metadataJson: '{"tags":["imported"]}',
          ),
        );

    final passage = await database.select(database.passageRecords).getSingle();

    expect(passage.source, 'imported');
    expect(passage.metadataJson, contains('imported'));
  });
}

