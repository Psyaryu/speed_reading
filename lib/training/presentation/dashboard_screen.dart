import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../progress/presentation/progress_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(localProfileProvider);
    final history = ref.watch(progressHistoryProvider);

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
              'Local profile ready • ${profile.goals.length} goal selected',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            error: (error, stackTrace) => Text(
              'Profile unavailable: $error',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            loading: () => const LinearProgressIndicator(),
          ),
          const SizedBox(height: 24),
          history.when(
            data: (history) => _ProgressSummary(history: history),
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
  const _ProgressSummary({required this.history});

  final ProgressHistory history;

  @override
  Widget build(BuildContext context) {
    final sessions = history.newestSessions;
    if (sessions.isEmpty) {
      return const Text('No completed sessions yet.');
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
          'Latest Progress',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text('${latest.wpm.round()} WPM - Comprehension: $comprehension'),
      ],
    );
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
