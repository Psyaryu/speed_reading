import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../domain/local_user_profile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(localProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: profile.when(
        data: (profile) => _SettingsForm(profile: profile),
        error: (error, stackTrace) => Center(
          child: Text('Unable to load settings: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm({required this.profile});

  final LocalUserProfile profile;

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  late double _fontSize;
  late double _lineHeight;
  late bool _reducedMotion;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _applyProfile(widget.profile);
  }

  @override
  void didUpdateWidget(covariant _SettingsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile && !_isSaving) {
      _applyProfile(widget.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Reading Preferences',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        _SliderSetting(
          label: 'Font Size',
          valueLabel: '${_fontSize.round()} pt',
          value: _fontSize,
          min: 14,
          max: 30,
          divisions: 16,
          onChanged: (value) {
            setState(() {
              _fontSize = value;
            });
          },
        ),
        const SizedBox(height: 16),
        _SliderSetting(
          label: 'Line Height',
          valueLabel: _lineHeight.toStringAsFixed(1),
          value: _lineHeight,
          min: 1.2,
          max: 2,
          divisions: 8,
          onChanged: (value) {
            setState(() {
              _lineHeight = value;
            });
          },
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Reduced Motion'),
          subtitle: const Text('Minimize animated reading effects.'),
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
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: const Text('Save Settings'),
          ),
        ),
      ],
    );
  }

  void _applyProfile(LocalUserProfile profile) {
    _fontSize = profile.preferredFontSize;
    _lineHeight = profile.preferredLineHeight;
    _reducedMotion = profile.reducedMotion;
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
    });

    await ref.read(localProfileControllerProvider).updateReadingPreferences(
          preferredFontSize: _fontSize,
          preferredLineHeight: _lineHeight,
          reducedMotion: _reducedMotion,
        );
    ref.invalidate(localProfileProvider);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved.')),
    );
  }
}

class _SliderSetting extends StatelessWidget {
  const _SliderSetting({
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label)),
            Text(valueLabel),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: valueLabel,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
