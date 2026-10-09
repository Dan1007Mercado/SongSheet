import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../core/storage/saf_storage.dart';

class BackupService {
  const BackupService(this.database, this.storage);

  final AppDatabase database;
  final SafStorage storage;

  Future<String?> exportBackup() async {
    final catalog = await database.exportCatalog();
    final name =
        'song-sheets-${DateFormat('yyyyMMdd-HHmm').format(DateTime.now())}.json';
    return storage.createBackup(
      name,
      Uint8List.fromList(
        utf8.encode(const JsonEncoder.withIndent('  ').convert(catalog)),
      ),
    );
  }

  Future<bool> restoreBackup() async {
    final bytes = await storage.openBackup();
    if (bytes == null) return false;
    await database.restoreCatalog(utf8.decode(bytes));
    return true;
  }
}
