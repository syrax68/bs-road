import 'dart:convert';
import 'dart:io' show gzip;

import 'package:bs_road/core/geo/geo.dart';
import 'package:bs_road/features/places/domain/place.dart';

/// Version du format de paquet que cette version de l'app sait lire.
/// Doit suivre SCHEMA_VERSION dans tools/catalog_lib.py.
const int supportedCatalogSchema = 1;

/// Le paquet est d'un format plus récent que l'app : il faut mettre l'app à jour.
class UnsupportedCatalogException implements Exception {
  UnsupportedCatalogException(this.schemaVersion);

  final int schemaVersion;

  @override
  String toString() =>
      'Catalogue au format $schemaVersion, cette version de l’app lit le format $supportedCatalogSchema.';
}

/// Le paquet est illisible ou incomplet.
class CatalogFormatException implements Exception {
  CatalogFormatException(this.message);

  final String message;

  @override
  String toString() => 'Catalogue illisible : $message';
}

/// Contenu d'un paquet catalogue (`catalog-<version>.json.gz`), produit par
/// tools/build_bundle.py.
class CatalogBundle {
  const CatalogBundle({
    required this.schemaVersion,
    required this.version,
    required this.publishedAt,
    required this.categories,
    required this.zones,
    required this.places,
  });

  /// Lit un paquet compressé. Lève [CatalogFormatException] ou
  /// [UnsupportedCatalogException] sans rien modifier.
  factory CatalogBundle.fromGzip(List<int> bytes) {
    final Object? json;
    try {
      json = jsonDecode(utf8.decode(gzip.decode(bytes)));
    } on FormatException catch (e) {
      throw CatalogFormatException('compression ou JSON invalide (${e.message})');
    }
    return CatalogBundle.fromJson(json);
  }

  factory CatalogBundle.fromJson(Object? json) {
    final root = _map(json, 'racine');
    final schema = _int(root, 'schemaVersion', 'racine');
    if (schema > supportedCatalogSchema) {
      throw UnsupportedCatalogException(schema);
    }
    final alerts = <String, PlaceAlert>{
      for (final a in _list(root, 'alerts', 'racine'))
        _str(_map(a, 'alerte'), 'place', 'alerte'): _parseAlert(_map(a, 'alerte')),
    };
    final places = [for (final p in _list(root, 'places', 'racine')) _parsePlace(_map(p, 'lieu'), alerts)];
    return CatalogBundle(
      schemaVersion: schema,
      version: _int(root, 'version', 'racine'),
      publishedAt: _str(root, 'publishedAt', 'racine'),
      categories: [
        for (final c in _list(root, 'categories', 'racine'))
          Category(
            id: _str(_map(c, 'catégorie'), 'id', 'catégorie'),
            label: _str(_map(c, 'catégorie'), 'label', 'catégorie'),
          ),
      ],
      zones: [
        for (final z in _list(root, 'zones', 'racine'))
          Zone(
            id: _str(_map(z, 'quartier'), 'id', 'quartier'),
            letter: _str(_map(z, 'quartier'), 'letter', 'quartier'),
            name: _str(_map(z, 'quartier'), 'name', 'quartier'),
            access: _str(_map(z, 'quartier'), 'access', 'quartier'),
          ),
      ],
      places: places,
    );
  }

  final int schemaVersion;

  /// Version croissante AAAAMMJJHHMM.
  final int version;
  final String publishedAt;
  final List<Category> categories;
  final List<Zone> zones;
  final List<Place> places;
}

Place _parsePlace(Map<String, Object?> m, Map<String, PlaceAlert> alerts) {
  final id = _str(m, 'id', 'lieu');
  final where = 'lieu « $id »';
  final transit = m['transit'];
  TransitStop? metro;
  var buses = const <TransitStop>[];
  if (transit != null) {
    final t = _map(transit, '$where, transit');
    final rawMetro = t['metro'];
    if (rawMetro != null) {
      final mm = _map(rawMetro, '$where, métro');
      metro = TransitStop(
        kind: TransitKind.metro,
        zh: _str(mm, 'zh', where),
        en: _str(mm, 'en', where),
        exit: _optStr(mm, 'exit'),
        distanceM: _int(mm, 'distanceM', where),
        lines: _strings(mm, 'lines', where),
      );
    }
    buses = [
      for (final b in _list(t, 'bus', where))
        TransitStop(
          kind: TransitKind.bus,
          zh: _str(_map(b, where), 'zh', where),
          en: _str(_map(b, where), 'en', where),
          distanceM: _int(_map(b, where), 'distanceM', where),
          lines: _strings(_map(b, where), 'lines', where),
        ),
    ];
  }
  final added = _optStr(m, 'added');
  return Place(
    id: id,
    zh: _str(m, 'zh', where),
    name: _str(m, 'name', where),
    alt: _optStr(m, 'alt'),
    region: Region.parse(_str(m, 'city', where), _optStr(m, 'group')),
    cityName: _optStr(m, 'cityName'),
    zoneId: _optStr(m, 'zone'),
    area: _str(m, 'area', where),
    categoryIds: _strings(m, 'categories', where),
    amapQuery: _str(m, 'amapQuery', where),
    address: _str(m, 'address', where),
    addressZh: _optStr(m, 'addressZh'),
    access: _str(m, 'access', where),
    hours: _str(m, 'hours', where),
    sells: _str(m, 'sells', where),
    moq: _str(m, 'moq', where),
    tips: _strings(m, 'tips', where),
    sources: [
      for (final s in _list(m, 'sources', where))
        SourceLink(title: _str(_map(s, where), 'title', where), url: _str(_map(s, where), 'url', where)),
    ],
    location: GeoPoint(_num(m, 'lat', where), _num(m, 'lng', where)),
    approxNote: _optStr(m, 'approx'),
    added: added == null ? null : DateTime.tryParse(added),
    metro: metro,
    buses: buses,
    alert: alerts[id],
  );
}

PlaceAlert _parseAlert(Map<String, Object?> m) {
  final where = 'signalement « ${m['place']} »';
  final src = m['source'];
  final date = DateTime.tryParse(_str(m, 'date', where));
  if (date == null) throw CatalogFormatException('$where : date invalide');
  return PlaceAlert(
    type: AlertType.parse(_str(m, 'type', where)),
    text: _str(m, 'text', where),
    date: date,
    source: src == null
        ? null
        : SourceLink(title: _str(_map(src, where), 'title', where), url: _str(_map(src, where), 'url', where)),
  );
}

// Lecture stricte : un champ manquant ou d'un mauvais type arrête l'import
// avec un message qui dit où, plutôt qu'un lieu à moitié rempli.

Map<String, Object?> _map(Object? v, String where) {
  if (v is Map<String, Object?>) return v;
  throw CatalogFormatException('$where : objet attendu');
}

List<Object?> _list(Map<String, Object?> m, String key, String where) {
  final v = m[key];
  if (v is List<Object?>) return v;
  throw CatalogFormatException('$where : liste « $key » manquante');
}

String _str(Map<String, Object?> m, String key, String where) {
  final v = m[key];
  if (v is String) return v;
  throw CatalogFormatException('$where : texte « $key » manquant');
}

String? _optStr(Map<String, Object?> m, String key) {
  final v = m[key];
  return v is String && v.isNotEmpty ? v : null;
}

int _int(Map<String, Object?> m, String key, String where) {
  final v = m[key];
  if (v is int) return v;
  throw CatalogFormatException('$where : entier « $key » manquant');
}

double _num(Map<String, Object?> m, String key, String where) {
  final v = m[key];
  if (v is num) return v.toDouble();
  throw CatalogFormatException('$where : nombre « $key » manquant');
}

List<String> _strings(Map<String, Object?> m, String key, String where) => [
  for (final v in _list(m, key, where))
    if (v is String) v,
];
