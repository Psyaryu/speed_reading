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
    final themeMode = profile.maybeWhen(
      data: (profile) => profile.preferredThemeMode,
      orElse: () => LocalThemeMode.system,
    );
    final appTheme = themeMode.toAppTheme();

    return MaterialApp.router(
      title: 'Speed Reading Trainer',
      theme: appTheme.theme,
      darkTheme: appTheme.darkTheme,
      themeMode: appTheme.themeMode,
      builder: (context, child) {
        final reduceMotion = profile.maybeWhen(
          data: (profile) => profile.reducedMotion,
          orElse: () => false,
        );
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: reduceMotion,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: appRouter,
    );
  }
}

extension on LocalThemeMode {
  _ResolvedAppTheme toAppTheme() {
    return switch (this) {
      LocalThemeMode.system => _ResolvedAppTheme(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
        ),
      LocalThemeMode.light => _ResolvedAppTheme(
          theme: AppTheme.light(),
          darkTheme: AppTheme.light(),
          themeMode: ThemeMode.light,
        ),
      LocalThemeMode.dark => _ResolvedAppTheme(
          theme: AppTheme.dark(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.dark,
        ),
      LocalThemeMode.gxCrimson => _ResolvedAppTheme.fixed(AppTheme.gxCrimson()),
      LocalThemeMode.ultraviolet =>
        _ResolvedAppTheme.fixed(AppTheme.ultraviolet()),
      LocalThemeMode.electricCyan =>
        _ResolvedAppTheme.fixed(AppTheme.electricCyan()),
      LocalThemeMode.acidLime => _ResolvedAppTheme.fixed(AppTheme.acidLime()),
      LocalThemeMode.hotMagenta =>
        _ResolvedAppTheme.fixed(AppTheme.hotMagenta()),
    };
  }
}

class _ResolvedAppTheme {
  const _ResolvedAppTheme({
    required this.theme,
    required this.darkTheme,
    required this.themeMode,
  });

  factory _ResolvedAppTheme.fixed(ThemeData theme) {
    return _ResolvedAppTheme(
      theme: theme,
      darkTheme: theme,
      themeMode: ThemeMode.light,
    );
  }

  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;
}
