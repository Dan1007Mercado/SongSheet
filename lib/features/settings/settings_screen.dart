import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../app/providers.dart';
import '../../core/database/app_database.dart';
import '../import/import_coordinator.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;
  ScanConfiguration? _configuration;
  Map<String, dynamic>? _lastScan;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final database = ref.read(databaseProvider);
    var folders = await database.select(database.sourceFolders).get();
    if (folders.isEmpty) {
      final legacy = await ref.read(storageProvider).legacySourceFolder();
      if (legacy != null) {
        await database
            .into(database.sourceFolders)
            .insertOnConflictUpdate(
              SourceFoldersCompanion.insert(
                id: const Uuid().v4(),
                treeUri: legacy.uri,
                displayName: legacy.name,
                addedAt: DateTime.now(),
              ),
            );
        folders = await database.select(database.sourceFolders).get();
      }
    }
    final configuration = await ref
        .read(importCoordinatorProvider)
        .loadConfiguration();
    final rawStatus = await database.setting('last_scan_summary');
    if (!mounted) return;
    setState(() {
      _configuration = configuration;
      if (rawStatus != null) {
        try {
          _lastScan = (jsonDecode(rawStatus) as Map).cast<String, dynamic>();
        } catch (_) {
          _lastScan = null;
        }
      }
    });
  }

  Future<void> _run(Future<String> Function() action) async {
    setState(() => _busy = true);
    try {
      final message = await action();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message), showCloseIcon: true));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Operation failed: $error'),
            showCloseIcon: true,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addFolder() async {
    final folder = await ref.read(storageProvider).chooseSourceFolder();
    if (folder == null) return;
    final database = ref.read(databaseProvider);
    final existing = await (database.select(
      database.sourceFolders,
    )..where((row) => row.treeUri.equals(folder.uri))).getSingleOrNull();
    if (existing == null) {
      await database
          .into(database.sourceFolders)
          .insert(
            SourceFoldersCompanion.insert(
              id: const Uuid().v4(),
              treeUri: folder.uri,
              displayName: folder.name,
              addedAt: DateTime.now(),
            ),
          );
    } else {
      await (database.update(database.sourceFolders)
            ..where((row) => row.id.equals(existing.id)))
          .write(SourceFoldersCompanion(displayName: Value(folder.name)));
    }
  }

  Future<void> _pickStart() async {
    final current = _configuration!;
    final value = await showDatePicker(
      context: context,
      initialDate: current.startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      helpText: 'Inclusive start date',
    );
    if (value == null) return;
    await _saveConfiguration(
      ScanConfiguration(
        startDate: value,
        endDate: current.endDate,
        endAtToday: current.endAtToday,
      ),
    );
  }

  Future<void> _pickEnd() async {
    final current = _configuration!;
    final value = await showDatePicker(
      context: context,
      initialDate: current.endDate,
      firstDate: current.startDate,
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      helpText: 'Inclusive end date',
    );
    if (value == null) return;
    await _saveConfiguration(
      ScanConfiguration(
        startDate: current.startDate,
        endDate: value,
        endAtToday: false,
      ),
    );
  }

  Future<void> _saveConfiguration(ScanConfiguration value) async {
    await ref.read(importCoordinatorProvider).saveConfiguration(value);
    if (mounted) setState(() => _configuration = value);
  }

  @override
  Widget build(BuildContext context) {
    final folders = ref.watch(sourceFoldersProvider);
    final configuration = _configuration;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          if (_busy) const LinearProgressIndicator(),
          const ListTile(
            title: Text('Authorized source folders'),
            subtitle: Text(
              'Only JPEG/PNG files directly inside these folders are considered. Enable subfolders explicitly; unrelated DCIM folders are never added automatically.',
            ),
          ),
          folders.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) =>
                ListTile(title: Text('Could not load folders: $error')),
            data: (rows) => Column(
              children: [
                for (final folder in rows)
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.folder_outlined),
                          title: Text(folder.displayName),
                          subtitle: Text(
                            folder.treeUri,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            tooltip:
                                'Remove source authorization from this app',
                            onPressed: _busy
                                ? null
                                : () =>
                                      (ref
                                              .read(databaseProvider)
                                              .delete(
                                                ref
                                                    .read(databaseProvider)
                                                    .sourceFolders,
                                              )
                                            ..where(
                                              (row) => row.id.equals(folder.id),
                                            ))
                                          .go(),
                          ),
                        ),
                        SwitchListTile(
                          title: const Text('Include child folders'),
                          subtitle: const Text(
                            'Off by default to keep discovery within the selected folder.',
                          ),
                          value: folder.includeSubfolders,
                          onChanged: _busy
                              ? null
                              : (value) =>
                                    (ref
                                            .read(databaseProvider)
                                            .update(
                                              ref
                                                  .read(databaseProvider)
                                                  .sourceFolders,
                                            )
                                          ..where(
                                            (row) => row.id.equals(folder.id),
                                          ))
                                        .write(
                                          SourceFoldersCompanion(
                                            includeSubfolders: Value(value),
                                          ),
                                        ),
                        ),
                      ],
                    ),
                  ),
                ListTile(
                  leading: const Icon(Icons.create_new_folder_outlined),
                  title: const Text('Add authorized source folder'),
                  onTap: _busy ? null : _addFolder,
                ),
              ],
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Inclusive discovery dates'),
            subtitle: Text(
              'Uses the date an image was added or downloaded to the device when Android exposes it. Original capture date and first-seen date do not qualify an image. Images with unknown saved dates are skipped during automatic OCR.',
            ),
          ),
          if (configuration == null)
            const Center(child: CircularProgressIndicator())
          else ...[
            ListTile(
              leading: const Icon(Icons.first_page),
              title: const Text('Start date'),
              trailing: Text(
                DateFormat.yMMMd().format(configuration.startDate),
              ),
              onTap: _busy ? null : _pickStart,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.today),
              title: const Text('End date is Today'),
              value: configuration.endAtToday,
              onChanged: _busy
                  ? null
                  : (value) => _saveConfiguration(
                      ScanConfiguration(
                        startDate: configuration.startDate,
                        endDate: configuration.endDate,
                        endAtToday: value,
                      ),
                    ),
            ),
            if (!configuration.endAtToday)
              ListTile(
                leading: const Icon(Icons.last_page),
                title: const Text('End date'),
                trailing: Text(
                  DateFormat.yMMMd().format(configuration.endDate),
                ),
                onTap: _busy ? null : _pickEnd,
              ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.monitor_heart_outlined),
            title: const Text('Last scan status'),
            subtitle: Text(_formatStatus(_lastScan)),
          ),
          ListTile(
            leading: const Icon(Icons.replay_circle_filled_outlined),
            title: const Text('Explicitly reprocess examined images'),
            subtitle: const Text(
              'Software updates never trigger a full rescan automatically. This marks completed, rejected, uncertain, and failed eligible items for the next scan.',
            ),
            onTap: _busy
                ? null
                : () => _run(() async {
                    await ref
                        .read(importCoordinatorProvider)
                        .markAllForExplicitReprocess();
                    return 'Examined images will be reconsidered on the next scoped scan.';
                  }),
          ),
          const ListTile(
            leading: Icon(Icons.offline_bolt_outlined),
            title: Text('Offline OCR'),
            subtitle: Text(
              'Google ML Kit Latin text recognition is bundled in the Android app.',
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Export catalog backup'),
            subtitle: const Text(
              'Saves catalog, ledger, source settings, and virtual collections—not master images.',
            ),
            onTap: _busy
                ? null
                : () => _run(() async {
                    final uri = await ref
                        .read(backupServiceProvider)
                        .exportBackup();
                    return uri == null ? 'Backup canceled.' : 'Backup saved.';
                  }),
          ),
          ListTile(
            leading: const Icon(Icons.restore_outlined),
            title: const Text('Restore catalog backup'),
            subtitle: const Text(
              'Restored images remain subject to Android URI permissions and may require relinking.',
            ),
            onTap: _busy
                ? null
                : () => _run(() async {
                    final restored = await ref
                        .read(backupServiceProvider)
                        .restoreBackup();
                    return restored
                        ? 'Catalog, ledger, and collections restored.'
                        : 'Restore canceled.';
                  }),
          ),
        ],
      ),
    );
  }
}

String _formatStatus(Map<String, dynamic>? status) {
  if (status == null) return 'No scoped scan has completed yet.';
  final timings = status['timingsMicros'] is Map
      ? (status['timingsMicros'] as Map).cast<String, dynamic>()
      : const <String, dynamic>{};
  final discoveryMs = ((timings['discovery'] as num?) ?? 0).toDouble() / 1000;
  final totalMs = ((timings['total'] as num?) ?? 0).toDouble() / 1000;
  return '${status['at']}\n${status['discovered']} metadata records: '
      '${status['imported']} imported, ${status['nonSongSheets']} non-sheets, '
      '${status['excluded']} excluded, ${status['unchangedSkipped']} unchanged, '
      '${status['failures']} failed. Discovery ${discoveryMs.toStringAsFixed(1)} ms; total ${totalMs.toStringAsFixed(1)} ms.';
}
