import 'dart:async';

import 'package:bs_road/core/geo/geo.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:geolocator/geolocator.dart';

/// Ce que l'app sait de la position du téléphone.
enum LocationAvailability {
  /// Pas encore demandé.
  unknown,

  /// Autorisé ; une position arrive (ou est déjà là).
  granted,

  /// Refusé par l'utilisateur, ou interdit dans les réglages du téléphone.
  denied,

  /// Localisation coupée dans les réglages du téléphone.
  serviceOff,
}

/// Accès au GPS. Remplacé par une version factice dans les tests.
abstract interface class LocationService {
  /// État actuel, sans rien demander à l'utilisateur.
  Future<LocationAvailability> availability();

  /// Demande l'autorisation si besoin (la fenêtre du système s'affiche une fois).
  Future<LocationAvailability> request();

  /// Positions successives. Ne marche qu'une fois l'autorisation donnée.
  Stream<GeoPoint> positions();
}

/// GPS du téléphone via geolocator.
///
/// Sur Android, on force le LocationManager du système plutôt que le
/// fournisseur des services Google : ceux-ci sont absents ou bloqués en Chine,
/// alors que la puce GPS marche sans réseau.
class DeviceLocationService implements LocationService {
  const DeviceLocationService();

  @override
  Future<LocationAvailability> availability() async {
    if (!await Geolocator.isLocationServiceEnabled()) return LocationAvailability.serviceOff;
    return _map(await Geolocator.checkPermission());
  }

  @override
  Future<LocationAvailability> request() async {
    if (!await Geolocator.isLocationServiceEnabled()) return LocationAvailability.serviceOff;
    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
    return _map(p);
  }

  @override
  Stream<GeoPoint> positions() => Geolocator.getPositionStream(
    locationSettings: switch (defaultTargetPlatform) {
      TargetPlatform.android => AndroidSettings(distanceFilter: 15, forceLocationManager: true),
      TargetPlatform.iOS => AppleSettings(distanceFilter: 15, activityType: ActivityType.otherNavigation),
      _ => const LocationSettings(distanceFilter: 15),
    },
  ).map((p) => GeoPoint(p.latitude, p.longitude));

  static LocationAvailability _map(LocationPermission p) => switch (p) {
    LocationPermission.always || LocationPermission.whileInUse => LocationAvailability.granted,
    LocationPermission.denied => LocationAvailability.unknown,
    LocationPermission.deniedForever || LocationPermission.unableToDetermine => LocationAvailability.denied,
  };
}
