import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/passage.dart';
import '../domain/passage_filter.dart';
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
      appBar: AppBar(title: const Text('Library')),
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

class _PassageList extends StatelessWidget {
  const _PassageList({required this.passages});

  final List<Passage> passages;

  @override
  Widget build(BuildContext context) {
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
            '${passage.metadata.topic} • ${passage.metadata.wordCount} words',
          ),
          trailing: Wrap(
            spacing: 6,
            children: passage.metadata.tags.take(3).map((tag) {
              return Chip(label: Text(tag));
            }).toList(growable: false),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemCount: passages.length,
    );
  }
}
