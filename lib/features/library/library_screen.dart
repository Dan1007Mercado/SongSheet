import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/database/app_database.dart';
import '../import/import_coordinator.dart';
import '../reader/reader_screen.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with WidgetsBindingObserver {
  String? _tree;
  bool _busy = false;
  ImportProgress? _progress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future<void>(() async {
      final tree = await ref.read(storageProvider).persistedTree();
      if (mounted) setState(() => _tree = tree);
      if (tree != null) await _refresh(silent: true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _tree != null && !_busy) {
      _refresh(silent: true);
    }
  }

  Future<void> _chooseFolder() async {
    final tree = await ref.read(storageProvider).chooseManagedTree();
    if (tree == null || !mounted) return;
    setState(() => _tree = tree);
    await _refresh();
  }

  Future<void> _refresh({bool silent = false}) async {
    if (_tree == null || _busy) return;
    setState(() {
      _busy = true;
      _progress = silent
          ? null
          : const ImportProgress(
              completed: 0,
              total: 0,
              message: 'Starting scan…',
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
          '${result.imported} added, ${result.duplicatesDeleted} exact duplicates deleted, ${result.pendingReview} need review'
          '${result.failures.isEmpty ? '' : ', ${result.failures.length} failed'}';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), showCloseIcon: true));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Refresh failed: $error'),
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

  Future<void> _importExternal() async {
    if (_tree == null) return _chooseFolder();
    final storage = ref.read(storageProvider);
    final uri = await storage.pickImage();
    if (uri == null) return;
    try {
      final metadata = await storage.metadata(uri);
      await storage.importIntoManagedTree(uri, metadata.name);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Copied into the managed folder. The external source remains unchanged.',
            ),
          ),
        );
      }
      await _refresh(silent: true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Import failed: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final assets = ref.watch(libraryAssetsProvider);
    final pending = ref.watch(pendingAssetsProvider).valueOrNull?.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song library'),
        actions: [
          if (pending > 0)
            Badge(
              label: Text('$pending'),
              child: IconButton(
                onPressed: _showReviewQueue,
                icon: const Icon(Icons.rate_review_outlined),
                tooltip: 'Review OCR',
              ),
            ),
          IconButton(
            onPressed: _busy ? null : () => _refresh(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh folder',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy ? null : _importExternal,
        icon: const Icon(Icons.add_photo_alternate_outlined),
        label: const Text('Import'),
      ),
      body: Column(
        children: [
          if (_tree == null)
            MaterialBanner(
              content: const Text(
                'Choose a dedicated local folder. Song Sheets will retain read/write access and manage its images in place.',
              ),
              actions: [
                FilledButton(
                  onPressed: _chooseFolder,
                  child: const Text('Choose folder'),
                ),
              ],
            ),
          if (_busy)
            ListTile(
              leading: const CircularProgressIndicator(),
              title: Text(_progress?.message ?? 'Refreshing…'),
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
                hintText: 'Search title or filename',
                isDense: true,
              ),
              onChanged: (value) =>
                  ref.read(libraryQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: assets.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Could not load the library: $error')),
              data: (rows) => rows.isEmpty
                  ? const _EmptyLibrary()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 92),
                      itemCount: rows.length,
                      itemBuilder: (context, index) =>
                          _AssetTile(asset: rows[index]),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewQueue() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ReviewQueueScreen()));
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile({required this.asset});
  final AssetRecord asset;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(
        asset.availabilityState == 'available'
            ? Icons.description_outlined
            : Icons.link_off,
      ),
      title: Text(asset.extractedTitle ?? asset.filename),
      subtitle: Text(
        [
          if (asset.extractedTitle != null) asset.filename,
          if (asset.reviewState == 'pending') 'Needs title review',
          if (asset.availabilityState != 'available')
            'File unavailable — relink needed',
        ].join(' • '),
      ),
      trailing: asset.reviewState == 'pending'
          ? const Icon(Icons.warning_amber_rounded)
          : const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ReaderScreen.standalone(asset: asset),
        ),
      ),
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
          Text('No song sheets yet', style: TextStyle(fontSize: 20)),
          SizedBox(height: 8),
          Text(
            'Add images to your managed folder or use Import, then refresh the library.',
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
    final pending = ref.watch(pendingAssetsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Review recognized titles')),
      body: pending.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (assets) => assets.isEmpty
            ? const Center(child: Text('Everything has been reviewed.'))
            : ListView.builder(
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  return ListTile(
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
                    onTap: () => _review(context, ref, asset),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _review(
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
