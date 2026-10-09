import 'package:flutter/services.dart';

class SafDocument {
  const SafDocument({
    required this.uri,
    required this.stableIdentity,
    required this.parentUri,
    required this.name,
    required this.mimeType,
    required this.size,
    required this.lastModified,
    required this.providerAddedAt,
    required this.canRead,
    required this.canWrite,
    required this.canRename,
    required this.canDelete,
  });

  factory SafDocument.fromMap(Map<Object?, Object?> map) => SafDocument(
    uri: map['uri']! as String,
    stableIdentity: (map['stableIdentity'] as String?) ?? map['uri']! as String,
    parentUri: map['parentUri'] as String?,
    name: map['name']! as String,
    mimeType: (map['mimeType'] as String?) ?? 'application/octet-stream',
    size: (map['size'] as num?)?.toInt() ?? 0,
    lastModified: _date(map['lastModified']),
    providerAddedAt: _date(map['providerAddedAt']),
    canRead: map['canRead'] == true,
    canWrite: map['canWrite'] == true,
    canRename: map['canRename'] == true,
    canDelete: map['canDelete'] == true,
  );

  final String uri;
  final String stableIdentity;
  final String? parentUri;
  final String name;
  final String mimeType;
  final int size;
  final DateTime? lastModified;
  final DateTime? providerAddedAt;
  final bool canRead;
  final bool canWrite;
  final bool canRename;
  final bool canDelete;
}

class SafFolder {
  const SafFolder({required this.uri, required this.name});

  factory SafFolder.fromMap(Map<Object?, Object?> map) => SafFolder(
    uri: map['uri']! as String,
    name: (map['name'] as String?) ?? 'Source folder',
  );

  final String uri;
  final String name;
}

class SafImageRead {
  const SafImageRead({required this.bytes, required this.sha256});
  final Uint8List bytes;
  final String sha256;
}

class SafStorage {
  const SafStorage();

  static const MethodChannel _channel = MethodChannel('song_sheets/storage');

  Future<SafFolder?> chooseSourceFolder() async {
    final value = await _channel.invokeMapMethod<Object?, Object?>(
      'chooseSourceFolder',
    );
    return value == null ? null : SafFolder.fromMap(value);
  }

  Future<SafFolder?> legacySourceFolder() async {
    final value = await _channel.invokeMapMethod<Object?, Object?>(
      'legacySourceFolder',
    );
    return value == null ? null : SafFolder.fromMap(value);
  }

  Future<List<SafDocument>> listImages(
    String treeUri, {
    required bool includeSubfolders,
  }) async {
    final rows =
        await _channel.invokeListMethod<Object?>('listImages', {
          'treeUri': treeUri,
          'includeSubfolders': includeSubfolders,
        }) ??
        const [];
    return rows
        .map(
          (row) => SafDocument.fromMap((row! as Map).cast<Object?, Object?>()),
        )
        .toList();
  }

  Future<SafDocument> metadata(String uri, {String? parentUri}) async {
    final row = await _channel.invokeMapMethod<Object?, Object?>('metadata', {
      'uri': uri,
      'parentUri': parentUri,
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

  Future<Uint8List> readPreview(String uri, {int maxDimension = 900}) async {
    final bytes = await _channel.invokeMethod<Uint8List>('readPreview', {
      'uri': uri,
      'maxDimension': maxDimension,
    });
    if (bytes == null) {
      throw StateError('The document preview returned no data.');
    }
    return bytes;
  }

  Future<SafImageRead> readImage(String uri) async {
    final value = await _channel.invokeMapMethod<Object?, Object?>(
      'readImage',
      {'uri': uri},
    );
    if (value == null ||
        value['bytes'] is! Uint8List ||
        value['sha256'] is! String) {
      throw StateError('The document returned incomplete image data.');
    }
    return SafImageRead(
      bytes: value['bytes']! as Uint8List,
      sha256: value['sha256']! as String,
    );
  }

  Future<SafDocument> rename(
    String uri,
    String displayName, {
    required String parentUri,
  }) async {
    final renamed = await _channel.invokeMapMethod<Object?, Object?>('rename', {
      'uri': uri,
      'name': displayName,
      'parentUri': parentUri,
    });
    if (renamed == null) {
      throw StateError('The provider did not return the renamed document.');
    }
    return SafDocument.fromMap(renamed);
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

  Future<String?> importIntoTree(
    String sourceUri,
    String preferredName,
    String treeUri,
  ) => _channel.invokeMethod<String>('copyIntoTree', {
    'uri': sourceUri,
    'name': preferredName,
    'treeUri': treeUri,
  });

  Future<String?> createBackup(String suggestedName, Uint8List bytes) =>
      _channel.invokeMethod<String>('createBackup', {
        'name': suggestedName,
        'bytes': bytes,
      });

  Future<Uint8List?> openBackup() =>
      _channel.invokeMethod<Uint8List>('openBackup');
}

DateTime? _date(Object? value) {
  if (value is! num || value.toInt() <= 0) return null;
  return DateTime.fromMillisecondsSinceEpoch(value.toInt());
}
