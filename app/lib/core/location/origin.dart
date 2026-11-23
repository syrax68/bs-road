import 'package:bs_road/core/geo/geo.dart';
import 'package:meta/meta.dart';

/// D'où partent les distances et l'itinéraire Amap.
enum OriginSource {
  /// Position du téléphone, lue en direct et jamais enregistrée.
  gps,

  /// Hôtel posé sur la carte.
  hotel,

  /// Point posé à la main (« je suis ici »).
  pinned,
}

/// Un point de départ connu.
@immutable
class Origin {
  const Origin({required this.source, required this.point, required this.label});

  final OriginSource source;
  final GeoPoint point;

  /// Libellé court, affiché dans « À 1,2 km de … ».
  final String label;

  @override
  bool operator ==(Object other) =>
      other is Origin && other.source == source && other.point == point && other.label == label;

  @override
  int get hashCode => Object.hash(source, point, label);
}

/// Points de départ enregistrés par l'utilisateur et source préférée.
@immutable
class OriginSettings {
  const OriginSettings({this.preferred = OriginSource.gps, this.hotel, this.pinned});

  /// Lecture tolérante : une valeur abîmée ne doit jamais empêcher l'app de démarrer.
  factory OriginSettings.fromJson(Object? json) {
    if (json is! Map) return const OriginSettings();
    GeoPoint? point(Object? v) {
      if (v is! List || v.length != 2) return null;
      final lat = v[0];
      final lng = v[1];
      if (lat is! num || lng is! num) return null;
      if (lat.abs() > 90 || lng.abs() > 180) return null;
      return GeoPoint(lat.toDouble(), lng.toDouble());
    }

    return OriginSettings(
      preferred: OriginSource.values.firstWhere((s) => s.name == json['preferred'], orElse: () => OriginSource.gps),
      hotel: point(json['hotel']),
      pinned: point(json['pinned']),
    );
  }

  /// Source choisie. Si elle n'est pas disponible (GPS refusé, hôtel non
  /// posé), on se rabat sur les autres dans l'ordre du prototype :
  /// point posé, puis hôtel.
  final OriginSource preferred;
  final GeoPoint? hotel;
  final GeoPoint? pinned;

  OriginSettings copyWith({OriginSource? preferred, GeoPoint? Function()? hotel, GeoPoint? Function()? pinned}) =>
      OriginSettings(
        preferred: preferred ?? this.preferred,
        hotel: hotel != null ? hotel() : this.hotel,
        pinned: pinned != null ? pinned() : this.pinned,
      );

  Map<String, Object?> toJson() => {
    'preferred': preferred.name,
    if (hotel != null) 'hotel': [hotel!.lat, hotel!.lng],
    if (pinned != null) 'pinned': [pinned!.lat, pinned!.lng],
  };

  @override
  bool operator ==(Object other) =>
      other is OriginSettings && other.preferred == preferred && other.hotel == hotel && other.pinned == pinned;

  @override
  int get hashCode => Object.hash(preferred, hotel, pinned);
}

const hotelLabel = 'mon hôtel';
const pinnedLabel = 'mon point de départ';
const gpsLabel = 'ma position';

/// Choisit le point de départ à partir des réglages et de la dernière
/// position GPS connue (null si le GPS est refusé ou pas encore fixé).
Origin? resolveOrigin(OriginSettings settings, GeoPoint? gpsFix) {
  Origin? of(OriginSource s) => switch (s) {
    OriginSource.gps => gpsFix == null ? null : Origin(source: s, point: gpsFix, label: gpsLabel),
    OriginSource.hotel => settings.hotel == null ? null : Origin(source: s, point: settings.hotel!, label: hotelLabel),
    OriginSource.pinned =>
      settings.pinned == null ? null : Origin(source: s, point: settings.pinned!, label: pinnedLabel),
  };
  return of(settings.preferred) ?? of(OriginSource.pinned) ?? of(OriginSource.hotel) ?? of(OriginSource.gps);
}
