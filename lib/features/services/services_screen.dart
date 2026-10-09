import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../core/database/app_database.dart';
import '../reader/reader_screen.dart';
import 'service_coordinator.dart';
import 'song_matcher.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  bool _busy = false;

  Future<void> _create() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(Duration(days: (DateTime.sunday - now.weekday) % 7)),
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 5),
      helpText: 'Choose service date',
    );
    if (date == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final draft = await ref
          .read(serviceCoordinatorProvider)
          .recognizeFromPicker(date);
      if (draft != null && mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ServiceDraftScreen(initialDraft: draft),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not read the song list: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(servicesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy ? null : _create,
        icon: _busy
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.document_scanner_outlined),
        label: const Text('Create service'),
      ),
      body: services.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Could not load services: $error')),
        data: (rows) => rows.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Create a service, choose its date, and select a photographed song list.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 92),
                itemCount: rows.length,
                itemBuilder: (context, index) =>
                    _ServiceTile(service: rows[index]),
              ),
      ),
    );
  }
}

class _ServiceTile extends ConsumerWidget {
  const _ServiceTile({required this.service});
  final ServiceRecord service;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Card(
    child: ListTile(
      leading: const Icon(Icons.calendar_month_outlined),
      title: Text(service.displayName),
      subtitle: Text(DateFormat.yMMMMEEEEd().format(service.localDate)),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ReaderScreen.service(service: service),
        ),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) async {
          if (value != 'delete') return;
          final accepted = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete collection?'),
              content: const Text(
                'The virtual collection will be deleted. Master song-sheet images will not be touched.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
          if (accepted == true) {
            await ref
                .read(serviceCoordinatorProvider)
                .deleteCollection(service.id);
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'delete', child: Text('Delete collection')),
        ],
      ),
    ),
  );
}

class ServiceDraftScreen extends ConsumerStatefulWidget {
  const ServiceDraftScreen({super.key, required this.initialDraft});
  final ServiceDraft initialDraft;

  @override
  ConsumerState<ServiceDraftScreen> createState() => _ServiceDraftScreenState();
}

class _ServiceDraftScreenState extends ConsumerState<ServiceDraftScreen> {
  late ServiceDraft _draft = widget.initialDraft;
  bool _saving = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Sunday ${DateFormat('yyyy-MM-dd').format(_draft.date)}'),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: const Icon(Icons.check_circle_outline, size: 18),
                label: Text('${_draft.matched} matched'),
              ),
              Chip(
                avatar: const Icon(Icons.help_outline, size: 18),
                label: Text('${_draft.ambiguous} ambiguous'),
              ),
              Chip(
                avatar: const Icon(Icons.remove_circle_outline, size: 18),
                label: Text('${_draft.missing} missing'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _draft.entries.isEmpty
              ? const Center(
                  child: Text(
                    'No ordered song rows were recognized. Try a clearer list image.',
                  ),
                )
              : ReorderableListView.builder(
                  itemCount: _draft.entries.length,
                  onReorder: _reorder,
                  itemBuilder: (context, index) => _DraftTile(
                    key: ValueKey(_draft.entries[index]),
                    entry: _draft.entries[index],
                    onEdit: () => _edit(index),
                    onSelectCandidate: (id) => setState(() {
                      _draft = ref
                          .read(serviceCoordinatorProvider)
                          .selectEdition(_draft, index, id);
                    }),
                  ),
                ),
        ),
        SafeArea(
          top: false,
          minimum: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed:
                  _saving || _draft.entries.isEmpty || _draft.ambiguous > 0
                  ? null
                  : _save,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                _draft.ambiguous > 0
                    ? 'Resolve ambiguous songs to save'
                    : 'Save virtual collection',
              ),
            ),
          ),
        ),
      ],
    ),
  );

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final entries = [..._draft.entries];
      final moved = entries.removeAt(oldIndex);
      entries.insert(newIndex, moved);
      _draft = ServiceDraft(
        date: _draft.date,
        entries: [
          for (var index = 0; index < entries.length; index++)
            ServiceDraftEntry(position: index, match: entries[index].match),
        ],
      );
    });
  }

  Future<void> _edit(int index) async {
    final old = _draft.entries[index].match.line;
    final title = TextEditingController(text: old.text);
    final key = TextEditingController(text: old.requestedKey);
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review song-list row'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Requested title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: key,
              decoration: const InputDecoration(
                labelText: 'Requested key (optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Match again'),
          ),
        ],
      ),
    );
    if (accepted != true || title.text.trim().isEmpty) return;
    final next = await ref
        .read(serviceCoordinatorProvider)
        .rematch(
          _draft,
          index,
          title.text,
          requestedKey: key.text.trim().isEmpty ? null : key.text.trim(),
        );
    if (mounted) setState(() => _draft = next);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(serviceCoordinatorProvider).save(_draft);
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not save: $error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _DraftTile extends StatelessWidget {
  const _DraftTile({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onSelectCandidate,
  });
  final ServiceDraftEntry entry;
  final VoidCallback onEdit;
  final ValueChanged<String> onSelectCandidate;

  @override
  Widget build(BuildContext context) {
    final status = entry.match.status;
    final color = switch (status) {
      MatchStatus.matched => Colors.green,
      MatchStatus.ambiguous => Colors.orange,
      MatchStatus.missing => Colors.red,
    };
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${entry.position + 1}')),
        title: Text(entry.match.line.text),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${status.name}${entry.match.line.requestedKey == null ? '' : ' • key ${entry.match.line.requestedKey}'}',
              style: TextStyle(color: color),
            ),
            if (status == MatchStatus.ambiguous)
              Wrap(
                spacing: 6,
                children: entry.match.candidateEditionIds
                    .map(
                      (id) => ActionChip(
                        label: Text('Edition ${id.substring(0, 6)}'),
                        onPressed: () => onSelectCandidate(id),
                      ),
                    )
                    .toList(),
              ),
            if (status == MatchStatus.missing)
              const Text(
                'This labeled empty slot will be kept in the collection.',
              ),
          ],
        ),
        trailing: IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Edit and rematch',
        ),
      ),
    );
  }
}
