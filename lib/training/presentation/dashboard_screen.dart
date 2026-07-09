import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../assessment/domain/quiz.dart';
import '../../content/domain/passage.dart';
import '../../content/domain/passage_filter.dart';
import '../../core/domain/reading_enums.dart';
import '../../core/providers/app_providers.dart';
import '../../progress/domain/effective_reading_score.dart';
import '../../progress/domain/progress_trend.dart';
import '../../progress/domain/progression.dart';
import '../../progress/presentation/progress_screen.dart';
import '../../reading/domain/reading_session.dart';
import '../domain/training_recommendation.dart';

final dashboardProgressSummaryProvider =
    FutureProvider<DashboardProgressSummary>((ref) async {
  final store = ref.watch(localDataStoreProvider);
  final repository = ref.watch(passageRepositoryProvider);
  final sessions = await store.loadReadingSessions();
  final quizResults = await store.loadQuizResults();
  final passages = await repository.search(const PassageFilter());
  final questions = await ref.watch(officialQuestionSourceProvider).load();

  return DashboardProgressSummary.from(
    history: ProgressHistory(
      sessions: sessions,
      quizResults: quizResults,
    ),
    passages: passages,
    questions: questions,
  );
});

class DashboardProgressSummary {
  const DashboardProgressSummary({
    required this.history,
    required this.level,
    required this.levelName,
    required this.bestQualifiedErs,
    required this.readinessPercent,
    required this.ersTrendSummary,
    required this.streakDays,
    required this.recommendedDrill,
    required this.practicePlanItems,
  });

  final ProgressHistory history;
  final int level;
  final String levelName;
  final double bestQualifiedErs;
  final double readinessPercent;
  final String ersTrendSummary;
  final int streakDays;
  final TrainingDrill recommendedDrill;
  final List<String> practicePlanItems;

  factory DashboardProgressSummary.from({
    required ProgressHistory history,
    required List<Passage> passages,
    List<QuizQuestion> questions = const [],
  }) {
    final passagesById = {
      for (final passage in passages) passage.id: passage,
    };
    var bestQualifiedErs = 0.0;

    for (final session in history.sessions) {
      final quiz = history.quizForSession(session.id);
      final passage = passagesById[session.passageId];
      if (quiz == null || passage == null) {
        continue;
      }

      final input = QualifiedAttemptInput(
        wpm: session.wpm,
        comprehensionScore: quiz.comprehensionScore,
        wordCount: session.wordCount,
        difficulty: passage.metadata.difficulty,
        status: session.status,
        excessivePausing: session.pauseCount > 3,
      );
      if (!Progression.isQualifiedAttempt(input)) {
        continue;
      }

      final ers = EffectiveReadingScore.calculate(
        wpm: session.wpm,
        comprehensionScore: quiz.comprehensionScore,
        difficulty: passage.metadata.difficulty,
        mode: session.mode,
      );
      if (ers > bestQualifiedErs) {
        bestQualifiedErs = ers;
      }
    }

    final level = Progression.levelForQualifiedErs(bestQualifiedErs);
    final trend = ProgressTrendBuilder.fromHistory(
      sessions: history.sessions,
      quizResults: history.quizResults,
      passages: passages,
    );
    final recommendedDrill = _recommendedDrillFor(
      history,
      questions,
    );
    return DashboardProgressSummary(
      history: history,
      level: level,
      levelName: Progression.levelName(level),
      bestQualifiedErs: bestQualifiedErs,
      readinessPercent: Progression.readinessPercent(bestQualifiedErs),
      ersTrendSummary: _ersTrendSummary(trend),
      streakDays: _currentStreakDays(history.sessions),
      recommendedDrill: recommendedDrill,
      practicePlanItems: _practicePlanFor(recommendedDrill),
    );
  }

  static String _ersTrendSummary(ProgressTrend trend) {
    if (!trend.hasEnoughData) {
      return 'ERS trend: complete two sessions with quizzes to compare.';
    }

    final latest = trend.points.last;
    final previous = trend.points[trend.points.length - 2];
    final delta = latest.effectiveReadingScore - previous.effectiveReadingScore;
    if (delta.abs() < 0.5) {
      return 'ERS trend: steady from previous session.';
    }

    final direction = delta > 0 ? 'up' : 'down';
    return 'ERS trend: $direction ${delta.abs().round()} from previous session.';
  }

  static int _currentStreakDays(List<ReadingSession> sessions) {
    final completedPracticeDays = sessions
        .where((session) {
          return switch (session.status) {
            AttemptQualificationStatus.qualified ||
            AttemptQualificationStatus.unqualified =>
              true,
            AttemptQualificationStatus.interrupted ||
            AttemptQualificationStatus.incomplete =>
              false,
          };
        })
        .map(
          (session) => DateTime.utc(
            session.startedAt.year,
            session.startedAt.month,
            session.startedAt.day,
          ),
        )
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (completedPracticeDays.isEmpty) {
      return 0;
    }

    var streak = 1;
    var expectedPreviousDay =
        completedPracticeDays.first.subtract(const Duration(days: 1));
    for (final day in completedPracticeDays.skip(1)) {
      if (day != expectedPreviousDay) {
        break;
      }
      streak += 1;
      expectedPreviousDay = expectedPreviousDay.subtract(
        const Duration(days: 1),
      );
    }

    return streak;
  }

  static TrainingDrill _recommendedDrillFor(
    ProgressHistory history,
    List<QuizQuestion> questions,
  ) {
    return TrainingRecommendationEngine.recommend(
      TrainingRecommendationInput.fromHistory(
        sessions: history.sessions,
        quizResults: history.quizResults,
        questions: questions,
      ),
    );
  }

  static List<String> _practicePlanFor(TrainingDrill drill) {
    return [
      'Warm up with 5 minutes of paced reading.',
      'Run one ${drill.displayName.toLowerCase()} drill.',
      'Finish with a comprehension quiz and review misses.',
    ];
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(localProfileProvider);
    final progressSummary = ref.watch(dashboardProgressSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Speed Reading Trainer')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comprehension-first speed reading practice starts here.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          profile.when(
            data: (profile) => Text(
              'Local profile ready - ${profile.goals.length} goal selected',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            error: (error, stackTrace) => Text(
              'Profile unavailable: $error',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            loading: () => const LinearProgressIndicator(),
          ),
          const SizedBox(height: 24),
          progressSummary.when(
            data: (summary) => _ProgressSummary(summary: summary),
            error: (error, stackTrace) => Text(
              'Progress unavailable: $error',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            loading: () => const LinearProgressIndicator(),
          ),
          const SizedBox(height: 24),
          _DashboardTile(
            title: 'Library',
            subtitle: 'Browse adventure passages and local imports.',
            icon: Icons.menu_book,
            onTap: () => context.goNamed('library'),
          ),
          _DashboardTile(
            title: 'Import Passage',
            subtitle: 'Paste text and store it locally for practice.',
            icon: Icons.post_add,
            onTap: () => context.goNamed('import'),
          ),
          _DashboardTile(
            title: 'Reader',
            subtitle: 'Manual, paced, RSVP, skim, and scan modes.',
            icon: Icons.speed,
            onTap: () => context.goNamed('reader'),
          ),
          _DashboardTile(
            title: 'Progress',
            subtitle: 'Track WPM, comprehension, ERS, and levels.',
            icon: Icons.insights,
            onTap: () => context.goNamed('progress'),
          ),
          _DashboardTile(
            title: 'Settings',
            subtitle: 'Adjust local preferences and exports.',
            icon: Icons.settings,
            onTap: () => context.goNamed('settings'),
          ),
        ],
      ),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({required this.summary});

  final DashboardProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    final history = summary.history;
    final sessions = history.newestSessions;
    if (sessions.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('No completed sessions yet.'),
          const SizedBox(height: 16),
          _PracticePlan(summary: summary),
        ],
      );
    }

    final latest = sessions.first;
    final quiz = history.quizForSession(latest.id);
    final comprehension = quiz == null
        ? 'Pending quiz'
        : '${(quiz.comprehensionScore * 100).round()}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '800 WPM Readiness',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text('Level ${summary.level}: ${summary.levelName}'),
        Text(
          'Readiness: ${summary.readinessPercent.round()}% '
          '(${summary.bestQualifiedErs.round()} qualified ERS)',
        ),
        Text(summary.ersTrendSummary),
        Text(
          'Practice streak: ${summary.streakDays} '
          '${summary.streakDays == 1 ? 'day' : 'days'}',
        ),
        Text('${latest.wpm.round()} WPM - Comprehension: $comprehension'),
        const SizedBox(height: 16),
        _PracticePlan(summary: summary),
      ],
    );
  }
}

class _PracticePlan extends StatelessWidget {
  const _PracticePlan({required this.summary});

  final DashboardProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Practice Plan',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ...summary.practicePlanItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(item),
          ),
        ),
        const SizedBox(height: 12),
        Text('Recommended next drill: ${summary.recommendedDrill.displayName}'),
      ],
    );
  }
}

extension on TrainingDrill {
  String get displayName {
    return switch (this) {
      TrainingDrill.pacedReading => 'Paced Reading',
      TrainingDrill.chunking => 'Chunking',
      TrainingDrill.regressionControl => 'Regression Control',
      TrainingDrill.subvocalizationAwareness => 'Subvocalization Awareness',
      TrainingDrill.skimming => 'Skimming',
      TrainingDrill.scanning => 'Scanning',
      TrainingDrill.rsvp => 'RSVP Practice',
      TrainingDrill.comprehensionReview => 'Comprehension Review',
      TrainingDrill.nonRsvpTransfer => 'Non-RSVP Transfer',
    };
  }
}

class _DashboardTile extends StatelessWidget {
  const _DashboardTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
