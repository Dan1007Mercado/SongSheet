import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/database/app_database.dart';
import '../../core/image_processing/image_tools.dart';
import '../library/library_entry.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen._({
    required this.serviceRecord,
    required this.standaloneAsset,
    required this.libraryEntries,
    required this.initialLibraryEntry,
  });

  factory ReaderScreen.service({required ServiceRecord service}) =>
      ReaderScreen._(
        serviceRecord: service,
        standaloneAsset: null,
        libraryEntries: null,
        initialLibraryEntry: 0,
      );
  factory ReaderScreen.standalone({required AssetRecord asset}) =>
      ReaderScreen._(
        serviceRecord: null,
        standaloneAsset: asset,
        libraryEntries: null,
        initialLibraryEntry: 0,
      );
  factory ReaderScreen.library({
    required List<LibraryEntry> entries,
    required int initialEntry,
  }) => ReaderScreen._(
    serviceRecord: null,
    standaloneAsset: null,
    libraryEntries: entries,
    initialLibraryEntry: initialEntry,
  );

  final ServiceRecord? serviceRecord;
  final AssetRecord? standaloneAsset;
  final List<LibraryEntry>? libraryEntries;
  final int initialLibraryEntry;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderPage {
  const _ReaderPage({
    required this.entryId,
    required this.title,
    required this.pageInEntry,
    this.asset,
  });
  final String entryId;
  final String title;
  final int pageInEntry;
  final AssetRecord? asset;
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final _pageController = PageController();
  List<_ReaderPage>? _pages;
  Object? _error;
  var _index = 0;
  var _vertical = false;
  var _zoomed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      if (widget.libraryEntries != null) {
        final pages = <_ReaderPage>[];
        for (
          var entryIndex = 0;
          entryIndex < widget.libraryEntries!.length;
          entryIndex++
        ) {
          final entry = widget.libraryEntries![entryIndex];
          if (entryIndex < widget.initialLibraryEntry) {
            _index += entry.assets.length;
          }
          for (var page = 0; page < entry.assets.length; page++) {
            pages.add(
              _ReaderPage(
                entryId: entry.id,
                title: entry.title,
                pageInEntry: page,
                asset: entry.assets[page],
              ),
            );
          }
        }
        _pages = pages;
      } else if (widget.standaloneAsset != null) {
        _pages = [
          _ReaderPage(
            entryId: 'standalone',
            title:
                widget.standaloneAsset!.extractedTitle ??
                widget.standaloneAsset!.filename,
            pageInEntry: 0,
            asset: widget.standaloneAsset,
          ),
        ];
      } else {
        final database = ref.read(databaseProvider);
        final entries = await database.entriesForService(
          widget.serviceRecord!.id,
        );
        final pages = <_ReaderPage>[];
        for (final entry in entries) {
          if (entry.editionId == null) {
            pages.add(
              _ReaderPage(
                entryId: entry.id,
                title: entry.requestedTitle,
                pageInEntry: 0,
              ),
            );
            continue;
          }
          final assets = await database.assetsForEdition(entry.editionId!);
          if (assets.isEmpty) {
            pages.add(
              _ReaderPage(
                entryId: entry.id,
                title: entry.requestedTitle,
                pageInEntry: 0,
              ),
            );
          } else {
            for (var page = 0; page < assets.length; page++) {
              pages.add(
                _ReaderPage(
                  entryId: entry.id,
                  title: entry.requestedTitle,
                  pageInEntry: page,
                  asset: assets[page],
                ),
              );
            }
          }
        }
        _pages = pages;
        final progress =
            await (database.select(database.readerProgress)..where(
                  (row) => row.serviceId.equals(widget.serviceRecord!.id),
                ))
                .getSingleOrNull();
        if (progress != null) {
          final restored = pages.indexWhere(
            (page) =>
                page.entryId == progress.entryId &&
                page.pageInEntry == progress.pagePosition,
          );
          if (restored >= 0) _index = restored;
        }
      }
      if (mounted) {
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients && _index > 0) {
            _pageController.jumpToPage(_index);
          }
        });
      }
    } catch (error) {
      if (mounted) setState(() => _error = error);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.serviceRecord?.displayName ??
              (widget.libraryEntries != null ? 'Song Library' : null) ??
              widget.standaloneAsset?.extractedTitle ??
              'Reader',
        ),
        actions: [
          if (pages != null && pages.length > 1)
            IconButton(
              onPressed: () => setState(() => _vertical = !_vertical),
              icon: Icon(
                _vertical
                    ? Icons.view_carousel_outlined
                    : Icons.view_agenda_outlined,
              ),
              tooltip: _vertical ? 'Page mode' : 'Vertical scrolling mode',
            ),
        ],
      ),
      body: _error != null
          ? Center(child: Text('Could not open reader: $_error'))
          : pages == null
          ? const Center(child: CircularProgressIndicator())
          : pages.isEmpty
          ? const Center(child: Text('This collection has no entries.'))
          : _vertical
          ? ListView.builder(
              itemCount: pages.length,
              cacheExtent: MediaQuery.sizeOf(context).height * 2,
              itemBuilder: (context, index) => SizedBox(
                height: MediaQuery.sizeOf(context).height * .82,
                child: _PageViewContent(
                  page: pages[index],
                  onRelink: pages[index].asset == null
                      ? null
                      : () => _relink(index),
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: _zoomed
                        ? const NeverScrollableScrollPhysics()
                        : const PageScrollPhysics(),
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _index = index;
                        _zoomed = false;
                      });
                      _saveProgress(pages[index]);
                    },
                    itemBuilder: (context, index) => _PageViewContent(
                      page: pages[index],
                      onZoomChanged: (zoomed) {
                        if (_zoomed != zoomed) setState(() => _zoomed = zoomed);
                      },
                      onRelink: pages[index].asset == null
                          ? null
                          : () => _relink(index),
                    ),
                  ),
                ),
                _NavigationBar(
                  current: _index,
                  total: pages.length,
                  title: pages[_index].title,
                  pageInSong: pages[_index].pageInEntry + 1,
                  onPreviousPage: _index == 0 ? null : () => _go(_index - 1),
                  onNextPage: _index == pages.length - 1
                      ? null
                      : () => _go(_index + 1),
                  onPreviousSong: _previousSong(pages),
                  onNextSong: _nextSong(pages),
                ),
              ],
            ),
    );
  }

  VoidCallback? _previousSong(List<_ReaderPage> pages) {
    final entry = pages[_index].entryId;
    for (var index = _index - 1; index >= 0; index--) {
      if (pages[index].entryId != entry) {
        final previousEntry = pages[index].entryId;
        while (index > 0 && pages[index - 1].entryId == previousEntry) {
          index--;
        }
        final target = index;
        return () => _go(target);
      }
    }
    return null;
  }

  VoidCallback? _nextSong(List<_ReaderPage> pages) {
    final entry = pages[_index].entryId;
    for (var index = _index + 1; index < pages.length; index++) {
      if (pages[index].entryId != entry) return () => _go(index);
    }
    return null;
  }

  void _go(int index) => _pageController.animateToPage(
    index,
    duration: const Duration(milliseconds: 220),
    curve: Curves.easeOut,
  );

  Future<void> _saveProgress(_ReaderPage page) async {
    if (widget.serviceRecord == null) return;
    await ref
        .read(databaseProvider)
        .into(ref.read(databaseProvider).readerProgress)
        .insertOnConflictUpdate(
          ReaderProgressCompanion.insert(
            serviceId: widget.serviceRecord!.id,
            entryId: page.entryId,
            pagePosition: Value(page.pageInEntry),
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<void> _relink(int index) async {
    final page = _pages![index];
    final asset = page.asset!;
    final storage = ref.read(storageProvider);
    final source = await storage.pickImage();
    if (source == null) return;
    try {
      final sourceMetadata = await storage.metadata(source);
      final database = ref.read(databaseProvider);
      final destinations = await database.select(database.sourceFolders).get();
      if (destinations.isEmpty) {
        throw StateError(
          'Add a writable source folder in Settings before relinking.',
        );
      }
      final newUri = await storage.importIntoTree(
        source,
        sourceMetadata.name,
        destinations.first.treeUri,
      );
      if (newUri == null) return;
      final bytes = await storage.readBytes(newUri);
      final facts = await Isolate.run(() => inspectDecodedPixels(bytes));
      final metadata = await storage.metadata(
        newUri,
        parentUri: destinations.first.treeUri,
      );
      final discovery =
          await (database.select(database.discoveryLedger)
                ..where((row) => row.currentUri.equals(asset.documentUri)))
              .getSingleOrNull();
      await (database.update(
        database.sheetAssets,
      )..where((row) => row.id.equals(asset.id))).write(
        SheetAssetsCompanion(
          documentUri: Value(newUri),
          filename: Value(metadata.name),
          mimeType: Value(metadata.mimeType),
          byteSize: Value(bytes.length),
          sha256: Value(sha256.convert(bytes).toString()),
          pixelFingerprint: Value(facts.pixelFingerprint),
          width: Value(facts.width),
          height: Value(facts.height),
          availabilityState: const Value('available'),
          contentFingerprint: Value(
            '${metadata.size}:${metadata.lastModified?.millisecondsSinceEpoch ?? 0}',
          ),
          updatedAt: Value(DateTime.now()),
        ),
      );
      if (discovery != null) {
        await (database.update(
          database.discoveryLedger,
        )..where((row) => row.id.equals(discovery.id))).write(
          DiscoveryLedgerCompanion(
            stableIdentity: Value(metadata.stableIdentity),
            sourceFolderId: Value(destinations.first.id),
            documentUri: Value(newUri),
            currentUri: Value(newUri),
            parentUri: Value(metadata.parentUri),
            filename: Value(metadata.name),
            metadataFingerprint: Value(
              '${metadata.size}:${metadata.lastModified?.millisecondsSinceEpoch ?? 0}',
            ),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
      final updated = await (database.select(
        database.sheetAssets,
      )..where((row) => row.id.equals(asset.id))).getSingle();
      setState(() {
        final pages = [..._pages!];
        pages[index] = _ReaderPage(
          entryId: page.entryId,
          title: page.title,
          pageInEntry: page.pageInEntry,
          asset: updated,
        );
        _pages = pages;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Relinked. The selected external source remains unchanged.',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Relink failed: $error')));
      }
    }
  }
}

class _PageViewContent extends ConsumerStatefulWidget {
  const _PageViewContent({
    required this.page,
    this.onZoomChanged,
    this.onRelink,
  });
  final _ReaderPage page;
  final ValueChanged<bool>? onZoomChanged;
  final VoidCallback? onRelink;

  @override
  ConsumerState<_PageViewContent> createState() => _PageViewContentState();
}

class _PageViewContentState extends ConsumerState<_PageViewContent> {
  late final TransformationController _transformation =
      TransformationController();

  @override
  void dispose() {
    _transformation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.page.asset;
    if (asset == null) {
      return _MissingPage(
        title: widget.page.title,
        message: 'No matching edition is linked to this service slot.',
      );
    }
    return FutureBuilder(
      future: ref.read(storageProvider).readBytes(asset.documentUri),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return _MissingPage(
            title: widget.page.title,
            message: 'The image is unavailable or access was revoked.',
            onRelink: widget.onRelink,
          );
        }
        return InteractiveViewer(
          transformationController: _transformation,
          minScale: 1,
          maxScale: 6,
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(80),
          onInteractionUpdate: (_) => widget.onZoomChanged?.call(
            _transformation.value.getMaxScaleOnAxis() > 1.03,
          ),
          onInteractionEnd: (_) => widget.onZoomChanged?.call(
            _transformation.value.getMaxScaleOnAxis() > 1.03,
          ),
          child: Center(
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.contain,
              gaplessPlayback: true,
            ),
          ),
        );
      },
    );
  }
}

class _MissingPage extends StatelessWidget {
  const _MissingPage({
    required this.title,
    required this.message,
    this.onRelink,
  });
  final String title;
  final String message;
  final VoidCallback? onRelink;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.image_not_supported_outlined, size: 64),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          if (onRelink != null) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRelink,
              icon: const Icon(Icons.link),
              label: const Text('Relink image'),
            ),
          ],
        ],
      ),
    ),
  );
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.current,
    required this.total,
    required this.title,
    required this.pageInSong,
    this.onPreviousPage,
    this.onNextPage,
    this.onPreviousSong,
    this.onNextSong,
  });
  final int current;
  final int total;
  final String title;
  final int pageInSong;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final VoidCallback? onPreviousSong;
  final VoidCallback? onNextSong;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Row(
      children: [
        IconButton(
          onPressed: onPreviousSong,
          icon: const Icon(Icons.skip_previous),
          tooltip: 'Previous song',
        ),
        IconButton(
          onPressed: onPreviousPage,
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Previous page',
        ),
        Expanded(
          child: Text(
            '$title • page $pageInSong • ${current + 1}/$total',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: onNextPage,
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Next page',
        ),
        IconButton(
          onPressed: onNextSong,
          icon: const Icon(Icons.skip_next),
          tooltip: 'Next song',
        ),
      ],
    ),
  );
}
