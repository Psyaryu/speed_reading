import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../progress/presentation/progress_screen.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(progressHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: history.when(
        data: (history) => _ResultsBody(history: history),
        error: (error, stackTrace) => Center(
          child: Text('Unable to load results: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({required this.history});

  final ProgressHistory history;

  @override
  Widget build(BuildContext context) {
    final sessions = history.newestSessions;
    if (sessions.isEmpty) {
      return const Center(child: Text('No results yet.'));
    }

    final session = sessions.first;
    final quiz = history.quizForSession(session.id);
    final comprehensionScore = quiz?.comprehensionScore;
    final comprehensionLabel = comprehensionScore == null
        ? 'Pending quiz'
        : '${(comprehensionScore * 100).round()}%';
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
          label: 'Standard Progress Gate',
          value: comprehensionScore == null
              ? 'Pending quiz'
              : meetsThreshold
                  ? 'Qualified'
                  : 'Below 70%',
        ),
        const SizedBox(height: 16),
        Text(
          'ERS requires passage difficulty metadata and will be shown once result scoring is connected to passage records.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
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
