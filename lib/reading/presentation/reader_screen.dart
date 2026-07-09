import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../content/domain/passage.dart';
import '../../content/domain/passage_filter.dart';
import '../../core/domain/reading_enums.dart';
import '../../core/providers/app_providers.dart';
import '../domain/reading_session.dart';
import '../domain/reading_session_factory.dart';
import '../domain/rsvp_timing.dart';

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
  String? _selectedPassageId;
  DateTime? _startedAt;
  DateTime? _pausedAt;
  Duration _pausedDuration = Duration.zero;
  int _pauseCount = 0;
  ReadingSession? _completedSession;
  bool _isSaving = false;
  ReadingMode _readingMode = ReadingMode.manual;
  int _rsvpWpm = 300;
  bool _rsvpPhraseMode = false;
  int _rsvpIndex = 0;
  Timer? _rsvpTimer;

  bool get _isReading => _startedAt != null && _completedSession == null;
  bool get _isPaused => _pausedAt != null;

  @override
  void dispose() {
    _rsvpTimer?.cancel();
    super.dispose();
  }

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
            final selectedPassage = _selectedPassage(items);
            return _ReaderBody(
              passages: items,
              selectedPassage: selectedPassage,
              isReading: _isReading,
              isPaused: _isPaused,
              isSaving: _isSaving,
              fontSize: profile?.preferredFontSize ?? 18,
              lineHeight: profile?.preferredLineHeight ?? 1.5,
              columnWidth: profile?.preferredColumnWidth ?? 760,
              completedSession: _completedSession,
              readingMode: _readingMode,
              rsvpWpm: _rsvpWpm,
              rsvpPhraseMode: _rsvpPhraseMode,
              rsvpIndex: _rsvpIndex,
              onStart: _startReading,
              onPause: _pauseReading,
              onResume: _resumeReading,
              onRewind: _rewindRsvp,
              onSelectMode: _selectMode,
              onWpmChanged: _setRsvpWpm,
              onPhraseModeChanged: _setRsvpPhraseMode,
              onSelectPassage: _selectPassage,
              onFinish: () => _finishReading(selectedPassage),
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

  Passage _selectedPassage(List<Passage> passages) {
    final selectedId = _selectedPassageId;
    if (selectedId == null) {
      return passages.first;
    }

    return passages.firstWhere(
      (passage) => passage.id == selectedId,
      orElse: () => passages.first,
    );
  }

  void _selectPassage(String? passageId) {
    if (passageId == null || _isReading) {
      return;
    }

    setState(() {
      _selectedPassageId = passageId;
      _completedSession = null;
      _rsvpIndex = 0;
    });
  }

  void _startReading() {
    setState(() {
      _startedAt = ref.read(currentDateTimeProvider).call();
      _pausedAt = null;
      _pausedDuration = Duration.zero;
      _pauseCount = 0;
      _completedSession = null;
      _rsvpIndex = 0;
    });
    _scheduleNextRsvpTick();
  }

  void _pauseReading() {
    if (!_isReading || _isPaused) {
      return;
    }

    _rsvpTimer?.cancel();
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
    _scheduleNextRsvpTick();
  }

  void _rewindRsvp() {
    if (_readingMode != ReadingMode.rsvp) {
      return;
    }

    setState(() {
      _rsvpIndex =
          (_rsvpIndex - (_rsvpPhraseMode ? 3 : 10)).clamp(0, _rsvpIndex);
    });
    _scheduleNextRsvpTick();
  }

  void _selectMode(ReadingMode? mode) {
    if (mode == null || _isReading) {
      return;
    }

    setState(() {
      _readingMode = mode;
      _completedSession = null;
      _rsvpIndex = 0;
    });
  }

  void _setRsvpWpm(double value) {
    setState(() {
      _rsvpWpm = value.round();
    });
    _scheduleNextRsvpTick();
  }

  void _setRsvpPhraseMode(bool value) {
    setState(() {
      _rsvpPhraseMode = value;
      _rsvpIndex = 0;
    });
    _scheduleNextRsvpTick();
  }

  void _scheduleNextRsvpTick() {
    _rsvpTimer?.cancel();
    if (!_isReading || _isPaused || _readingMode != ReadingMode.rsvp) {
      return;
    }

    final passages = ref.read(readerPassagesProvider).valueOrNull;
    if (passages == null || passages.isEmpty) {
      return;
    }

    final passage = _selectedPassage(passages);
    final schedule = _rsvpScheduleFor(passage);
    if (schedule.isEmpty || _rsvpIndex >= schedule.length - 1) {
      return;
    }

    _rsvpTimer = Timer(schedule[_rsvpIndex].duration, () {
      if (!mounted || !_isReading || _isPaused) {
        return;
      }
      setState(() {
        _rsvpIndex += 1;
      });
      _scheduleNextRsvpTick();
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
    _rsvpTimer?.cancel();

    final completedAt = ref.read(currentDateTimeProvider).call();
    final pausedAt = _pausedAt;
    final pausedDuration = pausedAt == null
        ? _pausedDuration
        : _pausedDuration + completedAt.difference(pausedAt);
    final session = ReadingSessionFactory.complete(
      id: ref.read(readerSessionIdProvider).call(),
      passageId: passage.id,
      mode: _readingMode,
      startedAt: startedAt,
      completedAt: completedAt,
      wordCount: passage.metadata.wordCount,
      pausedDuration: pausedDuration,
      pauseCount: _pauseCount,
      targetWpm: _readingMode == ReadingMode.rsvp ? _rsvpWpm : null,
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
      _rsvpIndex = 0;
    });
  }

  List<RsvpToken> _rsvpScheduleFor(Passage passage) {
    if (_rsvpPhraseMode) {
      return RsvpTiming.schedulePhrases(
        text: passage.body,
        wordsPerMinute: _rsvpWpm,
      );
    }

    return RsvpTiming.schedule(
      text: passage.body,
      wordsPerMinute: _rsvpWpm,
    );
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
      _rsvpIndex = 0;
    });
    _rsvpTimer?.cancel();

    Navigator.of(context).pop();
  }
}

class _ReaderBody extends StatelessWidget {
  const _ReaderBody({
    required this.passages,
    required this.selectedPassage,
    required this.isReading,
    required this.isPaused,
    required this.isSaving,
    required this.fontSize,
    required this.lineHeight,
    required this.columnWidth,
    required this.completedSession,
    required this.readingMode,
    required this.rsvpWpm,
    required this.rsvpPhraseMode,
    required this.rsvpIndex,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onRewind,
    required this.onSelectMode,
    required this.onWpmChanged,
    required this.onPhraseModeChanged,
    required this.onSelectPassage,
    required this.onFinish,
  });

  final List<Passage> passages;
  final Passage selectedPassage;
  final bool isReading;
  final bool isPaused;
  final bool isSaving;
  final double fontSize;
  final double lineHeight;
  final double columnWidth;
  final ReadingSession? completedSession;
  final ReadingMode readingMode;
  final int rsvpWpm;
  final bool rsvpPhraseMode;
  final int rsvpIndex;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onRewind;
  final ValueChanged<ReadingMode?> onSelectMode;
  final ValueChanged<double> onWpmChanged;
  final ValueChanged<bool> onPhraseModeChanged;
  final ValueChanged<String?> onSelectPassage;
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
            key: const ValueKey('reader-column'),
            constraints: BoxConstraints(maxWidth: columnWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedPassage.id,
                  onChanged: isReading ? null : onSelectPassage,
                  decoration: const InputDecoration(
                    labelText: 'Passage',
                    border: OutlineInputBorder(),
                  ),
                  items: passages.map((passage) {
                    return DropdownMenuItem(
                      value: passage.id,
                      child: Text(passage.title),
                    );
                  }).toList(growable: false),
                ),
                const SizedBox(height: 20),
                Text(selectedPassage.title, style: textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  '${selectedPassage.metadata.topic} - ${selectedPassage.metadata.wordCount} words',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedPassage.metadata.tags
                      .map((tag) => Chip(label: Text(tag)))
                      .toList(growable: false),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ReadingMode>(
                  initialValue: readingMode,
                  onChanged: isReading ? null : onSelectMode,
                  decoration: const InputDecoration(
                    labelText: 'Reading mode',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: ReadingMode.manual,
                      child: Text('Manual'),
                    ),
                    DropdownMenuItem(
                      value: ReadingMode.rsvp,
                      child: Text('RSVP'),
                    ),
                  ],
                ),
                if (readingMode == ReadingMode.rsvp) ...[
                  const SizedBox(height: 16),
                  _RsvpPanel(
                    passage: selectedPassage,
                    isReading: isReading,
                    isPaused: isPaused,
                    isSaving: isSaving,
                    wpm: rsvpWpm,
                    phraseMode: rsvpPhraseMode,
                    index: rsvpIndex,
                    onWpmChanged: onWpmChanged,
                    onPhraseModeChanged: onPhraseModeChanged,
                    onRewind: onRewind,
                  ),
                ],
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
                    if (readingMode == ReadingMode.rsvp)
                      OutlinedButton.icon(
                        onPressed: isReading && !isSaving ? onRewind : null,
                        icon: const Icon(Icons.replay_10),
                        label: const Text('Rewind'),
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
                  if (session.mode == ReadingMode.rsvp &&
                      session.targetWpm != null) ...[
                    const SizedBox(height: 4),
                    Text('RSVP target: ${session.targetWpm} WPM'),
                  ],
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.icon(
                      onPressed: () => context.goNamed('quiz'),
                      icon: const Icon(Icons.quiz),
                      label: const Text('Take Quiz'),
                    ),
                  ),
                ],
                if (readingMode == ReadingMode.manual) ...[
                  const SizedBox(height: 24),
                  Text(
                    selectedPassage.body,
                    style: textTheme.bodyLarge?.copyWith(
                      fontSize: fontSize,
                      height: lineHeight,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RsvpPanel extends StatelessWidget {
  const _RsvpPanel({
    required this.passage,
    required this.isReading,
    required this.isPaused,
    required this.isSaving,
    required this.wpm,
    required this.phraseMode,
    required this.index,
    required this.onWpmChanged,
    required this.onPhraseModeChanged,
    required this.onRewind,
  });

  final Passage passage;
  final bool isReading;
  final bool isPaused;
  final bool isSaving;
  final int wpm;
  final bool phraseMode;
  final int index;
  final ValueChanged<double> onWpmChanged;
  final ValueChanged<bool> onPhraseModeChanged;
  final VoidCallback onRewind;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final schedule = phraseMode
        ? RsvpTiming.schedulePhrases(text: passage.body, wordsPerMinute: wpm)
        : RsvpTiming.schedule(text: passage.body, wordsPerMinute: wpm);
    final safeIndex =
        schedule.isEmpty ? 0 : index.clamp(0, schedule.length - 1);
    final tokenText = schedule.isEmpty ? '' : schedule[safeIndex].text;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              label: 'RSVP display',
              child: Container(
                key: const ValueKey('rsvp-display'),
                alignment: Alignment.center,
                constraints: const BoxConstraints(minHeight: 120),
                child: Text(
                  tokenText,
                  textAlign: TextAlign.center,
                  style: textTheme.displaySmall,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              schedule.isEmpty
                  ? 'No RSVP tokens available.'
                  : '${safeIndex + 1} of ${schedule.length}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text('RSVP speed: $wpm WPM'),
            Slider(
              key: const ValueKey('rsvp-wpm-slider'),
              value: wpm.toDouble(),
              min: 100,
              max: 900,
              divisions: 16,
              label: '$wpm WPM',
              onChanged: isSaving ? null : onWpmChanged,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Phrase chunks'),
              value: phraseMode,
              onChanged: isReading ? null : onPhraseModeChanged,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: isReading && !isSaving ? onRewind : null,
                icon: const Icon(Icons.replay_10),
                label: const Text('Rewind RSVP'),
              ),
            ),
            if (isPaused) ...[
              const SizedBox(height: 8),
              const Text('RSVP playback paused.'),
            ],
          ],
        ),
      ),
    );
  }
}
