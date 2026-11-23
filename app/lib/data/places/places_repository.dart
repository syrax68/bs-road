import 'package:bs_road/core/catalog/place.dart';
import 'package:bs_road/core/geo/geo.dart';
import 'package:bs_road/data/db/app_database.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';

/// Lecture du catalogue installé, sous forme d'objets du domaine.
class PlacesRepository {
  PlacesRepository(this._db);

  final AppDatabase _db;

  /// Tous les lieux, dans l'ordre du catalogue. Réémet après chaque import :
  /// l'import réécrit toujours la table des lieux, ce qui suffit à déclencher
  /// la requête, et les tables liées sont relues à ce moment-là.
  Stream<List<Place>> watchPlaces() {
    final query = _db.select(_db.places)..orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.watch().asyncMap(_assemble);
  }

  Stream<List<Category>> watchCategories() {
    final query = _db.select(_db.categories)..orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.watch().map((rows) => [for (final r in rows) Category(id: r.id, label: r.label)]);
  }

  Stream<List<Zone>> watchZones() {
    final query = _db.select(_db.zones)..orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.watch().map(
      (rows) => [for (final r in rows) Zone(id: r.id, letter: r.letter, name: r.name, access: r.access)],
    );
  }

  Future<List<Place>> _assemble(List<PlaceRow> rows) async {
    final cats = groupBy<PlaceCategoryRow, String>(
      await (_db.select(_db.placeCategories)..orderBy([(t) => OrderingTerm(expression: t.position)])).get(),
      (r) => r.placeId,
    );
    final tips = groupBy<PlaceTipRow, String>(
      await (_db.select(_db.placeTips)..orderBy([(t) => OrderingTerm(expression: t.position)])).get(),
      (r) => r.placeId,
    );
    final sources = groupBy<PlaceSourceRow, String>(
      await (_db.select(_db.placeSources)..orderBy([(t) => OrderingTerm(expression: t.position)])).get(),
      (r) => r.placeId,
    );
    final stops = groupBy<TransitStopRow, String>(
      await (_db.select(_db.transitStops)..orderBy([(t) => OrderingTerm(expression: t.position)])).get(),
      (r) => r.placeId,
    );
    final alerts = {for (final a in await _db.select(_db.alerts).get()) a.placeId: a};

    return [
      for (final r in rows)
        _toPlace(
          r,
          cats[r.id] ?? const [],
          tips[r.id] ?? const [],
          sources[r.id] ?? const [],
          stops[r.id] ?? const [],
          alerts[r.id],
        ),
    ];
  }

  Place _toPlace(
    PlaceRow r,
    List<PlaceCategoryRow> cats,
    List<PlaceTipRow> tips,
    List<PlaceSourceRow> sources,
    List<TransitStopRow> stops,
    AlertRow? alert,
  ) {
    TransitStop toStop(TransitStopRow s) => TransitStop(
      kind: s.kind == 'metro' ? TransitKind.metro : TransitKind.bus,
      zh: s.zh,
      en: s.en,
      exit: s.exitName,
      distanceM: s.distanceM,
      lines: s.lines.isEmpty ? const [] : s.lines.split(','),
    );
    final alertDate = alert == null ? null : DateTime.tryParse(alert.date);
    return Place(
      id: r.id,
      zh: r.zh,
      name: r.name,
      alt: r.alt,
      region: Region.parse(r.city, r.grp),
      cityName: r.cityName,
      zoneId: r.zone,
      area: r.area,
      categoryIds: [for (final c in cats) c.categoryId],
      amapQuery: r.amapQuery,
      address: r.address,
      addressZh: r.addressZh,
      access: r.access,
      hours: r.hours,
      sells: r.sells,
      moq: r.moq,
      tips: [for (final t in tips) t.body],
      sources: [for (final s in sources) SourceLink(title: s.title, url: s.url)],
      location: GeoPoint(r.lat, r.lng),
      approxNote: r.approx,
      added: r.added == null ? null : DateTime.tryParse(r.added!),
      metro: stops.where((s) => s.kind == 'metro').map(toStop).firstOrNull,
      buses: [for (final s in stops.where((s) => s.kind == 'bus')) toStop(s)],
      alert: alert == null || alertDate == null
          ? null
          : PlaceAlert(
              type: AlertType.parse(alert.type),
              text: alert.body,
              date: alertDate,
              source: alert.sourceUrl == null
                  ? null
                  : SourceLink(title: alert.sourceTitle ?? 'Source', url: alert.sourceUrl!),
            ),
    );
  }
}

/// Statut, favori et note de chaque lieu : les données de l'utilisateur.
class PlaceStatesRepository {
  PlaceStatesRepository(this._db, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  Stream<Map<String, PlaceState>> watchAll() => _db
      .select(_db.placeStates)
      .watch()
      .map(
        (rows) => {
          for (final r in rows)
            r.placeId: PlaceState(
              placeId: r.placeId,
              status: PlaceStatus.values[r.status.clamp(0, PlaceStatus.values.length - 1)],
              favorite: r.favorite,
              note: r.note,
            ),
        },
      );

  Future<void> setStatus(String placeId, PlaceStatus status) =>
      _upsert(placeId, PlaceStatesCompanion(status: Value(status.index)));

  Future<void> setFavorite(String placeId, {required bool favorite}) =>
      _upsert(placeId, PlaceStatesCompanion(favorite: Value(favorite)));

  Future<void> setNote(String placeId, String note) => _upsert(placeId, PlaceStatesCompanion(note: Value(note)));

  Future<void> _upsert(String placeId, PlaceStatesCompanion change) async {
    final row = change.copyWith(placeId: Value(placeId), updatedAt: Value(_clock()));
    // Insère la ligne au premier changement, sinon ne met à jour que le champ modifié.
    await _db.into(_db.placeStates).insert(row, onConflict: DoUpdate((_) => row, target: [_db.placeStates.placeId]));
  }
}
