import '../domain/certification_attempt.dart';
import '../domain/progress_snapshot.dart';

abstract interface class ProgressRepository {
  Future<List<ProgressSnapshot>> loadSnapshots();

  Future<void> saveSnapshot(ProgressSnapshot snapshot);

  Future<void> saveCertificationAttempt(CertificationAttempt attempt);

  Future<void> saveMasteryAttempt(MasteryAttempt attempt);

  Future<String> exportJson();

  Future<String> exportCsv();

  Future<void> resetProgress();
}

