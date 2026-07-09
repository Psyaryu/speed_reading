import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/passage.dart';
import '../domain/passage_filter.dart';
import '../../../core/domain/reading_enums.dart';
import '../../../core/providers/app_providers.dart';

final libraryPassagesProvider = FutureProvider<List<Passage>>((ref) {
  return ref.watch(passageRepositoryProvider).search(const PassageFilter());
});

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passages = ref.watch(libraryPassagesProvider);

    return Scaffold(
      appBar: AppBar(
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
        data: (items) => _PassageList(passages: items),
        error: (error, stackTrace) => Center(
          child: Text('Unable to load passages: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _PassageList extends ConsumerWidget {
  const _PassageList({required this.passages});

  final List<Passage> passages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (passages.isEmpty) {
      return const Center(child: Text('No passages available.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final passage = passages[index];
        return ListTile(
          title: Text(passage.title),
          subtitle: Text(
            '${passage.metadata.topic} - ${passage.metadata.wordCount} words',
          ),
          trailing: _PassageActions(
            passage: passage,
            onChanged: () => ref.invalidate(libraryPassagesProvider),
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
