import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../core/ocr/ocr_service.dart';
import '../../core/storage/saf_storage.dart';
import 'song_matcher.dart';

class ServiceDraftEntry {
  const ServiceDraftEntry({required this.position, required this.match});
  final int position;
  final SongMatch match;

  ServiceDraftEntry copyWith({SongMatch? match}) =>
      ServiceDraftEntry(position: position, match: match ?? this.match);
}

class ServiceDraft {
  const ServiceDraft({required this.date, required this.entries});
  final DateTime date;
  final List<ServiceDraftEntry> entries;

  int get matched => entries
      .where((entry) => entry.match.status == MatchStatus.matched)
      .length;
  int get missing => entries
      .where((entry) => entry.match.status == MatchStatus.missing)
      .length;
  int get ambiguous => entries
      .where((entry) => entry.match.status == MatchStatus.ambiguous)
      .length;
}

class ServiceCoordinator {
  ServiceCoordinator(this.database, this.storage, this.ocr, this.matcher);

  final AppDatabase database;
  final SafStorage storage;
  final OcrService ocr;
  final SongMatcher matcher;
  final _uuid = const Uuid();

  Future<ServiceDraft?> recognizeFromPicker(DateTime date) async {
    final uri = await storage.pickImage();
    if (uri == null) return null;
    final lines = await ocr.recognizeSetlist(await storage.readBytes(uri));
    final entries = <ServiceDraftEntry>[];
    for (var index = 0; index < lines.length; index++) {
      entries.add(
        ServiceDraftEntry(
          position: index,
          match: await matcher.match(database, lines[index]),
        ),
      );
    }
    return ServiceDraft(
      date: DateTime(date.year, date.month, date.day),
      entries: entries,
    );
  }

  Future<ServiceDraft> rematch(
    ServiceDraft draft,
    int index,
    String title, {
    String? requestedKey,
  }) async {
    final line = SetlistLine(
      text: title.trim(),
      normalizedTitle: normalizeTitle(title),
      requestedKey: requestedKey,
    );
    final matched = await matcher.match(database, line);
    final entries = [...draft.entries];
    entries[index] = entries[index].copyWith(match: matched);
    return ServiceDraft(date: draft.date, entries: entries);
  }

  Future<ServiceDraft> addEntry(
    ServiceDraft draft,
    String title, {
    String? requestedKey,
  }) async {
    final line = SetlistLine(
      text: title.trim(),
      normalizedTitle: normalizeTitle(title),
      requestedKey: requestedKey,
    );
    final match = await matcher.match(database, line);
    return ServiceDraft(
      date: draft.date,
      entries: [
        ...draft.entries,
        ServiceDraftEntry(position: draft.entries.length, match: match),
      ],
    );
  }

  ServiceDraft removeEntry(ServiceDraft draft, int index) {
    final remaining = [...draft.entries]..removeAt(index);
    return ServiceDraft(
      date: draft.date,
      entries: [
        for (var position = 0; position < remaining.length; position++)
          ServiceDraftEntry(
            position: position,
            match: remaining[position].match,
          ),
      ],
    );
  }

  ServiceDraft selectEdition(ServiceDraft draft, int index, String editionId) {
    final entries = [...draft.entries];
    final old = entries[index];
    entries[index] = old.copyWith(
      match: SongMatch(
        line: old.match.line,
        status: MatchStatus.matched,
        editionId: editionId,
        candidateEditionIds: old.match.candidateEditionIds,
      ),
    );
    return ServiceDraft(date: draft.date, entries: entries);
  }

  Future<String> save(ServiceDraft draft) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await database.transaction(() async {
      await database
          .into(database.serviceCollections)
          .insert(
            ServiceCollectionsCompanion.insert(
              id: id,
              localDate: draft.date,
              displayName:
                  'Songs for Sunday (${DateFormat('yyyy-MM-dd').format(draft.date)})',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database.batch((batch) {
        batch.insertAll(
          database.serviceEntries,
          draft.entries.map((entry) {
            final match = entry.match;
            return ServiceEntriesCompanion.insert(
              id: _uuid.v4(),
              serviceId: id,
              position: entry.position,
              requestedTitle: match.line.text,
              normalizedRequestedTitle: match.line.normalizedTitle,
              requestedKey: Value(match.line.requestedKey),
              editionId: Value(match.editionId),
              status: match.status.name,
              candidateEditionIdsJson: Value(
                jsonEncode(match.candidateEditionIds),
              ),
            );
          }).toList(),
        );
      });
    });
    return id;
  }

  Future<void> deleteCollection(String id) => (database.delete(
    database.serviceCollections,
  )..where((row) => row.id.equals(id))).go();
}
