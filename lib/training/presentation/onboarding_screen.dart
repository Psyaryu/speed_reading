import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/domain/reading_enums.dart';
import '../../core/providers/app_providers.dart';
import '../../core/widgets/app_back_button.dart';
import '../../settings/domain/local_user_profile.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _selectedGoals = <TrainingGoal>{TrainingGoal.generalImprovement};
  double _fontSize = 18;
  LocalThemeMode _themeMode = LocalThemeMode.system;
  bool _reducedMotion = false;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Onboarding'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Speed with proof',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Progress requires reading speed plus comprehension. Standard advancement starts at 70% comprehension on qualifying passages.',
          ),
          const SizedBox(height: 8),
          const Text(
            '800 WPM is the mastery aspiration, not a shortcut: fast attempts only count when comprehension holds up.',
          ),
          const SizedBox(height: 24),
          Text(
            'Training Goals',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          for (final goal in TrainingGoal.values)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_goalLabel(goal)),
              value: _selectedGoals.contains(goal),
              onChanged: (selected) {
                setState(() {
                  if (selected == true) {
                    _selectedGoals.add(goal);
                  } else {
                    _selectedGoals.remove(goal);
                  }
                });
              },
            ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Text('Reader Font Size')),
              Text('${_fontSize.round()} pt'),
            ],
          ),
          Slider(
            value: _fontSize,
            min: 14,
            max: 30,
            divisions: 16,
            label: '${_fontSize.round()} pt',
            onChanged: (value) {
              setState(() {
                _fontSize = value;
              });
            },
          ),
          const SizedBox(height: 16),
          SegmentedButton<LocalThemeMode>(
            segments: const [
              ButtonSegment(
                value: LocalThemeMode.system,
                icon: Icon(Icons.devices),
                label: Text('System'),
              ),
              ButtonSegment(
                value: LocalThemeMode.light,
                icon: Icon(Icons.light_mode),
                label: Text('Light'),
              ),
              ButtonSegment(
                value: LocalThemeMode.dark,
                icon: Icon(Icons.dark_mode),
                label: Text('Dark'),
              ),
            ],
            selected: {_themeMode},
            onSelectionChanged: (selection) {
              setState(() {
                _themeMode = selection.single;
              });
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Reduced Motion'),
            value: _reducedMotion,
            onChanged: (value) {
              setState(() {
                _reducedMotion = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: _isSaving ? null : _complete,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: const Text('Start Training'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _complete() async {
    setState(() {
      _isSaving = true;
    });

    await ref.read(localProfileControllerProvider).updateOnboarding(
          goals: _selectedGoals.toList(growable: false),
          preferredFontSize: _fontSize,
          preferredThemeMode: _themeMode,
          reducedMotion: _reducedMotion,
        );
    ref.invalidate(localProfileProvider);

    if (!mounted) {
      return;
    }
    context.goNamed('dashboard');
  }

  String _goalLabel(TrainingGoal goal) {
    return switch (goal) {
      TrainingGoal.school => 'School',
      TrainingGoal.work => 'Work',
      TrainingGoal.exam => 'Exam',
      TrainingGoal.personalLearning => 'Personal Learning',
      TrainingGoal.generalImprovement => 'General Improvement',
    };
  }
}
