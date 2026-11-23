import 'package:drift/drift.dart';

// ---------------------------------------------------------------------------
// Zone catalogue : remplacée en bloc à chaque import d'un paquet.
// L'app n'y écrit jamais en dehors de CatalogImporter.
// ---------------------------------------------------------------------------

/// Une seule ligne (id = 1) : version du catalogue installé.
@DataClassName('CatalogMetaRow')
class CatalogMeta extends Table {
  IntColumn get id => integer()();
  IntColumn get version => integer()();
  IntColumn get schemaVersion => integer()();
  TextColumn get publishedAt => text()();
  DateTimeColumn get importedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  IntColumn get position => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ZoneRow')
class Zones extends Table {
  TextColumn get id => text()();
  TextColumn get letter => text()();
  TextColumn get name => text()();
  TextColumn get access => text()();
  IntColumn get position => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PlaceRow')
class Places extends Table {
  TextColumn get id => text()();
  IntColumn get position => integer()();
  TextColumn get zh => text()();
  TextColumn get name => text()();
  TextColumn get alt => text().nullable()();

  /// `gz` pour Guangzhou, sinon `other`.
  TextColumn get city => text()();
  TextColumn get cityName => text().nullable()();

  /// `sz`, `near` ou `far` hors Guangzhou.
  TextColumn get grp => text().nullable()();
  TextColumn get zone => text().nullable()();
  TextColumn get area => text()();
  TextColumn get amapQuery => text()();
  TextColumn get address => text()();
  TextColumn get addressZh => text().nullable()();
  TextColumn get access => text()();
  TextColumn get hours => text()();
  TextColumn get sells => text()();
  TextColumn get moq => text()();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  TextColumn get approx => text().nullable()();

  /// Date d'ajout au format AAAA-MM-JJ.
  TextColumn get added => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PlaceCategoryRow')
class PlaceCategories extends Table {
  TextColumn get placeId => text()();
  TextColumn get categoryId => text()();
  IntColumn get position => integer()();

  @override
  Set<Column> get primaryKey => {placeId, categoryId};
}

@DataClassName('PlaceTipRow')
class PlaceTips extends Table {
  TextColumn get placeId => text()();
  IntColumn get position => integer()();
  TextColumn get body => text()();

  @override
  Set<Column> get primaryKey => {placeId, position};
}

@DataClassName('PlaceSourceRow')
class PlaceSources extends Table {
  TextColumn get placeId => text()();
  IntColumn get position => integer()();
  TextColumn get title => text()();
  TextColumn get url => text()();

  @override
  Set<Column> get primaryKey => {placeId, position};
}

@DataClassName('TransitStopRow')
class TransitStops extends Table {
  TextColumn get placeId => text()();

  /// `metro` ou `bus`.
  TextColumn get kind => text()();
  IntColumn get position => integer()();
  TextColumn get zh => text()();
  TextColumn get en => text()();
  TextColumn get exitName => text().nullable()();
  IntColumn get distanceM => integer()();

  /// Lignes séparées par des virgules (« 2,5 » ou « B3,夜19 »).
  TextColumn get lines => text()();

  @override
  Set<Column> get primaryKey => {placeId, kind, position};
}

@DataClassName('AlertRow')
class Alerts extends Table {
  TextColumn get placeId => text()();

  /// `ferme`, `verifier` ou `info`.
  TextColumn get type => text()();
  TextColumn get body => text()();
  TextColumn get date => text()();
  TextColumn get sourceTitle => text().nullable()();
  TextColumn get sourceUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {placeId};
}

// ---------------------------------------------------------------------------
// Zone personnelle : écrite par l'utilisateur, jamais par une mise à jour.
// Rattachée aux lieux par leur identifiant texte, sans clé étrangère :
// une note survit si son lieu sort du catalogue.
// ---------------------------------------------------------------------------

@DataClassName('PlaceStateRow')
class PlaceStates extends Table {
  TextColumn get placeId => text()();

  /// 0 pas décidé, 1 à visiter, 2 visité (ordre de PlaceStatus).
  IntColumn get status => integer().withDefault(const Constant(0))();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {placeId};
}

/// Réglages de l'utilisateur, une valeur JSON par clé (point de départ,
/// hypothèses de marge…). Ajoutée en v2.
@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}
