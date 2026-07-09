import '../../core/domain/reading_enums.dart';
import '../../core/services/local_data_store.dart';
import '../domain/passage.dart';
import '../domain/passage_filter.dart';
import 'official_passage_loader.dart';
import 'passage_repository.dart';

class DefaultPassageRepository implements PassageRepository {
  const DefaultPassageRepository({
    required this.officialPassageSource,
    required this.localDataStore,
  });

  final OfficialPassageSource officialPassageSource;
  final LocalDataStore localDataStore;

  @override
  Future<List<Passage>> loadOfficialPassages() {
    return officialPassageSource.load();
  }

  @override
  Future<List<Passage>> loadImportedPassages() async {
    final passages = await localDataStore.loadPassages();
    return passages
        .where((passage) => passage.metadata.source == PassageSource.imported)
        .toList(growable: false);
  }

  @override
  Future<void> saveImportedPassage(Passage passage) {
    if (passage.metadata.source != PassageSource.imported) {
      throw ArgumentError.value(
        passage.metadata.source,
        'passage.metadata.source',
        'Only imported passages can be saved through this repository.',
      );
    }
    return localDataStore.saveImportedPassage(passage);
  }

  @override
  Future<void> deleteImportedPassage(String passageId) {
    return localDataStore.deleteImportedPassage(passageId);
  }

  @override
  Future<List<Passage>> search(PassageFilter filter) async {
    final passages = [
      ...await loadOfficialPassages(),
      ...await loadImportedPassages(),
    ];
    return PassageFilterService.apply(passages, filter);
  }
}
