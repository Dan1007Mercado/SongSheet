import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import '../core/ocr/ocr_service.dart';
import '../core/storage/saf_storage.dart';
import '../features/import/import_coordinator.dart';
import '../features/services/service_coordinator.dart';
import '../features/services/song_matcher.dart';
import '../features/settings/backup_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final storageProvider = Provider<SafStorage>((ref) => const SafStorage());

final ocrProvider = Provider<OcrService>((ref) {
  final service = OcrService();
  ref.onDispose(service.close);
  return service;
});

final importCoordinatorProvider = Provider<ImportCoordinator>(
  (ref) => ImportCoordinator(
    ref.watch(databaseProvider),
    ref.watch(storageProvider),
    ref.watch(ocrProvider),
  ),
);

final serviceCoordinatorProvider = Provider<ServiceCoordinator>(
  (ref) => ServiceCoordinator(
    ref.watch(databaseProvider),
    ref.watch(storageProvider),
    ref.watch(ocrProvider),
    const SongMatcher(),
  ),
);

final backupServiceProvider = Provider<BackupService>(
  (ref) =>
      BackupService(ref.watch(databaseProvider), ref.watch(storageProvider)),
);

final libraryQueryProvider = StateProvider<String>((ref) => '');

final libraryAssetsProvider = StreamProvider<List<AssetRecord>>((ref) {
  final query = ref.watch(libraryQueryProvider);
  return ref.watch(databaseProvider).watchAssets(query);
});

final pendingAssetsProvider = StreamProvider<List<AssetRecord>>(
  (ref) => ref.watch(databaseProvider).watchPendingReview(),
);

final servicesProvider = StreamProvider<List<ServiceRecord>>(
  (ref) => ref.watch(databaseProvider).watchServices(),
);
