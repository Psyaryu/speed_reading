import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../content/domain/passage.dart';
import '../../content/domain/passage_filter.dart';
import '../../core/domain/reading_enums.dart';
import '../../core/providers/app_providers.dart';
import '../domain/reading_session.dart';
import '../domain/reading_session_factory.dart';

final readerPassagesProvider = FutureProvider<List<Passage>>((ref) {
  return ref.watch(passageRepositoryProvider).search(const PassageFilter());
});

final readerSessionIdProvider = Provider<String Function()>((ref) {
  final now = ref.watch(currentDateTimeProvider);
  return () => now().microsecondsSinceEpoch.toString();
});

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  DateTime? _startedAt;
  ReadingSession? _completedSession;
  bool _isSaving = false;

  bool get _isReading => _startedAt != null && _completedSession == null;

  @override
  Widget build(BuildContext context) {
    final passages = ref.watch(readerPassagesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reader')),
      body: passages.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No passages available.'));
          }
          return _ReaderBody(
            passage: items.first,
            isReading: _isReading,
            isSaving: _isSaving,
            completedSession: _completedSession,
            onStart: _startReading,
            onFinish: () => _finishReading(items.first),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Unable to load reader passage: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _startReading() {
    setState(() {
      _startedAt = ref.read(currentDateTimeProvider).call();
      _completedSession = null;
    });
  }

  Future<void> _finishReading(Passage passage) async {
    final startedAt = _startedAt;
    if (startedAt == null || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final completedAt = ref.read(currentDateTimeProvider).call();
    final session = ReadingSessionFactory.complete(
      id: ref.read(readerSessionIdProvider).call(),
      passageId: passage.id,
      mode: ReadingMode.manual,
      startedAt: startedAt,
      completedAt: completedAt,
      wordCount: passage.metadata.wordCount,
    );

    await ref.read(localDataStoreProvider).saveReadingSession(session);

    if (!mounted) {
      return;
    }

    setState(() {
      _startedAt = null;
      _completedSession = session;
      _isSaving = false;
    });
  }
}

class _ReaderBody extends StatelessWidget {
  const _ReaderBody({
    required this.passage,
    required this.isReading,
    required this.isSaving,
    required this.completedSession,
    required this.onStart,
    required this.onFinish,
  });

  final Passage passage;
  final bool isReading;
  final bool isSaving;
  final ReadingSession? completedSession;
  final VoidCallback onStart;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final session = completedSession;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(passage.title, style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          '${passage.metadata.topic} - ${passage.metadata.wordCount} words',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: passage.metadata.tags
              .map((tag) => Chip(label: Text(tag)))
              .toList(growable: false),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            FilledButton.icon(
              onPressed: isReading || isSaving ? null : onStart,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: isReading && !isSaving ? onFinish : null,
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.flag),
              label: const Text('Finish'),
            ),
          ],
        ),
        if (isReading) ...[
          const SizedBox(height: 12),
          const Text('Reading session active.'),
        ],
        if (session != null) ...[
          const SizedBox(height: 12),
          Text('WPM: ${session.wpm.round()}'),
        ],
        const SizedBox(height: 24),
        Text(
          passage.body,
          style: textTheme.bodyLarge?.copyWith(height: 1.55),
        ),
      ],
    );
  }
}
