import 'package:flutter/services.dart';

class SafDocument {
  const SafDocument({
    required this.uri,
    required this.name,
    required this.mimeType,
    required this.size,
    required this.lastModified,
    required this.canRead,
    required this.canWrite,
    required this.canRename,
    required this.canDelete,
  });

  factory SafDocument.fromMap(Map<Object?, Object?> map) => SafDocument(
    uri: map['uri']! as String,
    name: map['name']! as String,
    mimeType: (map['mimeType'] as String?) ?? 'application/octet-stream',
    size: (map['size'] as num?)?.toInt() ?? 0,
    lastModified: (map['lastModified'] as num?) == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            (map['lastModified']! as num).toInt(),
          ),
    canRead: map['canRead'] == true,
    canWrite: map['canWrite'] == true,
    canRename: map['canRename'] == true,
    canDelete: map['canDelete'] == true,
  );

  final String uri;
  final String name;
  final String mimeType;
  final int size;
  final DateTime? lastModified;
  final bool canRead;
  final bool canWrite;
  final bool canRename;
  final bool canDelete;
}

class SafStorage {
  const SafStorage();

  static const MethodChannel _channel = MethodChannel('song_sheets/storage');

  Future<String?> chooseManagedTree() =>
      _channel.invokeMethod<String>('chooseTree');

  Future<String?> persistedTree() =>
      _channel.invokeMethod<String>('persistedTree');

  Future<List<SafDocument>> listImages() async {
    final rows =
        await _channel.invokeListMethod<Object?>('listImages') ?? const [];
    return rows
        .map(
          (row) => SafDocument.fromMap((row! as Map).cast<Object?, Object?>()),
        )
        .toList();
  }

  Future<SafDocument> metadata(String uri) async {
    final row = await _channel.invokeMapMethod<Object?, Object?>('metadata', {
      'uri': uri,
    });
    if (row == null) throw StateError('The document is unavailable.');
    return SafDocument.fromMap(row);
  }

  Future<Uint8List> readBytes(String uri) async {
    final bytes = await _channel.invokeMethod<Uint8List>('readBytes', {
      'uri': uri,
    });
    if (bytes == null) throw StateError('The document returned no data.');
    return bytes;
  }

  Future<String> rename(String uri, String displayName) async {
    final renamed = await _channel.invokeMethod<String>('rename', {
      'uri': uri,
      'name': displayName,
    });
    if (renamed == null) {
      throw StateError('The provider did not return the renamed document.');
    }
    return renamed;
  }

  Future<bool> delete(String uri) async =>
      (await _channel.invokeMethod<bool>('delete', {'uri': uri})) ?? false;

  Future<bool> exists(String uri) async =>
      (await _channel.invokeMethod<bool>('exists', {'uri': uri})) ?? false;

  Future<bool> sameDocument(String firstUri, String secondUri) async =>
      (await _channel.invokeMethod<bool>('sameDocument', {
        'firstUri': firstUri,
        'secondUri': secondUri,
      })) ??
      firstUri == secondUri;

  Future<String?> pickImage() => _channel.invokeMethod<String>('pickImage');

  Future<String?> importIntoManagedTree(
    String sourceUri,
    String preferredName,
  ) => _channel.invokeMethod<String>('copyIntoTree', {
    'uri': sourceUri,
    'name': preferredName,
  });

  Future<String?> createBackup(String suggestedName, Uint8List bytes) =>
      _channel.invokeMethod<String>('createBackup', {
        'name': suggestedName,
        'bytes': bytes,
      });

  Future<Uint8List?> openBackup() =>
      _channel.invokeMethod<Uint8List>('openBackup');
}
