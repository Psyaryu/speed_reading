import 'dart:convert';

import 'package:drift/drift.dart';

import '../../assessment/domain/quiz.dart';
import '../../content/domain/passage.dart';
import '../../core/domain/reading_enums.dart';
import '../../progress/domain/certification_attempt.dart';
import '../../progress/domain/delayed_recall_attempt.dart';
import '../../progress/domain/progress_snapshot.dart';
import '../../reading/domain/reading_session.dart';
import '../../settings/domain/local_user_profile.dart';
import '../../settings/domain/progress_exporter.dart';
import '../services/local_data_store.dart';
import 'app_database.dart';

class DriftLocalDataStore implements LocalDataStore {
  const DriftLocalDataStore(this.database);

  final AppDatabase database;

  @override
  Future<LocalUserProfile?> loadProfile() async {
    final rows = await database.select(database.localProfiles).get();
    if (rows.isEmpty) {
      return null;
    }
    return _profileFromRow(rows.single);
  }

  @override
  Future<void> saveProfile(LocalUserProfile profile) {
    return database.into(database.localProfiles).insertOnConflictUpdate(
          LocalProfilesCompanion.insert(
            id: profile.id,
            createdAt: profile.createdAt,
            goalsJson: jsonEncode(
              profile.goals.map((goal) => goal.name).toList(growable: false),
            ),
            preferredFontSize: profile.preferredFontSize,
            preferredLineHeight: profile.preferredLineHeight,
            preferredColumnWidth: Value(profile.preferredColumnWidth),
            preferredThemeMode: Value(profile.preferredThemeMode.name),
            reducedMotion: profile.reducedMotion,
            baselineWpm: Value(profile.baselineWpm),
            baselineComprehension: Value(profile.baselineComprehension),
            baselineEffectiveReadingScore: Value(
              profile.baselineEffectiveReadingScore,
            ),
          ),
        );
  }

  @override
  Future<List<Passage>> loadPassages() async {
    final rows = await database.select(database.passageRecords).get();
    return rows.map(_passageFromRow).toList(growable: false);
  }

  @override
  Future<void> saveImportedPassage(Passage passage) {
    if (passage.metadata.source != PassageSource.imported) {
      throw ArgumentError.value(
        passage.metadata.source,
        'passage.metadata.source',
        'Only imported passages can be saved through this method.',
      );
    }
    return database.into(database.passageRecords).insertOnConflictUpdate(
          PassageRecordsCompanion.insert(
            id: passage.id,
            title: passage.title,
            body: passage.body,
            source: passage.metadata.source.name,
            metadataJson: jsonEncode(passage.metadata.toJson()),
          ),
        );
  }

  @override
  Future<void> deleteImportedPassage(String passageId) {
    return (database.delete(database.passageRecords)
          ..where(
            (table) =>
                table.id.equals(passageId) &
                table.source.equals(PassageSource.imported.name),
          ))
        .go();
  }

  @override
  Future<void> saveReadingSession(ReadingSession session) {
    return database.into(database.readingSessionRecords).insertOnConflictUpdate(
          ReadingSessionRecordsCompanion.insert(
            id: session.id,
            passageId: session.passageId,
            mode: session.mode.name,
            startedAt: session.startedAt,
            completedAt: Value(session.completedAt),
            activeReadingSeconds: session.activeReadingSeconds,
            wordCount: session.wordCount,
            status: session.status.name,
            targetWpm: Value(session.targetWpm),
            pauseCount: session.pauseCount,
            userConfidenceRating: Value(session.userConfidenceRating),
            selfRatedFocus: Value(session.selfRatedFocus),
          ),
        );
  }

  @override
  Future<List<ReadingSession>> loadReadingSessions() async {
    final rows = await database.select(database.readingSessionRecords).get();
    return rows.map(_sessionFromRow).toList(growable: false);
  }

  @override
  Future<void> saveQuizResult(QuizResult result) {
    return database.into(database.quizResultRecords).insertOnConflictUpdate(
          QuizResultRecordsCompanion.insert(
            id: result.id,
            sessionId: result.sessionId,
            passageId: result.passageId,
            correctCount: result.correctCount,
            totalQuestions: result.totalQuestions,
            answersByQuestionIdJson: jsonEncode(result.answersByQuestionId),
            completedAt: result.completedAt,
            writtenSummary: Value(result.writtenSummary),
          ),
        );
  }

  @override
  Future<List<QuizResult>> loadQuizResults() async {
    final rows = await database.select(database.quizResultRecords).get();
    return rows.map(_quizResultFromRow).toList(growable: false);
  }

  @override
  Future<void> saveDelayedRecallAttempt(DelayedRecallAttempt attempt) {
    return database
        .into(database.delayedRecallAttemptRecords)
        .insertOnConflictUpdate(
          DelayedRecallAttemptRecordsCompanion.insert(
            id: attempt.id,
            passageId: attempt.passageId,
            immediateSessionId: Value(attempt.immediateSessionId),
            immediateQuizResultId: Value(attempt.immediateQuizResultId),
            recallCompletedAt: attempt.recallCompletedAt,
            immediateAttemptCompletedAt: Value(
              attempt.immediateAttemptCompletedAt,
            ),
            dueAt: Value(attempt.dueAt),
            score: attempt.score,
          ),
        );
  }

  @override
  Future<List<DelayedRecallAttempt>> loadDelayedRecallAttempts() async {
    final rows =
        await database.select(database.delayedRecallAttemptRecords).get();
    return rows.map(_delayedRecallAttemptFromRow).toList(growable: false);
  }

  @override
  Future<void> saveProgressSnapshot(ProgressSnapshot snapshot) {
    return database
        .into(database.progressSnapshotRecords)
        .insertOnConflictUpdate(
          ProgressSnapshotRecordsCompanion.insert(
            id: snapshot.id,
            createdAt: snapshot.createdAt,
            latestWpm: snapshot.latestWpm,
            latestComprehension: snapshot.latestComprehension,
            effectiveReadingScore: snapshot.effectiveReadingScore,
            readinessPercent: snapshot.readinessPercent,
            level: snapshot.level,
            streakDays: snapshot.streakDays,
          ),
        );
  }

  @override
  Future<List<ProgressSnapshot>> loadProgressSnapshots() async {
    final rows = await database.select(database.progressSnapshotRecords).get();
    return rows.map(_snapshotFromRow).toList(growable: false);
  }

  @override
  Future<void> saveCertificationAttempt(CertificationAttempt attempt) {
    return database
        .into(database.certificationAttemptRecords)
        .insertOnConflictUpdate(
          CertificationAttemptRecordsCompanion.insert(
            id: attempt.id,
            sessionIdsJson: jsonEncode(attempt.sessionIds),
            startedAt: attempt.startedAt,
            completedAt: Value(attempt.completedAt),
            isCertified: attempt.isCertified,
          ),
        );
  }

  @override
  Future<void> saveMasteryAttempt(MasteryAttempt attempt) {
    return database.into(database.masteryAttemptRecords).insertOnConflictUpdate(
          MasteryAttemptRecordsCompanion.insert(
            id: attempt.id,
            sessionIdsJson: jsonEncode(attempt.sessionIds),
            delayedRecallQuizResultIdsJson:
                jsonEncode(attempt.delayedRecallQuizResultIds),
            startedAt: attempt.startedAt,
            completedAt: Value(attempt.completedAt),
            isMastered: attempt.isMastered,
          ),
        );
  }

  @override
  Future<String> exportJson() async {
    return ProgressExporter.toJson(
      sessions: await loadReadingSessions(),
      quizResults: await loadQuizResults(),
      snapshots: await loadProgressSnapshots(),
    );
  }

  @override
  Future<String> exportCsv() async {
    return ProgressExporter.sessionsToCsv(await loadReadingSessions());
  }

  @override
  Future<void> resetProgress() {
    return database.transaction(() async {
      await database.delete(database.quizResultRecords).go();
      await database.delete(database.delayedRecallAttemptRecords).go();
      await database.delete(database.readingSessionRecords).go();
      await database.delete(database.progressSnapshotRecords).go();
      await database.delete(database.certificationAttemptRecords).go();
      await database.delete(database.masteryAttemptRecords).go();
    });
  }

  LocalUserProfile _profileFromRow(LocalProfile row) {
    return LocalUserProfile(
      id: row.id,
      createdAt: row.createdAt,
      goals: (jsonDecode(row.goalsJson) as List<Object?>)
          .map((goal) => TrainingGoal.values.byName(goal as String))
          .toList(growable: false),
      preferredFontSize: row.preferredFontSize,
      preferredLineHeight: row.preferredLineHeight,
      preferredColumnWidth: row.preferredColumnWidth,
      preferredThemeMode: LocalThemeMode.values.byName(row.preferredThemeMode),
      reducedMotion: row.reducedMotion,
      baselineWpm: row.baselineWpm,
      baselineComprehension: row.baselineComprehension,
      baselineEffectiveReadingScore: row.baselineEffectiveReadingScore,
    );
  }

  Passage _passageFromRow(PassageRecord row) {
    return Passage(
      id: row.id,
      title: row.title,
      body: row.body,
      metadata: PassageMetadata.fromJson(
        Map<String, Object?>.from(jsonDecode(row.metadataJson) as Map),
      ),
    );
  }

  ReadingSession _sessionFromRow(ReadingSessionRecord row) {
    return ReadingSession(
      id: row.id,
      passageId: row.passageId,
      mode: ReadingMode.values.byName(row.mode),
      startedAt: row.startedAt,
      completedAt: row.completedAt,
      activeReadingSeconds: row.activeReadingSeconds,
      wordCount: row.wordCount,
      status: AttemptQualificationStatus.values.byName(row.status),
      targetWpm: row.targetWpm,
      pauseCount: row.pauseCount,
      userConfidenceRating: row.userConfidenceRating,
      selfRatedFocus: row.selfRatedFocus,
    );
  }

  QuizResult _quizResultFromRow(QuizResultRecord row) {
    return QuizResult(
      id: row.id,
      sessionId: row.sessionId,
      passageId: row.passageId,
      correctCount: row.correctCount,
      totalQuestions: row.totalQuestions,
      answersByQuestionId: _intMapFromJson(row.answersByQuestionIdJson),
      completedAt: row.completedAt,
      writtenSummary: row.writtenSummary,
    );
  }

  DelayedRecallAttempt _delayedRecallAttemptFromRow(
    DelayedRecallAttemptRecord row,
  ) {
    return DelayedRecallAttempt(
      id: row.id,
      passageId: row.passageId,
      immediateSessionId: row.immediateSessionId,
      immediateQuizResultId: row.immediateQuizResultId,
      recallCompletedAt: row.recallCompletedAt,
      immediateAttemptCompletedAt: row.immediateAttemptCompletedAt,
      dueAt: row.dueAt,
      score: row.score,
    );
  }

  ProgressSnapshot _snapshotFromRow(ProgressSnapshotRecord row) {
    return ProgressSnapshot(
      id: row.id,
      createdAt: row.createdAt,
      latestWpm: row.latestWpm,
      latestComprehension: row.latestComprehension,
      effectiveReadingScore: row.effectiveReadingScore,
      readinessPercent: row.readinessPercent,
      level: row.level,
      streakDays: row.streakDays,
    );
  }

  Map<String, int> _intMapFromJson(String rawJson) {
    final decoded = jsonDecode(rawJson) as Map<String, Object?>;
    return decoded.map(
      (key, value) => MapEntry(key, (value as num).toInt()),
    );
  }
}
