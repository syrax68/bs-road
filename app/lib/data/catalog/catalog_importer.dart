import 'package:bs_road/core/catalog/place.dart';
import 'package:bs_road/data/catalog/catalog_bundle.dart';
import 'package:bs_road/data/db/app_database.dart';
import 'package:drift/drift.dart';

/// Résultat d'un import.
enum ImportOutcome {
  /// Le catalogue a été remplacé.
  imported,

  /// Le catalogue installé est déjà aussi récent : rien n'a changé.
  upToDate,
}

/// Remplace le catalogue local par le contenu d'un paquet, en une seule
/// transaction : en cas d'erreur, l'ancien catalogue reste en place.
/// Les données personnelles (PlaceStates…) ne sont jamais touchées.
class CatalogImporter {
  CatalogImporter(this._db);

  final AppDatabase _db;

  /// Version du catalogue installé, ou null si la base est vide.
  Future<int?> installedVersion() async {
    final row = await (_db.select(_db.catalogMeta)..where((t) => t.id.equals(1))).getSingleOrNull();
    return row?.version;
  }

  Future<ImportOutcome> import(CatalogBundle bundle, {DateTime? now}) async {
    final installed = await installedVersion();
    if (installed != null && installed >= bundle.version) {
      return ImportOutcome.upToDate;
    }
    await _db.transaction(() async {
      for (final table in _db.catalogTables) {
        await _db.delete(table).go();
      }
      await _db.batch((b) {
        b
          ..insert(
            _db.catalogMeta,
            CatalogMetaCompanion.insert(
              id: const Value(1),
              version: bundle.version,
              schemaVersion: bundle.schemaVersion,
              publishedAt: bundle.publishedAt,
              importedAt: now ?? DateTime.now(),
            ),
          )
          ..insertAll(_db.categories, [
            for (final (i, c) in bundle.categories.indexed)
              CategoriesCompanion.insert(id: c.id, label: c.label, position: i),
          ])
          ..insertAll(_db.zones, [
            for (final (i, z) in bundle.zones.indexed)
              ZonesCompanion.insert(id: z.id, letter: z.letter, name: z.name, access: z.access, position: i),
          ]);
        for (final (i, p) in bundle.places.indexed) {
          _insertPlace(b, p, i);
        }
      });
    });
    return ImportOutcome.imported;
  }

  void _insertPlace(Batch b, Place p, int position) {
    b
      ..insert(
        _db.places,
        PlacesCompanion.insert(
          id: p.id,
          position: position,
          zh: p.zh,
          name: p.name,
          alt: Value(p.alt),
          city: p.region == Region.guangzhou ? 'gz' : 'other',
          cityName: Value(p.cityName),
          grp: Value(switch (p.region) {
            Region.guangzhou => null,
            Region.shenzhen => 'sz',
            Region.near => 'near',
            Region.far => 'far',
          }),
          zone: Value(p.zoneId),
          area: p.area,
          amapQuery: p.amapQuery,
          address: p.address,
          addressZh: Value(p.addressZh),
          access: p.access,
          hours: p.hours,
          sells: p.sells,
          moq: p.moq,
          lat: p.location.lat,
          lng: p.location.lng,
          approx: Value(p.approxNote),
          added: Value(p.added == null ? null : _isoDate(p.added!)),
        ),
      )
      ..insertAll(_db.placeCategories, [
        for (final (i, c) in p.categoryIds.indexed)
          PlaceCategoriesCompanion.insert(placeId: p.id, categoryId: c, position: i),
      ])
      ..insertAll(_db.placeTips, [
        for (final (i, t) in p.tips.indexed) PlaceTipsCompanion.insert(placeId: p.id, position: i, body: t),
      ])
      ..insertAll(_db.placeSources, [
        for (final (i, s) in p.sources.indexed)
          PlaceSourcesCompanion.insert(placeId: p.id, position: i, title: s.title, url: s.url),
      ])
      ..insertAll(_db.transitStops, [
        for (final (i, s) in [?p.metro, ...p.buses].indexed)
          TransitStopsCompanion.insert(
            placeId: p.id,
            kind: s.kind.name,
            position: i,
            zh: s.zh,
            en: s.en,
            exitName: Value(s.exit),
            distanceM: s.distanceM,
            lines: s.lines.join(','),
          ),
      ]);
    final a = p.alert;
    if (a != null) {
      b.insert(
        _db.alerts,
        AlertsCompanion.insert(
          placeId: p.id,
          type: a.type.code,
          body: a.text,
          date: _isoDate(a.date),
          sourceTitle: Value(a.source?.title),
          sourceUrl: Value(a.source?.url),
        ),
      );
    }
  }
}

String _isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
