import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../assessment/domain/quiz.dart';
import '../../content/domain/passage_filter.dart';
import '../../core/domain/reading_enums.dart';
import '../../core/providers/app_providers.dart';
import '../../progress/domain/best_qualified_attempt.dart';
import '../../progress/domain/mastery_progress.dart';
import '../../progress/domain/passage_difficulty_distribution.dart';
import '../../progress/domain/progress_trend.dart';
import '../../progress/domain/shareable_progress_summary.dart';
import '../../progress/domain/skill_breakdown.dart';
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

final progressShareableSummaryProvider =
    FutureProvider<ShareableProgressSummary?>((ref) async {
  final history = await ref.watch(progressHistoryProvider.future);
  final passages = await ref.watch(passageRepositoryProvider).search(
        const PassageFilter(),
      );
  return ShareableProgressSummaryBuilder.fromHistory(
    sessions: history.sessions,
    quizResults: history.quizResults,
    passages: passages,
  );
});

final bestQualifiedAttemptProvider =
    FutureProvider<BestQualifiedAttempt?>((ref) async {
  final history = await ref.watch(progressHistoryProvider.future);
  final passages = await ref.watch(passageRepositoryProvider).search(
        const PassageFilter(),
      );
  return BestQualifiedAttemptSelector.fromHistory(
    sessions: history.sessions,
    quizResults: history.quizResults,
    passages: passages,
  );
});

final passageDifficultyDistributionProvider =
    FutureProvider<PassageDifficultyDistribution>((ref) async {
  final history = await ref.watch(progressHistoryProvider.future);
  final passages = await ref.watch(passageRepositoryProvider).search(
        const PassageFilter(),
      );
  return PassageDifficultyDistributionBuilder.fromHistory(
    sessions: history.sessions,
    passages: passages,
  );
});

final progressTrendProvider = FutureProvider<ProgressTrend>((ref) async {
  final history = await ref.watch(progressHistoryProvider.future);
  final passages = await ref.watch(passageRepositoryProvider).search(
        const PassageFilter(),
      );
  return ProgressTrendBuilder.fromHistory(
    sessions: history.sessions,
    quizResults: history.quizResults,
    passages: passages,
  );
});

final skillBreakdownProvider = FutureProvider<SkillBreakdown>((ref) async {
  final history = await ref.watch(progressHistoryProvider.future);
  final questions = await ref.watch(officialQuestionSourceProvider).load();
  return SkillBreakdownBuilder.fromQuizHistory(
    quizResults: history.quizResults,
    questions: questions,
  );
});

final masteryProgressProvider = FutureProvider<MasteryProgress>((ref) async {
  final history = await ref.watch(progressHistoryProvider.future);
  final passages = await ref.watch(passageRepositoryProvider).search(
        const PassageFilter(),
      );
  return MasteryProgressBuilder.fromHistory(
    sessions: history.sessions,
    quizResults: history.quizResults,
    passages: passages,
  );
});

final progressShareProvider = Provider<Future<void> Function(String)>((ref) {
  return (text) async {
    await Share.share(text, subject: 'Speed Reading Progress');
  };
});

class ProgressHistory {
  const ProgressHistory({
    required this.sessions,
    required this.quizResults,
  });

  final List<ReadingSession> sessions;
  final List<QuizResult> quizResults;

  List<ReadingSession> get newestSessions {
    return [...sessions]..sort((a, b) => b.startedAt.compareTo(a.startedAt));
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
    final shareSummary = ref.watch(progressShareableSummaryProvider);
    final bestQualifiedAttempt = ref.watch(bestQualifiedAttemptProvider);
    final difficultyDistribution =
        ref.watch(passageDifficultyDistributionProvider);
    final progressTrend = ref.watch(progressTrendProvider);
    final skillBreakdown = ref.watch(skillBreakdownProvider);
    final masteryProgress = ref.watch(masteryProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: history.when(
        data: (history) => _ProgressBody(
          history: history,
          shareSummary: shareSummary,
          bestQualifiedAttempt: bestQualifiedAttempt,
          difficultyDistribution: difficultyDistribution,
          progressTrend: progressTrend,
          skillBreakdown: skillBreakdown,
          masteryProgress: masteryProgress,
        ),
        error: (error, stackTrace) => Center(
          child: Text('Unable to load progress: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ProgressBody extends ConsumerWidget {
  const _ProgressBody({
    required this.history,
    required this.shareSummary,
    required this.bestQualifiedAttempt,
    required this.difficultyDistribution,
    required this.progressTrend,
    required this.skillBreakdown,
    required this.masteryProgress,
  });

  final ProgressHistory history;
  final AsyncValue<ShareableProgressSummary?> shareSummary;
  final AsyncValue<BestQualifiedAttempt?> bestQualifiedAttempt;
  final AsyncValue<PassageDifficultyDistribution> difficultyDistribution;
  final AsyncValue<ProgressTrend> progressTrend;
  final AsyncValue<SkillBreakdown> skillBreakdown;
  final AsyncValue<MasteryProgress> masteryProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        const SizedBox(height: 16),
        _ProgressTrendCard(trend: progressTrend),
        const SizedBox(height: 16),
        _ShareableProgressCard(
          summary: shareSummary,
          onShare: (summary) {
            ref.read(progressShareProvider).call(summary.toShareText());
          },
        ),
        const SizedBox(height: 16),
        _BestQualifiedAttemptCard(attempt: bestQualifiedAttempt),
        const SizedBox(height: 16),
        _MasteryProgressCard(progress: masteryProgress),
        const SizedBox(height: 16),
        _SkillBreakdownCard(breakdown: skillBreakdown),
        const SizedBox(height: 16),
        _DifficultyDistributionCard(distribution: difficultyDistribution),
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

class _MasteryProgressCard extends StatelessWidget {
  const _MasteryProgressCard({required this.progress});

  final AsyncValue<MasteryProgress> progress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: progress.when(
          data: (progress) {
            final count = progress.immediateCandidateCount;
            final required = progress.requiredPassageCount;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '800 WPM Mastery Progress',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _MetricRow(
                  label: 'Immediate candidates',
                  value: '$count/$required',
                ),
                _MetricRow(
                  label: 'Non-RSVP candidate',
                  value: progress.hasNonRsvpCandidate ? 'Met' : 'Needed',
                ),
                _MetricRow(
                  label: 'Delayed recall',
                  value: progress.delayedRecallTracked
                      ? 'Tracked'
                      : 'Pending - not yet tracked',
                ),
                const SizedBox(height: 4),
                Text(
                  'Requires 3 official standard or hard passages at 800+ WPM '
                  'with 100% immediate comprehension, then delayed recall '
                  'checks at least 24 hours later scoring 90% or better.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (progress.immediateCandidates.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ...progress.immediateCandidates
                      .take(required)
                      .map((candidate) => _MasteryCandidateRow(
                            candidate: candidate,
                          )),
                ],
              ],
            );
          },
          error: (error, stackTrace) => Text(
            'Mastery progress unavailable: $error',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          loading: () => const LinearProgressIndicator(),
        ),
      ),
    );
  }
}

class _MasteryCandidateRow extends StatelessWidget {
  const _MasteryCandidateRow({required this.candidate});

  final MasteryProgressCandidate candidate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(child: Text(candidate.passageTitle)),
          Text(
            '${candidate.wpm.round()} WPM',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ProgressTrendCard extends StatelessWidget {
  const _ProgressTrendCard({required this.trend});

  final AsyncValue<ProgressTrend> trend;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: trend.when(
          data: (trend) {
            if (!trend.hasEnoughData) {
              return const Text(
                'Complete at least two sessions with quizzes to see WPM, '
                'comprehension, and ERS trends.',
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress Trends',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'WPM, comprehension, and ERS over time',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                _TrendHeader(),
                const Divider(height: 16),
                ...trend.points.map((point) => _TrendPointRow(point: point)),
                if (trend.unmatchedSessionCount > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${trend.unmatchedSessionCount} completed quiz session '
                    'could not be matched to a passage.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            );
          },
          error: (error, stackTrace) => Text(
            'Progress trends unavailable: $error',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          loading: () => const LinearProgressIndicator(),
        ),
      ),
    );
  }
}

class _TrendHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium;
    return Row(
      children: [
        Expanded(flex: 2, child: Text('Date', style: style)),
        Expanded(child: Text('WPM', textAlign: TextAlign.end, style: style)),
        Expanded(child: Text('Comp', textAlign: TextAlign.end, style: style)),
        Expanded(child: Text('ERS', textAlign: TextAlign.end, style: style)),
        Expanded(child: Text('Source', textAlign: TextAlign.end, style: style)),
      ],
    );
  }
}

class _TrendPointRow extends StatelessWidget {
  const _TrendPointRow({required this.point});

  final ProgressTrendPoint point;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(_dateLabel(point.startedAt))),
          Expanded(
            child: Text(
              point.wpm.round().toString(),
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            child: Text(
              '${(point.comprehensionScore * 100).round()}%',
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            child: Text(
              point.effectiveReadingScore.round().toString(),
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            child: Text(
              _sourceLabel(point.source),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _dateLabel(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _sourceLabel(PassageSource source) {
    return switch (source) {
      PassageSource.official => 'Official',
      PassageSource.imported => 'Imported',
    };
  }
}

class _SkillBreakdownCard extends StatelessWidget {
  const _SkillBreakdownCard({required this.breakdown});

  final AsyncValue<SkillBreakdown> breakdown;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: breakdown.when(
          data: (breakdown) {
            if (!breakdown.hasAnsweredQuestions) {
              return const Text('Not enough skill data yet.');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skill Breakdown',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...breakdown.entries
                    .where((entry) => entry.answeredCount > 0)
                    .map((entry) => _SkillBreakdownRow(entry: entry)),
                if (breakdown.unmatchedAnswerCount > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${breakdown.unmatchedAnswerCount} answer could not be '
                    'matched to a skill.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            );
          },
          error: (error, stackTrace) => Text(
            'Skill breakdown unavailable: $error',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          loading: () => const LinearProgressIndicator(),
        ),
      ),
    );
  }
}

class _SkillBreakdownRow extends StatelessWidget {
  const _SkillBreakdownRow({required this.entry});

  final SkillBreakdownEntry entry;

  @override
  Widget build(BuildContext context) {
    final accuracyPercent = (entry.accuracy * 100).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(entry.label)),
              Text(
                '$accuracyPercent%',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: entry.accuracy),
          const SizedBox(height: 4),
          Text(
            '${entry.correctCount}/${entry.answeredCount} correct',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _DifficultyDistributionCard extends StatelessWidget {
  const _DifficultyDistributionCard({required this.distribution});

  final AsyncValue<PassageDifficultyDistribution> distribution;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: distribution.when(
          data: (distribution) {
            if (!distribution.hasClassifiedSessions) {
              return const Text('Not enough completed passage data yet.');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Passage Difficulty Distribution',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...distribution.entries.map(
                  (entry) => _DifficultyDistributionRow(
                    entry: entry,
                    totalSessions: distribution.totalClassifiedSessions,
                  ),
                ),
                if (distribution.unmatchedSessionCount > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${distribution.unmatchedSessionCount} completed '
                    'session could not be matched to a passage.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            );
          },
          error: (error, stackTrace) => Text(
            'Difficulty distribution unavailable: $error',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          loading: () => const LinearProgressIndicator(),
        ),
      ),
    );
  }
}

class _DifficultyDistributionRow extends StatelessWidget {
  const _DifficultyDistributionRow({
    required this.entry,
    required this.totalSessions,
  });

  final PassageDifficultyDistributionEntry entry;
  final int totalSessions;

  @override
  Widget build(BuildContext context) {
    final ratio = totalSessions == 0 ? 0.0 : entry.totalCount / totalSessions;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(entry.label)),
              Text(
                '${entry.totalCount}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: ratio),
          const SizedBox(height: 4),
          Text(
            'Official ${entry.officialCount} / Imported ${entry.importedCount}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _BestQualifiedAttemptCard extends StatelessWidget {
  const _BestQualifiedAttemptCard({required this.attempt});

  final AsyncValue<BestQualifiedAttempt?> attempt;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: attempt.when(
          data: (attempt) {
            if (attempt == null) {
              return const Text('No official qualified attempt yet.');
            }

            final comprehensionPercent =
                (attempt.comprehensionScore * 100).round();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Qualified Attempt',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _MetricRow(
                  label: 'Passage',
                  value: attempt.passageTitle,
                ),
                _MetricRow(
                  label: 'WPM',
                  value: attempt.wpm.round().toString(),
                ),
                _MetricRow(
                  label: 'Comprehension',
                  value: '$comprehensionPercent%',
                ),
                _MetricRow(
                  label: 'ERS',
                  value: attempt.effectiveReadingScore.round().toString(),
                ),
                _MetricRow(
                  label: 'Date',
                  value: _dateLabel(attempt.startedAt),
                ),
              ],
            );
          },
          error: (error, stackTrace) => Text(
            'Best qualified attempt unavailable: $error',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          loading: () => const LinearProgressIndicator(),
        ),
      ),
    );
  }

  String _dateLabel(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

class _ShareableProgressCard extends StatelessWidget {
  const _ShareableProgressCard({
    required this.summary,
    required this.onShare,
  });

  final AsyncValue<ShareableProgressSummary?> summary;
  final ValueChanged<ShareableProgressSummary> onShare;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: summary.when(
          data: (summary) {
            if (summary == null) {
              return const Text('No qualified progress summary to share yet.');
            }

            final comprehensionPercent =
                (summary.comprehensionScore * 100).round();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shareable Progress Summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _MetricRow(label: 'Level', value: summary.levelName),
                _MetricRow(
                  label: 'Qualified ERS',
                  value: summary.effectiveReadingScore.round().toString(),
                ),
                _MetricRow(
                  label: 'Qualified Attempt',
                  value: '${summary.qualifiedWpm.round()} WPM / '
                      '$comprehensionPercent%',
                ),
                _MetricRow(
                  label: 'Streak',
                  value: '${summary.streakDays} day',
                ),
                _MetricRow(
                  label: 'Certification',
                  value: summary.certificationStatus,
                ),
                _MetricRow(
                  label: 'Mastery',
                  value: summary.masteryStatus,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: () => onShare(summary),
                    icon: const Icon(Icons.share),
                    label: const Text('Share Progress'),
                  ),
                ),
              ],
            );
          },
          error: (error, stackTrace) => Text(
            'Share summary unavailable: $error',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          loading: () => const LinearProgressIndicator(),
        ),
      ),
    );
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
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
