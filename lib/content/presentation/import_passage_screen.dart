import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/imported_passage_factory.dart';
import '../../../core/providers/app_providers.dart';

final importedPassageIdProvider = Provider<String Function()>((ref) {
  return () => DateTime.now().microsecondsSinceEpoch.toString();
});

class ImportPassageScreen extends ConsumerStatefulWidget {
  const ImportPassageScreen({super.key});

  @override
  ConsumerState<ImportPassageScreen> createState() => _ImportPassageScreenState();
}

class _ImportPassageScreenState extends ConsumerState<ImportPassageScreen> {
  final _titleController = TextEditingController();
  final _sourceController = TextEditingController();
  final _tagsController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _sourceController.dispose();
    _tagsController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Passage')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _sourceController,
            decoration: const InputDecoration(labelText: 'Source'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tagsController,
            decoration: const InputDecoration(
              labelText: 'Tags',
              hintText: 'adventure, exam, work',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bodyController,
            minLines: 8,
            maxLines: 16,
            decoration: const InputDecoration(
              labelText: 'Passage text',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving' : 'Save Passage'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final body = _bodyController.text.trim();
    if (body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passage text is required.')),
      );
      return;
    }

    setState(() => _saving = true);
    final tags = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList(growable: false);
    final passage = ImportedPassageFactory.create(
      id: ref.read(importedPassageIdProvider)(),
      title: _titleController.text,
      body: body,
      sourceLabel: _sourceController.text,
      tags: tags,
    );

    await ref.read(passageRepositoryProvider).saveImportedPassage(passage);
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Passage saved.')),
    );
  }
}
