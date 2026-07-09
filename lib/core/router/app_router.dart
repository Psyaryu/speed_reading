import 'package:go_router/go_router.dart';

import '../../assessment/presentation/quiz_screen.dart';
import '../../assessment/presentation/results_screen.dart';
import '../../content/domain/passage.dart';
import '../../content/presentation/import_passage_screen.dart';
import '../../content/presentation/library_screen.dart';
import '../../progress/presentation/progress_screen.dart';
import '../../reading/presentation/reader_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../training/presentation/dashboard_screen.dart';
import '../../training/presentation/onboarding_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/library',
      name: 'library',
      builder: (context, state) => const LibraryScreen(),
    ),
    GoRoute(
      path: '/import',
      name: 'import',
      builder: (context, state) {
        final initialPassage = state.extra is Passage
            ? state.extra! as Passage
            : null;
        return ImportPassageScreen(initialPassage: initialPassage);
      },
    ),
    GoRoute(
      path: '/reader',
      name: 'reader',
      builder: (context, state) => const ReaderScreen(),
    ),
    GoRoute(
      path: '/quiz',
      name: 'quiz',
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/results',
      name: 'results',
      builder: (context, state) => const ResultsScreen(),
    ),
    GoRoute(
      path: '/progress',
      name: 'progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
