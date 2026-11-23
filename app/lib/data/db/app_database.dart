import 'package:bs_road/data/db/app_database.steps.dart';
import 'package:bs_road/data/db/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

export 'package:bs_road/data/db/tables.dart';

part 'app_database.g.dart';

/// Base SQLite locale : catalogue (remplacé en bloc) et données personnelles.
///
/// Toute modification de tables passe par une nouvelle [schemaVersion], une
/// étape de migration et `dart run drift_dev make-migrations` (voir le README).
@DriftDatabase(
  tables: [
    CatalogMeta,
    Categories,
    Zones,
    Places,
    PlaceCategories,
    PlaceTips,
    PlaceSources,
    TransitStops,
    Alerts,
    PlaceStates,
    Settings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Base de l'app, dans son dossier de documents.
  AppDatabase.open() : super(driftDatabase(name: 'bs_road'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: stepByStep(
      // v2 : réglages (point de départ, hypothèses de marge).
      from1To2: (m, schema) => m.createTable(schema.settings),
    ),
  );

  /// Tables vidées et réécrites à chaque import du catalogue.
  List<TableInfo<Table, Object?>> get catalogTables => [
    catalogMeta,
    categories,
    zones,
    places,
    placeCategories,
    placeTips,
    placeSources,
    transitStops,
    alerts,
  ];
}
