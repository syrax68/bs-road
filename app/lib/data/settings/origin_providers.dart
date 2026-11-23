import 'dart:async';

import 'package:bs_road/app/providers.dart';
import 'package:bs_road/core/geo/geo.dart';
import 'package:bs_road/core/location/location_service.dart';
import 'package:bs_road/core/location/origin.dart';
import 'package:bs_road/data/settings/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

/// GPS du téléphone. Remplacé par une version factice dans les tests.
final locationServiceProvider = Provider<LocationService>((ref) => const DeviceLocationService());

const originSettingsKey = 'origin';

/// Hôtel, point posé et source préférée, tels qu'enregistrés.
final originSettingsProvider = StreamProvider<OriginSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(originSettingsKey).map(OriginSettings.fromJson),
);

/// Modifie les points de départ enregistrés.
class OriginController {
  OriginController(this._ref);

  final Ref _ref;

  Future<OriginSettings> _current() async =>
      OriginSettings.fromJson(await _ref.read(settingsRepositoryProvider).read(originSettingsKey));

  Future<void> _save(OriginSettings s) => _ref.read(settingsRepositoryProvider).write(originSettingsKey, s.toJson());

  Future<void> usePreferred(OriginSource source) async => await _save((await _current()).copyWith(preferred: source));

  Future<void> setHotel(GeoPoint? point) async => await _save(
    (await _current()).copyWith(hotel: () => point, preferred: point == null ? null : OriginSource.hotel),
  );

  Future<void> setPinned(GeoPoint? point) async => await _save(
    (await _current()).copyWith(pinned: () => point, preferred: point == null ? null : OriginSource.pinned),
  );
}

final originControllerProvider = Provider<OriginController>(OriginController.new);

/// Autorisation du GPS. Rien n'est demandé tant que l'utilisateur ne touche
/// pas « Utiliser ma position ».
class GpsAvailabilityController extends AsyncNotifier<LocationAvailability> {
  @override
  Future<LocationAvailability> build() => ref.watch(locationServiceProvider).availability();

  Future<void> request() async {
    state = AsyncData(await ref.read(locationServiceProvider).request());
  }
}

final gpsAvailabilityProvider = AsyncNotifierProvider<GpsAvailabilityController, LocationAvailability>(
  GpsAvailabilityController.new,
);

/// Dernière position GPS, seulement si le GPS est autorisé et choisi comme
/// point de départ. La position n'est jamais enregistrée.
final gpsFixProvider = StreamProvider<GeoPoint?>((ref) {
  final granted = ref.watch(gpsAvailabilityProvider).value == LocationAvailability.granted;
  final wanted = ref.watch(originSettingsProvider).value?.preferred == OriginSource.gps;
  if (!granted || !wanted) return Stream.value(null);
  return ref.watch(locationServiceProvider).positions().map<GeoPoint?>((p) => p);
});

/// Point de départ actuel des distances, ou null si aucun n'est connu.
final originProvider = Provider<Origin?>((ref) {
  final settings = ref.watch(originSettingsProvider).value ?? const OriginSettings();
  return resolveOrigin(settings, ref.watch(gpsFixProvider).value);
});
