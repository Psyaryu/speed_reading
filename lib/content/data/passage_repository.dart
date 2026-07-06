import '../domain/passage.dart';
import '../domain/passage_filter.dart';

abstract interface class PassageRepository {
  Future<List<Passage>> loadOfficialPassages();

  Future<List<Passage>> loadImportedPassages();

  Future<void> saveImportedPassage(Passage passage);

  Future<void> deleteImportedPassage(String passageId);

  Future<List<Passage>> search(PassageFilter filter);
}

