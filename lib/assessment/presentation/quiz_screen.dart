import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/app_providers.dart';
import '../../reading/domain/reading_session.dart';
import '../domain/quiz.dart';
import '../domain/quiz_scorer.dart';

final latestQuizSessionProvider = FutureProvider<ReadingSession?>((ref) async {
  final sessions = await ref.watch(localDataStoreProvider).loadReadingSessions();
  if (sessions.isEmpty) {
    return null;
  }
  sessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));
  return sessions.first;
});

final quizQuestionsProvider =
    FutureProvider.family<List<QuizQuestion>, String>((ref, passageId) async {
  final questions = await ref.watch(officialQuestionSourceProvider).load();
  return questions
      .where((question) => question.passageId == passageId)
      .toList(growable: false);
});

final quizResultIdProvider = Provider<String Function()>((ref) {
  final now = ref.watch(currentDateTimeProvider);
  return () => 'quiz-${now().microsecondsSinceEpoch}';
});

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(latestQuizSessionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: session.when(
        data: (session) {
          if (session == null) {
            return const Center(child: Text('Complete a reading session first.'));
          }
          final questions = ref.watch(quizQuestionsProvider(session.passageId));
          return questions.when(
            data: (questions) {
              if (questions.isEmpty) {
                return const Center(child: Text('No quiz available yet.'));
              }
              return _QuizForm(
                session: session,
                questions: questions,
              );
            },
            error: (error, stackTrace) => Center(
              child: Text('Unable to load quiz: $error'),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Unable to load session: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _QuizForm extends ConsumerStatefulWidget {
  const _QuizForm({
    required this.session,
    required this.questions,
  });

  final ReadingSession session;
  final List<QuizQuestion> questions;

  @override
  ConsumerState<_QuizForm> createState() => _QuizFormState();
}

class _QuizFormState extends ConsumerState<_QuizForm> {
  final _answersByQuestionId = <String, int>{};
  QuizResult? _result;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Comprehension Check',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        for (final question in widget.questions) ...[
          _QuestionCard(
            question: question,
            selectedIndex: _answersByQuestionId[question.id],
            onChanged: result == null
                ? (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _answersByQuestionId[question.id] = value;
                    });
                  }
                : null,
          ),
          const SizedBox(height: 12),
        ],
        FilledButton.icon(
          onPressed: result == null && !_isSaving ? _submit : null,
          icon: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
          label: const Text('Submit Quiz'),
        ),
        if (result != null) ...[
          const SizedBox(height: 16),
          Text('Comprehension: ${(result.comprehensionScore * 100).round()}%'),
          Text('${result.correctCount}/${result.totalQuestions} correct'),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: () => context.goNamed('results'),
              icon: const Icon(Icons.assessment),
              label: const Text('View Results'),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _submit() async {
    setState(() {
      _isSaving = true;
    });

    final result = QuizScorer.score(
      id: ref.read(quizResultIdProvider).call(),
      sessionId: widget.session.id,
      passageId: widget.session.passageId,
      questions: widget.questions,
      answersByQuestionId: Map.unmodifiable(_answersByQuestionId),
      completedAt: ref.read(currentDateTimeProvider).call(),
    );
    await ref.read(localDataStoreProvider).saveQuizResult(result);

    if (!mounted) {
      return;
    }

    setState(() {
      _result = result;
      _isSaving = false;
    });
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.selectedIndex,
    required this.onChanged,
  });

  final QuizQuestion question;
  final int? selectedIndex;
  final ValueChanged<int?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.prompt),
            const SizedBox(height: 8),
            for (var index = 0; index < question.options.length; index++)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  selectedIndex == index
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                title: Text(question.options[index]),
                onTap: onChanged == null ? null : () => onChanged!(index),
              ),
          ],
        ),
      ),
    );
  }
}
