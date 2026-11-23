// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CatalogMetaTable extends CatalogMeta with TableInfo<$CatalogMetaTable, CatalogMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta('schemaVersion');
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta('publishedAt');
  @override
  late final GeneratedColumn<String> publishedAt = GeneratedColumn<String>(
    'published_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta('importedAt');
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, version, schemaVersion, publishedAt, importedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_meta';
  @override
  VerificationContext validateIntegrity(Insertable<CatalogMetaRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta, version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(data['schema_version']!, _schemaVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    if (data.containsKey('published_at')) {
      context.handle(_publishedAtMeta, publishedAt.isAcceptableOrUnknown(data['published_at']!, _publishedAtMeta));
    } else if (isInserting) {
      context.missing(_publishedAtMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(_importedAtMeta, importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta));
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogMetaRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      version: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      schemaVersion: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}schema_version'])!,
      publishedAt: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}published_at'])!,
      importedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}imported_at'])!,
    );
  }

  @override
  $CatalogMetaTable createAlias(String alias) {
    return $CatalogMetaTable(attachedDatabase, alias);
  }
}

class CatalogMetaRow extends DataClass implements Insertable<CatalogMetaRow> {
  final int id;
  final int version;
  final int schemaVersion;
  final String publishedAt;
  final DateTime importedAt;
  const CatalogMetaRow({
    required this.id,
    required this.version,
    required this.schemaVersion,
    required this.publishedAt,
    required this.importedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['version'] = Variable<int>(version);
    map['schema_version'] = Variable<int>(schemaVersion);
    map['published_at'] = Variable<String>(publishedAt);
    map['imported_at'] = Variable<DateTime>(importedAt);
    return map;
  }

  CatalogMetaCompanion toCompanion(bool nullToAbsent) {
    return CatalogMetaCompanion(
      id: Value(id),
      version: Value(version),
      schemaVersion: Value(schemaVersion),
      publishedAt: Value(publishedAt),
      importedAt: Value(importedAt),
    );
  }

  factory CatalogMetaRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogMetaRow(
      id: serializer.fromJson<int>(json['id']),
      version: serializer.fromJson<int>(json['version']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
      publishedAt: serializer.fromJson<String>(json['publishedAt']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'version': serializer.toJson<int>(version),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
      'publishedAt': serializer.toJson<String>(publishedAt),
      'importedAt': serializer.toJson<DateTime>(importedAt),
    };
  }

  CatalogMetaRow copyWith({int? id, int? version, int? schemaVersion, String? publishedAt, DateTime? importedAt}) =>
      CatalogMetaRow(
        id: id ?? this.id,
        version: version ?? this.version,
        schemaVersion: schemaVersion ?? this.schemaVersion,
        publishedAt: publishedAt ?? this.publishedAt,
        importedAt: importedAt ?? this.importedAt,
      );
  CatalogMetaRow copyWithCompanion(CatalogMetaCompanion data) {
    return CatalogMetaRow(
      id: data.id.present ? data.id.value : this.id,
      version: data.version.present ? data.version.value : this.version,
      schemaVersion: data.schemaVersion.present ? data.schemaVersion.value : this.schemaVersion,
      publishedAt: data.publishedAt.present ? data.publishedAt.value : this.publishedAt,
      importedAt: data.importedAt.present ? data.importedAt.value : this.importedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogMetaRow(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, version, schemaVersion, publishedAt, importedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogMetaRow &&
          other.id == this.id &&
          other.version == this.version &&
          other.schemaVersion == this.schemaVersion &&
          other.publishedAt == this.publishedAt &&
          other.importedAt == this.importedAt);
}

class CatalogMetaCompanion extends UpdateCompanion<CatalogMetaRow> {
  final Value<int> id;
  final Value<int> version;
  final Value<int> schemaVersion;
  final Value<String> publishedAt;
  final Value<DateTime> importedAt;
  const CatalogMetaCompanion({
    this.id = const Value.absent(),
    this.version = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.importedAt = const Value.absent(),
  });
  CatalogMetaCompanion.insert({
    this.id = const Value.absent(),
    required int version,
    required int schemaVersion,
    required String publishedAt,
    required DateTime importedAt,
  }) : version = Value(version),
       schemaVersion = Value(schemaVersion),
       publishedAt = Value(publishedAt),
       importedAt = Value(importedAt);
  static Insertable<CatalogMetaRow> custom({
    Expression<int>? id,
    Expression<int>? version,
    Expression<int>? schemaVersion,
    Expression<String>? publishedAt,
    Expression<DateTime>? importedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (version != null) 'version': version,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (publishedAt != null) 'published_at': publishedAt,
      if (importedAt != null) 'imported_at': importedAt,
    });
  }

  CatalogMetaCompanion copyWith({
    Value<int>? id,
    Value<int>? version,
    Value<int>? schemaVersion,
    Value<String>? publishedAt,
    Value<DateTime>? importedAt,
  }) {
    return CatalogMetaCompanion(
      id: id ?? this.id,
      version: version ?? this.version,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      publishedAt: publishedAt ?? this.publishedAt,
      importedAt: importedAt ?? this.importedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<String>(publishedAt.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogMetaCompanion(')
          ..write('id: $id, ')
          ..write('version: $version, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('importedAt: $importedAt')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, label, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(_labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta, position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      label: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String label;
  final int position;
  const CategoryRow({required this.id, required this.label, required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['position'] = Variable<int>(position);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(id: Value(id), label: Value(label), position: Value(position));
  }

  factory CategoryRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'position': serializer.toJson<int>(position),
    };
  }

  CategoryRow copyWith({String? id, String? label, int? position}) =>
      CategoryRow(id: id ?? this.id, label: label ?? this.label, position: position ?? this.position);
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow && other.id == this.id && other.label == this.label && other.position == this.position);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> label;
  final Value<int> position;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String label,
    required int position,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       position = Value(position);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({Value<String>? id, Value<String>? label, Value<int>? position, Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ZonesTable extends Zones with TableInfo<$ZonesTable, ZoneRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ZonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _letterMeta = const VerificationMeta('letter');
  @override
  late final GeneratedColumn<String> letter = GeneratedColumn<String>(
    'letter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accessMeta = const VerificationMeta('access');
  @override
  late final GeneratedColumn<String> access = GeneratedColumn<String>(
    'access',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, letter, name, access, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'zones';
  @override
  VerificationContext validateIntegrity(Insertable<ZoneRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('letter')) {
      context.handle(_letterMeta, letter.isAcceptableOrUnknown(data['letter']!, _letterMeta));
    } else if (isInserting) {
      context.missing(_letterMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('access')) {
      context.handle(_accessMeta, access.isAcceptableOrUnknown(data['access']!, _accessMeta));
    } else if (isInserting) {
      context.missing(_accessMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta, position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ZoneRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ZoneRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      letter: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}letter'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      access: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}access'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $ZonesTable createAlias(String alias) {
    return $ZonesTable(attachedDatabase, alias);
  }
}

class ZoneRow extends DataClass implements Insertable<ZoneRow> {
  final String id;
  final String letter;
  final String name;
  final String access;
  final int position;
  const ZoneRow({
    required this.id,
    required this.letter,
    required this.name,
    required this.access,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['letter'] = Variable<String>(letter);
    map['name'] = Variable<String>(name);
    map['access'] = Variable<String>(access);
    map['position'] = Variable<int>(position);
    return map;
  }

  ZonesCompanion toCompanion(bool nullToAbsent) {
    return ZonesCompanion(
      id: Value(id),
      letter: Value(letter),
      name: Value(name),
      access: Value(access),
      position: Value(position),
    );
  }

  factory ZoneRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ZoneRow(
      id: serializer.fromJson<String>(json['id']),
      letter: serializer.fromJson<String>(json['letter']),
      name: serializer.fromJson<String>(json['name']),
      access: serializer.fromJson<String>(json['access']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'letter': serializer.toJson<String>(letter),
      'name': serializer.toJson<String>(name),
      'access': serializer.toJson<String>(access),
      'position': serializer.toJson<int>(position),
    };
  }

  ZoneRow copyWith({String? id, String? letter, String? name, String? access, int? position}) => ZoneRow(
    id: id ?? this.id,
    letter: letter ?? this.letter,
    name: name ?? this.name,
    access: access ?? this.access,
    position: position ?? this.position,
  );
  ZoneRow copyWithCompanion(ZonesCompanion data) {
    return ZoneRow(
      id: data.id.present ? data.id.value : this.id,
      letter: data.letter.present ? data.letter.value : this.letter,
      name: data.name.present ? data.name.value : this.name,
      access: data.access.present ? data.access.value : this.access,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ZoneRow(')
          ..write('id: $id, ')
          ..write('letter: $letter, ')
          ..write('name: $name, ')
          ..write('access: $access, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, letter, name, access, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZoneRow &&
          other.id == this.id &&
          other.letter == this.letter &&
          other.name == this.name &&
          other.access == this.access &&
          other.position == this.position);
}

class ZonesCompanion extends UpdateCompanion<ZoneRow> {
  final Value<String> id;
  final Value<String> letter;
  final Value<String> name;
  final Value<String> access;
  final Value<int> position;
  final Value<int> rowid;
  const ZonesCompanion({
    this.id = const Value.absent(),
    this.letter = const Value.absent(),
    this.name = const Value.absent(),
    this.access = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ZonesCompanion.insert({
    required String id,
    required String letter,
    required String name,
    required String access,
    required int position,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       letter = Value(letter),
       name = Value(name),
       access = Value(access),
       position = Value(position);
  static Insertable<ZoneRow> custom({
    Expression<String>? id,
    Expression<String>? letter,
    Expression<String>? name,
    Expression<String>? access,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (letter != null) 'letter': letter,
      if (name != null) 'name': name,
      if (access != null) 'access': access,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ZonesCompanion copyWith({
    Value<String>? id,
    Value<String>? letter,
    Value<String>? name,
    Value<String>? access,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return ZonesCompanion(
      id: id ?? this.id,
      letter: letter ?? this.letter,
      name: name ?? this.name,
      access: access ?? this.access,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (letter.present) {
      map['letter'] = Variable<String>(letter.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (access.present) {
      map['access'] = Variable<String>(access.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ZonesCompanion(')
          ..write('id: $id, ')
          ..write('letter: $letter, ')
          ..write('name: $name, ')
          ..write('access: $access, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlacesTable extends Places with TableInfo<$PlacesTable, PlaceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zhMeta = const VerificationMeta('zh');
  @override
  late final GeneratedColumn<String> zh = GeneratedColumn<String>(
    'zh',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _altMeta = const VerificationMeta('alt');
  @override
  late final GeneratedColumn<String> alt = GeneratedColumn<String>(
    'alt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityNameMeta = const VerificationMeta('cityName');
  @override
  late final GeneratedColumn<String> cityName = GeneratedColumn<String>(
    'city_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grpMeta = const VerificationMeta('grp');
  @override
  late final GeneratedColumn<String> grp = GeneratedColumn<String>(
    'grp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zoneMeta = const VerificationMeta('zone');
  @override
  late final GeneratedColumn<String> zone = GeneratedColumn<String>(
    'zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amapQueryMeta = const VerificationMeta('amapQuery');
  @override
  late final GeneratedColumn<String> amapQuery = GeneratedColumn<String>(
    'amap_query',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressZhMeta = const VerificationMeta('addressZh');
  @override
  late final GeneratedColumn<String> addressZh = GeneratedColumn<String>(
    'address_zh',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accessMeta = const VerificationMeta('access');
  @override
  late final GeneratedColumn<String> access = GeneratedColumn<String>(
    'access',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hoursMeta = const VerificationMeta('hours');
  @override
  late final GeneratedColumn<String> hours = GeneratedColumn<String>(
    'hours',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sellsMeta = const VerificationMeta('sells');
  @override
  late final GeneratedColumn<String> sells = GeneratedColumn<String>(
    'sells',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moqMeta = const VerificationMeta('moq');
  @override
  late final GeneratedColumn<String> moq = GeneratedColumn<String>(
    'moq',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _approxMeta = const VerificationMeta('approx');
  @override
  late final GeneratedColumn<String> approx = GeneratedColumn<String>(
    'approx',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedMeta = const VerificationMeta('added');
  @override
  late final GeneratedColumn<String> added = GeneratedColumn<String>(
    'added',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    position,
    zh,
    name,
    alt,
    city,
    cityName,
    grp,
    zone,
    area,
    amapQuery,
    address,
    addressZh,
    access,
    hours,
    sells,
    moq,
    lat,
    lng,
    approx,
    added,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'places';
  @override
  VerificationContext validateIntegrity(Insertable<PlaceRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta, position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('zh')) {
      context.handle(_zhMeta, zh.isAcceptableOrUnknown(data['zh']!, _zhMeta));
    } else if (isInserting) {
      context.missing(_zhMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('alt')) {
      context.handle(_altMeta, alt.isAcceptableOrUnknown(data['alt']!, _altMeta));
    }
    if (data.containsKey('city')) {
      context.handle(_cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('city_name')) {
      context.handle(_cityNameMeta, cityName.isAcceptableOrUnknown(data['city_name']!, _cityNameMeta));
    }
    if (data.containsKey('grp')) {
      context.handle(_grpMeta, grp.isAcceptableOrUnknown(data['grp']!, _grpMeta));
    }
    if (data.containsKey('zone')) {
      context.handle(_zoneMeta, zone.isAcceptableOrUnknown(data['zone']!, _zoneMeta));
    }
    if (data.containsKey('area')) {
      context.handle(_areaMeta, area.isAcceptableOrUnknown(data['area']!, _areaMeta));
    } else if (isInserting) {
      context.missing(_areaMeta);
    }
    if (data.containsKey('amap_query')) {
      context.handle(_amapQueryMeta, amapQuery.isAcceptableOrUnknown(data['amap_query']!, _amapQueryMeta));
    } else if (isInserting) {
      context.missing(_amapQueryMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta, address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('address_zh')) {
      context.handle(_addressZhMeta, addressZh.isAcceptableOrUnknown(data['address_zh']!, _addressZhMeta));
    }
    if (data.containsKey('access')) {
      context.handle(_accessMeta, access.isAcceptableOrUnknown(data['access']!, _accessMeta));
    } else if (isInserting) {
      context.missing(_accessMeta);
    }
    if (data.containsKey('hours')) {
      context.handle(_hoursMeta, hours.isAcceptableOrUnknown(data['hours']!, _hoursMeta));
    } else if (isInserting) {
      context.missing(_hoursMeta);
    }
    if (data.containsKey('sells')) {
      context.handle(_sellsMeta, sells.isAcceptableOrUnknown(data['sells']!, _sellsMeta));
    } else if (isInserting) {
      context.missing(_sellsMeta);
    }
    if (data.containsKey('moq')) {
      context.handle(_moqMeta, moq.isAcceptableOrUnknown(data['moq']!, _moqMeta));
    } else if (isInserting) {
      context.missing(_moqMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(_latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(_lngMeta, lng.isAcceptableOrUnknown(data['lng']!, _lngMeta));
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('approx')) {
      context.handle(_approxMeta, approx.isAcceptableOrUnknown(data['approx']!, _approxMeta));
    }
    if (data.containsKey('added')) {
      context.handle(_addedMeta, added.isAcceptableOrUnknown(data['added']!, _addedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaceRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      zh: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}zh'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      alt: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}alt']),
      city: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}city'])!,
      cityName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}city_name']),
      grp: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}grp']),
      zone: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}zone']),
      area: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}area'])!,
      amapQuery: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}amap_query'])!,
      address: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      addressZh: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}address_zh']),
      access: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}access'])!,
      hours: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}hours'])!,
      sells: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sells'])!,
      moq: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}moq'])!,
      lat: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}lat'])!,
      lng: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}lng'])!,
      approx: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}approx']),
      added: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}added']),
    );
  }

  @override
  $PlacesTable createAlias(String alias) {
    return $PlacesTable(attachedDatabase, alias);
  }
}

class PlaceRow extends DataClass implements Insertable<PlaceRow> {
  final String id;
  final int position;
  final String zh;
  final String name;
  final String? alt;

  /// `gz` pour Guangzhou, sinon `other`.
  final String city;
  final String? cityName;

  /// `sz`, `near` ou `far` hors Guangzhou.
  final String? grp;
  final String? zone;
  final String area;
  final String amapQuery;
  final String address;
  final String? addressZh;
  final String access;
  final String hours;
  final String sells;
  final String moq;
  final double lat;
  final double lng;
  final String? approx;

  /// Date d'ajout au format AAAA-MM-JJ.
  final String? added;
  const PlaceRow({
    required this.id,
    required this.position,
    required this.zh,
    required this.name,
    this.alt,
    required this.city,
    this.cityName,
    this.grp,
    this.zone,
    required this.area,
    required this.amapQuery,
    required this.address,
    this.addressZh,
    required this.access,
    required this.hours,
    required this.sells,
    required this.moq,
    required this.lat,
    required this.lng,
    this.approx,
    this.added,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['position'] = Variable<int>(position);
    map['zh'] = Variable<String>(zh);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || alt != null) {
      map['alt'] = Variable<String>(alt);
    }
    map['city'] = Variable<String>(city);
    if (!nullToAbsent || cityName != null) {
      map['city_name'] = Variable<String>(cityName);
    }
    if (!nullToAbsent || grp != null) {
      map['grp'] = Variable<String>(grp);
    }
    if (!nullToAbsent || zone != null) {
      map['zone'] = Variable<String>(zone);
    }
    map['area'] = Variable<String>(area);
    map['amap_query'] = Variable<String>(amapQuery);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || addressZh != null) {
      map['address_zh'] = Variable<String>(addressZh);
    }
    map['access'] = Variable<String>(access);
    map['hours'] = Variable<String>(hours);
    map['sells'] = Variable<String>(sells);
    map['moq'] = Variable<String>(moq);
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    if (!nullToAbsent || approx != null) {
      map['approx'] = Variable<String>(approx);
    }
    if (!nullToAbsent || added != null) {
      map['added'] = Variable<String>(added);
    }
    return map;
  }

  PlacesCompanion toCompanion(bool nullToAbsent) {
    return PlacesCompanion(
      id: Value(id),
      position: Value(position),
      zh: Value(zh),
      name: Value(name),
      alt: alt == null && nullToAbsent ? const Value.absent() : Value(alt),
      city: Value(city),
      cityName: cityName == null && nullToAbsent ? const Value.absent() : Value(cityName),
      grp: grp == null && nullToAbsent ? const Value.absent() : Value(grp),
      zone: zone == null && nullToAbsent ? const Value.absent() : Value(zone),
      area: Value(area),
      amapQuery: Value(amapQuery),
      address: Value(address),
      addressZh: addressZh == null && nullToAbsent ? const Value.absent() : Value(addressZh),
      access: Value(access),
      hours: Value(hours),
      sells: Value(sells),
      moq: Value(moq),
      lat: Value(lat),
      lng: Value(lng),
      approx: approx == null && nullToAbsent ? const Value.absent() : Value(approx),
      added: added == null && nullToAbsent ? const Value.absent() : Value(added),
    );
  }

  factory PlaceRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaceRow(
      id: serializer.fromJson<String>(json['id']),
      position: serializer.fromJson<int>(json['position']),
      zh: serializer.fromJson<String>(json['zh']),
      name: serializer.fromJson<String>(json['name']),
      alt: serializer.fromJson<String?>(json['alt']),
      city: serializer.fromJson<String>(json['city']),
      cityName: serializer.fromJson<String?>(json['cityName']),
      grp: serializer.fromJson<String?>(json['grp']),
      zone: serializer.fromJson<String?>(json['zone']),
      area: serializer.fromJson<String>(json['area']),
      amapQuery: serializer.fromJson<String>(json['amapQuery']),
      address: serializer.fromJson<String>(json['address']),
      addressZh: serializer.fromJson<String?>(json['addressZh']),
      access: serializer.fromJson<String>(json['access']),
      hours: serializer.fromJson<String>(json['hours']),
      sells: serializer.fromJson<String>(json['sells']),
      moq: serializer.fromJson<String>(json['moq']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      approx: serializer.fromJson<String?>(json['approx']),
      added: serializer.fromJson<String?>(json['added']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'position': serializer.toJson<int>(position),
      'zh': serializer.toJson<String>(zh),
      'name': serializer.toJson<String>(name),
      'alt': serializer.toJson<String?>(alt),
      'city': serializer.toJson<String>(city),
      'cityName': serializer.toJson<String?>(cityName),
      'grp': serializer.toJson<String?>(grp),
      'zone': serializer.toJson<String?>(zone),
      'area': serializer.toJson<String>(area),
      'amapQuery': serializer.toJson<String>(amapQuery),
      'address': serializer.toJson<String>(address),
      'addressZh': serializer.toJson<String?>(addressZh),
      'access': serializer.toJson<String>(access),
      'hours': serializer.toJson<String>(hours),
      'sells': serializer.toJson<String>(sells),
      'moq': serializer.toJson<String>(moq),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'approx': serializer.toJson<String?>(approx),
      'added': serializer.toJson<String?>(added),
    };
  }

  PlaceRow copyWith({
    String? id,
    int? position,
    String? zh,
    String? name,
    Value<String?> alt = const Value.absent(),
    String? city,
    Value<String?> cityName = const Value.absent(),
    Value<String?> grp = const Value.absent(),
    Value<String?> zone = const Value.absent(),
    String? area,
    String? amapQuery,
    String? address,
    Value<String?> addressZh = const Value.absent(),
    String? access,
    String? hours,
    String? sells,
    String? moq,
    double? lat,
    double? lng,
    Value<String?> approx = const Value.absent(),
    Value<String?> added = const Value.absent(),
  }) => PlaceRow(
    id: id ?? this.id,
    position: position ?? this.position,
    zh: zh ?? this.zh,
    name: name ?? this.name,
    alt: alt.present ? alt.value : this.alt,
    city: city ?? this.city,
    cityName: cityName.present ? cityName.value : this.cityName,
    grp: grp.present ? grp.value : this.grp,
    zone: zone.present ? zone.value : this.zone,
    area: area ?? this.area,
    amapQuery: amapQuery ?? this.amapQuery,
    address: address ?? this.address,
    addressZh: addressZh.present ? addressZh.value : this.addressZh,
    access: access ?? this.access,
    hours: hours ?? this.hours,
    sells: sells ?? this.sells,
    moq: moq ?? this.moq,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    approx: approx.present ? approx.value : this.approx,
    added: added.present ? added.value : this.added,
  );
  PlaceRow copyWithCompanion(PlacesCompanion data) {
    return PlaceRow(
      id: data.id.present ? data.id.value : this.id,
      position: data.position.present ? data.position.value : this.position,
      zh: data.zh.present ? data.zh.value : this.zh,
      name: data.name.present ? data.name.value : this.name,
      alt: data.alt.present ? data.alt.value : this.alt,
      city: data.city.present ? data.city.value : this.city,
      cityName: data.cityName.present ? data.cityName.value : this.cityName,
      grp: data.grp.present ? data.grp.value : this.grp,
      zone: data.zone.present ? data.zone.value : this.zone,
      area: data.area.present ? data.area.value : this.area,
      amapQuery: data.amapQuery.present ? data.amapQuery.value : this.amapQuery,
      address: data.address.present ? data.address.value : this.address,
      addressZh: data.addressZh.present ? data.addressZh.value : this.addressZh,
      access: data.access.present ? data.access.value : this.access,
      hours: data.hours.present ? data.hours.value : this.hours,
      sells: data.sells.present ? data.sells.value : this.sells,
      moq: data.moq.present ? data.moq.value : this.moq,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      approx: data.approx.present ? data.approx.value : this.approx,
      added: data.added.present ? data.added.value : this.added,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaceRow(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('zh: $zh, ')
          ..write('name: $name, ')
          ..write('alt: $alt, ')
          ..write('city: $city, ')
          ..write('cityName: $cityName, ')
          ..write('grp: $grp, ')
          ..write('zone: $zone, ')
          ..write('area: $area, ')
          ..write('amapQuery: $amapQuery, ')
          ..write('address: $address, ')
          ..write('addressZh: $addressZh, ')
          ..write('access: $access, ')
          ..write('hours: $hours, ')
          ..write('sells: $sells, ')
          ..write('moq: $moq, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('approx: $approx, ')
          ..write('added: $added')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    position,
    zh,
    name,
    alt,
    city,
    cityName,
    grp,
    zone,
    area,
    amapQuery,
    address,
    addressZh,
    access,
    hours,
    sells,
    moq,
    lat,
    lng,
    approx,
    added,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaceRow &&
          other.id == this.id &&
          other.position == this.position &&
          other.zh == this.zh &&
          other.name == this.name &&
          other.alt == this.alt &&
          other.city == this.city &&
          other.cityName == this.cityName &&
          other.grp == this.grp &&
          other.zone == this.zone &&
          other.area == this.area &&
          other.amapQuery == this.amapQuery &&
          other.address == this.address &&
          other.addressZh == this.addressZh &&
          other.access == this.access &&
          other.hours == this.hours &&
          other.sells == this.sells &&
          other.moq == this.moq &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.approx == this.approx &&
          other.added == this.added);
}

class PlacesCompanion extends UpdateCompanion<PlaceRow> {
  final Value<String> id;
  final Value<int> position;
  final Value<String> zh;
  final Value<String> name;
  final Value<String?> alt;
  final Value<String> city;
  final Value<String?> cityName;
  final Value<String?> grp;
  final Value<String?> zone;
  final Value<String> area;
  final Value<String> amapQuery;
  final Value<String> address;
  final Value<String?> addressZh;
  final Value<String> access;
  final Value<String> hours;
  final Value<String> sells;
  final Value<String> moq;
  final Value<double> lat;
  final Value<double> lng;
  final Value<String?> approx;
  final Value<String?> added;
  final Value<int> rowid;
  const PlacesCompanion({
    this.id = const Value.absent(),
    this.position = const Value.absent(),
    this.zh = const Value.absent(),
    this.name = const Value.absent(),
    this.alt = const Value.absent(),
    this.city = const Value.absent(),
    this.cityName = const Value.absent(),
    this.grp = const Value.absent(),
    this.zone = const Value.absent(),
    this.area = const Value.absent(),
    this.amapQuery = const Value.absent(),
    this.address = const Value.absent(),
    this.addressZh = const Value.absent(),
    this.access = const Value.absent(),
    this.hours = const Value.absent(),
    this.sells = const Value.absent(),
    this.moq = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.approx = const Value.absent(),
    this.added = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlacesCompanion.insert({
    required String id,
    required int position,
    required String zh,
    required String name,
    this.alt = const Value.absent(),
    required String city,
    this.cityName = const Value.absent(),
    this.grp = const Value.absent(),
    this.zone = const Value.absent(),
    required String area,
    required String amapQuery,
    required String address,
    this.addressZh = const Value.absent(),
    required String access,
    required String hours,
    required String sells,
    required String moq,
    required double lat,
    required double lng,
    this.approx = const Value.absent(),
    this.added = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       position = Value(position),
       zh = Value(zh),
       name = Value(name),
       city = Value(city),
       area = Value(area),
       amapQuery = Value(amapQuery),
       address = Value(address),
       access = Value(access),
       hours = Value(hours),
       sells = Value(sells),
       moq = Value(moq),
       lat = Value(lat),
       lng = Value(lng);
  static Insertable<PlaceRow> custom({
    Expression<String>? id,
    Expression<int>? position,
    Expression<String>? zh,
    Expression<String>? name,
    Expression<String>? alt,
    Expression<String>? city,
    Expression<String>? cityName,
    Expression<String>? grp,
    Expression<String>? zone,
    Expression<String>? area,
    Expression<String>? amapQuery,
    Expression<String>? address,
    Expression<String>? addressZh,
    Expression<String>? access,
    Expression<String>? hours,
    Expression<String>? sells,
    Expression<String>? moq,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? approx,
    Expression<String>? added,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (position != null) 'position': position,
      if (zh != null) 'zh': zh,
      if (name != null) 'name': name,
      if (alt != null) 'alt': alt,
      if (city != null) 'city': city,
      if (cityName != null) 'city_name': cityName,
      if (grp != null) 'grp': grp,
      if (zone != null) 'zone': zone,
      if (area != null) 'area': area,
      if (amapQuery != null) 'amap_query': amapQuery,
      if (address != null) 'address': address,
      if (addressZh != null) 'address_zh': addressZh,
      if (access != null) 'access': access,
      if (hours != null) 'hours': hours,
      if (sells != null) 'sells': sells,
      if (moq != null) 'moq': moq,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (approx != null) 'approx': approx,
      if (added != null) 'added': added,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlacesCompanion copyWith({
    Value<String>? id,
    Value<int>? position,
    Value<String>? zh,
    Value<String>? name,
    Value<String?>? alt,
    Value<String>? city,
    Value<String?>? cityName,
    Value<String?>? grp,
    Value<String?>? zone,
    Value<String>? area,
    Value<String>? amapQuery,
    Value<String>? address,
    Value<String?>? addressZh,
    Value<String>? access,
    Value<String>? hours,
    Value<String>? sells,
    Value<String>? moq,
    Value<double>? lat,
    Value<double>? lng,
    Value<String?>? approx,
    Value<String?>? added,
    Value<int>? rowid,
  }) {
    return PlacesCompanion(
      id: id ?? this.id,
      position: position ?? this.position,
      zh: zh ?? this.zh,
      name: name ?? this.name,
      alt: alt ?? this.alt,
      city: city ?? this.city,
      cityName: cityName ?? this.cityName,
      grp: grp ?? this.grp,
      zone: zone ?? this.zone,
      area: area ?? this.area,
      amapQuery: amapQuery ?? this.amapQuery,
      address: address ?? this.address,
      addressZh: addressZh ?? this.addressZh,
      access: access ?? this.access,
      hours: hours ?? this.hours,
      sells: sells ?? this.sells,
      moq: moq ?? this.moq,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      approx: approx ?? this.approx,
      added: added ?? this.added,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (zh.present) {
      map['zh'] = Variable<String>(zh.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (alt.present) {
      map['alt'] = Variable<String>(alt.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (cityName.present) {
      map['city_name'] = Variable<String>(cityName.value);
    }
    if (grp.present) {
      map['grp'] = Variable<String>(grp.value);
    }
    if (zone.present) {
      map['zone'] = Variable<String>(zone.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (amapQuery.present) {
      map['amap_query'] = Variable<String>(amapQuery.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (addressZh.present) {
      map['address_zh'] = Variable<String>(addressZh.value);
    }
    if (access.present) {
      map['access'] = Variable<String>(access.value);
    }
    if (hours.present) {
      map['hours'] = Variable<String>(hours.value);
    }
    if (sells.present) {
      map['sells'] = Variable<String>(sells.value);
    }
    if (moq.present) {
      map['moq'] = Variable<String>(moq.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (approx.present) {
      map['approx'] = Variable<String>(approx.value);
    }
    if (added.present) {
      map['added'] = Variable<String>(added.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesCompanion(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('zh: $zh, ')
          ..write('name: $name, ')
          ..write('alt: $alt, ')
          ..write('city: $city, ')
          ..write('cityName: $cityName, ')
          ..write('grp: $grp, ')
          ..write('zone: $zone, ')
          ..write('area: $area, ')
          ..write('amapQuery: $amapQuery, ')
          ..write('address: $address, ')
          ..write('addressZh: $addressZh, ')
          ..write('access: $access, ')
          ..write('hours: $hours, ')
          ..write('sells: $sells, ')
          ..write('moq: $moq, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('approx: $approx, ')
          ..write('added: $added, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaceCategoriesTable extends PlaceCategories with TableInfo<$PlaceCategoriesTable, PlaceCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaceCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _placeIdMeta = const VerificationMeta('placeId');
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [placeId, categoryId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'place_categories';
  @override
  VerificationContext validateIntegrity(Insertable<PlaceCategoryRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta, placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(_categoryIdMeta, categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta, position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId, categoryId};
  @override
  PlaceCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaceCategoryRow(
      placeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}place_id'])!,
      categoryId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $PlaceCategoriesTable createAlias(String alias) {
    return $PlaceCategoriesTable(attachedDatabase, alias);
  }
}

class PlaceCategoryRow extends DataClass implements Insertable<PlaceCategoryRow> {
  final String placeId;
  final String categoryId;
  final int position;
  const PlaceCategoryRow({required this.placeId, required this.categoryId, required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<String>(placeId);
    map['category_id'] = Variable<String>(categoryId);
    map['position'] = Variable<int>(position);
    return map;
  }

  PlaceCategoriesCompanion toCompanion(bool nullToAbsent) {
    return PlaceCategoriesCompanion(placeId: Value(placeId), categoryId: Value(categoryId), position: Value(position));
  }

  factory PlaceCategoryRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaceCategoryRow(
      placeId: serializer.fromJson<String>(json['placeId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<String>(placeId),
      'categoryId': serializer.toJson<String>(categoryId),
      'position': serializer.toJson<int>(position),
    };
  }

  PlaceCategoryRow copyWith({String? placeId, String? categoryId, int? position}) => PlaceCategoryRow(
    placeId: placeId ?? this.placeId,
    categoryId: categoryId ?? this.categoryId,
    position: position ?? this.position,
  );
  PlaceCategoryRow copyWithCompanion(PlaceCategoriesCompanion data) {
    return PlaceCategoryRow(
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      categoryId: data.categoryId.present ? data.categoryId.value : this.categoryId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaceCategoryRow(')
          ..write('placeId: $placeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(placeId, categoryId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaceCategoryRow &&
          other.placeId == this.placeId &&
          other.categoryId == this.categoryId &&
          other.position == this.position);
}

class PlaceCategoriesCompanion extends UpdateCompanion<PlaceCategoryRow> {
  final Value<String> placeId;
  final Value<String> categoryId;
  final Value<int> position;
  final Value<int> rowid;
  const PlaceCategoriesCompanion({
    this.placeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaceCategoriesCompanion.insert({
    required String placeId,
    required String categoryId,
    required int position,
    this.rowid = const Value.absent(),
  }) : placeId = Value(placeId),
       categoryId = Value(categoryId),
       position = Value(position);
  static Insertable<PlaceCategoryRow> custom({
    Expression<String>? placeId,
    Expression<String>? categoryId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (categoryId != null) 'category_id': categoryId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaceCategoriesCompanion copyWith({
    Value<String>? placeId,
    Value<String>? categoryId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return PlaceCategoriesCompanion(
      placeId: placeId ?? this.placeId,
      categoryId: categoryId ?? this.categoryId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaceCategoriesCompanion(')
          ..write('placeId: $placeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaceTipsTable extends PlaceTips with TableInfo<$PlaceTipsTable, PlaceTipRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaceTipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _placeIdMeta = const VerificationMeta('placeId');
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [placeId, position, body];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'place_tips';
  @override
  VerificationContext validateIntegrity(Insertable<PlaceTipRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta, placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta, position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('body')) {
      context.handle(_bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId, position};
  @override
  PlaceTipRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaceTipRow(
      placeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}place_id'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      body: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}body'])!,
    );
  }

  @override
  $PlaceTipsTable createAlias(String alias) {
    return $PlaceTipsTable(attachedDatabase, alias);
  }
}

class PlaceTipRow extends DataClass implements Insertable<PlaceTipRow> {
  final String placeId;
  final int position;
  final String body;
  const PlaceTipRow({required this.placeId, required this.position, required this.body});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<String>(placeId);
    map['position'] = Variable<int>(position);
    map['body'] = Variable<String>(body);
    return map;
  }

  PlaceTipsCompanion toCompanion(bool nullToAbsent) {
    return PlaceTipsCompanion(placeId: Value(placeId), position: Value(position), body: Value(body));
  }

  factory PlaceTipRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaceTipRow(
      placeId: serializer.fromJson<String>(json['placeId']),
      position: serializer.fromJson<int>(json['position']),
      body: serializer.fromJson<String>(json['body']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<String>(placeId),
      'position': serializer.toJson<int>(position),
      'body': serializer.toJson<String>(body),
    };
  }

  PlaceTipRow copyWith({String? placeId, int? position, String? body}) =>
      PlaceTipRow(placeId: placeId ?? this.placeId, position: position ?? this.position, body: body ?? this.body);
  PlaceTipRow copyWithCompanion(PlaceTipsCompanion data) {
    return PlaceTipRow(
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      position: data.position.present ? data.position.value : this.position,
      body: data.body.present ? data.body.value : this.body,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaceTipRow(')
          ..write('placeId: $placeId, ')
          ..write('position: $position, ')
          ..write('body: $body')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(placeId, position, body);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaceTipRow &&
          other.placeId == this.placeId &&
          other.position == this.position &&
          other.body == this.body);
}

class PlaceTipsCompanion extends UpdateCompanion<PlaceTipRow> {
  final Value<String> placeId;
  final Value<int> position;
  final Value<String> body;
  final Value<int> rowid;
  const PlaceTipsCompanion({
    this.placeId = const Value.absent(),
    this.position = const Value.absent(),
    this.body = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaceTipsCompanion.insert({
    required String placeId,
    required int position,
    required String body,
    this.rowid = const Value.absent(),
  }) : placeId = Value(placeId),
       position = Value(position),
       body = Value(body);
  static Insertable<PlaceTipRow> custom({
    Expression<String>? placeId,
    Expression<int>? position,
    Expression<String>? body,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (position != null) 'position': position,
      if (body != null) 'body': body,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaceTipsCompanion copyWith({Value<String>? placeId, Value<int>? position, Value<String>? body, Value<int>? rowid}) {
    return PlaceTipsCompanion(
      placeId: placeId ?? this.placeId,
      position: position ?? this.position,
      body: body ?? this.body,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaceTipsCompanion(')
          ..write('placeId: $placeId, ')
          ..write('position: $position, ')
          ..write('body: $body, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaceSourcesTable extends PlaceSources with TableInfo<$PlaceSourcesTable, PlaceSourceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaceSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _placeIdMeta = const VerificationMeta('placeId');
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [placeId, position, title, url];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'place_sources';
  @override
  VerificationContext validateIntegrity(Insertable<PlaceSourceRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta, placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta, position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('url')) {
      context.handle(_urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId, position};
  @override
  PlaceSourceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaceSourceRow(
      placeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}place_id'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      url: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}url'])!,
    );
  }

  @override
  $PlaceSourcesTable createAlias(String alias) {
    return $PlaceSourcesTable(attachedDatabase, alias);
  }
}

class PlaceSourceRow extends DataClass implements Insertable<PlaceSourceRow> {
  final String placeId;
  final int position;
  final String title;
  final String url;
  const PlaceSourceRow({required this.placeId, required this.position, required this.title, required this.url});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<String>(placeId);
    map['position'] = Variable<int>(position);
    map['title'] = Variable<String>(title);
    map['url'] = Variable<String>(url);
    return map;
  }

  PlaceSourcesCompanion toCompanion(bool nullToAbsent) {
    return PlaceSourcesCompanion(
      placeId: Value(placeId),
      position: Value(position),
      title: Value(title),
      url: Value(url),
    );
  }

  factory PlaceSourceRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaceSourceRow(
      placeId: serializer.fromJson<String>(json['placeId']),
      position: serializer.fromJson<int>(json['position']),
      title: serializer.fromJson<String>(json['title']),
      url: serializer.fromJson<String>(json['url']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<String>(placeId),
      'position': serializer.toJson<int>(position),
      'title': serializer.toJson<String>(title),
      'url': serializer.toJson<String>(url),
    };
  }

  PlaceSourceRow copyWith({String? placeId, int? position, String? title, String? url}) => PlaceSourceRow(
    placeId: placeId ?? this.placeId,
    position: position ?? this.position,
    title: title ?? this.title,
    url: url ?? this.url,
  );
  PlaceSourceRow copyWithCompanion(PlaceSourcesCompanion data) {
    return PlaceSourceRow(
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      position: data.position.present ? data.position.value : this.position,
      title: data.title.present ? data.title.value : this.title,
      url: data.url.present ? data.url.value : this.url,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaceSourceRow(')
          ..write('placeId: $placeId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(placeId, position, title, url);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaceSourceRow &&
          other.placeId == this.placeId &&
          other.position == this.position &&
          other.title == this.title &&
          other.url == this.url);
}

class PlaceSourcesCompanion extends UpdateCompanion<PlaceSourceRow> {
  final Value<String> placeId;
  final Value<int> position;
  final Value<String> title;
  final Value<String> url;
  final Value<int> rowid;
  const PlaceSourcesCompanion({
    this.placeId = const Value.absent(),
    this.position = const Value.absent(),
    this.title = const Value.absent(),
    this.url = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaceSourcesCompanion.insert({
    required String placeId,
    required int position,
    required String title,
    required String url,
    this.rowid = const Value.absent(),
  }) : placeId = Value(placeId),
       position = Value(position),
       title = Value(title),
       url = Value(url);
  static Insertable<PlaceSourceRow> custom({
    Expression<String>? placeId,
    Expression<int>? position,
    Expression<String>? title,
    Expression<String>? url,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (position != null) 'position': position,
      if (title != null) 'title': title,
      if (url != null) 'url': url,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaceSourcesCompanion copyWith({
    Value<String>? placeId,
    Value<int>? position,
    Value<String>? title,
    Value<String>? url,
    Value<int>? rowid,
  }) {
    return PlaceSourcesCompanion(
      placeId: placeId ?? this.placeId,
      position: position ?? this.position,
      title: title ?? this.title,
      url: url ?? this.url,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaceSourcesCompanion(')
          ..write('placeId: $placeId, ')
          ..write('position: $position, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransitStopsTable extends TransitStops with TableInfo<$TransitStopsTable, TransitStopRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransitStopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _placeIdMeta = const VerificationMeta('placeId');
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
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
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zhMeta = const VerificationMeta('zh');
  @override
  late final GeneratedColumn<String> zh = GeneratedColumn<String>(
    'zh',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enMeta = const VerificationMeta('en');
  @override
  late final GeneratedColumn<String> en = GeneratedColumn<String>(
    'en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exitNameMeta = const VerificationMeta('exitName');
  @override
  late final GeneratedColumn<String> exitName = GeneratedColumn<String>(
    'exit_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMMeta = const VerificationMeta('distanceM');
  @override
  late final GeneratedColumn<int> distanceM = GeneratedColumn<int>(
    'distance_m',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linesMeta = const VerificationMeta('lines');
  @override
  late final GeneratedColumn<String> lines = GeneratedColumn<String>(
    'lines',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [placeId, kind, position, zh, en, exitName, distanceM, lines];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transit_stops';
  @override
  VerificationContext validateIntegrity(Insertable<TransitStopRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta, placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(_kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta, position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('zh')) {
      context.handle(_zhMeta, zh.isAcceptableOrUnknown(data['zh']!, _zhMeta));
    } else if (isInserting) {
      context.missing(_zhMeta);
    }
    if (data.containsKey('en')) {
      context.handle(_enMeta, en.isAcceptableOrUnknown(data['en']!, _enMeta));
    } else if (isInserting) {
      context.missing(_enMeta);
    }
    if (data.containsKey('exit_name')) {
      context.handle(_exitNameMeta, exitName.isAcceptableOrUnknown(data['exit_name']!, _exitNameMeta));
    }
    if (data.containsKey('distance_m')) {
      context.handle(_distanceMMeta, distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta));
    } else if (isInserting) {
      context.missing(_distanceMMeta);
    }
    if (data.containsKey('lines')) {
      context.handle(_linesMeta, lines.isAcceptableOrUnknown(data['lines']!, _linesMeta));
    } else if (isInserting) {
      context.missing(_linesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId, kind, position};
  @override
  TransitStopRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransitStopRow(
      placeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}place_id'])!,
      kind: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      position: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      zh: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}zh'])!,
      en: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}en'])!,
      exitName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}exit_name']),
      distanceM: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}distance_m'])!,
      lines: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}lines'])!,
    );
  }

  @override
  $TransitStopsTable createAlias(String alias) {
    return $TransitStopsTable(attachedDatabase, alias);
  }
}

class TransitStopRow extends DataClass implements Insertable<TransitStopRow> {
  final String placeId;

  /// `metro` ou `bus`.
  final String kind;
  final int position;
  final String zh;
  final String en;
  final String? exitName;
  final int distanceM;

  /// Lignes séparées par des virgules (« 2,5 » ou « B3,夜19 »).
  final String lines;
  const TransitStopRow({
    required this.placeId,
    required this.kind,
    required this.position,
    required this.zh,
    required this.en,
    this.exitName,
    required this.distanceM,
    required this.lines,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<String>(placeId);
    map['kind'] = Variable<String>(kind);
    map['position'] = Variable<int>(position);
    map['zh'] = Variable<String>(zh);
    map['en'] = Variable<String>(en);
    if (!nullToAbsent || exitName != null) {
      map['exit_name'] = Variable<String>(exitName);
    }
    map['distance_m'] = Variable<int>(distanceM);
    map['lines'] = Variable<String>(lines);
    return map;
  }

  TransitStopsCompanion toCompanion(bool nullToAbsent) {
    return TransitStopsCompanion(
      placeId: Value(placeId),
      kind: Value(kind),
      position: Value(position),
      zh: Value(zh),
      en: Value(en),
      exitName: exitName == null && nullToAbsent ? const Value.absent() : Value(exitName),
      distanceM: Value(distanceM),
      lines: Value(lines),
    );
  }

  factory TransitStopRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransitStopRow(
      placeId: serializer.fromJson<String>(json['placeId']),
      kind: serializer.fromJson<String>(json['kind']),
      position: serializer.fromJson<int>(json['position']),
      zh: serializer.fromJson<String>(json['zh']),
      en: serializer.fromJson<String>(json['en']),
      exitName: serializer.fromJson<String?>(json['exitName']),
      distanceM: serializer.fromJson<int>(json['distanceM']),
      lines: serializer.fromJson<String>(json['lines']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<String>(placeId),
      'kind': serializer.toJson<String>(kind),
      'position': serializer.toJson<int>(position),
      'zh': serializer.toJson<String>(zh),
      'en': serializer.toJson<String>(en),
      'exitName': serializer.toJson<String?>(exitName),
      'distanceM': serializer.toJson<int>(distanceM),
      'lines': serializer.toJson<String>(lines),
    };
  }

  TransitStopRow copyWith({
    String? placeId,
    String? kind,
    int? position,
    String? zh,
    String? en,
    Value<String?> exitName = const Value.absent(),
    int? distanceM,
    String? lines,
  }) => TransitStopRow(
    placeId: placeId ?? this.placeId,
    kind: kind ?? this.kind,
    position: position ?? this.position,
    zh: zh ?? this.zh,
    en: en ?? this.en,
    exitName: exitName.present ? exitName.value : this.exitName,
    distanceM: distanceM ?? this.distanceM,
    lines: lines ?? this.lines,
  );
  TransitStopRow copyWithCompanion(TransitStopsCompanion data) {
    return TransitStopRow(
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      kind: data.kind.present ? data.kind.value : this.kind,
      position: data.position.present ? data.position.value : this.position,
      zh: data.zh.present ? data.zh.value : this.zh,
      en: data.en.present ? data.en.value : this.en,
      exitName: data.exitName.present ? data.exitName.value : this.exitName,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      lines: data.lines.present ? data.lines.value : this.lines,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransitStopRow(')
          ..write('placeId: $placeId, ')
          ..write('kind: $kind, ')
          ..write('position: $position, ')
          ..write('zh: $zh, ')
          ..write('en: $en, ')
          ..write('exitName: $exitName, ')
          ..write('distanceM: $distanceM, ')
          ..write('lines: $lines')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(placeId, kind, position, zh, en, exitName, distanceM, lines);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransitStopRow &&
          other.placeId == this.placeId &&
          other.kind == this.kind &&
          other.position == this.position &&
          other.zh == this.zh &&
          other.en == this.en &&
          other.exitName == this.exitName &&
          other.distanceM == this.distanceM &&
          other.lines == this.lines);
}

class TransitStopsCompanion extends UpdateCompanion<TransitStopRow> {
  final Value<String> placeId;
  final Value<String> kind;
  final Value<int> position;
  final Value<String> zh;
  final Value<String> en;
  final Value<String?> exitName;
  final Value<int> distanceM;
  final Value<String> lines;
  final Value<int> rowid;
  const TransitStopsCompanion({
    this.placeId = const Value.absent(),
    this.kind = const Value.absent(),
    this.position = const Value.absent(),
    this.zh = const Value.absent(),
    this.en = const Value.absent(),
    this.exitName = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.lines = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransitStopsCompanion.insert({
    required String placeId,
    required String kind,
    required int position,
    required String zh,
    required String en,
    this.exitName = const Value.absent(),
    required int distanceM,
    required String lines,
    this.rowid = const Value.absent(),
  }) : placeId = Value(placeId),
       kind = Value(kind),
       position = Value(position),
       zh = Value(zh),
       en = Value(en),
       distanceM = Value(distanceM),
       lines = Value(lines);
  static Insertable<TransitStopRow> custom({
    Expression<String>? placeId,
    Expression<String>? kind,
    Expression<int>? position,
    Expression<String>? zh,
    Expression<String>? en,
    Expression<String>? exitName,
    Expression<int>? distanceM,
    Expression<String>? lines,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (kind != null) 'kind': kind,
      if (position != null) 'position': position,
      if (zh != null) 'zh': zh,
      if (en != null) 'en': en,
      if (exitName != null) 'exit_name': exitName,
      if (distanceM != null) 'distance_m': distanceM,
      if (lines != null) 'lines': lines,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransitStopsCompanion copyWith({
    Value<String>? placeId,
    Value<String>? kind,
    Value<int>? position,
    Value<String>? zh,
    Value<String>? en,
    Value<String?>? exitName,
    Value<int>? distanceM,
    Value<String>? lines,
    Value<int>? rowid,
  }) {
    return TransitStopsCompanion(
      placeId: placeId ?? this.placeId,
      kind: kind ?? this.kind,
      position: position ?? this.position,
      zh: zh ?? this.zh,
      en: en ?? this.en,
      exitName: exitName ?? this.exitName,
      distanceM: distanceM ?? this.distanceM,
      lines: lines ?? this.lines,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (zh.present) {
      map['zh'] = Variable<String>(zh.value);
    }
    if (en.present) {
      map['en'] = Variable<String>(en.value);
    }
    if (exitName.present) {
      map['exit_name'] = Variable<String>(exitName.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<int>(distanceM.value);
    }
    if (lines.present) {
      map['lines'] = Variable<String>(lines.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransitStopsCompanion(')
          ..write('placeId: $placeId, ')
          ..write('kind: $kind, ')
          ..write('position: $position, ')
          ..write('zh: $zh, ')
          ..write('en: $en, ')
          ..write('exitName: $exitName, ')
          ..write('distanceM: $distanceM, ')
          ..write('lines: $lines, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlertsTable extends Alerts with TableInfo<$AlertsTable, AlertRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _placeIdMeta = const VerificationMeta('placeId');
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTitleMeta = const VerificationMeta('sourceTitle');
  @override
  late final GeneratedColumn<String> sourceTitle = GeneratedColumn<String>(
    'source_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta('sourceUrl');
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [placeId, type, body, date, sourceTitle, sourceUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alerts';
  @override
  VerificationContext validateIntegrity(Insertable<AlertRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta, placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(_typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('body')) {
      context.handle(_bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('date')) {
      context.handle(_dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('source_title')) {
      context.handle(_sourceTitleMeta, sourceTitle.isAcceptableOrUnknown(data['source_title']!, _sourceTitleMeta));
    }
    if (data.containsKey('source_url')) {
      context.handle(_sourceUrlMeta, sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId};
  @override
  AlertRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertRow(
      placeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}place_id'])!,
      type: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      body: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      date: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      sourceTitle: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source_title']),
      sourceUrl: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source_url']),
    );
  }

  @override
  $AlertsTable createAlias(String alias) {
    return $AlertsTable(attachedDatabase, alias);
  }
}

class AlertRow extends DataClass implements Insertable<AlertRow> {
  final String placeId;

  /// `ferme`, `verifier` ou `info`.
  final String type;
  final String body;
  final String date;
  final String? sourceTitle;
  final String? sourceUrl;
  const AlertRow({
    required this.placeId,
    required this.type,
    required this.body,
    required this.date,
    this.sourceTitle,
    this.sourceUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<String>(placeId);
    map['type'] = Variable<String>(type);
    map['body'] = Variable<String>(body);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || sourceTitle != null) {
      map['source_title'] = Variable<String>(sourceTitle);
    }
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    return map;
  }

  AlertsCompanion toCompanion(bool nullToAbsent) {
    return AlertsCompanion(
      placeId: Value(placeId),
      type: Value(type),
      body: Value(body),
      date: Value(date),
      sourceTitle: sourceTitle == null && nullToAbsent ? const Value.absent() : Value(sourceTitle),
      sourceUrl: sourceUrl == null && nullToAbsent ? const Value.absent() : Value(sourceUrl),
    );
  }

  factory AlertRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertRow(
      placeId: serializer.fromJson<String>(json['placeId']),
      type: serializer.fromJson<String>(json['type']),
      body: serializer.fromJson<String>(json['body']),
      date: serializer.fromJson<String>(json['date']),
      sourceTitle: serializer.fromJson<String?>(json['sourceTitle']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<String>(placeId),
      'type': serializer.toJson<String>(type),
      'body': serializer.toJson<String>(body),
      'date': serializer.toJson<String>(date),
      'sourceTitle': serializer.toJson<String?>(sourceTitle),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
    };
  }

  AlertRow copyWith({
    String? placeId,
    String? type,
    String? body,
    String? date,
    Value<String?> sourceTitle = const Value.absent(),
    Value<String?> sourceUrl = const Value.absent(),
  }) => AlertRow(
    placeId: placeId ?? this.placeId,
    type: type ?? this.type,
    body: body ?? this.body,
    date: date ?? this.date,
    sourceTitle: sourceTitle.present ? sourceTitle.value : this.sourceTitle,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
  );
  AlertRow copyWithCompanion(AlertsCompanion data) {
    return AlertRow(
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      type: data.type.present ? data.type.value : this.type,
      body: data.body.present ? data.body.value : this.body,
      date: data.date.present ? data.date.value : this.date,
      sourceTitle: data.sourceTitle.present ? data.sourceTitle.value : this.sourceTitle,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertRow(')
          ..write('placeId: $placeId, ')
          ..write('type: $type, ')
          ..write('body: $body, ')
          ..write('date: $date, ')
          ..write('sourceTitle: $sourceTitle, ')
          ..write('sourceUrl: $sourceUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(placeId, type, body, date, sourceTitle, sourceUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertRow &&
          other.placeId == this.placeId &&
          other.type == this.type &&
          other.body == this.body &&
          other.date == this.date &&
          other.sourceTitle == this.sourceTitle &&
          other.sourceUrl == this.sourceUrl);
}

class AlertsCompanion extends UpdateCompanion<AlertRow> {
  final Value<String> placeId;
  final Value<String> type;
  final Value<String> body;
  final Value<String> date;
  final Value<String?> sourceTitle;
  final Value<String?> sourceUrl;
  final Value<int> rowid;
  const AlertsCompanion({
    this.placeId = const Value.absent(),
    this.type = const Value.absent(),
    this.body = const Value.absent(),
    this.date = const Value.absent(),
    this.sourceTitle = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlertsCompanion.insert({
    required String placeId,
    required String type,
    required String body,
    required String date,
    this.sourceTitle = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : placeId = Value(placeId),
       type = Value(type),
       body = Value(body),
       date = Value(date);
  static Insertable<AlertRow> custom({
    Expression<String>? placeId,
    Expression<String>? type,
    Expression<String>? body,
    Expression<String>? date,
    Expression<String>? sourceTitle,
    Expression<String>? sourceUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (type != null) 'type': type,
      if (body != null) 'body': body,
      if (date != null) 'date': date,
      if (sourceTitle != null) 'source_title': sourceTitle,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlertsCompanion copyWith({
    Value<String>? placeId,
    Value<String>? type,
    Value<String>? body,
    Value<String>? date,
    Value<String?>? sourceTitle,
    Value<String?>? sourceUrl,
    Value<int>? rowid,
  }) {
    return AlertsCompanion(
      placeId: placeId ?? this.placeId,
      type: type ?? this.type,
      body: body ?? this.body,
      date: date ?? this.date,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (sourceTitle.present) {
      map['source_title'] = Variable<String>(sourceTitle.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertsCompanion(')
          ..write('placeId: $placeId, ')
          ..write('type: $type, ')
          ..write('body: $body, ')
          ..write('date: $date, ')
          ..write('sourceTitle: $sourceTitle, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaceStatesTable extends PlaceStates with TableInfo<$PlaceStatesTable, PlaceStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaceStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _placeIdMeta = const VerificationMeta('placeId');
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta('favorite');
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("favorite" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [placeId, status, favorite, note, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'place_states';
  @override
  VerificationContext validateIntegrity(Insertable<PlaceStateRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(_placeIdMeta, placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta));
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta, status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('favorite')) {
      context.handle(_favoriteMeta, favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta));
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId};
  @override
  PlaceStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaceStateRow(
      placeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}place_id'])!,
      status: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      favorite: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}favorite'])!,
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PlaceStatesTable createAlias(String alias) {
    return $PlaceStatesTable(attachedDatabase, alias);
  }
}

class PlaceStateRow extends DataClass implements Insertable<PlaceStateRow> {
  final String placeId;

  /// 0 pas décidé, 1 à visiter, 2 visité (ordre de PlaceStatus).
  final int status;
  final bool favorite;
  final String note;
  final DateTime updatedAt;
  const PlaceStateRow({
    required this.placeId,
    required this.status,
    required this.favorite,
    required this.note,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<String>(placeId);
    map['status'] = Variable<int>(status);
    map['favorite'] = Variable<bool>(favorite);
    map['note'] = Variable<String>(note);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlaceStatesCompanion toCompanion(bool nullToAbsent) {
    return PlaceStatesCompanion(
      placeId: Value(placeId),
      status: Value(status),
      favorite: Value(favorite),
      note: Value(note),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlaceStateRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaceStateRow(
      placeId: serializer.fromJson<String>(json['placeId']),
      status: serializer.fromJson<int>(json['status']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      note: serializer.fromJson<String>(json['note']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<String>(placeId),
      'status': serializer.toJson<int>(status),
      'favorite': serializer.toJson<bool>(favorite),
      'note': serializer.toJson<String>(note),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlaceStateRow copyWith({String? placeId, int? status, bool? favorite, String? note, DateTime? updatedAt}) =>
      PlaceStateRow(
        placeId: placeId ?? this.placeId,
        status: status ?? this.status,
        favorite: favorite ?? this.favorite,
        note: note ?? this.note,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PlaceStateRow copyWithCompanion(PlaceStatesCompanion data) {
    return PlaceStateRow(
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      status: data.status.present ? data.status.value : this.status,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaceStateRow(')
          ..write('placeId: $placeId, ')
          ..write('status: $status, ')
          ..write('favorite: $favorite, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(placeId, status, favorite, note, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaceStateRow &&
          other.placeId == this.placeId &&
          other.status == this.status &&
          other.favorite == this.favorite &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt);
}

class PlaceStatesCompanion extends UpdateCompanion<PlaceStateRow> {
  final Value<String> placeId;
  final Value<int> status;
  final Value<bool> favorite;
  final Value<String> note;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlaceStatesCompanion({
    this.placeId = const Value.absent(),
    this.status = const Value.absent(),
    this.favorite = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaceStatesCompanion.insert({
    required String placeId,
    this.status = const Value.absent(),
    this.favorite = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : placeId = Value(placeId),
       updatedAt = Value(updatedAt);
  static Insertable<PlaceStateRow> custom({
    Expression<String>? placeId,
    Expression<int>? status,
    Expression<bool>? favorite,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (status != null) 'status': status,
      if (favorite != null) 'favorite': favorite,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaceStatesCompanion copyWith({
    Value<String>? placeId,
    Value<int>? status,
    Value<bool>? favorite,
    Value<String>? note,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlaceStatesCompanion(
      placeId: placeId ?? this.placeId,
      status: status ?? this.status,
      favorite: favorite ?? this.favorite,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
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
    return (StringBuffer('PlaceStatesCompanion(')
          ..write('placeId: $placeId, ')
          ..write('status: $status, ')
          ..write('favorite: $favorite, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatalogMetaTable catalogMeta = $CatalogMetaTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ZonesTable zones = $ZonesTable(this);
  late final $PlacesTable places = $PlacesTable(this);
  late final $PlaceCategoriesTable placeCategories = $PlaceCategoriesTable(this);
  late final $PlaceTipsTable placeTips = $PlaceTipsTable(this);
  late final $PlaceSourcesTable placeSources = $PlaceSourcesTable(this);
  late final $TransitStopsTable transitStops = $TransitStopsTable(this);
  late final $AlertsTable alerts = $AlertsTable(this);
  late final $PlaceStatesTable placeStates = $PlaceStatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    catalogMeta,
    categories,
    zones,
    places,
    placeCategories,
    placeTips,
    placeSources,
    transitStops,
    alerts,
    placeStates,
  ];
}

typedef $$CatalogMetaTableCreateCompanionBuilder = CatalogMetaCompanion Function({
  Value<int> id,
  required int version,
  required int schemaVersion,
  required String publishedAt,
  required DateTime importedAt,
});
typedef $$CatalogMetaTableUpdateCompanionBuilder = CatalogMetaCompanion Function({
  Value<int> id,
  Value<int> version,
  Value<int> schemaVersion,
  Value<String> publishedAt,
  Value<DateTime> importedAt,
});

class $$CatalogMetaTableFilterComposer extends Composer<_$AppDatabase, $CatalogMetaTable> {
  $$CatalogMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get schemaVersion =>
      $composableBuilder(column: $table.schemaVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get publishedAt =>
      $composableBuilder(column: $table.publishedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get importedAt =>
      $composableBuilder(column: $table.importedAt, builder: (column) => ColumnFilters(column));
}

class $$CatalogMetaTableOrderingComposer extends Composer<_$AppDatabase, $CatalogMetaTable> {
  $$CatalogMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get schemaVersion =>
      $composableBuilder(column: $table.schemaVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get publishedAt =>
      $composableBuilder(column: $table.publishedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get importedAt =>
      $composableBuilder(column: $table.importedAt, builder: (column) => ColumnOrderings(column));
}

class $$CatalogMetaTableAnnotationComposer extends Composer<_$AppDatabase, $CatalogMetaTable> {
  $$CatalogMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get version => $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get schemaVersion =>
      $composableBuilder(column: $table.schemaVersion, builder: (column) => column);

  GeneratedColumn<String> get publishedAt =>
      $composableBuilder(column: $table.publishedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get importedAt =>
      $composableBuilder(column: $table.importedAt, builder: (column) => column);
}

class $$CatalogMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogMetaTable,
          CatalogMetaRow,
          $$CatalogMetaTableFilterComposer,
          $$CatalogMetaTableOrderingComposer,
          $$CatalogMetaTableAnnotationComposer,
          $$CatalogMetaTableCreateCompanionBuilder,
          $$CatalogMetaTableUpdateCompanionBuilder,
          (CatalogMetaRow, BaseReferences<_$AppDatabase, $CatalogMetaTable, CatalogMetaRow>),
          CatalogMetaRow,
          PrefetchHooks Function()
        > {
  $$CatalogMetaTableTableManager(_$AppDatabase db, $CatalogMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$CatalogMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$CatalogMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$CatalogMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<String> publishedAt = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
              }) => CatalogMetaCompanion(
                id: id,
                version: version,
                schemaVersion: schemaVersion,
                publishedAt: publishedAt,
                importedAt: importedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int version,
                required int schemaVersion,
                required String publishedAt,
                required DateTime importedAt,
              }) => CatalogMetaCompanion.insert(
                id: id,
                version: version,
                schemaVersion: schemaVersion,
                publishedAt: publishedAt,
                importedAt: importedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CatalogMetaTable, CatalogMetaRow>(table),
                  BaseReferences<_$AppDatabase, $CatalogMetaTable, CatalogMetaRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogMetaTable,
      CatalogMetaRow,
      $$CatalogMetaTableFilterComposer,
      $$CatalogMetaTableOrderingComposer,
      $$CatalogMetaTableAnnotationComposer,
      $$CatalogMetaTableCreateCompanionBuilder,
      $$CatalogMetaTableUpdateCompanionBuilder,
      (CatalogMetaRow, BaseReferences<_$AppDatabase, $CatalogMetaTable, CatalogMetaRow>),
      CatalogMetaRow,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String label,
  required int position,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> label,
  Value<int> position,
  Value<int> rowid,
});

class $$CategoriesTableFilterComposer extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));
}

class $$CategoriesTableOrderingComposer extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label => $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get position => $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>),
          CategoryRow,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => CategoriesCompanion(id: id, label: label, position: position, rowid: rowid),
          createCompanionCallback: ({
            required String id,
            required String label,
            required int position,
            Value<int> rowid = const Value.absent(),
          }) => CategoriesCompanion.insert(id: id, label: label, position: position, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryRow>(table),
                  BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>),
      CategoryRow,
      PrefetchHooks Function()
    >;
typedef $$ZonesTableCreateCompanionBuilder = ZonesCompanion Function({
  required String id,
  required String letter,
  required String name,
  required String access,
  required int position,
  Value<int> rowid,
});
typedef $$ZonesTableUpdateCompanionBuilder = ZonesCompanion Function({
  Value<String> id,
  Value<String> letter,
  Value<String> name,
  Value<String> access,
  Value<int> position,
  Value<int> rowid,
});

class $$ZonesTableFilterComposer extends Composer<_$AppDatabase, $ZonesTable> {
  $$ZonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get letter =>
      $composableBuilder(column: $table.letter, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get access =>
      $composableBuilder(column: $table.access, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));
}

class $$ZonesTableOrderingComposer extends Composer<_$AppDatabase, $ZonesTable> {
  $$ZonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get letter =>
      $composableBuilder(column: $table.letter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get access =>
      $composableBuilder(column: $table.access, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));
}

class $$ZonesTableAnnotationComposer extends Composer<_$AppDatabase, $ZonesTable> {
  $$ZonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get letter => $composableBuilder(column: $table.letter, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get access => $composableBuilder(column: $table.access, builder: (column) => column);

  GeneratedColumn<int> get position => $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$ZonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ZonesTable,
          ZoneRow,
          $$ZonesTableFilterComposer,
          $$ZonesTableOrderingComposer,
          $$ZonesTableAnnotationComposer,
          $$ZonesTableCreateCompanionBuilder,
          $$ZonesTableUpdateCompanionBuilder,
          (ZoneRow, BaseReferences<_$AppDatabase, $ZonesTable, ZoneRow>),
          ZoneRow,
          PrefetchHooks Function()
        > {
  $$ZonesTableTableManager(_$AppDatabase db, $ZonesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ZonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ZonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ZonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> letter = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> access = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => ZonesCompanion(id: id, letter: letter, name: name, access: access, position: position, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String letter,
                required String name,
                required String access,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => ZonesCompanion.insert(
                id: id,
                letter: letter,
                name: name,
                access: access,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ZonesTable, ZoneRow>(table),
                  BaseReferences<_$AppDatabase, $ZonesTable, ZoneRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ZonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ZonesTable,
      ZoneRow,
      $$ZonesTableFilterComposer,
      $$ZonesTableOrderingComposer,
      $$ZonesTableAnnotationComposer,
      $$ZonesTableCreateCompanionBuilder,
      $$ZonesTableUpdateCompanionBuilder,
      (ZoneRow, BaseReferences<_$AppDatabase, $ZonesTable, ZoneRow>),
      ZoneRow,
      PrefetchHooks Function()
    >;
typedef $$PlacesTableCreateCompanionBuilder = PlacesCompanion Function({
  required String id,
  required int position,
  required String zh,
  required String name,
  Value<String?> alt,
  required String city,
  Value<String?> cityName,
  Value<String?> grp,
  Value<String?> zone,
  required String area,
  required String amapQuery,
  required String address,
  Value<String?> addressZh,
  required String access,
  required String hours,
  required String sells,
  required String moq,
  required double lat,
  required double lng,
  Value<String?> approx,
  Value<String?> added,
  Value<int> rowid,
});
typedef $$PlacesTableUpdateCompanionBuilder = PlacesCompanion Function({
  Value<String> id,
  Value<int> position,
  Value<String> zh,
  Value<String> name,
  Value<String?> alt,
  Value<String> city,
  Value<String?> cityName,
  Value<String?> grp,
  Value<String?> zone,
  Value<String> area,
  Value<String> amapQuery,
  Value<String> address,
  Value<String?> addressZh,
  Value<String> access,
  Value<String> hours,
  Value<String> sells,
  Value<String> moq,
  Value<double> lat,
  Value<double> lng,
  Value<String?> approx,
  Value<String?> added,
  Value<int> rowid,
});

class $$PlacesTableFilterComposer extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zh => $composableBuilder(column: $table.zh, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alt => $composableBuilder(column: $table.alt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cityName =>
      $composableBuilder(column: $table.cityName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get grp => $composableBuilder(column: $table.grp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zone => $composableBuilder(column: $table.zone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get area => $composableBuilder(column: $table.area, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get amapQuery =>
      $composableBuilder(column: $table.amapQuery, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get addressZh =>
      $composableBuilder(column: $table.addressZh, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get access =>
      $composableBuilder(column: $table.access, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hours =>
      $composableBuilder(column: $table.hours, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sells =>
      $composableBuilder(column: $table.sells, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moq => $composableBuilder(column: $table.moq, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lat => $composableBuilder(column: $table.lat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lng => $composableBuilder(column: $table.lng, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get approx =>
      $composableBuilder(column: $table.approx, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get added =>
      $composableBuilder(column: $table.added, builder: (column) => ColumnFilters(column));
}

class $$PlacesTableOrderingComposer extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zh => $composableBuilder(column: $table.zh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alt =>
      $composableBuilder(column: $table.alt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cityName =>
      $composableBuilder(column: $table.cityName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get grp =>
      $composableBuilder(column: $table.grp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get amapQuery =>
      $composableBuilder(column: $table.amapQuery, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get addressZh =>
      $composableBuilder(column: $table.addressZh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get access =>
      $composableBuilder(column: $table.access, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hours =>
      $composableBuilder(column: $table.hours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sells =>
      $composableBuilder(column: $table.sells, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moq =>
      $composableBuilder(column: $table.moq, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get approx =>
      $composableBuilder(column: $table.approx, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get added =>
      $composableBuilder(column: $table.added, builder: (column) => ColumnOrderings(column));
}

class $$PlacesTableAnnotationComposer extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position => $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get zh => $composableBuilder(column: $table.zh, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get alt => $composableBuilder(column: $table.alt, builder: (column) => column);

  GeneratedColumn<String> get city => $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get cityName => $composableBuilder(column: $table.cityName, builder: (column) => column);

  GeneratedColumn<String> get grp => $composableBuilder(column: $table.grp, builder: (column) => column);

  GeneratedColumn<String> get zone => $composableBuilder(column: $table.zone, builder: (column) => column);

  GeneratedColumn<String> get area => $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get amapQuery => $composableBuilder(column: $table.amapQuery, builder: (column) => column);

  GeneratedColumn<String> get address => $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get addressZh => $composableBuilder(column: $table.addressZh, builder: (column) => column);

  GeneratedColumn<String> get access => $composableBuilder(column: $table.access, builder: (column) => column);

  GeneratedColumn<String> get hours => $composableBuilder(column: $table.hours, builder: (column) => column);

  GeneratedColumn<String> get sells => $composableBuilder(column: $table.sells, builder: (column) => column);

  GeneratedColumn<String> get moq => $composableBuilder(column: $table.moq, builder: (column) => column);

  GeneratedColumn<double> get lat => $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng => $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<String> get approx => $composableBuilder(column: $table.approx, builder: (column) => column);

  GeneratedColumn<String> get added => $composableBuilder(column: $table.added, builder: (column) => column);
}

class $$PlacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlacesTable,
          PlaceRow,
          $$PlacesTableFilterComposer,
          $$PlacesTableOrderingComposer,
          $$PlacesTableAnnotationComposer,
          $$PlacesTableCreateCompanionBuilder,
          $$PlacesTableUpdateCompanionBuilder,
          (PlaceRow, BaseReferences<_$AppDatabase, $PlacesTable, PlaceRow>),
          PlaceRow,
          PrefetchHooks Function()
        > {
  $$PlacesTableTableManager(_$AppDatabase db, $PlacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> zh = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> alt = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String?> cityName = const Value.absent(),
                Value<String?> grp = const Value.absent(),
                Value<String?> zone = const Value.absent(),
                Value<String> area = const Value.absent(),
                Value<String> amapQuery = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String?> addressZh = const Value.absent(),
                Value<String> access = const Value.absent(),
                Value<String> hours = const Value.absent(),
                Value<String> sells = const Value.absent(),
                Value<String> moq = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lng = const Value.absent(),
                Value<String?> approx = const Value.absent(),
                Value<String?> added = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlacesCompanion(
                id: id,
                position: position,
                zh: zh,
                name: name,
                alt: alt,
                city: city,
                cityName: cityName,
                grp: grp,
                zone: zone,
                area: area,
                amapQuery: amapQuery,
                address: address,
                addressZh: addressZh,
                access: access,
                hours: hours,
                sells: sells,
                moq: moq,
                lat: lat,
                lng: lng,
                approx: approx,
                added: added,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int position,
                required String zh,
                required String name,
                Value<String?> alt = const Value.absent(),
                required String city,
                Value<String?> cityName = const Value.absent(),
                Value<String?> grp = const Value.absent(),
                Value<String?> zone = const Value.absent(),
                required String area,
                required String amapQuery,
                required String address,
                Value<String?> addressZh = const Value.absent(),
                required String access,
                required String hours,
                required String sells,
                required String moq,
                required double lat,
                required double lng,
                Value<String?> approx = const Value.absent(),
                Value<String?> added = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlacesCompanion.insert(
                id: id,
                position: position,
                zh: zh,
                name: name,
                alt: alt,
                city: city,
                cityName: cityName,
                grp: grp,
                zone: zone,
                area: area,
                amapQuery: amapQuery,
                address: address,
                addressZh: addressZh,
                access: access,
                hours: hours,
                sells: sells,
                moq: moq,
                lat: lat,
                lng: lng,
                approx: approx,
                added: added,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlacesTable, PlaceRow>(table),
                  BaseReferences<_$AppDatabase, $PlacesTable, PlaceRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlacesTable,
      PlaceRow,
      $$PlacesTableFilterComposer,
      $$PlacesTableOrderingComposer,
      $$PlacesTableAnnotationComposer,
      $$PlacesTableCreateCompanionBuilder,
      $$PlacesTableUpdateCompanionBuilder,
      (PlaceRow, BaseReferences<_$AppDatabase, $PlacesTable, PlaceRow>),
      PlaceRow,
      PrefetchHooks Function()
    >;
typedef $$PlaceCategoriesTableCreateCompanionBuilder = PlaceCategoriesCompanion Function({
  required String placeId,
  required String categoryId,
  required int position,
  Value<int> rowid,
});
typedef $$PlaceCategoriesTableUpdateCompanionBuilder = PlaceCategoriesCompanion Function({
  Value<String> placeId,
  Value<String> categoryId,
  Value<int> position,
  Value<int> rowid,
});

class $$PlaceCategoriesTableFilterComposer extends Composer<_$AppDatabase, $PlaceCategoriesTable> {
  $$PlaceCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));
}

class $$PlaceCategoriesTableOrderingComposer extends Composer<_$AppDatabase, $PlaceCategoriesTable> {
  $$PlaceCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));
}

class $$PlaceCategoriesTableAnnotationComposer extends Composer<_$AppDatabase, $PlaceCategoriesTable> {
  $$PlaceCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get placeId => $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<int> get position => $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$PlaceCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaceCategoriesTable,
          PlaceCategoryRow,
          $$PlaceCategoriesTableFilterComposer,
          $$PlaceCategoriesTableOrderingComposer,
          $$PlaceCategoriesTableAnnotationComposer,
          $$PlaceCategoriesTableCreateCompanionBuilder,
          $$PlaceCategoriesTableUpdateCompanionBuilder,
          (PlaceCategoryRow, BaseReferences<_$AppDatabase, $PlaceCategoriesTable, PlaceCategoryRow>),
          PlaceCategoryRow,
          PrefetchHooks Function()
        > {
  $$PlaceCategoriesTableTableManager(_$AppDatabase db, $PlaceCategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlaceCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlaceCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlaceCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> placeId = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => PlaceCategoriesCompanion(placeId: placeId, categoryId: categoryId, position: position, rowid: rowid),
          createCompanionCallback:
              ({
                required String placeId,
                required String categoryId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => PlaceCategoriesCompanion.insert(
                placeId: placeId,
                categoryId: categoryId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlaceCategoriesTable, PlaceCategoryRow>(table),
                  BaseReferences<_$AppDatabase, $PlaceCategoriesTable, PlaceCategoryRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaceCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaceCategoriesTable,
      PlaceCategoryRow,
      $$PlaceCategoriesTableFilterComposer,
      $$PlaceCategoriesTableOrderingComposer,
      $$PlaceCategoriesTableAnnotationComposer,
      $$PlaceCategoriesTableCreateCompanionBuilder,
      $$PlaceCategoriesTableUpdateCompanionBuilder,
      (PlaceCategoryRow, BaseReferences<_$AppDatabase, $PlaceCategoriesTable, PlaceCategoryRow>),
      PlaceCategoryRow,
      PrefetchHooks Function()
    >;
typedef $$PlaceTipsTableCreateCompanionBuilder = PlaceTipsCompanion Function({
  required String placeId,
  required int position,
  required String body,
  Value<int> rowid,
});
typedef $$PlaceTipsTableUpdateCompanionBuilder = PlaceTipsCompanion Function({
  Value<String> placeId,
  Value<int> position,
  Value<String> body,
  Value<int> rowid,
});

class $$PlaceTipsTableFilterComposer extends Composer<_$AppDatabase, $PlaceTipsTable> {
  $$PlaceTipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(column: $table.body, builder: (column) => ColumnFilters(column));
}

class $$PlaceTipsTableOrderingComposer extends Composer<_$AppDatabase, $PlaceTipsTable> {
  $$PlaceTipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => ColumnOrderings(column));
}

class $$PlaceTipsTableAnnotationComposer extends Composer<_$AppDatabase, $PlaceTipsTable> {
  $$PlaceTipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get placeId => $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<int> get position => $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get body => $composableBuilder(column: $table.body, builder: (column) => column);
}

class $$PlaceTipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaceTipsTable,
          PlaceTipRow,
          $$PlaceTipsTableFilterComposer,
          $$PlaceTipsTableOrderingComposer,
          $$PlaceTipsTableAnnotationComposer,
          $$PlaceTipsTableCreateCompanionBuilder,
          $$PlaceTipsTableUpdateCompanionBuilder,
          (PlaceTipRow, BaseReferences<_$AppDatabase, $PlaceTipsTable, PlaceTipRow>),
          PlaceTipRow,
          PrefetchHooks Function()
        > {
  $$PlaceTipsTableTableManager(_$AppDatabase db, $PlaceTipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlaceTipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlaceTipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlaceTipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> placeId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => PlaceTipsCompanion(placeId: placeId, position: position, body: body, rowid: rowid),
          createCompanionCallback: ({
            required String placeId,
            required int position,
            required String body,
            Value<int> rowid = const Value.absent(),
          }) => PlaceTipsCompanion.insert(placeId: placeId, position: position, body: body, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlaceTipsTable, PlaceTipRow>(table),
                  BaseReferences<_$AppDatabase, $PlaceTipsTable, PlaceTipRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaceTipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaceTipsTable,
      PlaceTipRow,
      $$PlaceTipsTableFilterComposer,
      $$PlaceTipsTableOrderingComposer,
      $$PlaceTipsTableAnnotationComposer,
      $$PlaceTipsTableCreateCompanionBuilder,
      $$PlaceTipsTableUpdateCompanionBuilder,
      (PlaceTipRow, BaseReferences<_$AppDatabase, $PlaceTipsTable, PlaceTipRow>),
      PlaceTipRow,
      PrefetchHooks Function()
    >;
typedef $$PlaceSourcesTableCreateCompanionBuilder = PlaceSourcesCompanion Function({
  required String placeId,
  required int position,
  required String title,
  required String url,
  Value<int> rowid,
});
typedef $$PlaceSourcesTableUpdateCompanionBuilder = PlaceSourcesCompanion Function({
  Value<String> placeId,
  Value<int> position,
  Value<String> title,
  Value<String> url,
  Value<int> rowid,
});

class $$PlaceSourcesTableFilterComposer extends Composer<_$AppDatabase, $PlaceSourcesTable> {
  $$PlaceSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(column: $table.url, builder: (column) => ColumnFilters(column));
}

class $$PlaceSourcesTableOrderingComposer extends Composer<_$AppDatabase, $PlaceSourcesTable> {
  $$PlaceSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => ColumnOrderings(column));
}

class $$PlaceSourcesTableAnnotationComposer extends Composer<_$AppDatabase, $PlaceSourcesTable> {
  $$PlaceSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get placeId => $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<int> get position => $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get title => $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get url => $composableBuilder(column: $table.url, builder: (column) => column);
}

class $$PlaceSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaceSourcesTable,
          PlaceSourceRow,
          $$PlaceSourcesTableFilterComposer,
          $$PlaceSourcesTableOrderingComposer,
          $$PlaceSourcesTableAnnotationComposer,
          $$PlaceSourcesTableCreateCompanionBuilder,
          $$PlaceSourcesTableUpdateCompanionBuilder,
          (PlaceSourceRow, BaseReferences<_$AppDatabase, $PlaceSourcesTable, PlaceSourceRow>),
          PlaceSourceRow,
          PrefetchHooks Function()
        > {
  $$PlaceSourcesTableTableManager(_$AppDatabase db, $PlaceSourcesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlaceSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlaceSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlaceSourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> placeId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => PlaceSourcesCompanion(placeId: placeId, position: position, title: title, url: url, rowid: rowid),
          createCompanionCallback:
              ({
                required String placeId,
                required int position,
                required String title,
                required String url,
                Value<int> rowid = const Value.absent(),
              }) => PlaceSourcesCompanion.insert(
                placeId: placeId,
                position: position,
                title: title,
                url: url,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlaceSourcesTable, PlaceSourceRow>(table),
                  BaseReferences<_$AppDatabase, $PlaceSourcesTable, PlaceSourceRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaceSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaceSourcesTable,
      PlaceSourceRow,
      $$PlaceSourcesTableFilterComposer,
      $$PlaceSourcesTableOrderingComposer,
      $$PlaceSourcesTableAnnotationComposer,
      $$PlaceSourcesTableCreateCompanionBuilder,
      $$PlaceSourcesTableUpdateCompanionBuilder,
      (PlaceSourceRow, BaseReferences<_$AppDatabase, $PlaceSourcesTable, PlaceSourceRow>),
      PlaceSourceRow,
      PrefetchHooks Function()
    >;
typedef $$TransitStopsTableCreateCompanionBuilder = TransitStopsCompanion Function({
  required String placeId,
  required String kind,
  required int position,
  required String zh,
  required String en,
  Value<String?> exitName,
  required int distanceM,
  required String lines,
  Value<int> rowid,
});
typedef $$TransitStopsTableUpdateCompanionBuilder = TransitStopsCompanion Function({
  Value<String> placeId,
  Value<String> kind,
  Value<int> position,
  Value<String> zh,
  Value<String> en,
  Value<String?> exitName,
  Value<int> distanceM,
  Value<String> lines,
  Value<int> rowid,
});

class $$TransitStopsTableFilterComposer extends Composer<_$AppDatabase, $TransitStopsTable> {
  $$TransitStopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zh => $composableBuilder(column: $table.zh, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get en => $composableBuilder(column: $table.en, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exitName =>
      $composableBuilder(column: $table.exitName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lines =>
      $composableBuilder(column: $table.lines, builder: (column) => ColumnFilters(column));
}

class $$TransitStopsTableOrderingComposer extends Composer<_$AppDatabase, $TransitStopsTable> {
  $$TransitStopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zh => $composableBuilder(column: $table.zh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get en => $composableBuilder(column: $table.en, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exitName =>
      $composableBuilder(column: $table.exitName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lines =>
      $composableBuilder(column: $table.lines, builder: (column) => ColumnOrderings(column));
}

class $$TransitStopsTableAnnotationComposer extends Composer<_$AppDatabase, $TransitStopsTable> {
  $$TransitStopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get placeId => $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get position => $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get zh => $composableBuilder(column: $table.zh, builder: (column) => column);

  GeneratedColumn<String> get en => $composableBuilder(column: $table.en, builder: (column) => column);

  GeneratedColumn<String> get exitName => $composableBuilder(column: $table.exitName, builder: (column) => column);

  GeneratedColumn<int> get distanceM => $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumn<String> get lines => $composableBuilder(column: $table.lines, builder: (column) => column);
}

class $$TransitStopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransitStopsTable,
          TransitStopRow,
          $$TransitStopsTableFilterComposer,
          $$TransitStopsTableOrderingComposer,
          $$TransitStopsTableAnnotationComposer,
          $$TransitStopsTableCreateCompanionBuilder,
          $$TransitStopsTableUpdateCompanionBuilder,
          (TransitStopRow, BaseReferences<_$AppDatabase, $TransitStopsTable, TransitStopRow>),
          TransitStopRow,
          PrefetchHooks Function()
        > {
  $$TransitStopsTableTableManager(_$AppDatabase db, $TransitStopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$TransitStopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$TransitStopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$TransitStopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> placeId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> zh = const Value.absent(),
                Value<String> en = const Value.absent(),
                Value<String?> exitName = const Value.absent(),
                Value<int> distanceM = const Value.absent(),
                Value<String> lines = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransitStopsCompanion(
                placeId: placeId,
                kind: kind,
                position: position,
                zh: zh,
                en: en,
                exitName: exitName,
                distanceM: distanceM,
                lines: lines,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String placeId,
                required String kind,
                required int position,
                required String zh,
                required String en,
                Value<String?> exitName = const Value.absent(),
                required int distanceM,
                required String lines,
                Value<int> rowid = const Value.absent(),
              }) => TransitStopsCompanion.insert(
                placeId: placeId,
                kind: kind,
                position: position,
                zh: zh,
                en: en,
                exitName: exitName,
                distanceM: distanceM,
                lines: lines,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransitStopsTable, TransitStopRow>(table),
                  BaseReferences<_$AppDatabase, $TransitStopsTable, TransitStopRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransitStopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransitStopsTable,
      TransitStopRow,
      $$TransitStopsTableFilterComposer,
      $$TransitStopsTableOrderingComposer,
      $$TransitStopsTableAnnotationComposer,
      $$TransitStopsTableCreateCompanionBuilder,
      $$TransitStopsTableUpdateCompanionBuilder,
      (TransitStopRow, BaseReferences<_$AppDatabase, $TransitStopsTable, TransitStopRow>),
      TransitStopRow,
      PrefetchHooks Function()
    >;
typedef $$AlertsTableCreateCompanionBuilder = AlertsCompanion Function({
  required String placeId,
  required String type,
  required String body,
  required String date,
  Value<String?> sourceTitle,
  Value<String?> sourceUrl,
  Value<int> rowid,
});
typedef $$AlertsTableUpdateCompanionBuilder = AlertsCompanion Function({
  Value<String> placeId,
  Value<String> type,
  Value<String> body,
  Value<String> date,
  Value<String?> sourceTitle,
  Value<String?> sourceUrl,
  Value<int> rowid,
});

class $$AlertsTableFilterComposer extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceTitle =>
      $composableBuilder(column: $table.sourceTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => ColumnFilters(column));
}

class $$AlertsTableOrderingComposer extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceTitle =>
      $composableBuilder(column: $table.sourceTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => ColumnOrderings(column));
}

class $$AlertsTableAnnotationComposer extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get placeId => $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<String> get type => $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get body => $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get date => $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get sourceTitle =>
      $composableBuilder(column: $table.sourceTitle, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl => $composableBuilder(column: $table.sourceUrl, builder: (column) => column);
}

class $$AlertsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlertsTable,
          AlertRow,
          $$AlertsTableFilterComposer,
          $$AlertsTableOrderingComposer,
          $$AlertsTableAnnotationComposer,
          $$AlertsTableCreateCompanionBuilder,
          $$AlertsTableUpdateCompanionBuilder,
          (AlertRow, BaseReferences<_$AppDatabase, $AlertsTable, AlertRow>),
          AlertRow,
          PrefetchHooks Function()
        > {
  $$AlertsTableTableManager(_$AppDatabase db, $AlertsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$AlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$AlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$AlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> placeId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> sourceTitle = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlertsCompanion(
                placeId: placeId,
                type: type,
                body: body,
                date: date,
                sourceTitle: sourceTitle,
                sourceUrl: sourceUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String placeId,
                required String type,
                required String body,
                required String date,
                Value<String?> sourceTitle = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlertsCompanion.insert(
                placeId: placeId,
                type: type,
                body: body,
                date: date,
                sourceTitle: sourceTitle,
                sourceUrl: sourceUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AlertsTable, AlertRow>(table),
                  BaseReferences<_$AppDatabase, $AlertsTable, AlertRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlertsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlertsTable,
      AlertRow,
      $$AlertsTableFilterComposer,
      $$AlertsTableOrderingComposer,
      $$AlertsTableAnnotationComposer,
      $$AlertsTableCreateCompanionBuilder,
      $$AlertsTableUpdateCompanionBuilder,
      (AlertRow, BaseReferences<_$AppDatabase, $AlertsTable, AlertRow>),
      AlertRow,
      PrefetchHooks Function()
    >;
typedef $$PlaceStatesTableCreateCompanionBuilder = PlaceStatesCompanion Function({
  required String placeId,
  Value<int> status,
  Value<bool> favorite,
  Value<String> note,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PlaceStatesTableUpdateCompanionBuilder = PlaceStatesCompanion Function({
  Value<String> placeId,
  Value<int> status,
  Value<bool> favorite,
  Value<String> note,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PlaceStatesTableFilterComposer extends Composer<_$AppDatabase, $PlaceStatesTable> {
  $$PlaceStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PlaceStatesTableOrderingComposer extends Composer<_$AppDatabase, $PlaceStatesTable> {
  $$PlaceStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PlaceStatesTableAnnotationComposer extends Composer<_$AppDatabase, $PlaceStatesTable> {
  $$PlaceStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get placeId => $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<int> get status => $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get favorite => $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<String> get note => $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PlaceStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaceStatesTable,
          PlaceStateRow,
          $$PlaceStatesTableFilterComposer,
          $$PlaceStatesTableOrderingComposer,
          $$PlaceStatesTableAnnotationComposer,
          $$PlaceStatesTableCreateCompanionBuilder,
          $$PlaceStatesTableUpdateCompanionBuilder,
          (PlaceStateRow, BaseReferences<_$AppDatabase, $PlaceStatesTable, PlaceStateRow>),
          PlaceStateRow,
          PrefetchHooks Function()
        > {
  $$PlaceStatesTableTableManager(_$AppDatabase db, $PlaceStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlaceStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlaceStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlaceStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> placeId = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaceStatesCompanion(
                placeId: placeId,
                status: status,
                favorite: favorite,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String placeId,
                Value<int> status = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<String> note = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlaceStatesCompanion.insert(
                placeId: placeId,
                status: status,
                favorite: favorite,
                note: note,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlaceStatesTable, PlaceStateRow>(table),
                  BaseReferences<_$AppDatabase, $PlaceStatesTable, PlaceStateRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaceStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaceStatesTable,
      PlaceStateRow,
      $$PlaceStatesTableFilterComposer,
      $$PlaceStatesTableOrderingComposer,
      $$PlaceStatesTableAnnotationComposer,
      $$PlaceStatesTableCreateCompanionBuilder,
      $$PlaceStatesTableUpdateCompanionBuilder,
      (PlaceStateRow, BaseReferences<_$AppDatabase, $PlaceStatesTable, PlaceStateRow>),
      PlaceStateRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatalogMetaTableTableManager get catalogMeta => $$CatalogMetaTableTableManager(_db, _db.catalogMeta);
  $$CategoriesTableTableManager get categories => $$CategoriesTableTableManager(_db, _db.categories);
  $$ZonesTableTableManager get zones => $$ZonesTableTableManager(_db, _db.zones);
  $$PlacesTableTableManager get places => $$PlacesTableTableManager(_db, _db.places);
  $$PlaceCategoriesTableTableManager get placeCategories =>
      $$PlaceCategoriesTableTableManager(_db, _db.placeCategories);
  $$PlaceTipsTableTableManager get placeTips => $$PlaceTipsTableTableManager(_db, _db.placeTips);
  $$PlaceSourcesTableTableManager get placeSources => $$PlaceSourcesTableTableManager(_db, _db.placeSources);
  $$TransitStopsTableTableManager get transitStops => $$TransitStopsTableTableManager(_db, _db.transitStops);
  $$AlertsTableTableManager get alerts => $$AlertsTableTableManager(_db, _db.alerts);
  $$PlaceStatesTableTableManager get placeStates => $$PlaceStatesTableTableManager(_db, _db.placeStates);
}
