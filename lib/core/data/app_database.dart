import 'package:drift/drift.dart';

part 'app_database.g.dart';

class LocalProfiles extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get goalsJson => text()();
  RealColumn get preferredFontSize => real()();
  RealColumn get preferredLineHeight => real()();
  BoolColumn get reducedMotion => boolean()();
  RealColumn get baselineWpm => real().nullable()();
  RealColumn get baselineComprehension => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PassageRecords extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get source => text()();
  TextColumn get metadataJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ReadingSessionRecords extends Table {
  TextColumn get id => text()();
  TextColumn get passageId => text()();
  TextColumn get mode => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get activeReadingSeconds => integer()();
  IntColumn get wordCount => integer()();
  TextColumn get status => text()();
  IntColumn get targetWpm => integer().nullable()();
  IntColumn get pauseCount => integer()();
  IntColumn get userConfidenceRating => integer().nullable()();
  IntColumn get selfRatedFocus => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class QuizResultRecords extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get passageId => text()();
  IntColumn get correctCount => integer()();
  IntColumn get totalQuestions => integer()();
  TextColumn get answersByQuestionIdJson => text()();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ProgressSnapshotRecords extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  RealColumn get latestWpm => real()();
  RealColumn get latestComprehension => real()();
  RealColumn get effectiveReadingScore => real()();
  RealColumn get readinessPercent => real()();
  IntColumn get level => integer()();
  IntColumn get streakDays => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CertificationAttemptRecords extends Table {
  TextColumn get id => text()();
  TextColumn get sessionIdsJson => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  BoolColumn get isCertified => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class MasteryAttemptRecords extends Table {
  TextColumn get id => text()();
  TextColumn get sessionIdsJson => text()();
  TextColumn get delayedRecallQuizResultIdsJson => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  BoolColumn get isMastered => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    LocalProfiles,
    PassageRecords,
    ReadingSessionRecords,
    QuizResultRecords,
    ProgressSnapshotRecords,
    CertificationAttemptRecords,
    MasteryAttemptRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}
