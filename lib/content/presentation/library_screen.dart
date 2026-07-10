import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/passage.dart';
import '../domain/passage_filter.dart';
import '../../../core/domain/reading_enums.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/app_back_button.dart';

final libraryPassagesProvider = FutureProvider<List<Passage>>((ref) {
  final filter = ref.watch(libraryPassageFilterProvider);
  return ref.watch(passageRepositoryProvider).search(filter);
});

final libraryAvailablePassagesProvider = FutureProvider<List<Passage>>((ref) {
  return ref.watch(passageRepositoryProvider).search(const PassageFilter());
});

final libraryPassageFilterProvider = StateProvider<PassageFilter>((ref) {
  return const PassageFilter();
});

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passages = ref.watch(libraryPassagesProvider);
    final availablePassages = ref.watch(libraryAvailablePassagesProvider);
    final filter = ref.watch(libraryPassageFilterProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Library'),
        actions: [
          IconButton(
            tooltip: 'Import passage',
            onPressed: () async {
              await context.pushNamed('import');
              if (context.mounted) {
                ref.invalidate(libraryPassagesProvider);
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: passages.when(
        data: (items) => _PassageLibraryBody(
          passages: items,
          availablePassages: availablePassages.valueOrNull ?? items,
          filter: filter,
          searchController: _searchController,
        ),
        error: (error, stackTrace) => Center(
          child: Text('Unable to load passages: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _PassageLibraryBody extends ConsumerWidget {
  const _PassageLibraryBody({
    required this.passages,
    required this.availablePassages,
    required this.filter,
    required this.searchController,
  });

  final List<Passage> passages;
  final List<Passage> availablePassages;
  final PassageFilter filter;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = _sortedTopics(availablePassages);
    final tags = _sortedTags(availablePassages);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _LibraryFilters(
          filter: filter,
          topics: topics,
          tags: tags,
          searchController: searchController,
        ),
        const SizedBox(height: 12),
        if (passages.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: Text('No passages available.')),
          )
        else
          _PassageList(
            passages: passages,
            onChanged: () {
              ref.invalidate(libraryAvailablePassagesProvider);
              ref.invalidate(libraryPassagesProvider);
            },
          ),
      ],
    );
  }

  List<String> _sortedTopics(List<Passage> passages) {
    final topics = passages
        .map((passage) => passage.metadata.topic)
        .where((topic) => topic.trim().isNotEmpty)
        .toSet()
        .toList();
    topics.sort();
    return topics;
  }

  List<String> _sortedTags(List<Passage> passages) {
    final tags = passages
        .expand((passage) => passage.metadata.tags)
        .where((tag) => tag.trim().isNotEmpty)
        .toSet()
        .toList();
    tags.sort();
    return tags;
  }
}

class _LibraryFilters extends ConsumerWidget {
  const _LibraryFilters({
    required this.filter,
    required this.topics,
    required this.tags,
    required this.searchController,
  });

  final PassageFilter filter;
  final List<String> topics;
  final List<String> tags;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Search passages',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: filter.query == null || filter.query!.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    onPressed: () {
                      searchController.clear();
                      _updateFilter(
                        ref,
                        filter.copyWith(clearQuery: true),
                      );
                    },
                    icon: const Icon(Icons.clear),
                  ),
          ),
          onChanged: (value) {
            final trimmedValue = value.trim();
            _updateFilter(
              ref,
              trimmedValue.isEmpty
                  ? filter.copyWith(clearQuery: true)
                  : filter.copyWith(query: value),
            );
          },
        ),
        const SizedBox(height: 12),
        Text('Difficulty', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('All'),
              selected: filter.difficulty == null,
              onSelected: (_) => _updateFilter(
                ref,
                filter.copyWith(clearDifficulty: true),
              ),
            ),
            ...PassageDifficulty.values.map((difficulty) {
              return ChoiceChip(
                label: Text(_labelForEnum(difficulty.name)),
                selected: filter.difficulty == difficulty,
                onSelected: (_) => _updateFilter(
                  ref,
                  filter.copyWith(difficulty: difficulty),
                ),
              );
            }),
          ],
        ),
        if (topics.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Topic', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All topics'),
                selected: filter.topic == null,
                onSelected: (_) => _updateFilter(
                  ref,
                  filter.copyWith(clearTopic: true),
                ),
              ),
              ...topics.map((topic) {
                return ChoiceChip(
                  label: Text(topic),
                  selected: filter.topic == topic,
                  onSelected: (_) => _updateFilter(
                    ref,
                    filter.copyWith(topic: topic),
                  ),
                );
              }),
            ],
          ),
        ],
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Tags', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              final selected = filter.tags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: selected,
                onSelected: (_) {
                  final nextTags = selected
                      ? filter.tags.where((item) => item != tag).toList()
                      : [...filter.tags, tag];
                  _updateFilter(ref, filter.copyWith(tags: nextTags));
                },
              );
            }).toList(),
          ),
        ],
        if (!filter.isEmpty) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              searchController.clear();
              _updateFilter(ref, const PassageFilter());
            },
            icon: const Icon(Icons.filter_alt_off),
            label: const Text('Clear filters'),
          ),
        ],
      ],
    );
  }

  void _updateFilter(WidgetRef ref, PassageFilter nextFilter) {
    ref.read(libraryPassageFilterProvider.notifier).state = nextFilter;
  }

  String _labelForEnum(String value) {
    return value
        .replaceAllMapped(RegExp('[A-Z]'), (match) => ' ${match.group(0)}')
        .replaceFirstMapped(
          RegExp('^.'),
          (match) => match.group(0)!.toUpperCase(),
        );
  }
}

class _PassageList extends ConsumerWidget {
  const _PassageList({
    required this.passages,
    required this.onChanged,
  });

  final List<Passage> passages;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final passage = passages[index];
        return ListTile(
          title: Text(passage.title),
          subtitle: Text(
            '${passage.metadata.topic} - ${passage.metadata.wordCount} words',
          ),
          trailing: _PassageActions(
            passage: passage,
            onChanged: onChanged,
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: passages.length,
    );
  }
}

class _PassageActions extends ConsumerWidget {
  const _PassageActions({
    required this.passage,
    required this.onChanged,
  });

  final Passage passage;
  final VoidCallback onChanged;

  bool get _isImported => passage.metadata.source == PassageSource.imported;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...passage.metadata.tags.take(3).map((tag) {
          return Chip(label: Text(tag));
        }),
        if (_isImported) ...[
          IconButton(
            tooltip: 'Edit imported passage',
            onPressed: () async {
              await context.pushNamed('import', extra: passage);
              if (context.mounted) {
                onChanged();
              }
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            tooltip: 'Delete imported passage',
            onPressed: () => _confirmDelete(context, ref),
            icon: const Icon(Icons.delete),
          ),
        ],
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Passage?'),
          content: Text('Delete "${passage.title}" from local storage?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    await ref.read(passageRepositoryProvider).deleteImportedPassage(passage.id);
    if (!context.mounted) {
      return;
    }
    onChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Passage deleted.')),
    );
  }
}
