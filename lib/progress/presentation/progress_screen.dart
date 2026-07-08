import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../assessment/domain/quiz.dart';
import '../../core/providers/app_providers.dart';
import '../../reading/domain/reading_session.dart';

final progressHistoryProvider = FutureProvider<ProgressHistory>((ref) async {
  final store = ref.watch(localDataStoreProvider);
  final sessions = await store.loadReadingSessions();
  final quizResults = await store.loadQuizResults();
  return ProgressHistory(
    sessions: sessions,
    quizResults: quizResults,
  );
});

class ProgressHistory {
  const ProgressHistory({
    required this.sessions,
    required this.quizResults,
  });

  final List<ReadingSession> sessions;
  final List<QuizResult> quizResults;

  List<ReadingSession> get newestSessions {
    return [...sessions]
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  QuizResult? quizForSession(String sessionId) {
    for (final result in quizResults) {
      if (result.sessionId == sessionId) {
        return result;
      }
    }
    return null;
  }
}

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(progressHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: history.when(
        data: (history) => _ProgressBody(history: history),
        error: (error, stackTrace) => Center(
          child: Text('Unable to load progress: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ProgressBody extends StatelessWidget {
  const _ProgressBody({required this.history});

  final ProgressHistory history;

  @override
  Widget build(BuildContext context) {
    final sessions = history.newestSessions;
    if (sessions.isEmpty) {
      return const Center(
        child: Text('No reading sessions yet.'),
      );
    }

    final latest = sessions.first;
    final latestQuiz = history.quizForSession(latest.id);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Latest Session',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        _MetricRow(label: 'WPM', value: latest.wpm.round().toString()),
        _MetricRow(
          label: 'Comprehension',
          value: _comprehensionLabel(latestQuiz),
        ),
        const SizedBox(height: 24),
        Text(
          'Session History',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ...sessions.map((session) {
          final quiz = history.quizForSession(session.id);
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.speed),
              title: Text('${session.wpm.round()} WPM'),
              subtitle: Text(
                'Comprehension: ${_comprehensionLabel(quiz)}',
              ),
              trailing: Text(session.mode.name),
            ),
          );
        }),
      ],
    );
  }

  String _comprehensionLabel(QuizResult? quiz) {
    if (quiz == null) {
      return 'Pending quiz';
    }
    return '${(quiz.comprehensionScore * 100).round()}%';
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
