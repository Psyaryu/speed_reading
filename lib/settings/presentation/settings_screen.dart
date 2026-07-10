import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/providers/app_providers.dart';
import '../../core/widgets/app_back_button.dart';
import '../domain/local_user_profile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(localProfileProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Settings'),
      ),
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
  late double _columnWidth;
  late LocalThemeMode _themeMode;
  late bool _reducedMotion;
  bool _isSaving = false;
  bool _isResetting = false;
  bool _isExporting = false;
  String? _exportText;
  _ExportFormat? _exportFormat;

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
        const SizedBox(height: 16),
        _SliderSetting(
          label: 'Column Width',
          valueLabel: '${_columnWidth.round()} px',
          value: _columnWidth,
          min: 520,
          max: 920,
          divisions: 8,
          onChanged: (value) {
            setState(() {
              _columnWidth = value;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<LocalThemeMode>(
          initialValue: _themeMode,
          decoration: const InputDecoration(
            labelText: 'Theme',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
              value: LocalThemeMode.system,
              child: Text('System'),
            ),
            DropdownMenuItem(
              value: LocalThemeMode.light,
              child: Text('Light'),
            ),
            DropdownMenuItem(
              value: LocalThemeMode.dark,
              child: Text('Dark'),
            ),
          ],
          onChanged: (value) {
            if (value == null) {
              return;
            }
            setState(() {
              _themeMode = value;
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
        const SizedBox(height: 32),
        Text(
          'Data',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: _isResetting ? null : _confirmResetProgress,
            icon: _isResetting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline),
            label: const Text('Reset Progress'),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed:
                  _isExporting ? null : () => _exportData(_ExportFormat.json),
              icon: const Icon(Icons.data_object),
              label: const Text('Export JSON'),
            ),
            OutlinedButton.icon(
              onPressed:
                  _isExporting ? null : () => _exportData(_ExportFormat.csv),
              icon: const Icon(Icons.table_chart),
              label: const Text('Export CSV'),
            ),
          ],
        ),
        if (_isExporting) ...[
          const SizedBox(height: 12),
          const LinearProgressIndicator(),
        ],
        if (_exportText != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Export Preview',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton.icon(
                onPressed: _shareExport,
                icon: const Icon(Icons.ios_share),
                label: const Text('Share Export'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 220),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: SelectableText(
                _exportText!,
                key: const ValueKey('settings-export-preview-text'),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _applyProfile(LocalUserProfile profile) {
    _fontSize = profile.preferredFontSize;
    _lineHeight = profile.preferredLineHeight;
    _columnWidth = profile.preferredColumnWidth;
    _themeMode = profile.preferredThemeMode;
    _reducedMotion = profile.reducedMotion;
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
    });

    await ref.read(localProfileControllerProvider).updateReadingPreferences(
          preferredFontSize: _fontSize,
          preferredLineHeight: _lineHeight,
          preferredColumnWidth: _columnWidth,
          preferredThemeMode: _themeMode,
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

  Future<void> _confirmResetProgress() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset progress?'),
        content: const Text(
          'This clears sessions, quiz results, progress snapshots, and certification attempts. Imported passages and settings stay on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (shouldReset != true) {
      return;
    }

    setState(() {
      _isResetting = true;
    });

    await ref.read(localDataStoreProvider).resetProgress();

    if (!mounted) {
      return;
    }

    setState(() {
      _isResetting = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Progress reset.')),
    );
  }

  Future<void> _exportData(_ExportFormat format) async {
    setState(() {
      _isExporting = true;
    });

    final store = ref.read(localDataStoreProvider);
    final exported = switch (format) {
      _ExportFormat.json => await store.exportJson(),
      _ExportFormat.csv => await store.exportCsv(),
    };

    if (!mounted) {
      return;
    }

    setState(() {
      _exportText = exported;
      _exportFormat = format;
      _isExporting = false;
    });
  }

  Future<void> _shareExport() async {
    final exportText = _exportText;
    if (exportText == null) {
      return;
    }

    final label = switch (_exportFormat) {
      _ExportFormat.json => 'JSON',
      _ExportFormat.csv => 'CSV',
      null => 'Progress',
    };
    await Share.share(
      exportText,
      subject: 'Speed Reading $label Export',
    );
  }
}

enum _ExportFormat { json, csv }

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
