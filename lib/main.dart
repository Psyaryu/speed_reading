import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_providers.dart';
import 'settings/domain/local_user_profile.dart';

void main() {
  runApp(const ProviderScope(child: SpeedReadingApp()));
}

class SpeedReadingApp extends ConsumerWidget {
  const SpeedReadingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(localProfileProvider);

    return MaterialApp.router(
      title: 'Speed Reading Trainer',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: profile.maybeWhen(
        data: (profile) => profile.preferredThemeMode.toMaterialThemeMode(),
        orElse: () => ThemeMode.system,
      ),
      routerConfig: appRouter,
    );
  }
}

extension on LocalThemeMode {
  ThemeMode toMaterialThemeMode() {
    return switch (this) {
      LocalThemeMode.system => ThemeMode.system,
      LocalThemeMode.light => ThemeMode.light,
      LocalThemeMode.dark => ThemeMode.dark,
    };
  }
}
