import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../content/domain/passage.dart';
import '../../content/domain/passage_filter.dart';
import '../../core/providers/app_providers.dart';
import '../../progress/domain/effective_reading_score.dart';
import '../../progress/presentation/progress_screen.dart';

final resultPassagesProvider = FutureProvider<List<Passage>>((ref) {
  return ref.watch(passageRepositoryProvider).search(const PassageFilter());
});

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(progressHistoryProvider);
    final passages = ref.watch(resultPassagesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: switch ((history, passages)) {
        (AsyncData(value: final history), AsyncData(value: final passages)) =>
          _ResultsBody(
            history: history,
            passages: passages,
          ),
        (AsyncError(error: final error), _) ||
        (_, AsyncError(error: final error)) =>
          Center(child: Text('Unable to load results: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({
    required this.history,
    required this.passages,
  });

  final ProgressHistory history;
  final List<Passage> passages;

  @override
  Widget build(BuildContext context) {
    final sessions = history.newestSessions;
    if (sessions.isEmpty) {
      return const Center(child: Text('No results yet.'));
    }

    final session = sessions.first;
    final quiz = history.quizForSession(session.id);
    final passage = _passageFor(session.passageId);
    final comprehensionScore = quiz?.comprehensionScore;
    final comprehensionLabel = comprehensionScore == null
        ? 'Pending quiz'
        : '${(comprehensionScore * 100).round()}%';
    final effectiveReadingScore = comprehensionScore == null || passage == null
        ? null
        : EffectiveReadingScore.calculate(
            wpm: session.wpm,
            comprehensionScore: comprehensionScore,
            difficulty: passage.metadata.difficulty,
            mode: session.mode,
          );
    final meetsThreshold =
        comprehensionScore != null && comprehensionScore >= 0.7;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Latest Result',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        _ResultTile(
          label: 'Reading Speed',
          value: '${session.wpm.round()} WPM',
        ),
        _ResultTile(
          label: 'Comprehension',
          value: comprehensionLabel,
        ),
        _ResultTile(
          label: 'Effective Reading Score',
          value: effectiveReadingScore == null
              ? 'Pending quiz'
              : effectiveReadingScore.round().toString(),
        ),
        _ResultTile(
          label: 'Standard Progress Gate',
          value: comprehensionScore == null
              ? 'Pending quiz'
              : meetsThreshold
                  ? 'Qualified'
                  : 'Below 70%',
        ),
      ],
    );
  }

  Passage? _passageFor(String passageId) {
    for (final passage in passages) {
      if (passage.id == passageId) {
        return passage;
      }
    }
    return null;
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(label),
        trailing: Text(value),
      ),
    );
  }
}
