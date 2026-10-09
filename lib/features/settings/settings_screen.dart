import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

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

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: ListView(
      children: [
        if (_busy) const LinearProgressIndicator(),
        const ListTile(
          leading: Icon(Icons.offline_bolt_outlined),
          title: Text('Offline OCR'),
          subtitle: Text(
            'Google ML Kit Latin text recognition is bundled in the Android app. No cloud OCR or account is used.',
          ),
        ),
        ListTile(
          leading: const Icon(Icons.folder_open_outlined),
          title: const Text('Change managed folder'),
          subtitle: const Text(
            'Android controls which folders are writable. Downloads root and some providers may be restricted.',
          ),
          onTap: _busy
              ? null
              : () => _run(() async {
                  final uri = await ref
                      .read(storageProvider)
                      .chooseManagedTree();
                  return uri == null
                      ? 'Folder selection canceled.'
                      : 'Managed folder updated. Refresh the library to reconcile files.';
                }),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.backup_outlined),
          title: const Text('Export catalog backup'),
          subtitle: const Text(
            'Saves metadata and virtual collections. Master image files are not duplicated.',
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
            'Restored images are marked for relinking until their storage URIs are available.',
          ),
          onTap: _busy
              ? null
              : () => _run(() async {
                  final restored = await ref
                      .read(backupServiceProvider)
                      .restoreBackup();
                  return restored
                      ? 'Catalog and collections restored.'
                      : 'Restore canceled.';
                }),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Catalog data survives normal app updates, closure, and reboot. Clearing app data or uninstalling can remove it unless you export a backup first.',
          ),
        ),
      ],
    ),
  );
}
