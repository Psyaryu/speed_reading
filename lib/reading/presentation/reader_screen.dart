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
  DateTime? _pausedAt;
  Duration _pausedDuration = Duration.zero;
  int _pauseCount = 0;
  ReadingSession? _completedSession;
  bool _isSaving = false;

  bool get _isReading => _startedAt != null && _completedSession == null;
  bool get _isPaused => _pausedAt != null;

  @override
  Widget build(BuildContext context) {
    final passages = ref.watch(readerPassagesProvider);
    final profile = ref.watch(localProfileProvider).valueOrNull;

    return PopScope<void>(
      canPop: !_isReading,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || !_isReading) {
          return;
        }
        _confirmDiscardSession();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Reader')),
        body: passages.when(
          data: (items) {
            if (items.isEmpty) {
              return const Center(child: Text('No passages available.'));
            }
            return _ReaderBody(
              passage: items.first,
              isReading: _isReading,
              isPaused: _isPaused,
              isSaving: _isSaving,
              fontSize: profile?.preferredFontSize ?? 18,
              lineHeight: profile?.preferredLineHeight ?? 1.5,
              completedSession: _completedSession,
              onStart: _startReading,
              onPause: _pauseReading,
              onResume: _resumeReading,
              onFinish: () => _finishReading(items.first),
            );
          },
          error: (error, stackTrace) => Center(
            child: Text('Unable to load reader passage: $error'),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  void _startReading() {
    setState(() {
      _startedAt = ref.read(currentDateTimeProvider).call();
      _pausedAt = null;
      _pausedDuration = Duration.zero;
      _pauseCount = 0;
      _completedSession = null;
    });
  }

  void _pauseReading() {
    if (!_isReading || _isPaused) {
      return;
    }

    setState(() {
      _pausedAt = ref.read(currentDateTimeProvider).call();
      _pauseCount += 1;
    });
  }

  void _resumeReading() {
    final pausedAt = _pausedAt;
    if (pausedAt == null) {
      return;
    }

    final resumedAt = ref.read(currentDateTimeProvider).call();
    setState(() {
      _pausedDuration += resumedAt.difference(pausedAt);
      _pausedAt = null;
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
    final pausedAt = _pausedAt;
    final pausedDuration = pausedAt == null
        ? _pausedDuration
        : _pausedDuration + completedAt.difference(pausedAt);
    final session = ReadingSessionFactory.complete(
      id: ref.read(readerSessionIdProvider).call(),
      passageId: passage.id,
      mode: ReadingMode.manual,
      startedAt: startedAt,
      completedAt: completedAt,
      wordCount: passage.metadata.wordCount,
      pausedDuration: pausedDuration,
      pauseCount: _pauseCount,
    );

    await ref.read(localDataStoreProvider).saveReadingSession(session);

    if (!mounted) {
      return;
    }

    setState(() {
      _startedAt = null;
      _pausedAt = null;
      _pausedDuration = Duration.zero;
      _pauseCount = 0;
      _completedSession = session;
      _isSaving = false;
    });
  }

  Future<void> _confirmDiscardSession() async {
    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard active session?'),
        content: const Text('Your current reading attempt has not been saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep Reading'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (!mounted || shouldDiscard != true) {
      return;
    }

    setState(() {
      _startedAt = null;
      _pausedAt = null;
      _pausedDuration = Duration.zero;
      _pauseCount = 0;
    });

    Navigator.of(context).pop();
  }
}

class _ReaderBody extends StatelessWidget {
  const _ReaderBody({
    required this.passage,
    required this.isReading,
    required this.isPaused,
    required this.isSaving,
    required this.fontSize,
    required this.lineHeight,
    required this.completedSession,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onFinish,
  });

  final Passage passage;
  final bool isReading;
  final bool isPaused;
  final bool isSaving;
  final double fontSize;
  final double lineHeight;
  final ReadingSession? completedSession;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final session = completedSession;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: isReading || isSaving ? null : onStart,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start'),
                    ),
                    OutlinedButton.icon(
                      onPressed:
                          isReading && !isPaused && !isSaving ? onPause : null,
                      icon: const Icon(Icons.pause),
                      label: const Text('Pause'),
                    ),
                    OutlinedButton.icon(
                      onPressed:
                          isReading && isPaused && !isSaving ? onResume : null,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Resume'),
                    ),
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
                  Text(
                    isPaused
                        ? 'Reading session paused.'
                        : 'Reading session active.',
                  ),
                ],
                if (session != null) ...[
                  const SizedBox(height: 12),
                  Text('WPM: ${session.wpm.round()}'),
                ],
                const SizedBox(height: 24),
                Text(
                  passage.body,
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: fontSize,
                    height: lineHeight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
