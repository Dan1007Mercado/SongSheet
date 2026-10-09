// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SongsTable extends Songs with TableInfo<$SongsTable, SongRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayTitleMeta = const VerificationMeta(
    'displayTitle',
  );
  @override
  late final GeneratedColumn<String> displayTitle = GeneratedColumn<String>(
    'display_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedTitleMeta = const VerificationMeta(
    'normalizedTitle',
  );
  @override
  late final GeneratedColumn<String> normalizedTitle = GeneratedColumn<String>(
    'normalized_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayTitle,
    normalizedTitle,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SongRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_title')) {
      context.handle(
        _displayTitleMeta,
        displayTitle.isAcceptableOrUnknown(
          data['display_title']!,
          _displayTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayTitleMeta);
    }
    if (data.containsKey('normalized_title')) {
      context.handle(
        _normalizedTitleMeta,
        normalizedTitle.isAcceptableOrUnknown(
          data['normalized_title']!,
          _normalizedTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedTitleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SongRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_title'],
      )!,
      normalizedTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(attachedDatabase, alias);
  }
}

class SongRecord extends DataClass implements Insertable<SongRecord> {
  final String id;
  final String displayTitle;
  final String normalizedTitle;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SongRecord({
    required this.id,
    required this.displayTitle,
    required this.normalizedTitle,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_title'] = Variable<String>(displayTitle);
    map['normalized_title'] = Variable<String>(normalizedTitle);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      displayTitle: Value(displayTitle),
      normalizedTitle: Value(normalizedTitle),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SongRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongRecord(
      id: serializer.fromJson<String>(json['id']),
      displayTitle: serializer.fromJson<String>(json['displayTitle']),
      normalizedTitle: serializer.fromJson<String>(json['normalizedTitle']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayTitle': serializer.toJson<String>(displayTitle),
      'normalizedTitle': serializer.toJson<String>(normalizedTitle),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SongRecord copyWith({
    String? id,
    String? displayTitle,
    String? normalizedTitle,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SongRecord(
    id: id ?? this.id,
    displayTitle: displayTitle ?? this.displayTitle,
    normalizedTitle: normalizedTitle ?? this.normalizedTitle,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SongRecord copyWithCompanion(SongsCompanion data) {
    return SongRecord(
      id: data.id.present ? data.id.value : this.id,
      displayTitle: data.displayTitle.present
          ? data.displayTitle.value
          : this.displayTitle,
      normalizedTitle: data.normalizedTitle.present
          ? data.normalizedTitle.value
          : this.normalizedTitle,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SongRecord(')
          ..write('id: $id, ')
          ..write('displayTitle: $displayTitle, ')
          ..write('normalizedTitle: $normalizedTitle, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, displayTitle, normalizedTitle, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongRecord &&
          other.id == this.id &&
          other.displayTitle == this.displayTitle &&
          other.normalizedTitle == this.normalizedTitle &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SongsCompanion extends UpdateCompanion<SongRecord> {
  final Value<String> id;
  final Value<String> displayTitle;
  final Value<String> normalizedTitle;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.displayTitle = const Value.absent(),
    this.normalizedTitle = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongsCompanion.insert({
    required String id,
    required String displayTitle,
    required String normalizedTitle,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayTitle = Value(displayTitle),
       normalizedTitle = Value(normalizedTitle),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SongRecord> custom({
    Expression<String>? id,
    Expression<String>? displayTitle,
    Expression<String>? normalizedTitle,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayTitle != null) 'display_title': displayTitle,
      if (normalizedTitle != null) 'normalized_title': normalizedTitle,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongsCompanion copyWith({
    Value<String>? id,
    Value<String>? displayTitle,
    Value<String>? normalizedTitle,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SongsCompanion(
      id: id ?? this.id,
      displayTitle: displayTitle ?? this.displayTitle,
      normalizedTitle: normalizedTitle ?? this.normalizedTitle,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayTitle.present) {
      map['display_title'] = Variable<String>(displayTitle.value);
    }
    if (normalizedTitle.present) {
      map['normalized_title'] = Variable<String>(normalizedTitle.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('displayTitle: $displayTitle, ')
          ..write('normalizedTitle: $normalizedTitle, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SongAliasesTable extends SongAliases
    with TableInfo<$SongAliasesTable, AliasRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongAliasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES songs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _normalizedAliasMeta = const VerificationMeta(
    'normalizedAlias',
  );
  @override
  late final GeneratedColumn<String> normalizedAlias = GeneratedColumn<String>(
    'normalized_alias',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, songId, normalizedAlias];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'song_aliases';
  @override
  VerificationContext validateIntegrity(
    Insertable<AliasRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('normalized_alias')) {
      context.handle(
        _normalizedAliasMeta,
        normalizedAlias.isAcceptableOrUnknown(
          data['normalized_alias']!,
          _normalizedAliasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedAliasMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AliasRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AliasRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_id'],
      )!,
      normalizedAlias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_alias'],
      )!,
    );
  }

  @override
  $SongAliasesTable createAlias(String alias) {
    return $SongAliasesTable(attachedDatabase, alias);
  }
}

class AliasRecord extends DataClass implements Insertable<AliasRecord> {
  final String id;
  final String songId;
  final String normalizedAlias;
  const AliasRecord({
    required this.id,
    required this.songId,
    required this.normalizedAlias,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['song_id'] = Variable<String>(songId);
    map['normalized_alias'] = Variable<String>(normalizedAlias);
    return map;
  }

  SongAliasesCompanion toCompanion(bool nullToAbsent) {
    return SongAliasesCompanion(
      id: Value(id),
      songId: Value(songId),
      normalizedAlias: Value(normalizedAlias),
    );
  }

  factory AliasRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AliasRecord(
      id: serializer.fromJson<String>(json['id']),
      songId: serializer.fromJson<String>(json['songId']),
      normalizedAlias: serializer.fromJson<String>(json['normalizedAlias']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'songId': serializer.toJson<String>(songId),
      'normalizedAlias': serializer.toJson<String>(normalizedAlias),
    };
  }

  AliasRecord copyWith({String? id, String? songId, String? normalizedAlias}) =>
      AliasRecord(
        id: id ?? this.id,
        songId: songId ?? this.songId,
        normalizedAlias: normalizedAlias ?? this.normalizedAlias,
      );
  AliasRecord copyWithCompanion(SongAliasesCompanion data) {
    return AliasRecord(
      id: data.id.present ? data.id.value : this.id,
      songId: data.songId.present ? data.songId.value : this.songId,
      normalizedAlias: data.normalizedAlias.present
          ? data.normalizedAlias.value
          : this.normalizedAlias,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AliasRecord(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('normalizedAlias: $normalizedAlias')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, songId, normalizedAlias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AliasRecord &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.normalizedAlias == this.normalizedAlias);
}

class SongAliasesCompanion extends UpdateCompanion<AliasRecord> {
  final Value<String> id;
  final Value<String> songId;
  final Value<String> normalizedAlias;
  final Value<int> rowid;
  const SongAliasesCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.normalizedAlias = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongAliasesCompanion.insert({
    required String id,
    required String songId,
    required String normalizedAlias,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       songId = Value(songId),
       normalizedAlias = Value(normalizedAlias);
  static Insertable<AliasRecord> custom({
    Expression<String>? id,
    Expression<String>? songId,
    Expression<String>? normalizedAlias,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (normalizedAlias != null) 'normalized_alias': normalizedAlias,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongAliasesCompanion copyWith({
    Value<String>? id,
    Value<String>? songId,
    Value<String>? normalizedAlias,
    Value<int>? rowid,
  }) {
    return SongAliasesCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      normalizedAlias: normalizedAlias ?? this.normalizedAlias,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (normalizedAlias.present) {
      map['normalized_alias'] = Variable<String>(normalizedAlias.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongAliasesCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('normalizedAlias: $normalizedAlias, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EditionsTable extends Editions
    with TableInfo<$EditionsTable, EditionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES songs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _keyLabelMeta = const VerificationMeta(
    'keyLabel',
  );
  @override
  late final GeneratedColumn<String> keyLabel = GeneratedColumn<String>(
    'key_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instrumentMeta = const VerificationMeta(
    'instrument',
  );
  @override
  late final GeneratedColumn<String> instrument = GeneratedColumn<String>(
    'instrument',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arrangementLabelMeta = const VerificationMeta(
    'arrangementLabel',
  );
  @override
  late final GeneratedColumn<String> arrangementLabel = GeneratedColumn<String>(
    'arrangement_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userLabelMeta = const VerificationMeta(
    'userLabel',
  );
  @override
  late final GeneratedColumn<String> userLabel = GeneratedColumn<String>(
    'user_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    songId,
    keyLabel,
    instrument,
    arrangementLabel,
    userLabel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'editions';
  @override
  VerificationContext validateIntegrity(
    Insertable<EditionRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('key_label')) {
      context.handle(
        _keyLabelMeta,
        keyLabel.isAcceptableOrUnknown(data['key_label']!, _keyLabelMeta),
      );
    }
    if (data.containsKey('instrument')) {
      context.handle(
        _instrumentMeta,
        instrument.isAcceptableOrUnknown(data['instrument']!, _instrumentMeta),
      );
    }
    if (data.containsKey('arrangement_label')) {
      context.handle(
        _arrangementLabelMeta,
        arrangementLabel.isAcceptableOrUnknown(
          data['arrangement_label']!,
          _arrangementLabelMeta,
        ),
      );
    }
    if (data.containsKey('user_label')) {
      context.handle(
        _userLabelMeta,
        userLabel.isAcceptableOrUnknown(data['user_label']!, _userLabelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EditionRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EditionRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}song_id'],
      )!,
      keyLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_label'],
      ),
      instrument: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instrument'],
      ),
      arrangementLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arrangement_label'],
      ),
      userLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_label'],
      )!,
    );
  }

  @override
  $EditionsTable createAlias(String alias) {
    return $EditionsTable(attachedDatabase, alias);
  }
}

class EditionRecord extends DataClass implements Insertable<EditionRecord> {
  final String id;
  final String songId;
  final String? keyLabel;
  final String? instrument;
  final String? arrangementLabel;
  final String userLabel;
  const EditionRecord({
    required this.id,
    required this.songId,
    this.keyLabel,
    this.instrument,
    this.arrangementLabel,
    required this.userLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['song_id'] = Variable<String>(songId);
    if (!nullToAbsent || keyLabel != null) {
      map['key_label'] = Variable<String>(keyLabel);
    }
    if (!nullToAbsent || instrument != null) {
      map['instrument'] = Variable<String>(instrument);
    }
    if (!nullToAbsent || arrangementLabel != null) {
      map['arrangement_label'] = Variable<String>(arrangementLabel);
    }
    map['user_label'] = Variable<String>(userLabel);
    return map;
  }

  EditionsCompanion toCompanion(bool nullToAbsent) {
    return EditionsCompanion(
      id: Value(id),
      songId: Value(songId),
      keyLabel: keyLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(keyLabel),
      instrument: instrument == null && nullToAbsent
          ? const Value.absent()
          : Value(instrument),
      arrangementLabel: arrangementLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(arrangementLabel),
      userLabel: Value(userLabel),
    );
  }

  factory EditionRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EditionRecord(
      id: serializer.fromJson<String>(json['id']),
      songId: serializer.fromJson<String>(json['songId']),
      keyLabel: serializer.fromJson<String?>(json['keyLabel']),
      instrument: serializer.fromJson<String?>(json['instrument']),
      arrangementLabel: serializer.fromJson<String?>(json['arrangementLabel']),
      userLabel: serializer.fromJson<String>(json['userLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'songId': serializer.toJson<String>(songId),
      'keyLabel': serializer.toJson<String?>(keyLabel),
      'instrument': serializer.toJson<String?>(instrument),
      'arrangementLabel': serializer.toJson<String?>(arrangementLabel),
      'userLabel': serializer.toJson<String>(userLabel),
    };
  }

  EditionRecord copyWith({
    String? id,
    String? songId,
    Value<String?> keyLabel = const Value.absent(),
    Value<String?> instrument = const Value.absent(),
    Value<String?> arrangementLabel = const Value.absent(),
    String? userLabel,
  }) => EditionRecord(
    id: id ?? this.id,
    songId: songId ?? this.songId,
    keyLabel: keyLabel.present ? keyLabel.value : this.keyLabel,
    instrument: instrument.present ? instrument.value : this.instrument,
    arrangementLabel: arrangementLabel.present
        ? arrangementLabel.value
        : this.arrangementLabel,
    userLabel: userLabel ?? this.userLabel,
  );
  EditionRecord copyWithCompanion(EditionsCompanion data) {
    return EditionRecord(
      id: data.id.present ? data.id.value : this.id,
      songId: data.songId.present ? data.songId.value : this.songId,
      keyLabel: data.keyLabel.present ? data.keyLabel.value : this.keyLabel,
      instrument: data.instrument.present
          ? data.instrument.value
          : this.instrument,
      arrangementLabel: data.arrangementLabel.present
          ? data.arrangementLabel.value
          : this.arrangementLabel,
      userLabel: data.userLabel.present ? data.userLabel.value : this.userLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EditionRecord(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('keyLabel: $keyLabel, ')
          ..write('instrument: $instrument, ')
          ..write('arrangementLabel: $arrangementLabel, ')
          ..write('userLabel: $userLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    songId,
    keyLabel,
    instrument,
    arrangementLabel,
    userLabel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EditionRecord &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.keyLabel == this.keyLabel &&
          other.instrument == this.instrument &&
          other.arrangementLabel == this.arrangementLabel &&
          other.userLabel == this.userLabel);
}

class EditionsCompanion extends UpdateCompanion<EditionRecord> {
  final Value<String> id;
  final Value<String> songId;
  final Value<String?> keyLabel;
  final Value<String?> instrument;
  final Value<String?> arrangementLabel;
  final Value<String> userLabel;
  final Value<int> rowid;
  const EditionsCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.keyLabel = const Value.absent(),
    this.instrument = const Value.absent(),
    this.arrangementLabel = const Value.absent(),
    this.userLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EditionsCompanion.insert({
    required String id,
    required String songId,
    this.keyLabel = const Value.absent(),
    this.instrument = const Value.absent(),
    this.arrangementLabel = const Value.absent(),
    this.userLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       songId = Value(songId);
  static Insertable<EditionRecord> custom({
    Expression<String>? id,
    Expression<String>? songId,
    Expression<String>? keyLabel,
    Expression<String>? instrument,
    Expression<String>? arrangementLabel,
    Expression<String>? userLabel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (keyLabel != null) 'key_label': keyLabel,
      if (instrument != null) 'instrument': instrument,
      if (arrangementLabel != null) 'arrangement_label': arrangementLabel,
      if (userLabel != null) 'user_label': userLabel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EditionsCompanion copyWith({
    Value<String>? id,
    Value<String>? songId,
    Value<String?>? keyLabel,
    Value<String?>? instrument,
    Value<String?>? arrangementLabel,
    Value<String>? userLabel,
    Value<int>? rowid,
  }) {
    return EditionsCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      keyLabel: keyLabel ?? this.keyLabel,
      instrument: instrument ?? this.instrument,
      arrangementLabel: arrangementLabel ?? this.arrangementLabel,
      userLabel: userLabel ?? this.userLabel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (keyLabel.present) {
      map['key_label'] = Variable<String>(keyLabel.value);
    }
    if (instrument.present) {
      map['instrument'] = Variable<String>(instrument.value);
    }
    if (arrangementLabel.present) {
      map['arrangement_label'] = Variable<String>(arrangementLabel.value);
    }
    if (userLabel.present) {
      map['user_label'] = Variable<String>(userLabel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EditionsCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('keyLabel: $keyLabel, ')
          ..write('instrument: $instrument, ')
          ..write('arrangementLabel: $arrangementLabel, ')
          ..write('userLabel: $userLabel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SheetAssetsTable extends SheetAssets
    with TableInfo<$SheetAssetsTable, AssetRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SheetAssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editionIdMeta = const VerificationMeta(
    'editionId',
  );
  @override
  late final GeneratedColumn<String> editionId = GeneratedColumn<String>(
    'edition_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES editions (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _documentUriMeta = const VerificationMeta(
    'documentUri',
  );
  @override
  late final GeneratedColumn<String> documentUri = GeneratedColumn<String>(
    'document_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _filenameMeta = const VerificationMeta(
    'filename',
  );
  @override
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
    'filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _byteSizeMeta = const VerificationMeta(
    'byteSize',
  );
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
    'byte_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pixelFingerprintMeta = const VerificationMeta(
    'pixelFingerprint',
  );
  @override
  late final GeneratedColumn<String> pixelFingerprint = GeneratedColumn<String>(
    'pixel_fingerprint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageOrderMeta = const VerificationMeta(
    'pageOrder',
  );
  @override
  late final GeneratedColumn<int> pageOrder = GeneratedColumn<int>(
    'page_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extractedTitleMeta = const VerificationMeta(
    'extractedTitle',
  );
  @override
  late final GeneratedColumn<String> extractedTitle = GeneratedColumn<String>(
    'extracted_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _normalizedTitleMeta = const VerificationMeta(
    'normalizedTitle',
  );
  @override
  late final GeneratedColumn<String> normalizedTitle = GeneratedColumn<String>(
    'normalized_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawOcrMeta = const VerificationMeta('rawOcr');
  @override
  late final GeneratedColumn<String> rawOcr = GeneratedColumn<String>(
    'raw_ocr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qualityScoreMeta = const VerificationMeta(
    'qualityScore',
  );
  @override
  late final GeneratedColumn<double> qualityScore = GeneratedColumn<double>(
    'quality_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reviewStateMeta = const VerificationMeta(
    'reviewState',
  );
  @override
  late final GeneratedColumn<String> reviewState = GeneratedColumn<String>(
    'review_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _availabilityStateMeta = const VerificationMeta(
    'availabilityState',
  );
  @override
  late final GeneratedColumn<String> availabilityState =
      GeneratedColumn<String>(
        'availability_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('available'),
      );
  static const VerificationMeta _contentFingerprintMeta =
      const VerificationMeta('contentFingerprint');
  @override
  late final GeneratedColumn<String> contentFingerprint =
      GeneratedColumn<String>(
        'content_fingerprint',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _processingVersionMeta = const VerificationMeta(
    'processingVersion',
  );
  @override
  late final GeneratedColumn<int> processingVersion = GeneratedColumn<int>(
    'processing_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    editionId,
    documentUri,
    filename,
    mimeType,
    byteSize,
    sha256,
    pixelFingerprint,
    width,
    height,
    pageOrder,
    extractedTitle,
    normalizedTitle,
    rawOcr,
    qualityScore,
    reviewState,
    availabilityState,
    contentFingerprint,
    processingVersion,
    modifiedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sheet_assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<AssetRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('edition_id')) {
      context.handle(
        _editionIdMeta,
        editionId.isAcceptableOrUnknown(data['edition_id']!, _editionIdMeta),
      );
    }
    if (data.containsKey('document_uri')) {
      context.handle(
        _documentUriMeta,
        documentUri.isAcceptableOrUnknown(
          data['document_uri']!,
          _documentUriMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentUriMeta);
    }
    if (data.containsKey('filename')) {
      context.handle(
        _filenameMeta,
        filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta),
      );
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('byte_size')) {
      context.handle(
        _byteSizeMeta,
        byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_byteSizeMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('pixel_fingerprint')) {
      context.handle(
        _pixelFingerprintMeta,
        pixelFingerprint.isAcceptableOrUnknown(
          data['pixel_fingerprint']!,
          _pixelFingerprintMeta,
        ),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('page_order')) {
      context.handle(
        _pageOrderMeta,
        pageOrder.isAcceptableOrUnknown(data['page_order']!, _pageOrderMeta),
      );
    }
    if (data.containsKey('extracted_title')) {
      context.handle(
        _extractedTitleMeta,
        extractedTitle.isAcceptableOrUnknown(
          data['extracted_title']!,
          _extractedTitleMeta,
        ),
      );
    }
    if (data.containsKey('normalized_title')) {
      context.handle(
        _normalizedTitleMeta,
        normalizedTitle.isAcceptableOrUnknown(
          data['normalized_title']!,
          _normalizedTitleMeta,
        ),
      );
    }
    if (data.containsKey('raw_ocr')) {
      context.handle(
        _rawOcrMeta,
        rawOcr.isAcceptableOrUnknown(data['raw_ocr']!, _rawOcrMeta),
      );
    }
    if (data.containsKey('quality_score')) {
      context.handle(
        _qualityScoreMeta,
        qualityScore.isAcceptableOrUnknown(
          data['quality_score']!,
          _qualityScoreMeta,
        ),
      );
    }
    if (data.containsKey('review_state')) {
      context.handle(
        _reviewStateMeta,
        reviewState.isAcceptableOrUnknown(
          data['review_state']!,
          _reviewStateMeta,
        ),
      );
    }
    if (data.containsKey('availability_state')) {
      context.handle(
        _availabilityStateMeta,
        availabilityState.isAcceptableOrUnknown(
          data['availability_state']!,
          _availabilityStateMeta,
        ),
      );
    }
    if (data.containsKey('content_fingerprint')) {
      context.handle(
        _contentFingerprintMeta,
        contentFingerprint.isAcceptableOrUnknown(
          data['content_fingerprint']!,
          _contentFingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentFingerprintMeta);
    }
    if (data.containsKey('processing_version')) {
      context.handle(
        _processingVersionMeta,
        processingVersion.isAcceptableOrUnknown(
          data['processing_version']!,
          _processingVersionMeta,
        ),
      );
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      editionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_id'],
      ),
      documentUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_uri'],
      )!,
      filename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filename'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      byteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_size'],
      )!,
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
      pixelFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pixel_fingerprint'],
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      pageOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_order'],
      ),
      extractedTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extracted_title'],
      ),
      normalizedTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_title'],
      ),
      rawOcr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_ocr'],
      ),
      qualityScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quality_score'],
      )!,
      reviewState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_state'],
      )!,
      availabilityState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}availability_state'],
      )!,
      contentFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_fingerprint'],
      )!,
      processingVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}processing_version'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SheetAssetsTable createAlias(String alias) {
    return $SheetAssetsTable(attachedDatabase, alias);
  }
}

class AssetRecord extends DataClass implements Insertable<AssetRecord> {
  final String id;
  final String? editionId;
  final String documentUri;
  final String filename;
  final String mimeType;
  final int byteSize;
  final String sha256;
  final String? pixelFingerprint;
  final int? width;
  final int? height;
  final int? pageOrder;
  final String? extractedTitle;
  final String? normalizedTitle;
  final String? rawOcr;
  final double qualityScore;
  final String reviewState;
  final String availabilityState;
  final String contentFingerprint;
  final int processingVersion;
  final DateTime? modifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AssetRecord({
    required this.id,
    this.editionId,
    required this.documentUri,
    required this.filename,
    required this.mimeType,
    required this.byteSize,
    required this.sha256,
    this.pixelFingerprint,
    this.width,
    this.height,
    this.pageOrder,
    this.extractedTitle,
    this.normalizedTitle,
    this.rawOcr,
    required this.qualityScore,
    required this.reviewState,
    required this.availabilityState,
    required this.contentFingerprint,
    required this.processingVersion,
    this.modifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || editionId != null) {
      map['edition_id'] = Variable<String>(editionId);
    }
    map['document_uri'] = Variable<String>(documentUri);
    map['filename'] = Variable<String>(filename);
    map['mime_type'] = Variable<String>(mimeType);
    map['byte_size'] = Variable<int>(byteSize);
    map['sha256'] = Variable<String>(sha256);
    if (!nullToAbsent || pixelFingerprint != null) {
      map['pixel_fingerprint'] = Variable<String>(pixelFingerprint);
    }
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    if (!nullToAbsent || pageOrder != null) {
      map['page_order'] = Variable<int>(pageOrder);
    }
    if (!nullToAbsent || extractedTitle != null) {
      map['extracted_title'] = Variable<String>(extractedTitle);
    }
    if (!nullToAbsent || normalizedTitle != null) {
      map['normalized_title'] = Variable<String>(normalizedTitle);
    }
    if (!nullToAbsent || rawOcr != null) {
      map['raw_ocr'] = Variable<String>(rawOcr);
    }
    map['quality_score'] = Variable<double>(qualityScore);
    map['review_state'] = Variable<String>(reviewState);
    map['availability_state'] = Variable<String>(availabilityState);
    map['content_fingerprint'] = Variable<String>(contentFingerprint);
    map['processing_version'] = Variable<int>(processingVersion);
    if (!nullToAbsent || modifiedAt != null) {
      map['modified_at'] = Variable<DateTime>(modifiedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SheetAssetsCompanion toCompanion(bool nullToAbsent) {
    return SheetAssetsCompanion(
      id: Value(id),
      editionId: editionId == null && nullToAbsent
          ? const Value.absent()
          : Value(editionId),
      documentUri: Value(documentUri),
      filename: Value(filename),
      mimeType: Value(mimeType),
      byteSize: Value(byteSize),
      sha256: Value(sha256),
      pixelFingerprint: pixelFingerprint == null && nullToAbsent
          ? const Value.absent()
          : Value(pixelFingerprint),
      width: width == null && nullToAbsent
          ? const Value.absent()
          : Value(width),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      pageOrder: pageOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(pageOrder),
      extractedTitle: extractedTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(extractedTitle),
      normalizedTitle: normalizedTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(normalizedTitle),
      rawOcr: rawOcr == null && nullToAbsent
          ? const Value.absent()
          : Value(rawOcr),
      qualityScore: Value(qualityScore),
      reviewState: Value(reviewState),
      availabilityState: Value(availabilityState),
      contentFingerprint: Value(contentFingerprint),
      processingVersion: Value(processingVersion),
      modifiedAt: modifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(modifiedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AssetRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetRecord(
      id: serializer.fromJson<String>(json['id']),
      editionId: serializer.fromJson<String?>(json['editionId']),
      documentUri: serializer.fromJson<String>(json['documentUri']),
      filename: serializer.fromJson<String>(json['filename']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      byteSize: serializer.fromJson<int>(json['byteSize']),
      sha256: serializer.fromJson<String>(json['sha256']),
      pixelFingerprint: serializer.fromJson<String?>(json['pixelFingerprint']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      pageOrder: serializer.fromJson<int?>(json['pageOrder']),
      extractedTitle: serializer.fromJson<String?>(json['extractedTitle']),
      normalizedTitle: serializer.fromJson<String?>(json['normalizedTitle']),
      rawOcr: serializer.fromJson<String?>(json['rawOcr']),
      qualityScore: serializer.fromJson<double>(json['qualityScore']),
      reviewState: serializer.fromJson<String>(json['reviewState']),
      availabilityState: serializer.fromJson<String>(json['availabilityState']),
      contentFingerprint: serializer.fromJson<String>(
        json['contentFingerprint'],
      ),
      processingVersion: serializer.fromJson<int>(json['processingVersion']),
      modifiedAt: serializer.fromJson<DateTime?>(json['modifiedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'editionId': serializer.toJson<String?>(editionId),
      'documentUri': serializer.toJson<String>(documentUri),
      'filename': serializer.toJson<String>(filename),
      'mimeType': serializer.toJson<String>(mimeType),
      'byteSize': serializer.toJson<int>(byteSize),
      'sha256': serializer.toJson<String>(sha256),
      'pixelFingerprint': serializer.toJson<String?>(pixelFingerprint),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'pageOrder': serializer.toJson<int?>(pageOrder),
      'extractedTitle': serializer.toJson<String?>(extractedTitle),
      'normalizedTitle': serializer.toJson<String?>(normalizedTitle),
      'rawOcr': serializer.toJson<String?>(rawOcr),
      'qualityScore': serializer.toJson<double>(qualityScore),
      'reviewState': serializer.toJson<String>(reviewState),
      'availabilityState': serializer.toJson<String>(availabilityState),
      'contentFingerprint': serializer.toJson<String>(contentFingerprint),
      'processingVersion': serializer.toJson<int>(processingVersion),
      'modifiedAt': serializer.toJson<DateTime?>(modifiedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AssetRecord copyWith({
    String? id,
    Value<String?> editionId = const Value.absent(),
    String? documentUri,
    String? filename,
    String? mimeType,
    int? byteSize,
    String? sha256,
    Value<String?> pixelFingerprint = const Value.absent(),
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    Value<int?> pageOrder = const Value.absent(),
    Value<String?> extractedTitle = const Value.absent(),
    Value<String?> normalizedTitle = const Value.absent(),
    Value<String?> rawOcr = const Value.absent(),
    double? qualityScore,
    String? reviewState,
    String? availabilityState,
    String? contentFingerprint,
    int? processingVersion,
    Value<DateTime?> modifiedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AssetRecord(
    id: id ?? this.id,
    editionId: editionId.present ? editionId.value : this.editionId,
    documentUri: documentUri ?? this.documentUri,
    filename: filename ?? this.filename,
    mimeType: mimeType ?? this.mimeType,
    byteSize: byteSize ?? this.byteSize,
    sha256: sha256 ?? this.sha256,
    pixelFingerprint: pixelFingerprint.present
        ? pixelFingerprint.value
        : this.pixelFingerprint,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    pageOrder: pageOrder.present ? pageOrder.value : this.pageOrder,
    extractedTitle: extractedTitle.present
        ? extractedTitle.value
        : this.extractedTitle,
    normalizedTitle: normalizedTitle.present
        ? normalizedTitle.value
        : this.normalizedTitle,
    rawOcr: rawOcr.present ? rawOcr.value : this.rawOcr,
    qualityScore: qualityScore ?? this.qualityScore,
    reviewState: reviewState ?? this.reviewState,
    availabilityState: availabilityState ?? this.availabilityState,
    contentFingerprint: contentFingerprint ?? this.contentFingerprint,
    processingVersion: processingVersion ?? this.processingVersion,
    modifiedAt: modifiedAt.present ? modifiedAt.value : this.modifiedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AssetRecord copyWithCompanion(SheetAssetsCompanion data) {
    return AssetRecord(
      id: data.id.present ? data.id.value : this.id,
      editionId: data.editionId.present ? data.editionId.value : this.editionId,
      documentUri: data.documentUri.present
          ? data.documentUri.value
          : this.documentUri,
      filename: data.filename.present ? data.filename.value : this.filename,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      pixelFingerprint: data.pixelFingerprint.present
          ? data.pixelFingerprint.value
          : this.pixelFingerprint,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      pageOrder: data.pageOrder.present ? data.pageOrder.value : this.pageOrder,
      extractedTitle: data.extractedTitle.present
          ? data.extractedTitle.value
          : this.extractedTitle,
      normalizedTitle: data.normalizedTitle.present
          ? data.normalizedTitle.value
          : this.normalizedTitle,
      rawOcr: data.rawOcr.present ? data.rawOcr.value : this.rawOcr,
      qualityScore: data.qualityScore.present
          ? data.qualityScore.value
          : this.qualityScore,
      reviewState: data.reviewState.present
          ? data.reviewState.value
          : this.reviewState,
      availabilityState: data.availabilityState.present
          ? data.availabilityState.value
          : this.availabilityState,
      contentFingerprint: data.contentFingerprint.present
          ? data.contentFingerprint.value
          : this.contentFingerprint,
      processingVersion: data.processingVersion.present
          ? data.processingVersion.value
          : this.processingVersion,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetRecord(')
          ..write('id: $id, ')
          ..write('editionId: $editionId, ')
          ..write('documentUri: $documentUri, ')
          ..write('filename: $filename, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('sha256: $sha256, ')
          ..write('pixelFingerprint: $pixelFingerprint, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('pageOrder: $pageOrder, ')
          ..write('extractedTitle: $extractedTitle, ')
          ..write('normalizedTitle: $normalizedTitle, ')
          ..write('rawOcr: $rawOcr, ')
          ..write('qualityScore: $qualityScore, ')
          ..write('reviewState: $reviewState, ')
          ..write('availabilityState: $availabilityState, ')
          ..write('contentFingerprint: $contentFingerprint, ')
          ..write('processingVersion: $processingVersion, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    editionId,
    documentUri,
    filename,
    mimeType,
    byteSize,
    sha256,
    pixelFingerprint,
    width,
    height,
    pageOrder,
    extractedTitle,
    normalizedTitle,
    rawOcr,
    qualityScore,
    reviewState,
    availabilityState,
    contentFingerprint,
    processingVersion,
    modifiedAt,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetRecord &&
          other.id == this.id &&
          other.editionId == this.editionId &&
          other.documentUri == this.documentUri &&
          other.filename == this.filename &&
          other.mimeType == this.mimeType &&
          other.byteSize == this.byteSize &&
          other.sha256 == this.sha256 &&
          other.pixelFingerprint == this.pixelFingerprint &&
          other.width == this.width &&
          other.height == this.height &&
          other.pageOrder == this.pageOrder &&
          other.extractedTitle == this.extractedTitle &&
          other.normalizedTitle == this.normalizedTitle &&
          other.rawOcr == this.rawOcr &&
          other.qualityScore == this.qualityScore &&
          other.reviewState == this.reviewState &&
          other.availabilityState == this.availabilityState &&
          other.contentFingerprint == this.contentFingerprint &&
          other.processingVersion == this.processingVersion &&
          other.modifiedAt == this.modifiedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SheetAssetsCompanion extends UpdateCompanion<AssetRecord> {
  final Value<String> id;
  final Value<String?> editionId;
  final Value<String> documentUri;
  final Value<String> filename;
  final Value<String> mimeType;
  final Value<int> byteSize;
  final Value<String> sha256;
  final Value<String?> pixelFingerprint;
  final Value<int?> width;
  final Value<int?> height;
  final Value<int?> pageOrder;
  final Value<String?> extractedTitle;
  final Value<String?> normalizedTitle;
  final Value<String?> rawOcr;
  final Value<double> qualityScore;
  final Value<String> reviewState;
  final Value<String> availabilityState;
  final Value<String> contentFingerprint;
  final Value<int> processingVersion;
  final Value<DateTime?> modifiedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SheetAssetsCompanion({
    this.id = const Value.absent(),
    this.editionId = const Value.absent(),
    this.documentUri = const Value.absent(),
    this.filename = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.pixelFingerprint = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.pageOrder = const Value.absent(),
    this.extractedTitle = const Value.absent(),
    this.normalizedTitle = const Value.absent(),
    this.rawOcr = const Value.absent(),
    this.qualityScore = const Value.absent(),
    this.reviewState = const Value.absent(),
    this.availabilityState = const Value.absent(),
    this.contentFingerprint = const Value.absent(),
    this.processingVersion = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SheetAssetsCompanion.insert({
    required String id,
    this.editionId = const Value.absent(),
    required String documentUri,
    required String filename,
    required String mimeType,
    required int byteSize,
    required String sha256,
    this.pixelFingerprint = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.pageOrder = const Value.absent(),
    this.extractedTitle = const Value.absent(),
    this.normalizedTitle = const Value.absent(),
    this.rawOcr = const Value.absent(),
    this.qualityScore = const Value.absent(),
    this.reviewState = const Value.absent(),
    this.availabilityState = const Value.absent(),
    required String contentFingerprint,
    this.processingVersion = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       documentUri = Value(documentUri),
       filename = Value(filename),
       mimeType = Value(mimeType),
       byteSize = Value(byteSize),
       sha256 = Value(sha256),
       contentFingerprint = Value(contentFingerprint),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AssetRecord> custom({
    Expression<String>? id,
    Expression<String>? editionId,
    Expression<String>? documentUri,
    Expression<String>? filename,
    Expression<String>? mimeType,
    Expression<int>? byteSize,
    Expression<String>? sha256,
    Expression<String>? pixelFingerprint,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? pageOrder,
    Expression<String>? extractedTitle,
    Expression<String>? normalizedTitle,
    Expression<String>? rawOcr,
    Expression<double>? qualityScore,
    Expression<String>? reviewState,
    Expression<String>? availabilityState,
    Expression<String>? contentFingerprint,
    Expression<int>? processingVersion,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (editionId != null) 'edition_id': editionId,
      if (documentUri != null) 'document_uri': documentUri,
      if (filename != null) 'filename': filename,
      if (mimeType != null) 'mime_type': mimeType,
      if (byteSize != null) 'byte_size': byteSize,
      if (sha256 != null) 'sha256': sha256,
      if (pixelFingerprint != null) 'pixel_fingerprint': pixelFingerprint,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (pageOrder != null) 'page_order': pageOrder,
      if (extractedTitle != null) 'extracted_title': extractedTitle,
      if (normalizedTitle != null) 'normalized_title': normalizedTitle,
      if (rawOcr != null) 'raw_ocr': rawOcr,
      if (qualityScore != null) 'quality_score': qualityScore,
      if (reviewState != null) 'review_state': reviewState,
      if (availabilityState != null) 'availability_state': availabilityState,
      if (contentFingerprint != null) 'content_fingerprint': contentFingerprint,
      if (processingVersion != null) 'processing_version': processingVersion,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SheetAssetsCompanion copyWith({
    Value<String>? id,
    Value<String?>? editionId,
    Value<String>? documentUri,
    Value<String>? filename,
    Value<String>? mimeType,
    Value<int>? byteSize,
    Value<String>? sha256,
    Value<String?>? pixelFingerprint,
    Value<int?>? width,
    Value<int?>? height,
    Value<int?>? pageOrder,
    Value<String?>? extractedTitle,
    Value<String?>? normalizedTitle,
    Value<String?>? rawOcr,
    Value<double>? qualityScore,
    Value<String>? reviewState,
    Value<String>? availabilityState,
    Value<String>? contentFingerprint,
    Value<int>? processingVersion,
    Value<DateTime?>? modifiedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SheetAssetsCompanion(
      id: id ?? this.id,
      editionId: editionId ?? this.editionId,
      documentUri: documentUri ?? this.documentUri,
      filename: filename ?? this.filename,
      mimeType: mimeType ?? this.mimeType,
      byteSize: byteSize ?? this.byteSize,
      sha256: sha256 ?? this.sha256,
      pixelFingerprint: pixelFingerprint ?? this.pixelFingerprint,
      width: width ?? this.width,
      height: height ?? this.height,
      pageOrder: pageOrder ?? this.pageOrder,
      extractedTitle: extractedTitle ?? this.extractedTitle,
      normalizedTitle: normalizedTitle ?? this.normalizedTitle,
      rawOcr: rawOcr ?? this.rawOcr,
      qualityScore: qualityScore ?? this.qualityScore,
      reviewState: reviewState ?? this.reviewState,
      availabilityState: availabilityState ?? this.availabilityState,
      contentFingerprint: contentFingerprint ?? this.contentFingerprint,
      processingVersion: processingVersion ?? this.processingVersion,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (editionId.present) {
      map['edition_id'] = Variable<String>(editionId.value);
    }
    if (documentUri.present) {
      map['document_uri'] = Variable<String>(documentUri.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (pixelFingerprint.present) {
      map['pixel_fingerprint'] = Variable<String>(pixelFingerprint.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (pageOrder.present) {
      map['page_order'] = Variable<int>(pageOrder.value);
    }
    if (extractedTitle.present) {
      map['extracted_title'] = Variable<String>(extractedTitle.value);
    }
    if (normalizedTitle.present) {
      map['normalized_title'] = Variable<String>(normalizedTitle.value);
    }
    if (rawOcr.present) {
      map['raw_ocr'] = Variable<String>(rawOcr.value);
    }
    if (qualityScore.present) {
      map['quality_score'] = Variable<double>(qualityScore.value);
    }
    if (reviewState.present) {
      map['review_state'] = Variable<String>(reviewState.value);
    }
    if (availabilityState.present) {
      map['availability_state'] = Variable<String>(availabilityState.value);
    }
    if (contentFingerprint.present) {
      map['content_fingerprint'] = Variable<String>(contentFingerprint.value);
    }
    if (processingVersion.present) {
      map['processing_version'] = Variable<int>(processingVersion.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SheetAssetsCompanion(')
          ..write('id: $id, ')
          ..write('editionId: $editionId, ')
          ..write('documentUri: $documentUri, ')
          ..write('filename: $filename, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('sha256: $sha256, ')
          ..write('pixelFingerprint: $pixelFingerprint, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('pageOrder: $pageOrder, ')
          ..write('extractedTitle: $extractedTitle, ')
          ..write('normalizedTitle: $normalizedTitle, ')
          ..write('rawOcr: $rawOcr, ')
          ..write('qualityScore: $qualityScore, ')
          ..write('reviewState: $reviewState, ')
          ..write('availabilityState: $availabilityState, ')
          ..write('contentFingerprint: $contentFingerprint, ')
          ..write('processingVersion: $processingVersion, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceCollectionsTable extends ServiceCollections
    with TableInfo<$ServiceCollectionsTable, ServiceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceCollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<DateTime> localDate = GeneratedColumn<DateTime>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localDate,
    displayName,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}local_date'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ServiceCollectionsTable createAlias(String alias) {
    return $ServiceCollectionsTable(attachedDatabase, alias);
  }
}

class ServiceRecord extends DataClass implements Insertable<ServiceRecord> {
  final String id;
  final DateTime localDate;
  final String displayName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ServiceRecord({
    required this.id,
    required this.localDate,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['local_date'] = Variable<DateTime>(localDate);
    map['display_name'] = Variable<String>(displayName);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ServiceCollectionsCompanion toCompanion(bool nullToAbsent) {
    return ServiceCollectionsCompanion(
      id: Value(id),
      localDate: Value(localDate),
      displayName: Value(displayName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ServiceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceRecord(
      id: serializer.fromJson<String>(json['id']),
      localDate: serializer.fromJson<DateTime>(json['localDate']),
      displayName: serializer.fromJson<String>(json['displayName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'localDate': serializer.toJson<DateTime>(localDate),
      'displayName': serializer.toJson<String>(displayName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ServiceRecord copyWith({
    String? id,
    DateTime? localDate,
    String? displayName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ServiceRecord(
    id: id ?? this.id,
    localDate: localDate ?? this.localDate,
    displayName: displayName ?? this.displayName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ServiceRecord copyWithCompanion(ServiceCollectionsCompanion data) {
    return ServiceRecord(
      id: data.id.present ? data.id.value : this.id,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceRecord(')
          ..write('id: $id, ')
          ..write('localDate: $localDate, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, localDate, displayName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceRecord &&
          other.id == this.id &&
          other.localDate == this.localDate &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ServiceCollectionsCompanion extends UpdateCompanion<ServiceRecord> {
  final Value<String> id;
  final Value<DateTime> localDate;
  final Value<String> displayName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ServiceCollectionsCompanion({
    this.id = const Value.absent(),
    this.localDate = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceCollectionsCompanion.insert({
    required String id,
    required DateTime localDate,
    required String displayName,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       localDate = Value(localDate),
       displayName = Value(displayName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ServiceRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? localDate,
    Expression<String>? displayName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localDate != null) 'local_date': localDate,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceCollectionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? localDate,
    Value<String>? displayName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ServiceCollectionsCompanion(
      id: id ?? this.id,
      localDate: localDate ?? this.localDate,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<DateTime>(localDate.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCollectionsCompanion(')
          ..write('id: $id, ')
          ..write('localDate: $localDate, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceEntriesTable extends ServiceEntries
    with TableInfo<$ServiceEntriesTable, ServiceEntryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<String> serviceId = GeneratedColumn<String>(
    'service_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_collections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestedTitleMeta = const VerificationMeta(
    'requestedTitle',
  );
  @override
  late final GeneratedColumn<String> requestedTitle = GeneratedColumn<String>(
    'requested_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedRequestedTitleMeta =
      const VerificationMeta('normalizedRequestedTitle');
  @override
  late final GeneratedColumn<String> normalizedRequestedTitle =
      GeneratedColumn<String>(
        'normalized_requested_title',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _requestedKeyMeta = const VerificationMeta(
    'requestedKey',
  );
  @override
  late final GeneratedColumn<String> requestedKey = GeneratedColumn<String>(
    'requested_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _editionIdMeta = const VerificationMeta(
    'editionId',
  );
  @override
  late final GeneratedColumn<String> editionId = GeneratedColumn<String>(
    'edition_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES editions (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _candidateEditionIdsJsonMeta =
      const VerificationMeta('candidateEditionIdsJson');
  @override
  late final GeneratedColumn<String> candidateEditionIdsJson =
      GeneratedColumn<String>(
        'candidate_edition_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serviceId,
    position,
    requestedTitle,
    normalizedRequestedTitle,
    requestedKey,
    editionId,
    status,
    candidateEditionIdsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceEntryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('requested_title')) {
      context.handle(
        _requestedTitleMeta,
        requestedTitle.isAcceptableOrUnknown(
          data['requested_title']!,
          _requestedTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestedTitleMeta);
    }
    if (data.containsKey('normalized_requested_title')) {
      context.handle(
        _normalizedRequestedTitleMeta,
        normalizedRequestedTitle.isAcceptableOrUnknown(
          data['normalized_requested_title']!,
          _normalizedRequestedTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedRequestedTitleMeta);
    }
    if (data.containsKey('requested_key')) {
      context.handle(
        _requestedKeyMeta,
        requestedKey.isAcceptableOrUnknown(
          data['requested_key']!,
          _requestedKeyMeta,
        ),
      );
    }
    if (data.containsKey('edition_id')) {
      context.handle(
        _editionIdMeta,
        editionId.isAcceptableOrUnknown(data['edition_id']!, _editionIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('candidate_edition_ids_json')) {
      context.handle(
        _candidateEditionIdsJsonMeta,
        candidateEditionIdsJson.isAcceptableOrUnknown(
          data['candidate_edition_ids_json']!,
          _candidateEditionIdsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {serviceId, position},
  ];
  @override
  ServiceEntryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceEntryRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      requestedTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requested_title'],
      )!,
      normalizedRequestedTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_requested_title'],
      )!,
      requestedKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requested_key'],
      ),
      editionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      candidateEditionIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidate_edition_ids_json'],
      )!,
    );
  }

  @override
  $ServiceEntriesTable createAlias(String alias) {
    return $ServiceEntriesTable(attachedDatabase, alias);
  }
}

class ServiceEntryRecord extends DataClass
    implements Insertable<ServiceEntryRecord> {
  final String id;
  final String serviceId;
  final int position;
  final String requestedTitle;
  final String normalizedRequestedTitle;
  final String? requestedKey;
  final String? editionId;
  final String status;
  final String candidateEditionIdsJson;
  const ServiceEntryRecord({
    required this.id,
    required this.serviceId,
    required this.position,
    required this.requestedTitle,
    required this.normalizedRequestedTitle,
    this.requestedKey,
    this.editionId,
    required this.status,
    required this.candidateEditionIdsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['service_id'] = Variable<String>(serviceId);
    map['position'] = Variable<int>(position);
    map['requested_title'] = Variable<String>(requestedTitle);
    map['normalized_requested_title'] = Variable<String>(
      normalizedRequestedTitle,
    );
    if (!nullToAbsent || requestedKey != null) {
      map['requested_key'] = Variable<String>(requestedKey);
    }
    if (!nullToAbsent || editionId != null) {
      map['edition_id'] = Variable<String>(editionId);
    }
    map['status'] = Variable<String>(status);
    map['candidate_edition_ids_json'] = Variable<String>(
      candidateEditionIdsJson,
    );
    return map;
  }

  ServiceEntriesCompanion toCompanion(bool nullToAbsent) {
    return ServiceEntriesCompanion(
      id: Value(id),
      serviceId: Value(serviceId),
      position: Value(position),
      requestedTitle: Value(requestedTitle),
      normalizedRequestedTitle: Value(normalizedRequestedTitle),
      requestedKey: requestedKey == null && nullToAbsent
          ? const Value.absent()
          : Value(requestedKey),
      editionId: editionId == null && nullToAbsent
          ? const Value.absent()
          : Value(editionId),
      status: Value(status),
      candidateEditionIdsJson: Value(candidateEditionIdsJson),
    );
  }

  factory ServiceEntryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceEntryRecord(
      id: serializer.fromJson<String>(json['id']),
      serviceId: serializer.fromJson<String>(json['serviceId']),
      position: serializer.fromJson<int>(json['position']),
      requestedTitle: serializer.fromJson<String>(json['requestedTitle']),
      normalizedRequestedTitle: serializer.fromJson<String>(
        json['normalizedRequestedTitle'],
      ),
      requestedKey: serializer.fromJson<String?>(json['requestedKey']),
      editionId: serializer.fromJson<String?>(json['editionId']),
      status: serializer.fromJson<String>(json['status']),
      candidateEditionIdsJson: serializer.fromJson<String>(
        json['candidateEditionIdsJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serviceId': serializer.toJson<String>(serviceId),
      'position': serializer.toJson<int>(position),
      'requestedTitle': serializer.toJson<String>(requestedTitle),
      'normalizedRequestedTitle': serializer.toJson<String>(
        normalizedRequestedTitle,
      ),
      'requestedKey': serializer.toJson<String?>(requestedKey),
      'editionId': serializer.toJson<String?>(editionId),
      'status': serializer.toJson<String>(status),
      'candidateEditionIdsJson': serializer.toJson<String>(
        candidateEditionIdsJson,
      ),
    };
  }

  ServiceEntryRecord copyWith({
    String? id,
    String? serviceId,
    int? position,
    String? requestedTitle,
    String? normalizedRequestedTitle,
    Value<String?> requestedKey = const Value.absent(),
    Value<String?> editionId = const Value.absent(),
    String? status,
    String? candidateEditionIdsJson,
  }) => ServiceEntryRecord(
    id: id ?? this.id,
    serviceId: serviceId ?? this.serviceId,
    position: position ?? this.position,
    requestedTitle: requestedTitle ?? this.requestedTitle,
    normalizedRequestedTitle:
        normalizedRequestedTitle ?? this.normalizedRequestedTitle,
    requestedKey: requestedKey.present ? requestedKey.value : this.requestedKey,
    editionId: editionId.present ? editionId.value : this.editionId,
    status: status ?? this.status,
    candidateEditionIdsJson:
        candidateEditionIdsJson ?? this.candidateEditionIdsJson,
  );
  ServiceEntryRecord copyWithCompanion(ServiceEntriesCompanion data) {
    return ServiceEntryRecord(
      id: data.id.present ? data.id.value : this.id,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      position: data.position.present ? data.position.value : this.position,
      requestedTitle: data.requestedTitle.present
          ? data.requestedTitle.value
          : this.requestedTitle,
      normalizedRequestedTitle: data.normalizedRequestedTitle.present
          ? data.normalizedRequestedTitle.value
          : this.normalizedRequestedTitle,
      requestedKey: data.requestedKey.present
          ? data.requestedKey.value
          : this.requestedKey,
      editionId: data.editionId.present ? data.editionId.value : this.editionId,
      status: data.status.present ? data.status.value : this.status,
      candidateEditionIdsJson: data.candidateEditionIdsJson.present
          ? data.candidateEditionIdsJson.value
          : this.candidateEditionIdsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceEntryRecord(')
          ..write('id: $id, ')
          ..write('serviceId: $serviceId, ')
          ..write('position: $position, ')
          ..write('requestedTitle: $requestedTitle, ')
          ..write('normalizedRequestedTitle: $normalizedRequestedTitle, ')
          ..write('requestedKey: $requestedKey, ')
          ..write('editionId: $editionId, ')
          ..write('status: $status, ')
          ..write('candidateEditionIdsJson: $candidateEditionIdsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serviceId,
    position,
    requestedTitle,
    normalizedRequestedTitle,
    requestedKey,
    editionId,
    status,
    candidateEditionIdsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceEntryRecord &&
          other.id == this.id &&
          other.serviceId == this.serviceId &&
          other.position == this.position &&
          other.requestedTitle == this.requestedTitle &&
          other.normalizedRequestedTitle == this.normalizedRequestedTitle &&
          other.requestedKey == this.requestedKey &&
          other.editionId == this.editionId &&
          other.status == this.status &&
          other.candidateEditionIdsJson == this.candidateEditionIdsJson);
}

class ServiceEntriesCompanion extends UpdateCompanion<ServiceEntryRecord> {
  final Value<String> id;
  final Value<String> serviceId;
  final Value<int> position;
  final Value<String> requestedTitle;
  final Value<String> normalizedRequestedTitle;
  final Value<String?> requestedKey;
  final Value<String?> editionId;
  final Value<String> status;
  final Value<String> candidateEditionIdsJson;
  final Value<int> rowid;
  const ServiceEntriesCompanion({
    this.id = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.position = const Value.absent(),
    this.requestedTitle = const Value.absent(),
    this.normalizedRequestedTitle = const Value.absent(),
    this.requestedKey = const Value.absent(),
    this.editionId = const Value.absent(),
    this.status = const Value.absent(),
    this.candidateEditionIdsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceEntriesCompanion.insert({
    required String id,
    required String serviceId,
    required int position,
    required String requestedTitle,
    required String normalizedRequestedTitle,
    this.requestedKey = const Value.absent(),
    this.editionId = const Value.absent(),
    required String status,
    this.candidateEditionIdsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       serviceId = Value(serviceId),
       position = Value(position),
       requestedTitle = Value(requestedTitle),
       normalizedRequestedTitle = Value(normalizedRequestedTitle),
       status = Value(status);
  static Insertable<ServiceEntryRecord> custom({
    Expression<String>? id,
    Expression<String>? serviceId,
    Expression<int>? position,
    Expression<String>? requestedTitle,
    Expression<String>? normalizedRequestedTitle,
    Expression<String>? requestedKey,
    Expression<String>? editionId,
    Expression<String>? status,
    Expression<String>? candidateEditionIdsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serviceId != null) 'service_id': serviceId,
      if (position != null) 'position': position,
      if (requestedTitle != null) 'requested_title': requestedTitle,
      if (normalizedRequestedTitle != null)
        'normalized_requested_title': normalizedRequestedTitle,
      if (requestedKey != null) 'requested_key': requestedKey,
      if (editionId != null) 'edition_id': editionId,
      if (status != null) 'status': status,
      if (candidateEditionIdsJson != null)
        'candidate_edition_ids_json': candidateEditionIdsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? serviceId,
    Value<int>? position,
    Value<String>? requestedTitle,
    Value<String>? normalizedRequestedTitle,
    Value<String?>? requestedKey,
    Value<String?>? editionId,
    Value<String>? status,
    Value<String>? candidateEditionIdsJson,
    Value<int>? rowid,
  }) {
    return ServiceEntriesCompanion(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      position: position ?? this.position,
      requestedTitle: requestedTitle ?? this.requestedTitle,
      normalizedRequestedTitle:
          normalizedRequestedTitle ?? this.normalizedRequestedTitle,
      requestedKey: requestedKey ?? this.requestedKey,
      editionId: editionId ?? this.editionId,
      status: status ?? this.status,
      candidateEditionIdsJson:
          candidateEditionIdsJson ?? this.candidateEditionIdsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<String>(serviceId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (requestedTitle.present) {
      map['requested_title'] = Variable<String>(requestedTitle.value);
    }
    if (normalizedRequestedTitle.present) {
      map['normalized_requested_title'] = Variable<String>(
        normalizedRequestedTitle.value,
      );
    }
    if (requestedKey.present) {
      map['requested_key'] = Variable<String>(requestedKey.value);
    }
    if (editionId.present) {
      map['edition_id'] = Variable<String>(editionId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (candidateEditionIdsJson.present) {
      map['candidate_edition_ids_json'] = Variable<String>(
        candidateEditionIdsJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceEntriesCompanion(')
          ..write('id: $id, ')
          ..write('serviceId: $serviceId, ')
          ..write('position: $position, ')
          ..write('requestedTitle: $requestedTitle, ')
          ..write('normalizedRequestedTitle: $normalizedRequestedTitle, ')
          ..write('requestedKey: $requestedKey, ')
          ..write('editionId: $editionId, ')
          ..write('status: $status, ')
          ..write('candidateEditionIdsJson: $candidateEditionIdsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportJobsTable extends ImportJobs
    with TableInfo<$ImportJobsTable, ImportJobRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUriMeta = const VerificationMeta(
    'sourceUri',
  );
  @override
  late final GeneratedColumn<String> sourceUri = GeneratedColumn<String>(
    'source_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inputFingerprintMeta = const VerificationMeta(
    'inputFingerprint',
  );
  @override
  late final GeneratedColumn<String> inputFingerprint = GeneratedColumn<String>(
    'input_fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceUri,
    inputFingerprint,
    state,
    attempts,
    error,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportJobRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_uri')) {
      context.handle(
        _sourceUriMeta,
        sourceUri.isAcceptableOrUnknown(data['source_uri']!, _sourceUriMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUriMeta);
    }
    if (data.containsKey('input_fingerprint')) {
      context.handle(
        _inputFingerprintMeta,
        inputFingerprint.isAcceptableOrUnknown(
          data['input_fingerprint']!,
          _inputFingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inputFingerprintMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportJobRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportJobRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_uri'],
      )!,
      inputFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_fingerprint'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ImportJobsTable createAlias(String alias) {
    return $ImportJobsTable(attachedDatabase, alias);
  }
}

class ImportJobRecord extends DataClass implements Insertable<ImportJobRecord> {
  final String id;
  final String sourceUri;
  final String inputFingerprint;
  final String state;
  final int attempts;
  final String? error;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ImportJobRecord({
    required this.id,
    required this.sourceUri,
    required this.inputFingerprint,
    required this.state,
    required this.attempts,
    this.error,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_uri'] = Variable<String>(sourceUri);
    map['input_fingerprint'] = Variable<String>(inputFingerprint);
    map['state'] = Variable<String>(state);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ImportJobsCompanion toCompanion(bool nullToAbsent) {
    return ImportJobsCompanion(
      id: Value(id),
      sourceUri: Value(sourceUri),
      inputFingerprint: Value(inputFingerprint),
      state: Value(state),
      attempts: Value(attempts),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ImportJobRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportJobRecord(
      id: serializer.fromJson<String>(json['id']),
      sourceUri: serializer.fromJson<String>(json['sourceUri']),
      inputFingerprint: serializer.fromJson<String>(json['inputFingerprint']),
      state: serializer.fromJson<String>(json['state']),
      attempts: serializer.fromJson<int>(json['attempts']),
      error: serializer.fromJson<String?>(json['error']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceUri': serializer.toJson<String>(sourceUri),
      'inputFingerprint': serializer.toJson<String>(inputFingerprint),
      'state': serializer.toJson<String>(state),
      'attempts': serializer.toJson<int>(attempts),
      'error': serializer.toJson<String?>(error),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ImportJobRecord copyWith({
    String? id,
    String? sourceUri,
    String? inputFingerprint,
    String? state,
    int? attempts,
    Value<String?> error = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ImportJobRecord(
    id: id ?? this.id,
    sourceUri: sourceUri ?? this.sourceUri,
    inputFingerprint: inputFingerprint ?? this.inputFingerprint,
    state: state ?? this.state,
    attempts: attempts ?? this.attempts,
    error: error.present ? error.value : this.error,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ImportJobRecord copyWithCompanion(ImportJobsCompanion data) {
    return ImportJobRecord(
      id: data.id.present ? data.id.value : this.id,
      sourceUri: data.sourceUri.present ? data.sourceUri.value : this.sourceUri,
      inputFingerprint: data.inputFingerprint.present
          ? data.inputFingerprint.value
          : this.inputFingerprint,
      state: data.state.present ? data.state.value : this.state,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      error: data.error.present ? data.error.value : this.error,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportJobRecord(')
          ..write('id: $id, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('inputFingerprint: $inputFingerprint, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceUri,
    inputFingerprint,
    state,
    attempts,
    error,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportJobRecord &&
          other.id == this.id &&
          other.sourceUri == this.sourceUri &&
          other.inputFingerprint == this.inputFingerprint &&
          other.state == this.state &&
          other.attempts == this.attempts &&
          other.error == this.error &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ImportJobsCompanion extends UpdateCompanion<ImportJobRecord> {
  final Value<String> id;
  final Value<String> sourceUri;
  final Value<String> inputFingerprint;
  final Value<String> state;
  final Value<int> attempts;
  final Value<String?> error;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ImportJobsCompanion({
    this.id = const Value.absent(),
    this.sourceUri = const Value.absent(),
    this.inputFingerprint = const Value.absent(),
    this.state = const Value.absent(),
    this.attempts = const Value.absent(),
    this.error = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportJobsCompanion.insert({
    required String id,
    required String sourceUri,
    required String inputFingerprint,
    required String state,
    this.attempts = const Value.absent(),
    this.error = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceUri = Value(sourceUri),
       inputFingerprint = Value(inputFingerprint),
       state = Value(state),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ImportJobRecord> custom({
    Expression<String>? id,
    Expression<String>? sourceUri,
    Expression<String>? inputFingerprint,
    Expression<String>? state,
    Expression<int>? attempts,
    Expression<String>? error,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceUri != null) 'source_uri': sourceUri,
      if (inputFingerprint != null) 'input_fingerprint': inputFingerprint,
      if (state != null) 'state': state,
      if (attempts != null) 'attempts': attempts,
      if (error != null) 'error': error,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportJobsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceUri,
    Value<String>? inputFingerprint,
    Value<String>? state,
    Value<int>? attempts,
    Value<String?>? error,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ImportJobsCompanion(
      id: id ?? this.id,
      sourceUri: sourceUri ?? this.sourceUri,
      inputFingerprint: inputFingerprint ?? this.inputFingerprint,
      state: state ?? this.state,
      attempts: attempts ?? this.attempts,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceUri.present) {
      map['source_uri'] = Variable<String>(sourceUri.value);
    }
    if (inputFingerprint.present) {
      map['input_fingerprint'] = Variable<String>(inputFingerprint.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportJobsCompanion(')
          ..write('id: $id, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('inputFingerprint: $inputFingerprint, ')
          ..write('state: $state, ')
          ..write('attempts: $attempts, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FileOperationsTable extends FileOperations
    with TableInfo<$FileOperationsTable, FileOperationRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FileOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUriMeta = const VerificationMeta(
    'sourceUri',
  );
  @override
  late final GeneratedColumn<String> sourceUri = GeneratedColumn<String>(
    'source_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationNameMeta = const VerificationMeta(
    'destinationName',
  );
  @override
  late final GeneratedColumn<String> destinationName = GeneratedColumn<String>(
    'destination_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resultUriMeta = const VerificationMeta(
    'resultUri',
  );
  @override
  late final GeneratedColumn<String> resultUri = GeneratedColumn<String>(
    'result_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _retainedAssetIdMeta = const VerificationMeta(
    'retainedAssetId',
  );
  @override
  late final GeneratedColumn<String> retainedAssetId = GeneratedColumn<String>(
    'retained_asset_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sheet_assets (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _expectedFingerprintMeta =
      const VerificationMeta('expectedFingerprint');
  @override
  late final GeneratedColumn<String> expectedFingerprint =
      GeneratedColumn<String>(
        'expected_fingerprint',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    sourceUri,
    destinationName,
    resultUri,
    retainedAssetId,
    expectedFingerprint,
    state,
    error,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'file_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<FileOperationRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('source_uri')) {
      context.handle(
        _sourceUriMeta,
        sourceUri.isAcceptableOrUnknown(data['source_uri']!, _sourceUriMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUriMeta);
    }
    if (data.containsKey('destination_name')) {
      context.handle(
        _destinationNameMeta,
        destinationName.isAcceptableOrUnknown(
          data['destination_name']!,
          _destinationNameMeta,
        ),
      );
    }
    if (data.containsKey('result_uri')) {
      context.handle(
        _resultUriMeta,
        resultUri.isAcceptableOrUnknown(data['result_uri']!, _resultUriMeta),
      );
    }
    if (data.containsKey('retained_asset_id')) {
      context.handle(
        _retainedAssetIdMeta,
        retainedAssetId.isAcceptableOrUnknown(
          data['retained_asset_id']!,
          _retainedAssetIdMeta,
        ),
      );
    }
    if (data.containsKey('expected_fingerprint')) {
      context.handle(
        _expectedFingerprintMeta,
        expectedFingerprint.isAcceptableOrUnknown(
          data['expected_fingerprint']!,
          _expectedFingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedFingerprintMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FileOperationRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FileOperationRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      sourceUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_uri'],
      )!,
      destinationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_name'],
      ),
      resultUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_uri'],
      ),
      retainedAssetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}retained_asset_id'],
      ),
      expectedFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expected_fingerprint'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FileOperationsTable createAlias(String alias) {
    return $FileOperationsTable(attachedDatabase, alias);
  }
}

class FileOperationRecord extends DataClass
    implements Insertable<FileOperationRecord> {
  final String id;
  final String kind;
  final String sourceUri;
  final String? destinationName;
  final String? resultUri;
  final String? retainedAssetId;
  final String expectedFingerprint;
  final String state;
  final String? error;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FileOperationRecord({
    required this.id,
    required this.kind,
    required this.sourceUri,
    this.destinationName,
    this.resultUri,
    this.retainedAssetId,
    required this.expectedFingerprint,
    required this.state,
    this.error,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['source_uri'] = Variable<String>(sourceUri);
    if (!nullToAbsent || destinationName != null) {
      map['destination_name'] = Variable<String>(destinationName);
    }
    if (!nullToAbsent || resultUri != null) {
      map['result_uri'] = Variable<String>(resultUri);
    }
    if (!nullToAbsent || retainedAssetId != null) {
      map['retained_asset_id'] = Variable<String>(retainedAssetId);
    }
    map['expected_fingerprint'] = Variable<String>(expectedFingerprint);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FileOperationsCompanion toCompanion(bool nullToAbsent) {
    return FileOperationsCompanion(
      id: Value(id),
      kind: Value(kind),
      sourceUri: Value(sourceUri),
      destinationName: destinationName == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationName),
      resultUri: resultUri == null && nullToAbsent
          ? const Value.absent()
          : Value(resultUri),
      retainedAssetId: retainedAssetId == null && nullToAbsent
          ? const Value.absent()
          : Value(retainedAssetId),
      expectedFingerprint: Value(expectedFingerprint),
      state: Value(state),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FileOperationRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FileOperationRecord(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      sourceUri: serializer.fromJson<String>(json['sourceUri']),
      destinationName: serializer.fromJson<String?>(json['destinationName']),
      resultUri: serializer.fromJson<String?>(json['resultUri']),
      retainedAssetId: serializer.fromJson<String?>(json['retainedAssetId']),
      expectedFingerprint: serializer.fromJson<String>(
        json['expectedFingerprint'],
      ),
      state: serializer.fromJson<String>(json['state']),
      error: serializer.fromJson<String?>(json['error']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'sourceUri': serializer.toJson<String>(sourceUri),
      'destinationName': serializer.toJson<String?>(destinationName),
      'resultUri': serializer.toJson<String?>(resultUri),
      'retainedAssetId': serializer.toJson<String?>(retainedAssetId),
      'expectedFingerprint': serializer.toJson<String>(expectedFingerprint),
      'state': serializer.toJson<String>(state),
      'error': serializer.toJson<String?>(error),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FileOperationRecord copyWith({
    String? id,
    String? kind,
    String? sourceUri,
    Value<String?> destinationName = const Value.absent(),
    Value<String?> resultUri = const Value.absent(),
    Value<String?> retainedAssetId = const Value.absent(),
    String? expectedFingerprint,
    String? state,
    Value<String?> error = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FileOperationRecord(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    sourceUri: sourceUri ?? this.sourceUri,
    destinationName: destinationName.present
        ? destinationName.value
        : this.destinationName,
    resultUri: resultUri.present ? resultUri.value : this.resultUri,
    retainedAssetId: retainedAssetId.present
        ? retainedAssetId.value
        : this.retainedAssetId,
    expectedFingerprint: expectedFingerprint ?? this.expectedFingerprint,
    state: state ?? this.state,
    error: error.present ? error.value : this.error,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FileOperationRecord copyWithCompanion(FileOperationsCompanion data) {
    return FileOperationRecord(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      sourceUri: data.sourceUri.present ? data.sourceUri.value : this.sourceUri,
      destinationName: data.destinationName.present
          ? data.destinationName.value
          : this.destinationName,
      resultUri: data.resultUri.present ? data.resultUri.value : this.resultUri,
      retainedAssetId: data.retainedAssetId.present
          ? data.retainedAssetId.value
          : this.retainedAssetId,
      expectedFingerprint: data.expectedFingerprint.present
          ? data.expectedFingerprint.value
          : this.expectedFingerprint,
      state: data.state.present ? data.state.value : this.state,
      error: data.error.present ? data.error.value : this.error,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FileOperationRecord(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('destinationName: $destinationName, ')
          ..write('resultUri: $resultUri, ')
          ..write('retainedAssetId: $retainedAssetId, ')
          ..write('expectedFingerprint: $expectedFingerprint, ')
          ..write('state: $state, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    sourceUri,
    destinationName,
    resultUri,
    retainedAssetId,
    expectedFingerprint,
    state,
    error,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FileOperationRecord &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.sourceUri == this.sourceUri &&
          other.destinationName == this.destinationName &&
          other.resultUri == this.resultUri &&
          other.retainedAssetId == this.retainedAssetId &&
          other.expectedFingerprint == this.expectedFingerprint &&
          other.state == this.state &&
          other.error == this.error &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FileOperationsCompanion extends UpdateCompanion<FileOperationRecord> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> sourceUri;
  final Value<String?> destinationName;
  final Value<String?> resultUri;
  final Value<String?> retainedAssetId;
  final Value<String> expectedFingerprint;
  final Value<String> state;
  final Value<String?> error;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FileOperationsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.sourceUri = const Value.absent(),
    this.destinationName = const Value.absent(),
    this.resultUri = const Value.absent(),
    this.retainedAssetId = const Value.absent(),
    this.expectedFingerprint = const Value.absent(),
    this.state = const Value.absent(),
    this.error = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FileOperationsCompanion.insert({
    required String id,
    required String kind,
    required String sourceUri,
    this.destinationName = const Value.absent(),
    this.resultUri = const Value.absent(),
    this.retainedAssetId = const Value.absent(),
    required String expectedFingerprint,
    required String state,
    this.error = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       sourceUri = Value(sourceUri),
       expectedFingerprint = Value(expectedFingerprint),
       state = Value(state),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FileOperationRecord> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? sourceUri,
    Expression<String>? destinationName,
    Expression<String>? resultUri,
    Expression<String>? retainedAssetId,
    Expression<String>? expectedFingerprint,
    Expression<String>? state,
    Expression<String>? error,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (sourceUri != null) 'source_uri': sourceUri,
      if (destinationName != null) 'destination_name': destinationName,
      if (resultUri != null) 'result_uri': resultUri,
      if (retainedAssetId != null) 'retained_asset_id': retainedAssetId,
      if (expectedFingerprint != null)
        'expected_fingerprint': expectedFingerprint,
      if (state != null) 'state': state,
      if (error != null) 'error': error,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FileOperationsCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? sourceUri,
    Value<String?>? destinationName,
    Value<String?>? resultUri,
    Value<String?>? retainedAssetId,
    Value<String>? expectedFingerprint,
    Value<String>? state,
    Value<String?>? error,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FileOperationsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      sourceUri: sourceUri ?? this.sourceUri,
      destinationName: destinationName ?? this.destinationName,
      resultUri: resultUri ?? this.resultUri,
      retainedAssetId: retainedAssetId ?? this.retainedAssetId,
      expectedFingerprint: expectedFingerprint ?? this.expectedFingerprint,
      state: state ?? this.state,
      error: error ?? this.error,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (sourceUri.present) {
      map['source_uri'] = Variable<String>(sourceUri.value);
    }
    if (destinationName.present) {
      map['destination_name'] = Variable<String>(destinationName.value);
    }
    if (resultUri.present) {
      map['result_uri'] = Variable<String>(resultUri.value);
    }
    if (retainedAssetId.present) {
      map['retained_asset_id'] = Variable<String>(retainedAssetId.value);
    }
    if (expectedFingerprint.present) {
      map['expected_fingerprint'] = Variable<String>(expectedFingerprint.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FileOperationsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('destinationName: $destinationName, ')
          ..write('resultUri: $resultUri, ')
          ..write('retainedAssetId: $retainedAssetId, ')
          ..write('expectedFingerprint: $expectedFingerprint, ')
          ..write('state: $state, ')
          ..write('error: $error, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReaderProgressTable extends ReaderProgress
    with TableInfo<$ReaderProgressTable, ReaderProgressRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReaderProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<String> serviceId = GeneratedColumn<String>(
    'service_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_collections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pagePositionMeta = const VerificationMeta(
    'pagePosition',
  );
  @override
  late final GeneratedColumn<int> pagePosition = GeneratedColumn<int>(
    'page_position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    serviceId,
    entryId,
    pagePosition,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reader_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReaderProgressRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('page_position')) {
      context.handle(
        _pagePositionMeta,
        pagePosition.isAcceptableOrUnknown(
          data['page_position']!,
          _pagePositionMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serviceId};
  @override
  ReaderProgressRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReaderProgressRecord(
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      pagePosition: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_position'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReaderProgressTable createAlias(String alias) {
    return $ReaderProgressTable(attachedDatabase, alias);
  }
}

class ReaderProgressRecord extends DataClass
    implements Insertable<ReaderProgressRecord> {
  final String serviceId;
  final String entryId;
  final int pagePosition;
  final DateTime updatedAt;
  const ReaderProgressRecord({
    required this.serviceId,
    required this.entryId,
    required this.pagePosition,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['service_id'] = Variable<String>(serviceId);
    map['entry_id'] = Variable<String>(entryId);
    map['page_position'] = Variable<int>(pagePosition);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReaderProgressCompanion toCompanion(bool nullToAbsent) {
    return ReaderProgressCompanion(
      serviceId: Value(serviceId),
      entryId: Value(entryId),
      pagePosition: Value(pagePosition),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReaderProgressRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReaderProgressRecord(
      serviceId: serializer.fromJson<String>(json['serviceId']),
      entryId: serializer.fromJson<String>(json['entryId']),
      pagePosition: serializer.fromJson<int>(json['pagePosition']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serviceId': serializer.toJson<String>(serviceId),
      'entryId': serializer.toJson<String>(entryId),
      'pagePosition': serializer.toJson<int>(pagePosition),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReaderProgressRecord copyWith({
    String? serviceId,
    String? entryId,
    int? pagePosition,
    DateTime? updatedAt,
  }) => ReaderProgressRecord(
    serviceId: serviceId ?? this.serviceId,
    entryId: entryId ?? this.entryId,
    pagePosition: pagePosition ?? this.pagePosition,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReaderProgressRecord copyWithCompanion(ReaderProgressCompanion data) {
    return ReaderProgressRecord(
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      pagePosition: data.pagePosition.present
          ? data.pagePosition.value
          : this.pagePosition,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReaderProgressRecord(')
          ..write('serviceId: $serviceId, ')
          ..write('entryId: $entryId, ')
          ..write('pagePosition: $pagePosition, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(serviceId, entryId, pagePosition, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReaderProgressRecord &&
          other.serviceId == this.serviceId &&
          other.entryId == this.entryId &&
          other.pagePosition == this.pagePosition &&
          other.updatedAt == this.updatedAt);
}

class ReaderProgressCompanion extends UpdateCompanion<ReaderProgressRecord> {
  final Value<String> serviceId;
  final Value<String> entryId;
  final Value<int> pagePosition;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReaderProgressCompanion({
    this.serviceId = const Value.absent(),
    this.entryId = const Value.absent(),
    this.pagePosition = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReaderProgressCompanion.insert({
    required String serviceId,
    required String entryId,
    this.pagePosition = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : serviceId = Value(serviceId),
       entryId = Value(entryId),
       updatedAt = Value(updatedAt);
  static Insertable<ReaderProgressRecord> custom({
    Expression<String>? serviceId,
    Expression<String>? entryId,
    Expression<int>? pagePosition,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serviceId != null) 'service_id': serviceId,
      if (entryId != null) 'entry_id': entryId,
      if (pagePosition != null) 'page_position': pagePosition,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReaderProgressCompanion copyWith({
    Value<String>? serviceId,
    Value<String>? entryId,
    Value<int>? pagePosition,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReaderProgressCompanion(
      serviceId: serviceId ?? this.serviceId,
      entryId: entryId ?? this.entryId,
      pagePosition: pagePosition ?? this.pagePosition,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serviceId.present) {
      map['service_id'] = Variable<String>(serviceId.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (pagePosition.present) {
      map['page_position'] = Variable<int>(pagePosition.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReaderProgressCompanion(')
          ..write('serviceId: $serviceId, ')
          ..write('entryId: $entryId, ')
          ..write('pagePosition: $pagePosition, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, SettingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRecord(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class SettingRecord extends DataClass implements Insertable<SettingRecord> {
  final String key;
  final String value;
  const SettingRecord({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRecord(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRecord copyWith({String? key, String? value}) =>
      SettingRecord(key: key ?? this.key, value: value ?? this.value);
  SettingRecord copyWithCompanion(AppSettingsCompanion data) {
    return SettingRecord(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRecord(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRecord &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<SettingRecord> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRecord> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourceFoldersTable extends SourceFolders
    with TableInfo<$SourceFoldersTable, SourceFolderRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourceFoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _treeUriMeta = const VerificationMeta(
    'treeUri',
  );
  @override
  late final GeneratedColumn<String> treeUri = GeneratedColumn<String>(
    'tree_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _includeSubfoldersMeta = const VerificationMeta(
    'includeSubfolders',
  );
  @override
  late final GeneratedColumn<bool> includeSubfolders = GeneratedColumn<bool>(
    'include_subfolders',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("include_subfolders" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    treeUri,
    displayName,
    includeSubfolders,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'source_folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<SourceFolderRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tree_uri')) {
      context.handle(
        _treeUriMeta,
        treeUri.isAcceptableOrUnknown(data['tree_uri']!, _treeUriMeta),
      );
    } else if (isInserting) {
      context.missing(_treeUriMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('include_subfolders')) {
      context.handle(
        _includeSubfoldersMeta,
        includeSubfolders.isAcceptableOrUnknown(
          data['include_subfolders']!,
          _includeSubfoldersMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceFolderRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceFolderRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      treeUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tree_uri'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      includeSubfolders: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}include_subfolders'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $SourceFoldersTable createAlias(String alias) {
    return $SourceFoldersTable(attachedDatabase, alias);
  }
}

class SourceFolderRecord extends DataClass
    implements Insertable<SourceFolderRecord> {
  final String id;
  final String treeUri;
  final String displayName;
  final bool includeSubfolders;
  final DateTime addedAt;
  const SourceFolderRecord({
    required this.id,
    required this.treeUri,
    required this.displayName,
    required this.includeSubfolders,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tree_uri'] = Variable<String>(treeUri);
    map['display_name'] = Variable<String>(displayName);
    map['include_subfolders'] = Variable<bool>(includeSubfolders);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  SourceFoldersCompanion toCompanion(bool nullToAbsent) {
    return SourceFoldersCompanion(
      id: Value(id),
      treeUri: Value(treeUri),
      displayName: Value(displayName),
      includeSubfolders: Value(includeSubfolders),
      addedAt: Value(addedAt),
    );
  }

  factory SourceFolderRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceFolderRecord(
      id: serializer.fromJson<String>(json['id']),
      treeUri: serializer.fromJson<String>(json['treeUri']),
      displayName: serializer.fromJson<String>(json['displayName']),
      includeSubfolders: serializer.fromJson<bool>(json['includeSubfolders']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'treeUri': serializer.toJson<String>(treeUri),
      'displayName': serializer.toJson<String>(displayName),
      'includeSubfolders': serializer.toJson<bool>(includeSubfolders),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  SourceFolderRecord copyWith({
    String? id,
    String? treeUri,
    String? displayName,
    bool? includeSubfolders,
    DateTime? addedAt,
  }) => SourceFolderRecord(
    id: id ?? this.id,
    treeUri: treeUri ?? this.treeUri,
    displayName: displayName ?? this.displayName,
    includeSubfolders: includeSubfolders ?? this.includeSubfolders,
    addedAt: addedAt ?? this.addedAt,
  );
  SourceFolderRecord copyWithCompanion(SourceFoldersCompanion data) {
    return SourceFolderRecord(
      id: data.id.present ? data.id.value : this.id,
      treeUri: data.treeUri.present ? data.treeUri.value : this.treeUri,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      includeSubfolders: data.includeSubfolders.present
          ? data.includeSubfolders.value
          : this.includeSubfolders,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceFolderRecord(')
          ..write('id: $id, ')
          ..write('treeUri: $treeUri, ')
          ..write('displayName: $displayName, ')
          ..write('includeSubfolders: $includeSubfolders, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, treeUri, displayName, includeSubfolders, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceFolderRecord &&
          other.id == this.id &&
          other.treeUri == this.treeUri &&
          other.displayName == this.displayName &&
          other.includeSubfolders == this.includeSubfolders &&
          other.addedAt == this.addedAt);
}

class SourceFoldersCompanion extends UpdateCompanion<SourceFolderRecord> {
  final Value<String> id;
  final Value<String> treeUri;
  final Value<String> displayName;
  final Value<bool> includeSubfolders;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const SourceFoldersCompanion({
    this.id = const Value.absent(),
    this.treeUri = const Value.absent(),
    this.displayName = const Value.absent(),
    this.includeSubfolders = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourceFoldersCompanion.insert({
    required String id,
    required String treeUri,
    required String displayName,
    this.includeSubfolders = const Value.absent(),
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       treeUri = Value(treeUri),
       displayName = Value(displayName),
       addedAt = Value(addedAt);
  static Insertable<SourceFolderRecord> custom({
    Expression<String>? id,
    Expression<String>? treeUri,
    Expression<String>? displayName,
    Expression<bool>? includeSubfolders,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (treeUri != null) 'tree_uri': treeUri,
      if (displayName != null) 'display_name': displayName,
      if (includeSubfolders != null) 'include_subfolders': includeSubfolders,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourceFoldersCompanion copyWith({
    Value<String>? id,
    Value<String>? treeUri,
    Value<String>? displayName,
    Value<bool>? includeSubfolders,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return SourceFoldersCompanion(
      id: id ?? this.id,
      treeUri: treeUri ?? this.treeUri,
      displayName: displayName ?? this.displayName,
      includeSubfolders: includeSubfolders ?? this.includeSubfolders,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (treeUri.present) {
      map['tree_uri'] = Variable<String>(treeUri.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (includeSubfolders.present) {
      map['include_subfolders'] = Variable<bool>(includeSubfolders.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourceFoldersCompanion(')
          ..write('id: $id, ')
          ..write('treeUri: $treeUri, ')
          ..write('displayName: $displayName, ')
          ..write('includeSubfolders: $includeSubfolders, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiscoveryLedgerTable extends DiscoveryLedger
    with TableInfo<$DiscoveryLedgerTable, DiscoveryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiscoveryLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stableIdentityMeta = const VerificationMeta(
    'stableIdentity',
  );
  @override
  late final GeneratedColumn<String> stableIdentity = GeneratedColumn<String>(
    'stable_identity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _sourceFolderIdMeta = const VerificationMeta(
    'sourceFolderId',
  );
  @override
  late final GeneratedColumn<String> sourceFolderId = GeneratedColumn<String>(
    'source_folder_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES source_folders (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _documentUriMeta = const VerificationMeta(
    'documentUri',
  );
  @override
  late final GeneratedColumn<String> documentUri = GeneratedColumn<String>(
    'document_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _parentUriMeta = const VerificationMeta(
    'parentUri',
  );
  @override
  late final GeneratedColumn<String> parentUri = GeneratedColumn<String>(
    'parent_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filenameMeta = const VerificationMeta(
    'filename',
  );
  @override
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
    'filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _byteSizeMeta = const VerificationMeta(
    'byteSize',
  );
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
    'byte_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerAddedAtMeta = const VerificationMeta(
    'providerAddedAt',
  );
  @override
  late final GeneratedColumn<DateTime> providerAddedAt =
      GeneratedColumn<DateTime>(
        'provider_added_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _firstSeenAtMeta = const VerificationMeta(
    'firstSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> firstSeenAt = GeneratedColumn<DateTime>(
    'first_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eligibilityDateMeta = const VerificationMeta(
    'eligibilityDate',
  );
  @override
  late final GeneratedColumn<DateTime> eligibilityDate =
      GeneratedColumn<DateTime>(
        'eligibility_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dateSourceMeta = const VerificationMeta(
    'dateSource',
  );
  @override
  late final GeneratedColumn<String> dateSource = GeneratedColumn<String>(
    'date_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedAtMeta = const VerificationMeta(
    'modifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
    'modified_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataFingerprintMeta =
      const VerificationMeta('metadataFingerprint');
  @override
  late final GeneratedColumn<String> metadataFingerprint =
      GeneratedColumn<String>(
        'metadata_fingerprint',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _processingVersionMeta = const VerificationMeta(
    'processingVersion',
  );
  @override
  late final GeneratedColumn<int> processingVersion = GeneratedColumn<int>(
    'processing_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _classificationMeta = const VerificationMeta(
    'classification',
  );
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
    'classification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unclassified'),
  );
  static const VerificationMeta _classificationScoreMeta =
      const VerificationMeta('classificationScore');
  @override
  late final GeneratedColumn<double> classificationScore =
      GeneratedColumn<double>(
        'classification_score',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _processingStateMeta = const VerificationMeta(
    'processingState',
  );
  @override
  late final GeneratedColumn<String> processingState = GeneratedColumn<String>(
    'processing_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('discovered'),
  );
  static const VerificationMeta _failureReasonMeta = const VerificationMeta(
    'failureReason',
  );
  @override
  late final GeneratedColumn<String> failureReason = GeneratedColumn<String>(
    'failure_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pixelFingerprintMeta = const VerificationMeta(
    'pixelFingerprint',
  );
  @override
  late final GeneratedColumn<String> pixelFingerprint = GeneratedColumn<String>(
    'pixel_fingerprint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentUriMeta = const VerificationMeta(
    'currentUri',
  );
  @override
  late final GeneratedColumn<String> currentUri = GeneratedColumn<String>(
    'current_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stageTimingsJsonMeta = const VerificationMeta(
    'stageTimingsJson',
  );
  @override
  late final GeneratedColumn<String> stageTimingsJson = GeneratedColumn<String>(
    'stage_timings_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _lastProcessedAtMeta = const VerificationMeta(
    'lastProcessedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastProcessedAt =
      GeneratedColumn<DateTime>(
        'last_processed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    stableIdentity,
    sourceFolderId,
    documentUri,
    parentUri,
    filename,
    mimeType,
    byteSize,
    providerAddedAt,
    firstSeenAt,
    eligibilityDate,
    dateSource,
    modifiedAt,
    metadataFingerprint,
    processingVersion,
    classification,
    classificationScore,
    processingState,
    failureReason,
    sha256,
    pixelFingerprint,
    currentUri,
    stageTimingsJson,
    lastProcessedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'discovery_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiscoveryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('stable_identity')) {
      context.handle(
        _stableIdentityMeta,
        stableIdentity.isAcceptableOrUnknown(
          data['stable_identity']!,
          _stableIdentityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stableIdentityMeta);
    }
    if (data.containsKey('source_folder_id')) {
      context.handle(
        _sourceFolderIdMeta,
        sourceFolderId.isAcceptableOrUnknown(
          data['source_folder_id']!,
          _sourceFolderIdMeta,
        ),
      );
    }
    if (data.containsKey('document_uri')) {
      context.handle(
        _documentUriMeta,
        documentUri.isAcceptableOrUnknown(
          data['document_uri']!,
          _documentUriMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentUriMeta);
    }
    if (data.containsKey('parent_uri')) {
      context.handle(
        _parentUriMeta,
        parentUri.isAcceptableOrUnknown(data['parent_uri']!, _parentUriMeta),
      );
    }
    if (data.containsKey('filename')) {
      context.handle(
        _filenameMeta,
        filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta),
      );
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('byte_size')) {
      context.handle(
        _byteSizeMeta,
        byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_byteSizeMeta);
    }
    if (data.containsKey('provider_added_at')) {
      context.handle(
        _providerAddedAtMeta,
        providerAddedAt.isAcceptableOrUnknown(
          data['provider_added_at']!,
          _providerAddedAtMeta,
        ),
      );
    }
    if (data.containsKey('first_seen_at')) {
      context.handle(
        _firstSeenAtMeta,
        firstSeenAt.isAcceptableOrUnknown(
          data['first_seen_at']!,
          _firstSeenAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstSeenAtMeta);
    }
    if (data.containsKey('eligibility_date')) {
      context.handle(
        _eligibilityDateMeta,
        eligibilityDate.isAcceptableOrUnknown(
          data['eligibility_date']!,
          _eligibilityDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_eligibilityDateMeta);
    }
    if (data.containsKey('date_source')) {
      context.handle(
        _dateSourceMeta,
        dateSource.isAcceptableOrUnknown(data['date_source']!, _dateSourceMeta),
      );
    } else if (isInserting) {
      context.missing(_dateSourceMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
        _modifiedAtMeta,
        modifiedAt.isAcceptableOrUnknown(data['modified_at']!, _modifiedAtMeta),
      );
    }
    if (data.containsKey('metadata_fingerprint')) {
      context.handle(
        _metadataFingerprintMeta,
        metadataFingerprint.isAcceptableOrUnknown(
          data['metadata_fingerprint']!,
          _metadataFingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_metadataFingerprintMeta);
    }
    if (data.containsKey('processing_version')) {
      context.handle(
        _processingVersionMeta,
        processingVersion.isAcceptableOrUnknown(
          data['processing_version']!,
          _processingVersionMeta,
        ),
      );
    }
    if (data.containsKey('classification')) {
      context.handle(
        _classificationMeta,
        classification.isAcceptableOrUnknown(
          data['classification']!,
          _classificationMeta,
        ),
      );
    }
    if (data.containsKey('classification_score')) {
      context.handle(
        _classificationScoreMeta,
        classificationScore.isAcceptableOrUnknown(
          data['classification_score']!,
          _classificationScoreMeta,
        ),
      );
    }
    if (data.containsKey('processing_state')) {
      context.handle(
        _processingStateMeta,
        processingState.isAcceptableOrUnknown(
          data['processing_state']!,
          _processingStateMeta,
        ),
      );
    }
    if (data.containsKey('failure_reason')) {
      context.handle(
        _failureReasonMeta,
        failureReason.isAcceptableOrUnknown(
          data['failure_reason']!,
          _failureReasonMeta,
        ),
      );
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    }
    if (data.containsKey('pixel_fingerprint')) {
      context.handle(
        _pixelFingerprintMeta,
        pixelFingerprint.isAcceptableOrUnknown(
          data['pixel_fingerprint']!,
          _pixelFingerprintMeta,
        ),
      );
    }
    if (data.containsKey('current_uri')) {
      context.handle(
        _currentUriMeta,
        currentUri.isAcceptableOrUnknown(data['current_uri']!, _currentUriMeta),
      );
    } else if (isInserting) {
      context.missing(_currentUriMeta);
    }
    if (data.containsKey('stage_timings_json')) {
      context.handle(
        _stageTimingsJsonMeta,
        stageTimingsJson.isAcceptableOrUnknown(
          data['stage_timings_json']!,
          _stageTimingsJsonMeta,
        ),
      );
    }
    if (data.containsKey('last_processed_at')) {
      context.handle(
        _lastProcessedAtMeta,
        lastProcessedAt.isAcceptableOrUnknown(
          data['last_processed_at']!,
          _lastProcessedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiscoveryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiscoveryRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      stableIdentity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stable_identity'],
      )!,
      sourceFolderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_folder_id'],
      ),
      documentUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_uri'],
      )!,
      parentUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_uri'],
      ),
      filename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filename'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      byteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_size'],
      )!,
      providerAddedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}provider_added_at'],
      ),
      firstSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_seen_at'],
      )!,
      eligibilityDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}eligibility_date'],
      )!,
      dateSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_source'],
      )!,
      modifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modified_at'],
      ),
      metadataFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_fingerprint'],
      )!,
      processingVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}processing_version'],
      )!,
      classification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classification'],
      )!,
      classificationScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}classification_score'],
      ),
      processingState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}processing_state'],
      )!,
      failureReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}failure_reason'],
      ),
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      ),
      pixelFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pixel_fingerprint'],
      ),
      currentUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_uri'],
      )!,
      stageTimingsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage_timings_json'],
      )!,
      lastProcessedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_processed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DiscoveryLedgerTable createAlias(String alias) {
    return $DiscoveryLedgerTable(attachedDatabase, alias);
  }
}

class DiscoveryRecord extends DataClass implements Insertable<DiscoveryRecord> {
  final String id;
  final String stableIdentity;
  final String? sourceFolderId;
  final String documentUri;
  final String? parentUri;
  final String filename;
  final String mimeType;
  final int byteSize;
  final DateTime? providerAddedAt;
  final DateTime firstSeenAt;
  final DateTime eligibilityDate;
  final String dateSource;
  final DateTime? modifiedAt;
  final String metadataFingerprint;
  final int processingVersion;
  final String classification;
  final double? classificationScore;
  final String processingState;
  final String? failureReason;
  final String? sha256;
  final String? pixelFingerprint;
  final String currentUri;
  final String stageTimingsJson;
  final DateTime? lastProcessedAt;
  final DateTime updatedAt;
  const DiscoveryRecord({
    required this.id,
    required this.stableIdentity,
    this.sourceFolderId,
    required this.documentUri,
    this.parentUri,
    required this.filename,
    required this.mimeType,
    required this.byteSize,
    this.providerAddedAt,
    required this.firstSeenAt,
    required this.eligibilityDate,
    required this.dateSource,
    this.modifiedAt,
    required this.metadataFingerprint,
    required this.processingVersion,
    required this.classification,
    this.classificationScore,
    required this.processingState,
    this.failureReason,
    this.sha256,
    this.pixelFingerprint,
    required this.currentUri,
    required this.stageTimingsJson,
    this.lastProcessedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['stable_identity'] = Variable<String>(stableIdentity);
    if (!nullToAbsent || sourceFolderId != null) {
      map['source_folder_id'] = Variable<String>(sourceFolderId);
    }
    map['document_uri'] = Variable<String>(documentUri);
    if (!nullToAbsent || parentUri != null) {
      map['parent_uri'] = Variable<String>(parentUri);
    }
    map['filename'] = Variable<String>(filename);
    map['mime_type'] = Variable<String>(mimeType);
    map['byte_size'] = Variable<int>(byteSize);
    if (!nullToAbsent || providerAddedAt != null) {
      map['provider_added_at'] = Variable<DateTime>(providerAddedAt);
    }
    map['first_seen_at'] = Variable<DateTime>(firstSeenAt);
    map['eligibility_date'] = Variable<DateTime>(eligibilityDate);
    map['date_source'] = Variable<String>(dateSource);
    if (!nullToAbsent || modifiedAt != null) {
      map['modified_at'] = Variable<DateTime>(modifiedAt);
    }
    map['metadata_fingerprint'] = Variable<String>(metadataFingerprint);
    map['processing_version'] = Variable<int>(processingVersion);
    map['classification'] = Variable<String>(classification);
    if (!nullToAbsent || classificationScore != null) {
      map['classification_score'] = Variable<double>(classificationScore);
    }
    map['processing_state'] = Variable<String>(processingState);
    if (!nullToAbsent || failureReason != null) {
      map['failure_reason'] = Variable<String>(failureReason);
    }
    if (!nullToAbsent || sha256 != null) {
      map['sha256'] = Variable<String>(sha256);
    }
    if (!nullToAbsent || pixelFingerprint != null) {
      map['pixel_fingerprint'] = Variable<String>(pixelFingerprint);
    }
    map['current_uri'] = Variable<String>(currentUri);
    map['stage_timings_json'] = Variable<String>(stageTimingsJson);
    if (!nullToAbsent || lastProcessedAt != null) {
      map['last_processed_at'] = Variable<DateTime>(lastProcessedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DiscoveryLedgerCompanion toCompanion(bool nullToAbsent) {
    return DiscoveryLedgerCompanion(
      id: Value(id),
      stableIdentity: Value(stableIdentity),
      sourceFolderId: sourceFolderId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceFolderId),
      documentUri: Value(documentUri),
      parentUri: parentUri == null && nullToAbsent
          ? const Value.absent()
          : Value(parentUri),
      filename: Value(filename),
      mimeType: Value(mimeType),
      byteSize: Value(byteSize),
      providerAddedAt: providerAddedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(providerAddedAt),
      firstSeenAt: Value(firstSeenAt),
      eligibilityDate: Value(eligibilityDate),
      dateSource: Value(dateSource),
      modifiedAt: modifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(modifiedAt),
      metadataFingerprint: Value(metadataFingerprint),
      processingVersion: Value(processingVersion),
      classification: Value(classification),
      classificationScore: classificationScore == null && nullToAbsent
          ? const Value.absent()
          : Value(classificationScore),
      processingState: Value(processingState),
      failureReason: failureReason == null && nullToAbsent
          ? const Value.absent()
          : Value(failureReason),
      sha256: sha256 == null && nullToAbsent
          ? const Value.absent()
          : Value(sha256),
      pixelFingerprint: pixelFingerprint == null && nullToAbsent
          ? const Value.absent()
          : Value(pixelFingerprint),
      currentUri: Value(currentUri),
      stageTimingsJson: Value(stageTimingsJson),
      lastProcessedAt: lastProcessedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastProcessedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DiscoveryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiscoveryRecord(
      id: serializer.fromJson<String>(json['id']),
      stableIdentity: serializer.fromJson<String>(json['stableIdentity']),
      sourceFolderId: serializer.fromJson<String?>(json['sourceFolderId']),
      documentUri: serializer.fromJson<String>(json['documentUri']),
      parentUri: serializer.fromJson<String?>(json['parentUri']),
      filename: serializer.fromJson<String>(json['filename']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      byteSize: serializer.fromJson<int>(json['byteSize']),
      providerAddedAt: serializer.fromJson<DateTime?>(json['providerAddedAt']),
      firstSeenAt: serializer.fromJson<DateTime>(json['firstSeenAt']),
      eligibilityDate: serializer.fromJson<DateTime>(json['eligibilityDate']),
      dateSource: serializer.fromJson<String>(json['dateSource']),
      modifiedAt: serializer.fromJson<DateTime?>(json['modifiedAt']),
      metadataFingerprint: serializer.fromJson<String>(
        json['metadataFingerprint'],
      ),
      processingVersion: serializer.fromJson<int>(json['processingVersion']),
      classification: serializer.fromJson<String>(json['classification']),
      classificationScore: serializer.fromJson<double?>(
        json['classificationScore'],
      ),
      processingState: serializer.fromJson<String>(json['processingState']),
      failureReason: serializer.fromJson<String?>(json['failureReason']),
      sha256: serializer.fromJson<String?>(json['sha256']),
      pixelFingerprint: serializer.fromJson<String?>(json['pixelFingerprint']),
      currentUri: serializer.fromJson<String>(json['currentUri']),
      stageTimingsJson: serializer.fromJson<String>(json['stageTimingsJson']),
      lastProcessedAt: serializer.fromJson<DateTime?>(json['lastProcessedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'stableIdentity': serializer.toJson<String>(stableIdentity),
      'sourceFolderId': serializer.toJson<String?>(sourceFolderId),
      'documentUri': serializer.toJson<String>(documentUri),
      'parentUri': serializer.toJson<String?>(parentUri),
      'filename': serializer.toJson<String>(filename),
      'mimeType': serializer.toJson<String>(mimeType),
      'byteSize': serializer.toJson<int>(byteSize),
      'providerAddedAt': serializer.toJson<DateTime?>(providerAddedAt),
      'firstSeenAt': serializer.toJson<DateTime>(firstSeenAt),
      'eligibilityDate': serializer.toJson<DateTime>(eligibilityDate),
      'dateSource': serializer.toJson<String>(dateSource),
      'modifiedAt': serializer.toJson<DateTime?>(modifiedAt),
      'metadataFingerprint': serializer.toJson<String>(metadataFingerprint),
      'processingVersion': serializer.toJson<int>(processingVersion),
      'classification': serializer.toJson<String>(classification),
      'classificationScore': serializer.toJson<double?>(classificationScore),
      'processingState': serializer.toJson<String>(processingState),
      'failureReason': serializer.toJson<String?>(failureReason),
      'sha256': serializer.toJson<String?>(sha256),
      'pixelFingerprint': serializer.toJson<String?>(pixelFingerprint),
      'currentUri': serializer.toJson<String>(currentUri),
      'stageTimingsJson': serializer.toJson<String>(stageTimingsJson),
      'lastProcessedAt': serializer.toJson<DateTime?>(lastProcessedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DiscoveryRecord copyWith({
    String? id,
    String? stableIdentity,
    Value<String?> sourceFolderId = const Value.absent(),
    String? documentUri,
    Value<String?> parentUri = const Value.absent(),
    String? filename,
    String? mimeType,
    int? byteSize,
    Value<DateTime?> providerAddedAt = const Value.absent(),
    DateTime? firstSeenAt,
    DateTime? eligibilityDate,
    String? dateSource,
    Value<DateTime?> modifiedAt = const Value.absent(),
    String? metadataFingerprint,
    int? processingVersion,
    String? classification,
    Value<double?> classificationScore = const Value.absent(),
    String? processingState,
    Value<String?> failureReason = const Value.absent(),
    Value<String?> sha256 = const Value.absent(),
    Value<String?> pixelFingerprint = const Value.absent(),
    String? currentUri,
    String? stageTimingsJson,
    Value<DateTime?> lastProcessedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => DiscoveryRecord(
    id: id ?? this.id,
    stableIdentity: stableIdentity ?? this.stableIdentity,
    sourceFolderId: sourceFolderId.present
        ? sourceFolderId.value
        : this.sourceFolderId,
    documentUri: documentUri ?? this.documentUri,
    parentUri: parentUri.present ? parentUri.value : this.parentUri,
    filename: filename ?? this.filename,
    mimeType: mimeType ?? this.mimeType,
    byteSize: byteSize ?? this.byteSize,
    providerAddedAt: providerAddedAt.present
        ? providerAddedAt.value
        : this.providerAddedAt,
    firstSeenAt: firstSeenAt ?? this.firstSeenAt,
    eligibilityDate: eligibilityDate ?? this.eligibilityDate,
    dateSource: dateSource ?? this.dateSource,
    modifiedAt: modifiedAt.present ? modifiedAt.value : this.modifiedAt,
    metadataFingerprint: metadataFingerprint ?? this.metadataFingerprint,
    processingVersion: processingVersion ?? this.processingVersion,
    classification: classification ?? this.classification,
    classificationScore: classificationScore.present
        ? classificationScore.value
        : this.classificationScore,
    processingState: processingState ?? this.processingState,
    failureReason: failureReason.present
        ? failureReason.value
        : this.failureReason,
    sha256: sha256.present ? sha256.value : this.sha256,
    pixelFingerprint: pixelFingerprint.present
        ? pixelFingerprint.value
        : this.pixelFingerprint,
    currentUri: currentUri ?? this.currentUri,
    stageTimingsJson: stageTimingsJson ?? this.stageTimingsJson,
    lastProcessedAt: lastProcessedAt.present
        ? lastProcessedAt.value
        : this.lastProcessedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DiscoveryRecord copyWithCompanion(DiscoveryLedgerCompanion data) {
    return DiscoveryRecord(
      id: data.id.present ? data.id.value : this.id,
      stableIdentity: data.stableIdentity.present
          ? data.stableIdentity.value
          : this.stableIdentity,
      sourceFolderId: data.sourceFolderId.present
          ? data.sourceFolderId.value
          : this.sourceFolderId,
      documentUri: data.documentUri.present
          ? data.documentUri.value
          : this.documentUri,
      parentUri: data.parentUri.present ? data.parentUri.value : this.parentUri,
      filename: data.filename.present ? data.filename.value : this.filename,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
      providerAddedAt: data.providerAddedAt.present
          ? data.providerAddedAt.value
          : this.providerAddedAt,
      firstSeenAt: data.firstSeenAt.present
          ? data.firstSeenAt.value
          : this.firstSeenAt,
      eligibilityDate: data.eligibilityDate.present
          ? data.eligibilityDate.value
          : this.eligibilityDate,
      dateSource: data.dateSource.present
          ? data.dateSource.value
          : this.dateSource,
      modifiedAt: data.modifiedAt.present
          ? data.modifiedAt.value
          : this.modifiedAt,
      metadataFingerprint: data.metadataFingerprint.present
          ? data.metadataFingerprint.value
          : this.metadataFingerprint,
      processingVersion: data.processingVersion.present
          ? data.processingVersion.value
          : this.processingVersion,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      classificationScore: data.classificationScore.present
          ? data.classificationScore.value
          : this.classificationScore,
      processingState: data.processingState.present
          ? data.processingState.value
          : this.processingState,
      failureReason: data.failureReason.present
          ? data.failureReason.value
          : this.failureReason,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      pixelFingerprint: data.pixelFingerprint.present
          ? data.pixelFingerprint.value
          : this.pixelFingerprint,
      currentUri: data.currentUri.present
          ? data.currentUri.value
          : this.currentUri,
      stageTimingsJson: data.stageTimingsJson.present
          ? data.stageTimingsJson.value
          : this.stageTimingsJson,
      lastProcessedAt: data.lastProcessedAt.present
          ? data.lastProcessedAt.value
          : this.lastProcessedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiscoveryRecord(')
          ..write('id: $id, ')
          ..write('stableIdentity: $stableIdentity, ')
          ..write('sourceFolderId: $sourceFolderId, ')
          ..write('documentUri: $documentUri, ')
          ..write('parentUri: $parentUri, ')
          ..write('filename: $filename, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('providerAddedAt: $providerAddedAt, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('eligibilityDate: $eligibilityDate, ')
          ..write('dateSource: $dateSource, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('metadataFingerprint: $metadataFingerprint, ')
          ..write('processingVersion: $processingVersion, ')
          ..write('classification: $classification, ')
          ..write('classificationScore: $classificationScore, ')
          ..write('processingState: $processingState, ')
          ..write('failureReason: $failureReason, ')
          ..write('sha256: $sha256, ')
          ..write('pixelFingerprint: $pixelFingerprint, ')
          ..write('currentUri: $currentUri, ')
          ..write('stageTimingsJson: $stageTimingsJson, ')
          ..write('lastProcessedAt: $lastProcessedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    stableIdentity,
    sourceFolderId,
    documentUri,
    parentUri,
    filename,
    mimeType,
    byteSize,
    providerAddedAt,
    firstSeenAt,
    eligibilityDate,
    dateSource,
    modifiedAt,
    metadataFingerprint,
    processingVersion,
    classification,
    classificationScore,
    processingState,
    failureReason,
    sha256,
    pixelFingerprint,
    currentUri,
    stageTimingsJson,
    lastProcessedAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiscoveryRecord &&
          other.id == this.id &&
          other.stableIdentity == this.stableIdentity &&
          other.sourceFolderId == this.sourceFolderId &&
          other.documentUri == this.documentUri &&
          other.parentUri == this.parentUri &&
          other.filename == this.filename &&
          other.mimeType == this.mimeType &&
          other.byteSize == this.byteSize &&
          other.providerAddedAt == this.providerAddedAt &&
          other.firstSeenAt == this.firstSeenAt &&
          other.eligibilityDate == this.eligibilityDate &&
          other.dateSource == this.dateSource &&
          other.modifiedAt == this.modifiedAt &&
          other.metadataFingerprint == this.metadataFingerprint &&
          other.processingVersion == this.processingVersion &&
          other.classification == this.classification &&
          other.classificationScore == this.classificationScore &&
          other.processingState == this.processingState &&
          other.failureReason == this.failureReason &&
          other.sha256 == this.sha256 &&
          other.pixelFingerprint == this.pixelFingerprint &&
          other.currentUri == this.currentUri &&
          other.stageTimingsJson == this.stageTimingsJson &&
          other.lastProcessedAt == this.lastProcessedAt &&
          other.updatedAt == this.updatedAt);
}

class DiscoveryLedgerCompanion extends UpdateCompanion<DiscoveryRecord> {
  final Value<String> id;
  final Value<String> stableIdentity;
  final Value<String?> sourceFolderId;
  final Value<String> documentUri;
  final Value<String?> parentUri;
  final Value<String> filename;
  final Value<String> mimeType;
  final Value<int> byteSize;
  final Value<DateTime?> providerAddedAt;
  final Value<DateTime> firstSeenAt;
  final Value<DateTime> eligibilityDate;
  final Value<String> dateSource;
  final Value<DateTime?> modifiedAt;
  final Value<String> metadataFingerprint;
  final Value<int> processingVersion;
  final Value<String> classification;
  final Value<double?> classificationScore;
  final Value<String> processingState;
  final Value<String?> failureReason;
  final Value<String?> sha256;
  final Value<String?> pixelFingerprint;
  final Value<String> currentUri;
  final Value<String> stageTimingsJson;
  final Value<DateTime?> lastProcessedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DiscoveryLedgerCompanion({
    this.id = const Value.absent(),
    this.stableIdentity = const Value.absent(),
    this.sourceFolderId = const Value.absent(),
    this.documentUri = const Value.absent(),
    this.parentUri = const Value.absent(),
    this.filename = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.providerAddedAt = const Value.absent(),
    this.firstSeenAt = const Value.absent(),
    this.eligibilityDate = const Value.absent(),
    this.dateSource = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.metadataFingerprint = const Value.absent(),
    this.processingVersion = const Value.absent(),
    this.classification = const Value.absent(),
    this.classificationScore = const Value.absent(),
    this.processingState = const Value.absent(),
    this.failureReason = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.pixelFingerprint = const Value.absent(),
    this.currentUri = const Value.absent(),
    this.stageTimingsJson = const Value.absent(),
    this.lastProcessedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiscoveryLedgerCompanion.insert({
    required String id,
    required String stableIdentity,
    this.sourceFolderId = const Value.absent(),
    required String documentUri,
    this.parentUri = const Value.absent(),
    required String filename,
    required String mimeType,
    required int byteSize,
    this.providerAddedAt = const Value.absent(),
    required DateTime firstSeenAt,
    required DateTime eligibilityDate,
    required String dateSource,
    this.modifiedAt = const Value.absent(),
    required String metadataFingerprint,
    this.processingVersion = const Value.absent(),
    this.classification = const Value.absent(),
    this.classificationScore = const Value.absent(),
    this.processingState = const Value.absent(),
    this.failureReason = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.pixelFingerprint = const Value.absent(),
    required String currentUri,
    this.stageTimingsJson = const Value.absent(),
    this.lastProcessedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       stableIdentity = Value(stableIdentity),
       documentUri = Value(documentUri),
       filename = Value(filename),
       mimeType = Value(mimeType),
       byteSize = Value(byteSize),
       firstSeenAt = Value(firstSeenAt),
       eligibilityDate = Value(eligibilityDate),
       dateSource = Value(dateSource),
       metadataFingerprint = Value(metadataFingerprint),
       currentUri = Value(currentUri),
       updatedAt = Value(updatedAt);
  static Insertable<DiscoveryRecord> custom({
    Expression<String>? id,
    Expression<String>? stableIdentity,
    Expression<String>? sourceFolderId,
    Expression<String>? documentUri,
    Expression<String>? parentUri,
    Expression<String>? filename,
    Expression<String>? mimeType,
    Expression<int>? byteSize,
    Expression<DateTime>? providerAddedAt,
    Expression<DateTime>? firstSeenAt,
    Expression<DateTime>? eligibilityDate,
    Expression<String>? dateSource,
    Expression<DateTime>? modifiedAt,
    Expression<String>? metadataFingerprint,
    Expression<int>? processingVersion,
    Expression<String>? classification,
    Expression<double>? classificationScore,
    Expression<String>? processingState,
    Expression<String>? failureReason,
    Expression<String>? sha256,
    Expression<String>? pixelFingerprint,
    Expression<String>? currentUri,
    Expression<String>? stageTimingsJson,
    Expression<DateTime>? lastProcessedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stableIdentity != null) 'stable_identity': stableIdentity,
      if (sourceFolderId != null) 'source_folder_id': sourceFolderId,
      if (documentUri != null) 'document_uri': documentUri,
      if (parentUri != null) 'parent_uri': parentUri,
      if (filename != null) 'filename': filename,
      if (mimeType != null) 'mime_type': mimeType,
      if (byteSize != null) 'byte_size': byteSize,
      if (providerAddedAt != null) 'provider_added_at': providerAddedAt,
      if (firstSeenAt != null) 'first_seen_at': firstSeenAt,
      if (eligibilityDate != null) 'eligibility_date': eligibilityDate,
      if (dateSource != null) 'date_source': dateSource,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (metadataFingerprint != null)
        'metadata_fingerprint': metadataFingerprint,
      if (processingVersion != null) 'processing_version': processingVersion,
      if (classification != null) 'classification': classification,
      if (classificationScore != null)
        'classification_score': classificationScore,
      if (processingState != null) 'processing_state': processingState,
      if (failureReason != null) 'failure_reason': failureReason,
      if (sha256 != null) 'sha256': sha256,
      if (pixelFingerprint != null) 'pixel_fingerprint': pixelFingerprint,
      if (currentUri != null) 'current_uri': currentUri,
      if (stageTimingsJson != null) 'stage_timings_json': stageTimingsJson,
      if (lastProcessedAt != null) 'last_processed_at': lastProcessedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiscoveryLedgerCompanion copyWith({
    Value<String>? id,
    Value<String>? stableIdentity,
    Value<String?>? sourceFolderId,
    Value<String>? documentUri,
    Value<String?>? parentUri,
    Value<String>? filename,
    Value<String>? mimeType,
    Value<int>? byteSize,
    Value<DateTime?>? providerAddedAt,
    Value<DateTime>? firstSeenAt,
    Value<DateTime>? eligibilityDate,
    Value<String>? dateSource,
    Value<DateTime?>? modifiedAt,
    Value<String>? metadataFingerprint,
    Value<int>? processingVersion,
    Value<String>? classification,
    Value<double?>? classificationScore,
    Value<String>? processingState,
    Value<String?>? failureReason,
    Value<String?>? sha256,
    Value<String?>? pixelFingerprint,
    Value<String>? currentUri,
    Value<String>? stageTimingsJson,
    Value<DateTime?>? lastProcessedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DiscoveryLedgerCompanion(
      id: id ?? this.id,
      stableIdentity: stableIdentity ?? this.stableIdentity,
      sourceFolderId: sourceFolderId ?? this.sourceFolderId,
      documentUri: documentUri ?? this.documentUri,
      parentUri: parentUri ?? this.parentUri,
      filename: filename ?? this.filename,
      mimeType: mimeType ?? this.mimeType,
      byteSize: byteSize ?? this.byteSize,
      providerAddedAt: providerAddedAt ?? this.providerAddedAt,
      firstSeenAt: firstSeenAt ?? this.firstSeenAt,
      eligibilityDate: eligibilityDate ?? this.eligibilityDate,
      dateSource: dateSource ?? this.dateSource,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      metadataFingerprint: metadataFingerprint ?? this.metadataFingerprint,
      processingVersion: processingVersion ?? this.processingVersion,
      classification: classification ?? this.classification,
      classificationScore: classificationScore ?? this.classificationScore,
      processingState: processingState ?? this.processingState,
      failureReason: failureReason ?? this.failureReason,
      sha256: sha256 ?? this.sha256,
      pixelFingerprint: pixelFingerprint ?? this.pixelFingerprint,
      currentUri: currentUri ?? this.currentUri,
      stageTimingsJson: stageTimingsJson ?? this.stageTimingsJson,
      lastProcessedAt: lastProcessedAt ?? this.lastProcessedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (stableIdentity.present) {
      map['stable_identity'] = Variable<String>(stableIdentity.value);
    }
    if (sourceFolderId.present) {
      map['source_folder_id'] = Variable<String>(sourceFolderId.value);
    }
    if (documentUri.present) {
      map['document_uri'] = Variable<String>(documentUri.value);
    }
    if (parentUri.present) {
      map['parent_uri'] = Variable<String>(parentUri.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (providerAddedAt.present) {
      map['provider_added_at'] = Variable<DateTime>(providerAddedAt.value);
    }
    if (firstSeenAt.present) {
      map['first_seen_at'] = Variable<DateTime>(firstSeenAt.value);
    }
    if (eligibilityDate.present) {
      map['eligibility_date'] = Variable<DateTime>(eligibilityDate.value);
    }
    if (dateSource.present) {
      map['date_source'] = Variable<String>(dateSource.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (metadataFingerprint.present) {
      map['metadata_fingerprint'] = Variable<String>(metadataFingerprint.value);
    }
    if (processingVersion.present) {
      map['processing_version'] = Variable<int>(processingVersion.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (classificationScore.present) {
      map['classification_score'] = Variable<double>(classificationScore.value);
    }
    if (processingState.present) {
      map['processing_state'] = Variable<String>(processingState.value);
    }
    if (failureReason.present) {
      map['failure_reason'] = Variable<String>(failureReason.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (pixelFingerprint.present) {
      map['pixel_fingerprint'] = Variable<String>(pixelFingerprint.value);
    }
    if (currentUri.present) {
      map['current_uri'] = Variable<String>(currentUri.value);
    }
    if (stageTimingsJson.present) {
      map['stage_timings_json'] = Variable<String>(stageTimingsJson.value);
    }
    if (lastProcessedAt.present) {
      map['last_processed_at'] = Variable<DateTime>(lastProcessedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscoveryLedgerCompanion(')
          ..write('id: $id, ')
          ..write('stableIdentity: $stableIdentity, ')
          ..write('sourceFolderId: $sourceFolderId, ')
          ..write('documentUri: $documentUri, ')
          ..write('parentUri: $parentUri, ')
          ..write('filename: $filename, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('providerAddedAt: $providerAddedAt, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('eligibilityDate: $eligibilityDate, ')
          ..write('dateSource: $dateSource, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('metadataFingerprint: $metadataFingerprint, ')
          ..write('processingVersion: $processingVersion, ')
          ..write('classification: $classification, ')
          ..write('classificationScore: $classificationScore, ')
          ..write('processingState: $processingState, ')
          ..write('failureReason: $failureReason, ')
          ..write('sha256: $sha256, ')
          ..write('pixelFingerprint: $pixelFingerprint, ')
          ..write('currentUri: $currentUri, ')
          ..write('stageTimingsJson: $stageTimingsJson, ')
          ..write('lastProcessedAt: $lastProcessedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SongsTable songs = $SongsTable(this);
  late final $SongAliasesTable songAliases = $SongAliasesTable(this);
  late final $EditionsTable editions = $EditionsTable(this);
  late final $SheetAssetsTable sheetAssets = $SheetAssetsTable(this);
  late final $ServiceCollectionsTable serviceCollections =
      $ServiceCollectionsTable(this);
  late final $ServiceEntriesTable serviceEntries = $ServiceEntriesTable(this);
  late final $ImportJobsTable importJobs = $ImportJobsTable(this);
  late final $FileOperationsTable fileOperations = $FileOperationsTable(this);
  late final $ReaderProgressTable readerProgress = $ReaderProgressTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $SourceFoldersTable sourceFolders = $SourceFoldersTable(this);
  late final $DiscoveryLedgerTable discoveryLedger = $DiscoveryLedgerTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    songs,
    songAliases,
    editions,
    sheetAssets,
    serviceCollections,
    serviceEntries,
    importJobs,
    fileOperations,
    readerProgress,
    appSettings,
    sourceFolders,
    discoveryLedger,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'songs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('song_aliases', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'songs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('editions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'editions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sheet_assets', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'service_collections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('service_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'editions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('service_entries', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sheet_assets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('file_operations', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'service_collections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reader_progress', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'service_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reader_progress', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'source_folders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('discovery_ledger', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$SongsTableCreateCompanionBuilder =
    SongsCompanion Function({
      required String id,
      required String displayTitle,
      required String normalizedTitle,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SongsTableUpdateCompanionBuilder =
    SongsCompanion Function({
      Value<String> id,
      Value<String> displayTitle,
      Value<String> normalizedTitle,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SongsTableReferences
    extends BaseReferences<_$AppDatabase, $SongsTable, SongRecord> {
  $$SongsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SongAliasesTable, List<AliasRecord>>
  _songAliasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.songAliases,
    aliasName: $_aliasNameGenerator(db.songs.id, db.songAliases.songId),
  );

  $$SongAliasesTableProcessedTableManager get songAliasesRefs {
    final manager = $$SongAliasesTableTableManager(
      $_db,
      $_db.songAliases,
    ).filter((f) => f.songId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_songAliasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EditionsTable, List<EditionRecord>>
  _editionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.editions,
    aliasName: $_aliasNameGenerator(db.songs.id, db.editions.songId),
  );

  $$EditionsTableProcessedTableManager get editionsRefs {
    final manager = $$EditionsTableTableManager(
      $_db,
      $_db.editions,
    ).filter((f) => f.songId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_editionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SongsTableFilterComposer extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayTitle => $composableBuilder(
    column: $table.displayTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedTitle => $composableBuilder(
    column: $table.normalizedTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> songAliasesRefs(
    Expression<bool> Function($$SongAliasesTableFilterComposer f) f,
  ) {
    final $$SongAliasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.songAliases,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongAliasesTableFilterComposer(
            $db: $db,
            $table: $db.songAliases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> editionsRefs(
    Expression<bool> Function($$EditionsTableFilterComposer f) f,
  ) {
    final $$EditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableFilterComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SongsTableOrderingComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayTitle => $composableBuilder(
    column: $table.displayTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedTitle => $composableBuilder(
    column: $table.normalizedTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayTitle => $composableBuilder(
    column: $table.displayTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normalizedTitle => $composableBuilder(
    column: $table.normalizedTitle,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> songAliasesRefs<T extends Object>(
    Expression<T> Function($$SongAliasesTableAnnotationComposer a) f,
  ) {
    final $$SongAliasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.songAliases,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongAliasesTableAnnotationComposer(
            $db: $db,
            $table: $db.songAliases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> editionsRefs<T extends Object>(
    Expression<T> Function($$EditionsTableAnnotationComposer a) f,
  ) {
    final $$EditionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableAnnotationComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SongsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SongsTable,
          SongRecord,
          $$SongsTableFilterComposer,
          $$SongsTableOrderingComposer,
          $$SongsTableAnnotationComposer,
          $$SongsTableCreateCompanionBuilder,
          $$SongsTableUpdateCompanionBuilder,
          (SongRecord, $$SongsTableReferences),
          SongRecord,
          PrefetchHooks Function({bool songAliasesRefs, bool editionsRefs})
        > {
  $$SongsTableTableManager(_$AppDatabase db, $SongsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayTitle = const Value.absent(),
                Value<String> normalizedTitle = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SongsCompanion(
                id: id,
                displayTitle: displayTitle,
                normalizedTitle: normalizedTitle,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayTitle,
                required String normalizedTitle,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SongsCompanion.insert(
                id: id,
                displayTitle: displayTitle,
                normalizedTitle: normalizedTitle,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SongsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({songAliasesRefs = false, editionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (songAliasesRefs) db.songAliases,
                    if (editionsRefs) db.editions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (songAliasesRefs)
                        await $_getPrefetchedData<
                          SongRecord,
                          $SongsTable,
                          AliasRecord
                        >(
                          currentTable: table,
                          referencedTable: $$SongsTableReferences
                              ._songAliasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SongsTableReferences(
                                db,
                                table,
                                p0,
                              ).songAliasesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.songId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (editionsRefs)
                        await $_getPrefetchedData<
                          SongRecord,
                          $SongsTable,
                          EditionRecord
                        >(
                          currentTable: table,
                          referencedTable: $$SongsTableReferences
                              ._editionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SongsTableReferences(
                                db,
                                table,
                                p0,
                              ).editionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.songId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SongsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SongsTable,
      SongRecord,
      $$SongsTableFilterComposer,
      $$SongsTableOrderingComposer,
      $$SongsTableAnnotationComposer,
      $$SongsTableCreateCompanionBuilder,
      $$SongsTableUpdateCompanionBuilder,
      (SongRecord, $$SongsTableReferences),
      SongRecord,
      PrefetchHooks Function({bool songAliasesRefs, bool editionsRefs})
    >;
typedef $$SongAliasesTableCreateCompanionBuilder =
    SongAliasesCompanion Function({
      required String id,
      required String songId,
      required String normalizedAlias,
      Value<int> rowid,
    });
typedef $$SongAliasesTableUpdateCompanionBuilder =
    SongAliasesCompanion Function({
      Value<String> id,
      Value<String> songId,
      Value<String> normalizedAlias,
      Value<int> rowid,
    });

final class $$SongAliasesTableReferences
    extends BaseReferences<_$AppDatabase, $SongAliasesTable, AliasRecord> {
  $$SongAliasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SongsTable _songIdTable(_$AppDatabase db) => db.songs.createAlias(
    $_aliasNameGenerator(db.songAliases.songId, db.songs.id),
  );

  $$SongsTableProcessedTableManager get songId {
    final $_column = $_itemColumn<String>('song_id')!;

    final manager = $$SongsTableTableManager(
      $_db,
      $_db.songs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_songIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SongAliasesTableFilterComposer
    extends Composer<_$AppDatabase, $SongAliasesTable> {
  $$SongAliasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedAlias => $composableBuilder(
    column: $table.normalizedAlias,
    builder: (column) => ColumnFilters(column),
  );

  $$SongsTableFilterComposer get songId {
    final $$SongsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableFilterComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SongAliasesTableOrderingComposer
    extends Composer<_$AppDatabase, $SongAliasesTable> {
  $$SongAliasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedAlias => $composableBuilder(
    column: $table.normalizedAlias,
    builder: (column) => ColumnOrderings(column),
  );

  $$SongsTableOrderingComposer get songId {
    final $$SongsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableOrderingComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SongAliasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongAliasesTable> {
  $$SongAliasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get normalizedAlias => $composableBuilder(
    column: $table.normalizedAlias,
    builder: (column) => column,
  );

  $$SongsTableAnnotationComposer get songId {
    final $$SongsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableAnnotationComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SongAliasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SongAliasesTable,
          AliasRecord,
          $$SongAliasesTableFilterComposer,
          $$SongAliasesTableOrderingComposer,
          $$SongAliasesTableAnnotationComposer,
          $$SongAliasesTableCreateCompanionBuilder,
          $$SongAliasesTableUpdateCompanionBuilder,
          (AliasRecord, $$SongAliasesTableReferences),
          AliasRecord,
          PrefetchHooks Function({bool songId})
        > {
  $$SongAliasesTableTableManager(_$AppDatabase db, $SongAliasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongAliasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongAliasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongAliasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> songId = const Value.absent(),
                Value<String> normalizedAlias = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SongAliasesCompanion(
                id: id,
                songId: songId,
                normalizedAlias: normalizedAlias,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String songId,
                required String normalizedAlias,
                Value<int> rowid = const Value.absent(),
              }) => SongAliasesCompanion.insert(
                id: id,
                songId: songId,
                normalizedAlias: normalizedAlias,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SongAliasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({songId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (songId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.songId,
                                referencedTable: $$SongAliasesTableReferences
                                    ._songIdTable(db),
                                referencedColumn: $$SongAliasesTableReferences
                                    ._songIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SongAliasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SongAliasesTable,
      AliasRecord,
      $$SongAliasesTableFilterComposer,
      $$SongAliasesTableOrderingComposer,
      $$SongAliasesTableAnnotationComposer,
      $$SongAliasesTableCreateCompanionBuilder,
      $$SongAliasesTableUpdateCompanionBuilder,
      (AliasRecord, $$SongAliasesTableReferences),
      AliasRecord,
      PrefetchHooks Function({bool songId})
    >;
typedef $$EditionsTableCreateCompanionBuilder =
    EditionsCompanion Function({
      required String id,
      required String songId,
      Value<String?> keyLabel,
      Value<String?> instrument,
      Value<String?> arrangementLabel,
      Value<String> userLabel,
      Value<int> rowid,
    });
typedef $$EditionsTableUpdateCompanionBuilder =
    EditionsCompanion Function({
      Value<String> id,
      Value<String> songId,
      Value<String?> keyLabel,
      Value<String?> instrument,
      Value<String?> arrangementLabel,
      Value<String> userLabel,
      Value<int> rowid,
    });

final class $$EditionsTableReferences
    extends BaseReferences<_$AppDatabase, $EditionsTable, EditionRecord> {
  $$EditionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SongsTable _songIdTable(_$AppDatabase db) => db.songs.createAlias(
    $_aliasNameGenerator(db.editions.songId, db.songs.id),
  );

  $$SongsTableProcessedTableManager get songId {
    final $_column = $_itemColumn<String>('song_id')!;

    final manager = $$SongsTableTableManager(
      $_db,
      $_db.songs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_songIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SheetAssetsTable, List<AssetRecord>>
  _sheetAssetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sheetAssets,
    aliasName: $_aliasNameGenerator(db.editions.id, db.sheetAssets.editionId),
  );

  $$SheetAssetsTableProcessedTableManager get sheetAssetsRefs {
    final manager = $$SheetAssetsTableTableManager(
      $_db,
      $_db.sheetAssets,
    ).filter((f) => f.editionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sheetAssetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ServiceEntriesTable, List<ServiceEntryRecord>>
  _serviceEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.serviceEntries,
    aliasName: $_aliasNameGenerator(
      db.editions.id,
      db.serviceEntries.editionId,
    ),
  );

  $$ServiceEntriesTableProcessedTableManager get serviceEntriesRefs {
    final manager = $$ServiceEntriesTableTableManager(
      $_db,
      $_db.serviceEntries,
    ).filter((f) => f.editionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_serviceEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EditionsTableFilterComposer
    extends Composer<_$AppDatabase, $EditionsTable> {
  $$EditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyLabel => $composableBuilder(
    column: $table.keyLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instrument => $composableBuilder(
    column: $table.instrument,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arrangementLabel => $composableBuilder(
    column: $table.arrangementLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userLabel => $composableBuilder(
    column: $table.userLabel,
    builder: (column) => ColumnFilters(column),
  );

  $$SongsTableFilterComposer get songId {
    final $$SongsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableFilterComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sheetAssetsRefs(
    Expression<bool> Function($$SheetAssetsTableFilterComposer f) f,
  ) {
    final $$SheetAssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sheetAssets,
      getReferencedColumn: (t) => t.editionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SheetAssetsTableFilterComposer(
            $db: $db,
            $table: $db.sheetAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> serviceEntriesRefs(
    Expression<bool> Function($$ServiceEntriesTableFilterComposer f) f,
  ) {
    final $$ServiceEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceEntries,
      getReferencedColumn: (t) => t.editionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceEntriesTableFilterComposer(
            $db: $db,
            $table: $db.serviceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EditionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EditionsTable> {
  $$EditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyLabel => $composableBuilder(
    column: $table.keyLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instrument => $composableBuilder(
    column: $table.instrument,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arrangementLabel => $composableBuilder(
    column: $table.arrangementLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userLabel => $composableBuilder(
    column: $table.userLabel,
    builder: (column) => ColumnOrderings(column),
  );

  $$SongsTableOrderingComposer get songId {
    final $$SongsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableOrderingComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EditionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EditionsTable> {
  $$EditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get keyLabel =>
      $composableBuilder(column: $table.keyLabel, builder: (column) => column);

  GeneratedColumn<String> get instrument => $composableBuilder(
    column: $table.instrument,
    builder: (column) => column,
  );

  GeneratedColumn<String> get arrangementLabel => $composableBuilder(
    column: $table.arrangementLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userLabel =>
      $composableBuilder(column: $table.userLabel, builder: (column) => column);

  $$SongsTableAnnotationComposer get songId {
    final $$SongsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableAnnotationComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sheetAssetsRefs<T extends Object>(
    Expression<T> Function($$SheetAssetsTableAnnotationComposer a) f,
  ) {
    final $$SheetAssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sheetAssets,
      getReferencedColumn: (t) => t.editionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SheetAssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.sheetAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> serviceEntriesRefs<T extends Object>(
    Expression<T> Function($$ServiceEntriesTableAnnotationComposer a) f,
  ) {
    final $$ServiceEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceEntries,
      getReferencedColumn: (t) => t.editionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EditionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EditionsTable,
          EditionRecord,
          $$EditionsTableFilterComposer,
          $$EditionsTableOrderingComposer,
          $$EditionsTableAnnotationComposer,
          $$EditionsTableCreateCompanionBuilder,
          $$EditionsTableUpdateCompanionBuilder,
          (EditionRecord, $$EditionsTableReferences),
          EditionRecord,
          PrefetchHooks Function({
            bool songId,
            bool sheetAssetsRefs,
            bool serviceEntriesRefs,
          })
        > {
  $$EditionsTableTableManager(_$AppDatabase db, $EditionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> songId = const Value.absent(),
                Value<String?> keyLabel = const Value.absent(),
                Value<String?> instrument = const Value.absent(),
                Value<String?> arrangementLabel = const Value.absent(),
                Value<String> userLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EditionsCompanion(
                id: id,
                songId: songId,
                keyLabel: keyLabel,
                instrument: instrument,
                arrangementLabel: arrangementLabel,
                userLabel: userLabel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String songId,
                Value<String?> keyLabel = const Value.absent(),
                Value<String?> instrument = const Value.absent(),
                Value<String?> arrangementLabel = const Value.absent(),
                Value<String> userLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EditionsCompanion.insert(
                id: id,
                songId: songId,
                keyLabel: keyLabel,
                instrument: instrument,
                arrangementLabel: arrangementLabel,
                userLabel: userLabel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EditionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                songId = false,
                sheetAssetsRefs = false,
                serviceEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sheetAssetsRefs) db.sheetAssets,
                    if (serviceEntriesRefs) db.serviceEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (songId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.songId,
                                    referencedTable: $$EditionsTableReferences
                                        ._songIdTable(db),
                                    referencedColumn: $$EditionsTableReferences
                                        ._songIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sheetAssetsRefs)
                        await $_getPrefetchedData<
                          EditionRecord,
                          $EditionsTable,
                          AssetRecord
                        >(
                          currentTable: table,
                          referencedTable: $$EditionsTableReferences
                              ._sheetAssetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EditionsTableReferences(
                                db,
                                table,
                                p0,
                              ).sheetAssetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.editionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (serviceEntriesRefs)
                        await $_getPrefetchedData<
                          EditionRecord,
                          $EditionsTable,
                          ServiceEntryRecord
                        >(
                          currentTable: table,
                          referencedTable: $$EditionsTableReferences
                              ._serviceEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EditionsTableReferences(
                                db,
                                table,
                                p0,
                              ).serviceEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.editionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EditionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EditionsTable,
      EditionRecord,
      $$EditionsTableFilterComposer,
      $$EditionsTableOrderingComposer,
      $$EditionsTableAnnotationComposer,
      $$EditionsTableCreateCompanionBuilder,
      $$EditionsTableUpdateCompanionBuilder,
      (EditionRecord, $$EditionsTableReferences),
      EditionRecord,
      PrefetchHooks Function({
        bool songId,
        bool sheetAssetsRefs,
        bool serviceEntriesRefs,
      })
    >;
typedef $$SheetAssetsTableCreateCompanionBuilder =
    SheetAssetsCompanion Function({
      required String id,
      Value<String?> editionId,
      required String documentUri,
      required String filename,
      required String mimeType,
      required int byteSize,
      required String sha256,
      Value<String?> pixelFingerprint,
      Value<int?> width,
      Value<int?> height,
      Value<int?> pageOrder,
      Value<String?> extractedTitle,
      Value<String?> normalizedTitle,
      Value<String?> rawOcr,
      Value<double> qualityScore,
      Value<String> reviewState,
      Value<String> availabilityState,
      required String contentFingerprint,
      Value<int> processingVersion,
      Value<DateTime?> modifiedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SheetAssetsTableUpdateCompanionBuilder =
    SheetAssetsCompanion Function({
      Value<String> id,
      Value<String?> editionId,
      Value<String> documentUri,
      Value<String> filename,
      Value<String> mimeType,
      Value<int> byteSize,
      Value<String> sha256,
      Value<String?> pixelFingerprint,
      Value<int?> width,
      Value<int?> height,
      Value<int?> pageOrder,
      Value<String?> extractedTitle,
      Value<String?> normalizedTitle,
      Value<String?> rawOcr,
      Value<double> qualityScore,
      Value<String> reviewState,
      Value<String> availabilityState,
      Value<String> contentFingerprint,
      Value<int> processingVersion,
      Value<DateTime?> modifiedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SheetAssetsTableReferences
    extends BaseReferences<_$AppDatabase, $SheetAssetsTable, AssetRecord> {
  $$SheetAssetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EditionsTable _editionIdTable(_$AppDatabase db) =>
      db.editions.createAlias(
        $_aliasNameGenerator(db.sheetAssets.editionId, db.editions.id),
      );

  $$EditionsTableProcessedTableManager? get editionId {
    final $_column = $_itemColumn<String>('edition_id');
    if ($_column == null) return null;
    final manager = $$EditionsTableTableManager(
      $_db,
      $_db.editions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_editionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FileOperationsTable, List<FileOperationRecord>>
  _fileOperationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fileOperations,
    aliasName: $_aliasNameGenerator(
      db.sheetAssets.id,
      db.fileOperations.retainedAssetId,
    ),
  );

  $$FileOperationsTableProcessedTableManager get fileOperationsRefs {
    final manager = $$FileOperationsTableTableManager($_db, $_db.fileOperations)
        .filter(
          (f) => f.retainedAssetId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_fileOperationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SheetAssetsTableFilterComposer
    extends Composer<_$AppDatabase, $SheetAssetsTable> {
  $$SheetAssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentUri => $composableBuilder(
    column: $table.documentUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pixelFingerprint => $composableBuilder(
    column: $table.pixelFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageOrder => $composableBuilder(
    column: $table.pageOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractedTitle => $composableBuilder(
    column: $table.extractedTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedTitle => $composableBuilder(
    column: $table.normalizedTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawOcr => $composableBuilder(
    column: $table.rawOcr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qualityScore => $composableBuilder(
    column: $table.qualityScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewState => $composableBuilder(
    column: $table.reviewState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availabilityState => $composableBuilder(
    column: $table.availabilityState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentFingerprint => $composableBuilder(
    column: $table.contentFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get processingVersion => $composableBuilder(
    column: $table.processingVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EditionsTableFilterComposer get editionId {
    final $$EditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableFilterComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> fileOperationsRefs(
    Expression<bool> Function($$FileOperationsTableFilterComposer f) f,
  ) {
    final $$FileOperationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fileOperations,
      getReferencedColumn: (t) => t.retainedAssetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FileOperationsTableFilterComposer(
            $db: $db,
            $table: $db.fileOperations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SheetAssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $SheetAssetsTable> {
  $$SheetAssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentUri => $composableBuilder(
    column: $table.documentUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pixelFingerprint => $composableBuilder(
    column: $table.pixelFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageOrder => $composableBuilder(
    column: $table.pageOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractedTitle => $composableBuilder(
    column: $table.extractedTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedTitle => $composableBuilder(
    column: $table.normalizedTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawOcr => $composableBuilder(
    column: $table.rawOcr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qualityScore => $composableBuilder(
    column: $table.qualityScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewState => $composableBuilder(
    column: $table.reviewState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availabilityState => $composableBuilder(
    column: $table.availabilityState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentFingerprint => $composableBuilder(
    column: $table.contentFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get processingVersion => $composableBuilder(
    column: $table.processingVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EditionsTableOrderingComposer get editionId {
    final $$EditionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableOrderingComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SheetAssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SheetAssetsTable> {
  $$SheetAssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get documentUri => $composableBuilder(
    column: $table.documentUri,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<String> get pixelFingerprint => $composableBuilder(
    column: $table.pixelFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get pageOrder =>
      $composableBuilder(column: $table.pageOrder, builder: (column) => column);

  GeneratedColumn<String> get extractedTitle => $composableBuilder(
    column: $table.extractedTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normalizedTitle => $composableBuilder(
    column: $table.normalizedTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawOcr =>
      $composableBuilder(column: $table.rawOcr, builder: (column) => column);

  GeneratedColumn<double> get qualityScore => $composableBuilder(
    column: $table.qualityScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewState => $composableBuilder(
    column: $table.reviewState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get availabilityState => $composableBuilder(
    column: $table.availabilityState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentFingerprint => $composableBuilder(
    column: $table.contentFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get processingVersion => $composableBuilder(
    column: $table.processingVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EditionsTableAnnotationComposer get editionId {
    final $$EditionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableAnnotationComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> fileOperationsRefs<T extends Object>(
    Expression<T> Function($$FileOperationsTableAnnotationComposer a) f,
  ) {
    final $$FileOperationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fileOperations,
      getReferencedColumn: (t) => t.retainedAssetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FileOperationsTableAnnotationComposer(
            $db: $db,
            $table: $db.fileOperations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SheetAssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SheetAssetsTable,
          AssetRecord,
          $$SheetAssetsTableFilterComposer,
          $$SheetAssetsTableOrderingComposer,
          $$SheetAssetsTableAnnotationComposer,
          $$SheetAssetsTableCreateCompanionBuilder,
          $$SheetAssetsTableUpdateCompanionBuilder,
          (AssetRecord, $$SheetAssetsTableReferences),
          AssetRecord,
          PrefetchHooks Function({bool editionId, bool fileOperationsRefs})
        > {
  $$SheetAssetsTableTableManager(_$AppDatabase db, $SheetAssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SheetAssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SheetAssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SheetAssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> editionId = const Value.absent(),
                Value<String> documentUri = const Value.absent(),
                Value<String> filename = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> byteSize = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<String?> pixelFingerprint = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int?> pageOrder = const Value.absent(),
                Value<String?> extractedTitle = const Value.absent(),
                Value<String?> normalizedTitle = const Value.absent(),
                Value<String?> rawOcr = const Value.absent(),
                Value<double> qualityScore = const Value.absent(),
                Value<String> reviewState = const Value.absent(),
                Value<String> availabilityState = const Value.absent(),
                Value<String> contentFingerprint = const Value.absent(),
                Value<int> processingVersion = const Value.absent(),
                Value<DateTime?> modifiedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SheetAssetsCompanion(
                id: id,
                editionId: editionId,
                documentUri: documentUri,
                filename: filename,
                mimeType: mimeType,
                byteSize: byteSize,
                sha256: sha256,
                pixelFingerprint: pixelFingerprint,
                width: width,
                height: height,
                pageOrder: pageOrder,
                extractedTitle: extractedTitle,
                normalizedTitle: normalizedTitle,
                rawOcr: rawOcr,
                qualityScore: qualityScore,
                reviewState: reviewState,
                availabilityState: availabilityState,
                contentFingerprint: contentFingerprint,
                processingVersion: processingVersion,
                modifiedAt: modifiedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> editionId = const Value.absent(),
                required String documentUri,
                required String filename,
                required String mimeType,
                required int byteSize,
                required String sha256,
                Value<String?> pixelFingerprint = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int?> pageOrder = const Value.absent(),
                Value<String?> extractedTitle = const Value.absent(),
                Value<String?> normalizedTitle = const Value.absent(),
                Value<String?> rawOcr = const Value.absent(),
                Value<double> qualityScore = const Value.absent(),
                Value<String> reviewState = const Value.absent(),
                Value<String> availabilityState = const Value.absent(),
                required String contentFingerprint,
                Value<int> processingVersion = const Value.absent(),
                Value<DateTime?> modifiedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SheetAssetsCompanion.insert(
                id: id,
                editionId: editionId,
                documentUri: documentUri,
                filename: filename,
                mimeType: mimeType,
                byteSize: byteSize,
                sha256: sha256,
                pixelFingerprint: pixelFingerprint,
                width: width,
                height: height,
                pageOrder: pageOrder,
                extractedTitle: extractedTitle,
                normalizedTitle: normalizedTitle,
                rawOcr: rawOcr,
                qualityScore: qualityScore,
                reviewState: reviewState,
                availabilityState: availabilityState,
                contentFingerprint: contentFingerprint,
                processingVersion: processingVersion,
                modifiedAt: modifiedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SheetAssetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({editionId = false, fileOperationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fileOperationsRefs) db.fileOperations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (editionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.editionId,
                                    referencedTable:
                                        $$SheetAssetsTableReferences
                                            ._editionIdTable(db),
                                    referencedColumn:
                                        $$SheetAssetsTableReferences
                                            ._editionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fileOperationsRefs)
                        await $_getPrefetchedData<
                          AssetRecord,
                          $SheetAssetsTable,
                          FileOperationRecord
                        >(
                          currentTable: table,
                          referencedTable: $$SheetAssetsTableReferences
                              ._fileOperationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SheetAssetsTableReferences(
                                db,
                                table,
                                p0,
                              ).fileOperationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.retainedAssetId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SheetAssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SheetAssetsTable,
      AssetRecord,
      $$SheetAssetsTableFilterComposer,
      $$SheetAssetsTableOrderingComposer,
      $$SheetAssetsTableAnnotationComposer,
      $$SheetAssetsTableCreateCompanionBuilder,
      $$SheetAssetsTableUpdateCompanionBuilder,
      (AssetRecord, $$SheetAssetsTableReferences),
      AssetRecord,
      PrefetchHooks Function({bool editionId, bool fileOperationsRefs})
    >;
typedef $$ServiceCollectionsTableCreateCompanionBuilder =
    ServiceCollectionsCompanion Function({
      required String id,
      required DateTime localDate,
      required String displayName,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ServiceCollectionsTableUpdateCompanionBuilder =
    ServiceCollectionsCompanion Function({
      Value<String> id,
      Value<DateTime> localDate,
      Value<String> displayName,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ServiceCollectionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ServiceCollectionsTable, ServiceRecord> {
  $$ServiceCollectionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ServiceEntriesTable, List<ServiceEntryRecord>>
  _serviceEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.serviceEntries,
    aliasName: $_aliasNameGenerator(
      db.serviceCollections.id,
      db.serviceEntries.serviceId,
    ),
  );

  $$ServiceEntriesTableProcessedTableManager get serviceEntriesRefs {
    final manager = $$ServiceEntriesTableTableManager(
      $_db,
      $_db.serviceEntries,
    ).filter((f) => f.serviceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_serviceEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReaderProgressTable, List<ReaderProgressRecord>>
  _readerProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readerProgress,
    aliasName: $_aliasNameGenerator(
      db.serviceCollections.id,
      db.readerProgress.serviceId,
    ),
  );

  $$ReaderProgressTableProcessedTableManager get readerProgressRefs {
    final manager = $$ReaderProgressTableTableManager(
      $_db,
      $_db.readerProgress,
    ).filter((f) => f.serviceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_readerProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServiceCollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceCollectionsTable> {
  $$ServiceCollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> serviceEntriesRefs(
    Expression<bool> Function($$ServiceEntriesTableFilterComposer f) f,
  ) {
    final $$ServiceEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceEntries,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceEntriesTableFilterComposer(
            $db: $db,
            $table: $db.serviceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readerProgressRefs(
    Expression<bool> Function($$ReaderProgressTableFilterComposer f) f,
  ) {
    final $$ReaderProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readerProgress,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReaderProgressTableFilterComposer(
            $db: $db,
            $table: $db.readerProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceCollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceCollectionsTable> {
  $$ServiceCollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiceCollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceCollectionsTable> {
  $$ServiceCollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> serviceEntriesRefs<T extends Object>(
    Expression<T> Function($$ServiceEntriesTableAnnotationComposer a) f,
  ) {
    final $$ServiceEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceEntries,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readerProgressRefs<T extends Object>(
    Expression<T> Function($$ReaderProgressTableAnnotationComposer a) f,
  ) {
    final $$ReaderProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readerProgress,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReaderProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.readerProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceCollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceCollectionsTable,
          ServiceRecord,
          $$ServiceCollectionsTableFilterComposer,
          $$ServiceCollectionsTableOrderingComposer,
          $$ServiceCollectionsTableAnnotationComposer,
          $$ServiceCollectionsTableCreateCompanionBuilder,
          $$ServiceCollectionsTableUpdateCompanionBuilder,
          (ServiceRecord, $$ServiceCollectionsTableReferences),
          ServiceRecord,
          PrefetchHooks Function({
            bool serviceEntriesRefs,
            bool readerProgressRefs,
          })
        > {
  $$ServiceCollectionsTableTableManager(
    _$AppDatabase db,
    $ServiceCollectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceCollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceCollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceCollectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> localDate = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceCollectionsCompanion(
                id: id,
                localDate: localDate,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime localDate,
                required String displayName,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ServiceCollectionsCompanion.insert(
                id: id,
                localDate: localDate,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServiceCollectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({serviceEntriesRefs = false, readerProgressRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (serviceEntriesRefs) db.serviceEntries,
                    if (readerProgressRefs) db.readerProgress,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (serviceEntriesRefs)
                        await $_getPrefetchedData<
                          ServiceRecord,
                          $ServiceCollectionsTable,
                          ServiceEntryRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceCollectionsTableReferences
                              ._serviceEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceCollectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).serviceEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.serviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readerProgressRefs)
                        await $_getPrefetchedData<
                          ServiceRecord,
                          $ServiceCollectionsTable,
                          ReaderProgressRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceCollectionsTableReferences
                              ._readerProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceCollectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).readerProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.serviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ServiceCollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceCollectionsTable,
      ServiceRecord,
      $$ServiceCollectionsTableFilterComposer,
      $$ServiceCollectionsTableOrderingComposer,
      $$ServiceCollectionsTableAnnotationComposer,
      $$ServiceCollectionsTableCreateCompanionBuilder,
      $$ServiceCollectionsTableUpdateCompanionBuilder,
      (ServiceRecord, $$ServiceCollectionsTableReferences),
      ServiceRecord,
      PrefetchHooks Function({bool serviceEntriesRefs, bool readerProgressRefs})
    >;
typedef $$ServiceEntriesTableCreateCompanionBuilder =
    ServiceEntriesCompanion Function({
      required String id,
      required String serviceId,
      required int position,
      required String requestedTitle,
      required String normalizedRequestedTitle,
      Value<String?> requestedKey,
      Value<String?> editionId,
      required String status,
      Value<String> candidateEditionIdsJson,
      Value<int> rowid,
    });
typedef $$ServiceEntriesTableUpdateCompanionBuilder =
    ServiceEntriesCompanion Function({
      Value<String> id,
      Value<String> serviceId,
      Value<int> position,
      Value<String> requestedTitle,
      Value<String> normalizedRequestedTitle,
      Value<String?> requestedKey,
      Value<String?> editionId,
      Value<String> status,
      Value<String> candidateEditionIdsJson,
      Value<int> rowid,
    });

final class $$ServiceEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ServiceEntriesTable,
          ServiceEntryRecord
        > {
  $$ServiceEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ServiceCollectionsTable _serviceIdTable(_$AppDatabase db) =>
      db.serviceCollections.createAlias(
        $_aliasNameGenerator(
          db.serviceEntries.serviceId,
          db.serviceCollections.id,
        ),
      );

  $$ServiceCollectionsTableProcessedTableManager get serviceId {
    final $_column = $_itemColumn<String>('service_id')!;

    final manager = $$ServiceCollectionsTableTableManager(
      $_db,
      $_db.serviceCollections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EditionsTable _editionIdTable(_$AppDatabase db) =>
      db.editions.createAlias(
        $_aliasNameGenerator(db.serviceEntries.editionId, db.editions.id),
      );

  $$EditionsTableProcessedTableManager? get editionId {
    final $_column = $_itemColumn<String>('edition_id');
    if ($_column == null) return null;
    final manager = $$EditionsTableTableManager(
      $_db,
      $_db.editions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_editionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReaderProgressTable, List<ReaderProgressRecord>>
  _readerProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readerProgress,
    aliasName: $_aliasNameGenerator(
      db.serviceEntries.id,
      db.readerProgress.entryId,
    ),
  );

  $$ReaderProgressTableProcessedTableManager get readerProgressRefs {
    final manager = $$ReaderProgressTableTableManager(
      $_db,
      $_db.readerProgress,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_readerProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServiceEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceEntriesTable> {
  $$ServiceEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestedTitle => $composableBuilder(
    column: $table.requestedTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedRequestedTitle => $composableBuilder(
    column: $table.normalizedRequestedTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestedKey => $composableBuilder(
    column: $table.requestedKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get candidateEditionIdsJson => $composableBuilder(
    column: $table.candidateEditionIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$ServiceCollectionsTableFilterComposer get serviceId {
    final $$ServiceCollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.serviceCollections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceCollectionsTableFilterComposer(
            $db: $db,
            $table: $db.serviceCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EditionsTableFilterComposer get editionId {
    final $$EditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableFilterComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> readerProgressRefs(
    Expression<bool> Function($$ReaderProgressTableFilterComposer f) f,
  ) {
    final $$ReaderProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readerProgress,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReaderProgressTableFilterComposer(
            $db: $db,
            $table: $db.readerProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceEntriesTable> {
  $$ServiceEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestedTitle => $composableBuilder(
    column: $table.requestedTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedRequestedTitle => $composableBuilder(
    column: $table.normalizedRequestedTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestedKey => $composableBuilder(
    column: $table.requestedKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get candidateEditionIdsJson => $composableBuilder(
    column: $table.candidateEditionIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServiceCollectionsTableOrderingComposer get serviceId {
    final $$ServiceCollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.serviceCollections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceCollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.serviceCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EditionsTableOrderingComposer get editionId {
    final $$EditionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableOrderingComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServiceEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceEntriesTable> {
  $$ServiceEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get requestedTitle => $composableBuilder(
    column: $table.requestedTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normalizedRequestedTitle => $composableBuilder(
    column: $table.normalizedRequestedTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requestedKey => $composableBuilder(
    column: $table.requestedKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get candidateEditionIdsJson => $composableBuilder(
    column: $table.candidateEditionIdsJson,
    builder: (column) => column,
  );

  $$ServiceCollectionsTableAnnotationComposer get serviceId {
    final $$ServiceCollectionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.serviceId,
          referencedTable: $db.serviceCollections,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ServiceCollectionsTableAnnotationComposer(
                $db: $db,
                $table: $db.serviceCollections,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$EditionsTableAnnotationComposer get editionId {
    final $$EditionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editionId,
      referencedTable: $db.editions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EditionsTableAnnotationComposer(
            $db: $db,
            $table: $db.editions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> readerProgressRefs<T extends Object>(
    Expression<T> Function($$ReaderProgressTableAnnotationComposer a) f,
  ) {
    final $$ReaderProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readerProgress,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReaderProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.readerProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceEntriesTable,
          ServiceEntryRecord,
          $$ServiceEntriesTableFilterComposer,
          $$ServiceEntriesTableOrderingComposer,
          $$ServiceEntriesTableAnnotationComposer,
          $$ServiceEntriesTableCreateCompanionBuilder,
          $$ServiceEntriesTableUpdateCompanionBuilder,
          (ServiceEntryRecord, $$ServiceEntriesTableReferences),
          ServiceEntryRecord,
          PrefetchHooks Function({
            bool serviceId,
            bool editionId,
            bool readerProgressRefs,
          })
        > {
  $$ServiceEntriesTableTableManager(
    _$AppDatabase db,
    $ServiceEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> serviceId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> requestedTitle = const Value.absent(),
                Value<String> normalizedRequestedTitle = const Value.absent(),
                Value<String?> requestedKey = const Value.absent(),
                Value<String?> editionId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> candidateEditionIdsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceEntriesCompanion(
                id: id,
                serviceId: serviceId,
                position: position,
                requestedTitle: requestedTitle,
                normalizedRequestedTitle: normalizedRequestedTitle,
                requestedKey: requestedKey,
                editionId: editionId,
                status: status,
                candidateEditionIdsJson: candidateEditionIdsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String serviceId,
                required int position,
                required String requestedTitle,
                required String normalizedRequestedTitle,
                Value<String?> requestedKey = const Value.absent(),
                Value<String?> editionId = const Value.absent(),
                required String status,
                Value<String> candidateEditionIdsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceEntriesCompanion.insert(
                id: id,
                serviceId: serviceId,
                position: position,
                requestedTitle: requestedTitle,
                normalizedRequestedTitle: normalizedRequestedTitle,
                requestedKey: requestedKey,
                editionId: editionId,
                status: status,
                candidateEditionIdsJson: candidateEditionIdsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServiceEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                serviceId = false,
                editionId = false,
                readerProgressRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (readerProgressRefs) db.readerProgress,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (serviceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.serviceId,
                                    referencedTable:
                                        $$ServiceEntriesTableReferences
                                            ._serviceIdTable(db),
                                    referencedColumn:
                                        $$ServiceEntriesTableReferences
                                            ._serviceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (editionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.editionId,
                                    referencedTable:
                                        $$ServiceEntriesTableReferences
                                            ._editionIdTable(db),
                                    referencedColumn:
                                        $$ServiceEntriesTableReferences
                                            ._editionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readerProgressRefs)
                        await $_getPrefetchedData<
                          ServiceEntryRecord,
                          $ServiceEntriesTable,
                          ReaderProgressRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceEntriesTableReferences
                              ._readerProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).readerProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ServiceEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceEntriesTable,
      ServiceEntryRecord,
      $$ServiceEntriesTableFilterComposer,
      $$ServiceEntriesTableOrderingComposer,
      $$ServiceEntriesTableAnnotationComposer,
      $$ServiceEntriesTableCreateCompanionBuilder,
      $$ServiceEntriesTableUpdateCompanionBuilder,
      (ServiceEntryRecord, $$ServiceEntriesTableReferences),
      ServiceEntryRecord,
      PrefetchHooks Function({
        bool serviceId,
        bool editionId,
        bool readerProgressRefs,
      })
    >;
typedef $$ImportJobsTableCreateCompanionBuilder =
    ImportJobsCompanion Function({
      required String id,
      required String sourceUri,
      required String inputFingerprint,
      required String state,
      Value<int> attempts,
      Value<String?> error,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ImportJobsTableUpdateCompanionBuilder =
    ImportJobsCompanion Function({
      Value<String> id,
      Value<String> sourceUri,
      Value<String> inputFingerprint,
      Value<String> state,
      Value<int> attempts,
      Value<String?> error,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ImportJobsTableFilterComposer
    extends Composer<_$AppDatabase, $ImportJobsTable> {
  $$ImportJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUri => $composableBuilder(
    column: $table.sourceUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputFingerprint => $composableBuilder(
    column: $table.inputFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ImportJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportJobsTable> {
  $$ImportJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUri => $composableBuilder(
    column: $table.sourceUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputFingerprint => $composableBuilder(
    column: $table.inputFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImportJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportJobsTable> {
  $$ImportJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceUri =>
      $composableBuilder(column: $table.sourceUri, builder: (column) => column);

  GeneratedColumn<String> get inputFingerprint => $composableBuilder(
    column: $table.inputFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ImportJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportJobsTable,
          ImportJobRecord,
          $$ImportJobsTableFilterComposer,
          $$ImportJobsTableOrderingComposer,
          $$ImportJobsTableAnnotationComposer,
          $$ImportJobsTableCreateCompanionBuilder,
          $$ImportJobsTableUpdateCompanionBuilder,
          (
            ImportJobRecord,
            BaseReferences<_$AppDatabase, $ImportJobsTable, ImportJobRecord>,
          ),
          ImportJobRecord,
          PrefetchHooks Function()
        > {
  $$ImportJobsTableTableManager(_$AppDatabase db, $ImportJobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceUri = const Value.absent(),
                Value<String> inputFingerprint = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportJobsCompanion(
                id: id,
                sourceUri: sourceUri,
                inputFingerprint: inputFingerprint,
                state: state,
                attempts: attempts,
                error: error,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceUri,
                required String inputFingerprint,
                required String state,
                Value<int> attempts = const Value.absent(),
                Value<String?> error = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ImportJobsCompanion.insert(
                id: id,
                sourceUri: sourceUri,
                inputFingerprint: inputFingerprint,
                state: state,
                attempts: attempts,
                error: error,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ImportJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportJobsTable,
      ImportJobRecord,
      $$ImportJobsTableFilterComposer,
      $$ImportJobsTableOrderingComposer,
      $$ImportJobsTableAnnotationComposer,
      $$ImportJobsTableCreateCompanionBuilder,
      $$ImportJobsTableUpdateCompanionBuilder,
      (
        ImportJobRecord,
        BaseReferences<_$AppDatabase, $ImportJobsTable, ImportJobRecord>,
      ),
      ImportJobRecord,
      PrefetchHooks Function()
    >;
typedef $$FileOperationsTableCreateCompanionBuilder =
    FileOperationsCompanion Function({
      required String id,
      required String kind,
      required String sourceUri,
      Value<String?> destinationName,
      Value<String?> resultUri,
      Value<String?> retainedAssetId,
      required String expectedFingerprint,
      required String state,
      Value<String?> error,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FileOperationsTableUpdateCompanionBuilder =
    FileOperationsCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<String> sourceUri,
      Value<String?> destinationName,
      Value<String?> resultUri,
      Value<String?> retainedAssetId,
      Value<String> expectedFingerprint,
      Value<String> state,
      Value<String?> error,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$FileOperationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FileOperationsTable,
          FileOperationRecord
        > {
  $$FileOperationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SheetAssetsTable _retainedAssetIdTable(_$AppDatabase db) =>
      db.sheetAssets.createAlias(
        $_aliasNameGenerator(
          db.fileOperations.retainedAssetId,
          db.sheetAssets.id,
        ),
      );

  $$SheetAssetsTableProcessedTableManager? get retainedAssetId {
    final $_column = $_itemColumn<String>('retained_asset_id');
    if ($_column == null) return null;
    final manager = $$SheetAssetsTableTableManager(
      $_db,
      $_db.sheetAssets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_retainedAssetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FileOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $FileOperationsTable> {
  $$FileOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUri => $composableBuilder(
    column: $table.sourceUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationName => $composableBuilder(
    column: $table.destinationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultUri => $composableBuilder(
    column: $table.resultUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expectedFingerprint => $composableBuilder(
    column: $table.expectedFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SheetAssetsTableFilterComposer get retainedAssetId {
    final $$SheetAssetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.retainedAssetId,
      referencedTable: $db.sheetAssets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SheetAssetsTableFilterComposer(
            $db: $db,
            $table: $db.sheetAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FileOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $FileOperationsTable> {
  $$FileOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUri => $composableBuilder(
    column: $table.sourceUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationName => $composableBuilder(
    column: $table.destinationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultUri => $composableBuilder(
    column: $table.resultUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectedFingerprint => $composableBuilder(
    column: $table.expectedFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SheetAssetsTableOrderingComposer get retainedAssetId {
    final $$SheetAssetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.retainedAssetId,
      referencedTable: $db.sheetAssets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SheetAssetsTableOrderingComposer(
            $db: $db,
            $table: $db.sheetAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FileOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FileOperationsTable> {
  $$FileOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get sourceUri =>
      $composableBuilder(column: $table.sourceUri, builder: (column) => column);

  GeneratedColumn<String> get destinationName => $composableBuilder(
    column: $table.destinationName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resultUri =>
      $composableBuilder(column: $table.resultUri, builder: (column) => column);

  GeneratedColumn<String> get expectedFingerprint => $composableBuilder(
    column: $table.expectedFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SheetAssetsTableAnnotationComposer get retainedAssetId {
    final $$SheetAssetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.retainedAssetId,
      referencedTable: $db.sheetAssets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SheetAssetsTableAnnotationComposer(
            $db: $db,
            $table: $db.sheetAssets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FileOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FileOperationsTable,
          FileOperationRecord,
          $$FileOperationsTableFilterComposer,
          $$FileOperationsTableOrderingComposer,
          $$FileOperationsTableAnnotationComposer,
          $$FileOperationsTableCreateCompanionBuilder,
          $$FileOperationsTableUpdateCompanionBuilder,
          (FileOperationRecord, $$FileOperationsTableReferences),
          FileOperationRecord,
          PrefetchHooks Function({bool retainedAssetId})
        > {
  $$FileOperationsTableTableManager(
    _$AppDatabase db,
    $FileOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FileOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FileOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FileOperationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> sourceUri = const Value.absent(),
                Value<String?> destinationName = const Value.absent(),
                Value<String?> resultUri = const Value.absent(),
                Value<String?> retainedAssetId = const Value.absent(),
                Value<String> expectedFingerprint = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FileOperationsCompanion(
                id: id,
                kind: kind,
                sourceUri: sourceUri,
                destinationName: destinationName,
                resultUri: resultUri,
                retainedAssetId: retainedAssetId,
                expectedFingerprint: expectedFingerprint,
                state: state,
                error: error,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required String sourceUri,
                Value<String?> destinationName = const Value.absent(),
                Value<String?> resultUri = const Value.absent(),
                Value<String?> retainedAssetId = const Value.absent(),
                required String expectedFingerprint,
                required String state,
                Value<String?> error = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FileOperationsCompanion.insert(
                id: id,
                kind: kind,
                sourceUri: sourceUri,
                destinationName: destinationName,
                resultUri: resultUri,
                retainedAssetId: retainedAssetId,
                expectedFingerprint: expectedFingerprint,
                state: state,
                error: error,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FileOperationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({retainedAssetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (retainedAssetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.retainedAssetId,
                                referencedTable: $$FileOperationsTableReferences
                                    ._retainedAssetIdTable(db),
                                referencedColumn:
                                    $$FileOperationsTableReferences
                                        ._retainedAssetIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FileOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FileOperationsTable,
      FileOperationRecord,
      $$FileOperationsTableFilterComposer,
      $$FileOperationsTableOrderingComposer,
      $$FileOperationsTableAnnotationComposer,
      $$FileOperationsTableCreateCompanionBuilder,
      $$FileOperationsTableUpdateCompanionBuilder,
      (FileOperationRecord, $$FileOperationsTableReferences),
      FileOperationRecord,
      PrefetchHooks Function({bool retainedAssetId})
    >;
typedef $$ReaderProgressTableCreateCompanionBuilder =
    ReaderProgressCompanion Function({
      required String serviceId,
      required String entryId,
      Value<int> pagePosition,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ReaderProgressTableUpdateCompanionBuilder =
    ReaderProgressCompanion Function({
      Value<String> serviceId,
      Value<String> entryId,
      Value<int> pagePosition,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ReaderProgressTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReaderProgressTable,
          ReaderProgressRecord
        > {
  $$ReaderProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ServiceCollectionsTable _serviceIdTable(_$AppDatabase db) =>
      db.serviceCollections.createAlias(
        $_aliasNameGenerator(
          db.readerProgress.serviceId,
          db.serviceCollections.id,
        ),
      );

  $$ServiceCollectionsTableProcessedTableManager get serviceId {
    final $_column = $_itemColumn<String>('service_id')!;

    final manager = $$ServiceCollectionsTableTableManager(
      $_db,
      $_db.serviceCollections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ServiceEntriesTable _entryIdTable(_$AppDatabase db) =>
      db.serviceEntries.createAlias(
        $_aliasNameGenerator(db.readerProgress.entryId, db.serviceEntries.id),
      );

  $$ServiceEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<String>('entry_id')!;

    final manager = $$ServiceEntriesTableTableManager(
      $_db,
      $_db.serviceEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReaderProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ReaderProgressTable> {
  $$ReaderProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get pagePosition => $composableBuilder(
    column: $table.pagePosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ServiceCollectionsTableFilterComposer get serviceId {
    final $$ServiceCollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.serviceCollections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceCollectionsTableFilterComposer(
            $db: $db,
            $table: $db.serviceCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceEntriesTableFilterComposer get entryId {
    final $$ServiceEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.serviceEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceEntriesTableFilterComposer(
            $db: $db,
            $table: $db.serviceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReaderProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ReaderProgressTable> {
  $$ReaderProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get pagePosition => $composableBuilder(
    column: $table.pagePosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServiceCollectionsTableOrderingComposer get serviceId {
    final $$ServiceCollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.serviceCollections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceCollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.serviceCollections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceEntriesTableOrderingComposer get entryId {
    final $$ServiceEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.serviceEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.serviceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReaderProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReaderProgressTable> {
  $$ReaderProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get pagePosition => $composableBuilder(
    column: $table.pagePosition,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ServiceCollectionsTableAnnotationComposer get serviceId {
    final $$ServiceCollectionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.serviceId,
          referencedTable: $db.serviceCollections,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ServiceCollectionsTableAnnotationComposer(
                $db: $db,
                $table: $db.serviceCollections,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ServiceEntriesTableAnnotationComposer get entryId {
    final $$ServiceEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.serviceEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReaderProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReaderProgressTable,
          ReaderProgressRecord,
          $$ReaderProgressTableFilterComposer,
          $$ReaderProgressTableOrderingComposer,
          $$ReaderProgressTableAnnotationComposer,
          $$ReaderProgressTableCreateCompanionBuilder,
          $$ReaderProgressTableUpdateCompanionBuilder,
          (ReaderProgressRecord, $$ReaderProgressTableReferences),
          ReaderProgressRecord,
          PrefetchHooks Function({bool serviceId, bool entryId})
        > {
  $$ReaderProgressTableTableManager(
    _$AppDatabase db,
    $ReaderProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReaderProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReaderProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReaderProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serviceId = const Value.absent(),
                Value<String> entryId = const Value.absent(),
                Value<int> pagePosition = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReaderProgressCompanion(
                serviceId: serviceId,
                entryId: entryId,
                pagePosition: pagePosition,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serviceId,
                required String entryId,
                Value<int> pagePosition = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReaderProgressCompanion.insert(
                serviceId: serviceId,
                entryId: entryId,
                pagePosition: pagePosition,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReaderProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({serviceId = false, entryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (serviceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.serviceId,
                                referencedTable: $$ReaderProgressTableReferences
                                    ._serviceIdTable(db),
                                referencedColumn:
                                    $$ReaderProgressTableReferences
                                        ._serviceIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (entryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.entryId,
                                referencedTable: $$ReaderProgressTableReferences
                                    ._entryIdTable(db),
                                referencedColumn:
                                    $$ReaderProgressTableReferences
                                        ._entryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReaderProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReaderProgressTable,
      ReaderProgressRecord,
      $$ReaderProgressTableFilterComposer,
      $$ReaderProgressTableOrderingComposer,
      $$ReaderProgressTableAnnotationComposer,
      $$ReaderProgressTableCreateCompanionBuilder,
      $$ReaderProgressTableUpdateCompanionBuilder,
      (ReaderProgressRecord, $$ReaderProgressTableReferences),
      ReaderProgressRecord,
      PrefetchHooks Function({bool serviceId, bool entryId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          SettingRecord,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            SettingRecord,
            BaseReferences<_$AppDatabase, $AppSettingsTable, SettingRecord>,
          ),
          SettingRecord,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      SettingRecord,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        SettingRecord,
        BaseReferences<_$AppDatabase, $AppSettingsTable, SettingRecord>,
      ),
      SettingRecord,
      PrefetchHooks Function()
    >;
typedef $$SourceFoldersTableCreateCompanionBuilder =
    SourceFoldersCompanion Function({
      required String id,
      required String treeUri,
      required String displayName,
      Value<bool> includeSubfolders,
      required DateTime addedAt,
      Value<int> rowid,
    });
typedef $$SourceFoldersTableUpdateCompanionBuilder =
    SourceFoldersCompanion Function({
      Value<String> id,
      Value<String> treeUri,
      Value<String> displayName,
      Value<bool> includeSubfolders,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

final class $$SourceFoldersTableReferences
    extends
        BaseReferences<_$AppDatabase, $SourceFoldersTable, SourceFolderRecord> {
  $$SourceFoldersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$DiscoveryLedgerTable, List<DiscoveryRecord>>
  _discoveryLedgerRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.discoveryLedger,
    aliasName: $_aliasNameGenerator(
      db.sourceFolders.id,
      db.discoveryLedger.sourceFolderId,
    ),
  );

  $$DiscoveryLedgerTableProcessedTableManager get discoveryLedgerRefs {
    final manager = $$DiscoveryLedgerTableTableManager(
      $_db,
      $_db.discoveryLedger,
    ).filter((f) => f.sourceFolderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _discoveryLedgerRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SourceFoldersTableFilterComposer
    extends Composer<_$AppDatabase, $SourceFoldersTable> {
  $$SourceFoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get treeUri => $composableBuilder(
    column: $table.treeUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get includeSubfolders => $composableBuilder(
    column: $table.includeSubfolders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> discoveryLedgerRefs(
    Expression<bool> Function($$DiscoveryLedgerTableFilterComposer f) f,
  ) {
    final $$DiscoveryLedgerTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.discoveryLedger,
      getReferencedColumn: (t) => t.sourceFolderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiscoveryLedgerTableFilterComposer(
            $db: $db,
            $table: $db.discoveryLedger,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourceFoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $SourceFoldersTable> {
  $$SourceFoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get treeUri => $composableBuilder(
    column: $table.treeUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get includeSubfolders => $composableBuilder(
    column: $table.includeSubfolders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SourceFoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SourceFoldersTable> {
  $$SourceFoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get treeUri =>
      $composableBuilder(column: $table.treeUri, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get includeSubfolders => $composableBuilder(
    column: $table.includeSubfolders,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  Expression<T> discoveryLedgerRefs<T extends Object>(
    Expression<T> Function($$DiscoveryLedgerTableAnnotationComposer a) f,
  ) {
    final $$DiscoveryLedgerTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.discoveryLedger,
      getReferencedColumn: (t) => t.sourceFolderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiscoveryLedgerTableAnnotationComposer(
            $db: $db,
            $table: $db.discoveryLedger,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SourceFoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SourceFoldersTable,
          SourceFolderRecord,
          $$SourceFoldersTableFilterComposer,
          $$SourceFoldersTableOrderingComposer,
          $$SourceFoldersTableAnnotationComposer,
          $$SourceFoldersTableCreateCompanionBuilder,
          $$SourceFoldersTableUpdateCompanionBuilder,
          (SourceFolderRecord, $$SourceFoldersTableReferences),
          SourceFolderRecord,
          PrefetchHooks Function({bool discoveryLedgerRefs})
        > {
  $$SourceFoldersTableTableManager(_$AppDatabase db, $SourceFoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SourceFoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SourceFoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SourceFoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> treeUri = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<bool> includeSubfolders = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SourceFoldersCompanion(
                id: id,
                treeUri: treeUri,
                displayName: displayName,
                includeSubfolders: includeSubfolders,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String treeUri,
                required String displayName,
                Value<bool> includeSubfolders = const Value.absent(),
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => SourceFoldersCompanion.insert(
                id: id,
                treeUri: treeUri,
                displayName: displayName,
                includeSubfolders: includeSubfolders,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SourceFoldersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({discoveryLedgerRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (discoveryLedgerRefs) db.discoveryLedger,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (discoveryLedgerRefs)
                    await $_getPrefetchedData<
                      SourceFolderRecord,
                      $SourceFoldersTable,
                      DiscoveryRecord
                    >(
                      currentTable: table,
                      referencedTable: $$SourceFoldersTableReferences
                          ._discoveryLedgerRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SourceFoldersTableReferences(
                            db,
                            table,
                            p0,
                          ).discoveryLedgerRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.sourceFolderId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SourceFoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SourceFoldersTable,
      SourceFolderRecord,
      $$SourceFoldersTableFilterComposer,
      $$SourceFoldersTableOrderingComposer,
      $$SourceFoldersTableAnnotationComposer,
      $$SourceFoldersTableCreateCompanionBuilder,
      $$SourceFoldersTableUpdateCompanionBuilder,
      (SourceFolderRecord, $$SourceFoldersTableReferences),
      SourceFolderRecord,
      PrefetchHooks Function({bool discoveryLedgerRefs})
    >;
typedef $$DiscoveryLedgerTableCreateCompanionBuilder =
    DiscoveryLedgerCompanion Function({
      required String id,
      required String stableIdentity,
      Value<String?> sourceFolderId,
      required String documentUri,
      Value<String?> parentUri,
      required String filename,
      required String mimeType,
      required int byteSize,
      Value<DateTime?> providerAddedAt,
      required DateTime firstSeenAt,
      required DateTime eligibilityDate,
      required String dateSource,
      Value<DateTime?> modifiedAt,
      required String metadataFingerprint,
      Value<int> processingVersion,
      Value<String> classification,
      Value<double?> classificationScore,
      Value<String> processingState,
      Value<String?> failureReason,
      Value<String?> sha256,
      Value<String?> pixelFingerprint,
      required String currentUri,
      Value<String> stageTimingsJson,
      Value<DateTime?> lastProcessedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DiscoveryLedgerTableUpdateCompanionBuilder =
    DiscoveryLedgerCompanion Function({
      Value<String> id,
      Value<String> stableIdentity,
      Value<String?> sourceFolderId,
      Value<String> documentUri,
      Value<String?> parentUri,
      Value<String> filename,
      Value<String> mimeType,
      Value<int> byteSize,
      Value<DateTime?> providerAddedAt,
      Value<DateTime> firstSeenAt,
      Value<DateTime> eligibilityDate,
      Value<String> dateSource,
      Value<DateTime?> modifiedAt,
      Value<String> metadataFingerprint,
      Value<int> processingVersion,
      Value<String> classification,
      Value<double?> classificationScore,
      Value<String> processingState,
      Value<String?> failureReason,
      Value<String?> sha256,
      Value<String?> pixelFingerprint,
      Value<String> currentUri,
      Value<String> stageTimingsJson,
      Value<DateTime?> lastProcessedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$DiscoveryLedgerTableReferences
    extends
        BaseReferences<_$AppDatabase, $DiscoveryLedgerTable, DiscoveryRecord> {
  $$DiscoveryLedgerTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SourceFoldersTable _sourceFolderIdTable(_$AppDatabase db) =>
      db.sourceFolders.createAlias(
        $_aliasNameGenerator(
          db.discoveryLedger.sourceFolderId,
          db.sourceFolders.id,
        ),
      );

  $$SourceFoldersTableProcessedTableManager? get sourceFolderId {
    final $_column = $_itemColumn<String>('source_folder_id');
    if ($_column == null) return null;
    final manager = $$SourceFoldersTableTableManager(
      $_db,
      $_db.sourceFolders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceFolderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DiscoveryLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $DiscoveryLedgerTable> {
  $$DiscoveryLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stableIdentity => $composableBuilder(
    column: $table.stableIdentity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get documentUri => $composableBuilder(
    column: $table.documentUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentUri => $composableBuilder(
    column: $table.parentUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get providerAddedAt => $composableBuilder(
    column: $table.providerAddedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eligibilityDate => $composableBuilder(
    column: $table.eligibilityDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateSource => $composableBuilder(
    column: $table.dateSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataFingerprint => $composableBuilder(
    column: $table.metadataFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get processingVersion => $composableBuilder(
    column: $table.processingVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get classificationScore => $composableBuilder(
    column: $table.classificationScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processingState => $composableBuilder(
    column: $table.processingState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pixelFingerprint => $composableBuilder(
    column: $table.pixelFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentUri => $composableBuilder(
    column: $table.currentUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stageTimingsJson => $composableBuilder(
    column: $table.stageTimingsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastProcessedAt => $composableBuilder(
    column: $table.lastProcessedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SourceFoldersTableFilterComposer get sourceFolderId {
    final $$SourceFoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceFolderId,
      referencedTable: $db.sourceFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceFoldersTableFilterComposer(
            $db: $db,
            $table: $db.sourceFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiscoveryLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $DiscoveryLedgerTable> {
  $$DiscoveryLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stableIdentity => $composableBuilder(
    column: $table.stableIdentity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentUri => $composableBuilder(
    column: $table.documentUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentUri => $composableBuilder(
    column: $table.parentUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get providerAddedAt => $composableBuilder(
    column: $table.providerAddedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eligibilityDate => $composableBuilder(
    column: $table.eligibilityDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateSource => $composableBuilder(
    column: $table.dateSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataFingerprint => $composableBuilder(
    column: $table.metadataFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get processingVersion => $composableBuilder(
    column: $table.processingVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get classificationScore => $composableBuilder(
    column: $table.classificationScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processingState => $composableBuilder(
    column: $table.processingState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pixelFingerprint => $composableBuilder(
    column: $table.pixelFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentUri => $composableBuilder(
    column: $table.currentUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stageTimingsJson => $composableBuilder(
    column: $table.stageTimingsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastProcessedAt => $composableBuilder(
    column: $table.lastProcessedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SourceFoldersTableOrderingComposer get sourceFolderId {
    final $$SourceFoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceFolderId,
      referencedTable: $db.sourceFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceFoldersTableOrderingComposer(
            $db: $db,
            $table: $db.sourceFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiscoveryLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiscoveryLedgerTable> {
  $$DiscoveryLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get stableIdentity => $composableBuilder(
    column: $table.stableIdentity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get documentUri => $composableBuilder(
    column: $table.documentUri,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parentUri =>
      $composableBuilder(column: $table.parentUri, builder: (column) => column);

  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  GeneratedColumn<DateTime> get providerAddedAt => $composableBuilder(
    column: $table.providerAddedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get eligibilityDate => $composableBuilder(
    column: $table.eligibilityDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dateSource => $composableBuilder(
    column: $table.dateSource,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
    column: $table.modifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadataFingerprint => $composableBuilder(
    column: $table.metadataFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get processingVersion => $composableBuilder(
    column: $table.processingVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => column,
  );

  GeneratedColumn<double> get classificationScore => $composableBuilder(
    column: $table.classificationScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get processingState => $composableBuilder(
    column: $table.processingState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<String> get pixelFingerprint => $composableBuilder(
    column: $table.pixelFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentUri => $composableBuilder(
    column: $table.currentUri,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stageTimingsJson => $composableBuilder(
    column: $table.stageTimingsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastProcessedAt => $composableBuilder(
    column: $table.lastProcessedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SourceFoldersTableAnnotationComposer get sourceFolderId {
    final $$SourceFoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceFolderId,
      referencedTable: $db.sourceFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SourceFoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.sourceFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiscoveryLedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiscoveryLedgerTable,
          DiscoveryRecord,
          $$DiscoveryLedgerTableFilterComposer,
          $$DiscoveryLedgerTableOrderingComposer,
          $$DiscoveryLedgerTableAnnotationComposer,
          $$DiscoveryLedgerTableCreateCompanionBuilder,
          $$DiscoveryLedgerTableUpdateCompanionBuilder,
          (DiscoveryRecord, $$DiscoveryLedgerTableReferences),
          DiscoveryRecord,
          PrefetchHooks Function({bool sourceFolderId})
        > {
  $$DiscoveryLedgerTableTableManager(
    _$AppDatabase db,
    $DiscoveryLedgerTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiscoveryLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiscoveryLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiscoveryLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> stableIdentity = const Value.absent(),
                Value<String?> sourceFolderId = const Value.absent(),
                Value<String> documentUri = const Value.absent(),
                Value<String?> parentUri = const Value.absent(),
                Value<String> filename = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> byteSize = const Value.absent(),
                Value<DateTime?> providerAddedAt = const Value.absent(),
                Value<DateTime> firstSeenAt = const Value.absent(),
                Value<DateTime> eligibilityDate = const Value.absent(),
                Value<String> dateSource = const Value.absent(),
                Value<DateTime?> modifiedAt = const Value.absent(),
                Value<String> metadataFingerprint = const Value.absent(),
                Value<int> processingVersion = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<double?> classificationScore = const Value.absent(),
                Value<String> processingState = const Value.absent(),
                Value<String?> failureReason = const Value.absent(),
                Value<String?> sha256 = const Value.absent(),
                Value<String?> pixelFingerprint = const Value.absent(),
                Value<String> currentUri = const Value.absent(),
                Value<String> stageTimingsJson = const Value.absent(),
                Value<DateTime?> lastProcessedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiscoveryLedgerCompanion(
                id: id,
                stableIdentity: stableIdentity,
                sourceFolderId: sourceFolderId,
                documentUri: documentUri,
                parentUri: parentUri,
                filename: filename,
                mimeType: mimeType,
                byteSize: byteSize,
                providerAddedAt: providerAddedAt,
                firstSeenAt: firstSeenAt,
                eligibilityDate: eligibilityDate,
                dateSource: dateSource,
                modifiedAt: modifiedAt,
                metadataFingerprint: metadataFingerprint,
                processingVersion: processingVersion,
                classification: classification,
                classificationScore: classificationScore,
                processingState: processingState,
                failureReason: failureReason,
                sha256: sha256,
                pixelFingerprint: pixelFingerprint,
                currentUri: currentUri,
                stageTimingsJson: stageTimingsJson,
                lastProcessedAt: lastProcessedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String stableIdentity,
                Value<String?> sourceFolderId = const Value.absent(),
                required String documentUri,
                Value<String?> parentUri = const Value.absent(),
                required String filename,
                required String mimeType,
                required int byteSize,
                Value<DateTime?> providerAddedAt = const Value.absent(),
                required DateTime firstSeenAt,
                required DateTime eligibilityDate,
                required String dateSource,
                Value<DateTime?> modifiedAt = const Value.absent(),
                required String metadataFingerprint,
                Value<int> processingVersion = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<double?> classificationScore = const Value.absent(),
                Value<String> processingState = const Value.absent(),
                Value<String?> failureReason = const Value.absent(),
                Value<String?> sha256 = const Value.absent(),
                Value<String?> pixelFingerprint = const Value.absent(),
                required String currentUri,
                Value<String> stageTimingsJson = const Value.absent(),
                Value<DateTime?> lastProcessedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DiscoveryLedgerCompanion.insert(
                id: id,
                stableIdentity: stableIdentity,
                sourceFolderId: sourceFolderId,
                documentUri: documentUri,
                parentUri: parentUri,
                filename: filename,
                mimeType: mimeType,
                byteSize: byteSize,
                providerAddedAt: providerAddedAt,
                firstSeenAt: firstSeenAt,
                eligibilityDate: eligibilityDate,
                dateSource: dateSource,
                modifiedAt: modifiedAt,
                metadataFingerprint: metadataFingerprint,
                processingVersion: processingVersion,
                classification: classification,
                classificationScore: classificationScore,
                processingState: processingState,
                failureReason: failureReason,
                sha256: sha256,
                pixelFingerprint: pixelFingerprint,
                currentUri: currentUri,
                stageTimingsJson: stageTimingsJson,
                lastProcessedAt: lastProcessedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiscoveryLedgerTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sourceFolderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sourceFolderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sourceFolderId,
                                referencedTable:
                                    $$DiscoveryLedgerTableReferences
                                        ._sourceFolderIdTable(db),
                                referencedColumn:
                                    $$DiscoveryLedgerTableReferences
                                        ._sourceFolderIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DiscoveryLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiscoveryLedgerTable,
      DiscoveryRecord,
      $$DiscoveryLedgerTableFilterComposer,
      $$DiscoveryLedgerTableOrderingComposer,
      $$DiscoveryLedgerTableAnnotationComposer,
      $$DiscoveryLedgerTableCreateCompanionBuilder,
      $$DiscoveryLedgerTableUpdateCompanionBuilder,
      (DiscoveryRecord, $$DiscoveryLedgerTableReferences),
      DiscoveryRecord,
      PrefetchHooks Function({bool sourceFolderId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SongsTableTableManager get songs =>
      $$SongsTableTableManager(_db, _db.songs);
  $$SongAliasesTableTableManager get songAliases =>
      $$SongAliasesTableTableManager(_db, _db.songAliases);
  $$EditionsTableTableManager get editions =>
      $$EditionsTableTableManager(_db, _db.editions);
  $$SheetAssetsTableTableManager get sheetAssets =>
      $$SheetAssetsTableTableManager(_db, _db.sheetAssets);
  $$ServiceCollectionsTableTableManager get serviceCollections =>
      $$ServiceCollectionsTableTableManager(_db, _db.serviceCollections);
  $$ServiceEntriesTableTableManager get serviceEntries =>
      $$ServiceEntriesTableTableManager(_db, _db.serviceEntries);
  $$ImportJobsTableTableManager get importJobs =>
      $$ImportJobsTableTableManager(_db, _db.importJobs);
  $$FileOperationsTableTableManager get fileOperations =>
      $$FileOperationsTableTableManager(_db, _db.fileOperations);
  $$ReaderProgressTableTableManager get readerProgress =>
      $$ReaderProgressTableTableManager(_db, _db.readerProgress);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$SourceFoldersTableTableManager get sourceFolders =>
      $$SourceFoldersTableTableManager(_db, _db.sourceFolders);
  $$DiscoveryLedgerTableTableManager get discoveryLedger =>
      $$DiscoveryLedgerTableTableManager(_db, _db.discoveryLedger);
}
