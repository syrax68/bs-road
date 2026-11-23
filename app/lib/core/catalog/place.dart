import 'package:bs_road/core/geo/geo.dart';

/// Catégorie de produits (sacs, pièces moto…).
class Category {
  const Category({required this.id, required this.label});

  final String id;
  final String label;
}

/// Quartier de Guangzhou qui regroupe des lieux voisins (A à K).
class Zone {
  const Zone({required this.id, required this.letter, required this.name, required this.access});

  final String id;
  final String letter;
  final String name;

  /// Comment s'y rendre en une ligne (station de métro principale).
  final String access;
}

/// Où se trouve un lieu par rapport à la base de Guangzhou.
enum Region {
  guangzhou,
  shenzhen,

  /// Aller-retour possible dans la journée depuis Guangzhou.
  near,

  /// Demande un train long ou un avion.
  far;

  static Region parse(String city, String? group) {
    if (city == 'gz') return Region.guangzhou;
    return switch (group) {
      'sz' => Region.shenzhen,
      'near' => Region.near,
      _ => Region.far,
    };
  }
}

enum TransitKind { metro, bus }

/// Station ou arrêt le plus proche, relevé sur OpenStreetMap.
class TransitStop {
  const TransitStop({
    required this.kind,
    required this.zh,
    required this.en,
    required this.distanceM,
    required this.lines,
    this.exit,
  });

  final TransitKind kind;
  final String zh;
  final String en;

  /// Sortie de métro conseillée, si connue.
  final String? exit;
  final int distanceM;
  final List<String> lines;
}

class SourceLink {
  const SourceLink({required this.title, required this.url});

  final String title;
  final String url;
}

enum AlertType {
  /// Fermé, démoli ou déménagé.
  closed,

  /// Information douteuse à contrôler sur place.
  verify,

  /// Changement utile (nouvelle station de métro…).
  info;

  static AlertType parse(String raw) => switch (raw) {
    'ferme' => AlertType.closed,
    'info' => AlertType.info,
    _ => AlertType.verify,
  };

  String get code => switch (this) {
    AlertType.closed => 'ferme',
    AlertType.verify => 'verifier',
    AlertType.info => 'info',
  };
}

/// Signalement posé par la mise à jour mensuelle sur un lieu existant.
class PlaceAlert {
  const PlaceAlert({required this.type, required this.text, required this.date, this.source});

  final AlertType type;
  final String text;
  final DateTime date;
  final SourceLink? source;
}

/// Un marché de gros ou une boutique du catalogue. Lecture seule :
/// ce que l'utilisateur ajoute (statut, note) vit dans [PlaceState].
class Place {
  const Place({
    required this.id,
    required this.zh,
    required this.name,
    required this.region,
    required this.area,
    required this.categoryIds,
    required this.amapQuery,
    required this.address,
    required this.access,
    required this.hours,
    required this.sells,
    required this.moq,
    required this.location,
    this.alt,
    this.cityName,
    this.zoneId,
    this.addressZh,
    this.tips = const [],
    this.sources = const [],
    this.approxNote,
    this.added,
    this.metro,
    this.buses = const [],
    this.alert,
  });

  /// Identifiant stable : les notes de l'utilisateur y sont rattachées.
  final String id;

  /// Nom chinois de l'enseigne, à montrer au chauffeur.
  final String zh;
  final String name;
  final String? alt;
  final Region region;

  /// Ville hors Guangzhou (« Shenzhen », « Yiwu, Zhejiang »…).
  final String? cityName;

  /// Quartier de Guangzhou, s'il y en a un.
  final String? zoneId;
  final String area;
  final List<String> categoryIds;
  final String amapQuery;
  final String address;
  final String? addressZh;
  final String access;
  final String hours;
  final String sells;
  final String moq;
  final List<String> tips;
  final List<SourceLink> sources;

  /// Position en WGS-84.
  final GeoPoint location;

  /// Présent si la position est approximative : dit sur quoi le repère est posé.
  final String? approxNote;

  /// Date d'ajout au catalogue.
  final DateTime? added;
  final TransitStop? metro;
  final List<TransitStop> buses;
  final PlaceAlert? alert;

  bool get isApprox => approxNote != null && approxNote!.isNotEmpty;

  /// Durée pendant laquelle un lieu ajouté porte le badge « Nouveau ».
  static const newWindow = Duration(days: 45);

  bool isNew(DateTime now) => added != null && now.difference(added!) < newWindow;
}

/// Ce que l'utilisateur décide pour un lieu.
enum PlaceStatus { undecided, toVisit, visited }

/// Données personnelles attachées à un lieu. Jamais touchées par une mise à
/// jour du catalogue, et conservées même si le lieu en sort.
class PlaceState {
  const PlaceState({required this.placeId, this.status = PlaceStatus.undecided, this.favorite = false, this.note = ''});

  final String placeId;
  final PlaceStatus status;
  final bool favorite;
  final String note;
}
