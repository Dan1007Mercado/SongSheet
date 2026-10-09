import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/database/app_database.dart';
import '../import/import_coordinator.dart';
import '../reader/reader_screen.dart';
import 'library_entry.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool _busy = false;
  ImportProgress? _progress;

  Future<void> _refresh({bool silent = false}) async {
    if (_busy) return;
    final folders = await ref
        .read(databaseProvider)
        .select(ref.read(databaseProvider).sourceFolders)
        .get();
    if (folders.isEmpty) {
      if (!silent && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add an authorized source folder in Settings first.'),
          ),
        );
      }
      return;
    }
    setState(() {
      _busy = true;
      _progress = silent
          ? null
          : const ImportProgress(
              completed: 0,
              total: 0,
              message: 'Starting scoped scan…',
            );
    });
    try {
      final result = await ref
          .read(importCoordinatorProvider)
          .refresh(
            onProgress: (progress) {
              if (mounted) setState(() => _progress = progress);
            },
          );
      if (!mounted || silent) return;
      final message =
          '${result.imported} added, ${result.nonSongSheets} non-sheets skipped, '
          '${result.excluded} outside range, ${result.unchangedSkipped} unchanged, '
          '${result.duplicatesDeleted} exact duplicates deleted, ${result.pendingReview} need review'
          '${result.failures.isEmpty ? '' : ', ${result.failures.length} failed'}';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), showCloseIcon: true));
    } on ScanCancelledException {
      if (mounted && !silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scan stopped: date settings changed. Tap Scan to use the new range.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scoped scan failed: $error'),
            showCloseIcon: true,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _progress = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(libraryEntriesProvider);
    final sourceCount =
        ref.watch(sourceFoldersProvider).valueOrNull?.length ?? 0;
    final pendingTitles =
        ref.watch(pendingAssetsProvider).valueOrNull?.length ?? 0;
    final uncertain =
        ref.watch(uncertainDiscoveriesProvider).valueOrNull?.length ?? 0;
    final reviewCount = pendingTitles + uncertain;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Library'),
        actions: [
          Badge(
            isLabelVisible: reviewCount > 0,
            label: Text('$reviewCount'),
            child: IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ReviewQueueScreen(),
                ),
              ),
              icon: const Icon(Icons.rate_review_outlined),
              tooltip: 'Review classifications and titles',
            ),
          ),
          IconButton(
            onPressed: _busy ? null : () => _refresh(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Scan configured sources',
          ),
        ],
      ),
      body: Column(
        children: [
          if (sourceCount == 0)
            const MaterialBanner(
              content: Text(
                'No source folders are configured. Add one in Settings and choose its date range before scanning.',
              ),
              actions: [SizedBox.shrink()],
            ),
          if (_busy)
            ListTile(
              leading: const CircularProgressIndicator(),
              title: Text(
                _progress?.message ?? 'Comparing lightweight metadata…',
              ),
              subtitle: _progress == null || _progress!.total == 0
                  ? null
                  : LinearProgressIndicator(
                      value: _progress!.completed / _progress!.total,
                    ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search song title or filename',
                isDense: true,
              ),
              onChanged: (value) =>
                  ref.read(libraryQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: entries.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Could not load the library: $error')),
              data: (rows) => rows.isEmpty
                  ? const _EmptyLibrary()
                  : ListView.builder(
                      itemCount: rows.length,
                      itemBuilder: (context, index) => _LibraryTile(
                        entry: rows[index],
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ReaderScreen.library(
                              entries: rows,
                              initialEntry: index,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryTile extends StatelessWidget {
  const _LibraryTile({required this.entry, required this.onTap});
  final LibraryEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const Icon(Icons.description_outlined),
      title: Text(entry.title),
      subtitle: Text(
        [
          if (entry.keyLabel != null) 'Key ${entry.keyLabel}',
          if (entry.versionLabel != null) entry.versionLabel!,
          '${entry.assets.length} page${entry.assets.length == 1 ? '' : 's'}',
          entry.assets.first.filename,
        ].join(' • '),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary();

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.library_music_outlined, size: 64),
          SizedBox(height: 16),
          Text('No recognized song sheets', style: TextStyle(fontSize: 20)),
          SizedBox(height: 8),
          Text(
            'Configure authorized folders and an inclusive date range in Settings, then run a scoped scan.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class ReviewQueueScreen extends ConsumerWidget {
  const ReviewQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveries = ref.watch(uncertainDiscoveriesProvider);
    final rejected = ref.watch(nonSongDiscoveriesProvider);
    final assets = ref.watch(pendingAssetsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Review queue')),
      body: discoveries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (uncertain) => rejected.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
          data: (nonSongs) => assets.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('$error')),
            data: (pending) {
              if (uncertain.isEmpty && nonSongs.isEmpty && pending.isEmpty) {
                return const Center(
                  child: Text('No classifications or titles to review.'),
                );
              }
              return ListView(
                children: [
                  if (uncertain.isNotEmpty)
                    const ListTile(
                      title: Text('Uncertain image classification'),
                    ),
                  for (final discovery in uncertain)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: Text(discovery.filename),
                        subtitle: Text(
                          'Music evidence score ${((discovery.classificationScore ?? 0) * 100).round()}%. Original preserved.',
                        ),
                        trailing: PopupMenuButton<bool>(
                          onSelected: (isSong) async {
                            try {
                              await ref
                                  .read(importCoordinatorProvider)
                                  .confirmClassification(
                                    discovery,
                                    isSongSheet: isSong,
                                  );
                            } catch (error) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Review failed: $error'),
                                  ),
                                );
                              }
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: true,
                              child: Text('Song sheet'),
                            ),
                            PopupMenuItem(
                              value: false,
                              child: Text('Not a song sheet'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (nonSongs.isNotEmpty)
                    const ListTile(
                      title: Text('Classified as not song sheets'),
                    ),
                  for (final discovery in nonSongs)
                    ListTile(
                      leading: const Icon(Icons.image_not_supported_outlined),
                      title: Text(discovery.filename),
                      subtitle: const Text(
                        'Kept unchanged and excluded from the Song Library.',
                      ),
                      trailing: TextButton(
                        onPressed: () =>
                            _correctClassification(context, ref, discovery),
                        child: const Text('This is a song sheet'),
                      ),
                    ),
                  if (pending.isNotEmpty)
                    const ListTile(title: Text('Uncertain title OCR')),
                  for (final asset in pending)
                    ListTile(
                      title: Text(asset.extractedTitle ?? 'Uncertain title'),
                      subtitle: Text(
                        asset.rawOcr?.trim().isEmpty == false
                            ? asset.rawOcr!
                            : asset.filename,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        '${(asset.qualityScore * 100).round()}% score',
                      ),
                      onTap: () => _reviewTitle(context, ref, asset),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _correctClassification(
    BuildContext context,
    WidgetRef ref,
    DiscoveryRecord discovery,
  ) async {
    try {
      await ref
          .read(importCoordinatorProvider)
          .confirmClassification(discovery, isSongSheet: true);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Correction failed: $error')));
      }
    }
  }

  Future<void> _reviewTitle(
    BuildContext context,
    WidgetRef ref,
    AssetRecord asset,
  ) async {
    final title = TextEditingController(text: asset.extractedTitle ?? '');
    final key = TextEditingController();
    final page = TextEditingController(text: '${asset.pageOrder ?? 1}');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm sheet details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: key,
                decoration: const InputDecoration(
                  labelText: 'Printed key (optional)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: page,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Page'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm & rename'),
          ),
        ],
      ),
    );
    if (confirmed != true || title.text.trim().isEmpty || !context.mounted) {
      return;
    }
    try {
      await ref
          .read(importCoordinatorProvider)
          .confirmAsset(
            asset,
            title: title.text,
            keyLabel: key.text.trim().isEmpty ? null : key.text.trim(),
            page: int.tryParse(page.text) ?? 1,
          );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not confirm: $error')));
      }
    }
  }
}
