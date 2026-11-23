import 'dart:math' as math;

import 'package:meta/meta.dart';

/// Un point en WGS-84, le système du GPS et d'OpenStreetMap.
///
/// Toute l'app stocke et calcule en WGS-84. La conversion vers le GCJ-02
/// (système imposé aux cartes chinoises, dont Amap) se fait uniquement au
/// moment de construire un lien Amap : voir [toGcj02].
@immutable
class GeoPoint {
  const GeoPoint(this.lat, this.lng);

  final double lat;
  final double lng;

  @override
  bool operator ==(Object other) => other is GeoPoint && other.lat == lat && other.lng == lng;

  @override
  int get hashCode => Object.hash(lat, lng);

  @override
  String toString() => 'GeoPoint($lat, $lng)';
}

const double _earthRadiusM = 6371000;

/// Distance à vol d'oiseau en mètres (formule de haversine).
double distanceMeters(GeoPoint a, GeoPoint b) {
  final p1 = a.lat * math.pi / 180;
  final p2 = b.lat * math.pi / 180;
  final dp = p2 - p1;
  final dl = (b.lng - a.lng) * math.pi / 180;
  final h = math.pow(math.sin(dp / 2), 2) + math.cos(p1) * math.cos(p2) * math.pow(math.sin(dl / 2), 2);
  return 2 * _earthRadiusM * math.asin(math.sqrt(h));
}

/// Distance lisible, arrondie comme dans le prototype :
/// « sur place » sous 30 m, par pas de 50 m sous 1 km, puis en km.
String formatDistance(double meters) {
  if (meters < 30) return 'sur place';
  if (meters < 950) {
    final rounded = math.max(50, (meters / 50).round() * 50);
    return '$rounded m';
  }
  if (meters < 20000) {
    return '${(meters / 1000).toStringAsFixed(1).replaceAll('.', ',')} km';
  }
  final km = (meters / 1000).round();
  // Espace fine insécable comme séparateur de milliers, à la française.
  final s = km.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ' ');
  return '$s km';
}

bool _outOfChina(GeoPoint p) => p.lng < 72.004 || p.lng > 137.8347 || p.lat < 0.8293 || p.lat > 55.8271;

/// Convertit un point WGS-84 en GCJ-02.
///
/// Même algorithme que le prototype web (vérifié contre lui par les tests).
/// Hors de Chine, le point est rendu tel quel, comme le font les cartes chinoises.
GeoPoint toGcj02(GeoPoint p) {
  if (_outOfChina(p)) return p;
  const a = 6378245.0;
  const ee = 0.00669342162296594323;
  const pi = math.pi;
  final x = p.lng - 105;
  final y = p.lat - 35;
  var dLat =
      -100 +
      2 * x +
      3 * y +
      0.2 * y * y +
      0.1 * x * y +
      0.2 * math.sqrt(x.abs()) +
      (20 * math.sin(6 * x * pi) + 20 * math.sin(2 * x * pi)) * 2 / 3 +
      (20 * math.sin(y * pi) + 40 * math.sin(y / 3 * pi)) * 2 / 3 +
      (160 * math.sin(y / 12 * pi) + 320 * math.sin(y * pi / 30)) * 2 / 3;
  var dLng =
      300 +
      x +
      2 * y +
      0.1 * x * x +
      0.1 * x * y +
      0.1 * math.sqrt(x.abs()) +
      (20 * math.sin(6 * x * pi) + 20 * math.sin(2 * x * pi)) * 2 / 3 +
      (20 * math.sin(x * pi) + 40 * math.sin(x / 3 * pi)) * 2 / 3 +
      (150 * math.sin(x / 12 * pi) + 300 * math.sin(x / 30 * pi)) * 2 / 3;
  final rad = p.lat / 180 * pi;
  var magic = math.sin(rad);
  magic = 1 - ee * magic * magic;
  final sqrtMagic = math.sqrt(magic);
  dLat = dLat * 180 / (a * (1 - ee) / (magic * sqrtMagic) * pi);
  dLng = dLng * 180 / (a / sqrtMagic * math.cos(rad) * pi);
  return GeoPoint(p.lat + dLat, p.lng + dLng);
}
