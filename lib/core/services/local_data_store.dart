import '../../assessment/domain/quiz.dart';
import '../../content/domain/passage.dart';
import '../../progress/domain/certification_attempt.dart';
import '../../progress/domain/delayed_recall_attempt.dart';
import '../../progress/domain/progress_snapshot.dart';
import '../../reading/domain/reading_session.dart';
import '../../settings/domain/local_user_profile.dart';

abstract interface class LocalDataStore {
  Future<LocalUserProfile?> loadProfile();

  Future<void> saveProfile(LocalUserProfile profile);

  Future<List<Passage>> loadPassages();

  Future<void> saveImportedPassage(Passage passage);

  Future<void> deleteImportedPassage(String passageId);

  Future<void> saveReadingSession(ReadingSession session);

  Future<List<ReadingSession>> loadReadingSessions();

  Future<void> saveQuizResult(QuizResult result);

  Future<List<QuizResult>> loadQuizResults();

  Future<void> saveDelayedRecallAttempt(DelayedRecallAttempt attempt);

  Future<List<DelayedRecallAttempt>> loadDelayedRecallAttempts();

  Future<void> saveProgressSnapshot(ProgressSnapshot snapshot);

  Future<List<ProgressSnapshot>> loadProgressSnapshots();

  Future<void> saveCertificationAttempt(CertificationAttempt attempt);

  Future<void> saveMasteryAttempt(MasteryAttempt attempt);

  Future<String> exportJson();

  Future<String> exportCsv();

  Future<void> resetProgress();
}
