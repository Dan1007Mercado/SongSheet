import '../../core/database/app_database.dart';

class LibraryEntry {
  const LibraryEntry({
    required this.id,
    required this.title,
    required this.keyLabel,
    required this.versionLabel,
    required this.assets,
  });

  final String id;
  final String title;
  final String? keyLabel;
  final String? versionLabel;
  final List<AssetRecord> assets;
}

Future<List<LibraryEntry>> buildLibraryEntries(
  AppDatabase database,
  List<AssetRecord> assets,
) async {
  final editions = {
    for (final edition in await database.select(database.editions).get())
      edition.id: edition,
  };
  final grouped = <String, List<AssetRecord>>{};
  for (final asset in assets.where(
    (asset) => asset.reviewState == 'confirmed',
  )) {
    grouped
        .putIfAbsent(asset.editionId ?? 'asset:${asset.id}', () => [])
        .add(asset);
  }
  final entries = <LibraryEntry>[];
  for (final group in grouped.entries) {
    final pages = group.value
      ..sort(
        (left, right) => (left.pageOrder ?? 0).compareTo(right.pageOrder ?? 0),
      );
    final edition = pages.first.editionId == null
        ? null
        : editions[pages.first.editionId];
    entries.add(
      LibraryEntry(
        id: group.key,
        title: pages.first.extractedTitle ?? pages.first.filename,
        keyLabel: edition?.keyLabel,
        versionLabel:
            edition?.arrangementLabel ??
            (edition?.userLabel.isEmpty == false ? edition!.userLabel : null),
        assets: pages,
      ),
    );
  }
  entries.sort(
    (left, right) =>
        left.title.toLowerCase().compareTo(right.title.toLowerCase()),
  );
  return entries;
}
