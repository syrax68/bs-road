import 'package:bs_road/app/providers.dart';
import 'package:bs_road/core/catalog/place.dart';
import 'package:bs_road/data/places/places_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderFamily;

// Catalogue et données personnelles des lieux, partagés par toutes les
// fonctionnalités (liste, carte, boutiques). Les filtres de la liste restent
// dans features/places.

final placesRepositoryProvider = Provider<PlacesRepository>((ref) => PlacesRepository(ref.watch(databaseProvider)));

final placeStatesRepositoryProvider = Provider<PlaceStatesRepository>(
  (ref) => PlaceStatesRepository(ref.watch(databaseProvider)),
);

final placesProvider = StreamProvider<List<Place>>((ref) => ref.watch(placesRepositoryProvider).watchPlaces());

final categoriesProvider = StreamProvider<List<Category>>(
  (ref) => ref.watch(placesRepositoryProvider).watchCategories(),
);

final zonesProvider = StreamProvider<List<Zone>>((ref) => ref.watch(placesRepositoryProvider).watchZones());

final placeStatesProvider = StreamProvider<Map<String, PlaceState>>(
  (ref) => ref.watch(placeStatesRepositoryProvider).watchAll(),
);

/// Un lieu par son identifiant (null s'il n'est plus au catalogue).
final ProviderFamily<AsyncValue<Place?>, String> placeByIdProvider = Provider.family<AsyncValue<Place?>, String>(
  (ref, id) => ref.watch(placesProvider).whenData((list) => list.firstWhereOrNull((p) => p.id == id)),
);

final ProviderFamily<PlaceState, String> placeStateProvider = Provider.family<PlaceState, String>(
  (ref, id) => ref.watch(placeStatesProvider).value?[id] ?? PlaceState(placeId: id),
);

final categoryLabelsProvider = Provider<Map<String, String>>(
  (ref) => {for (final c in ref.watch(categoriesProvider).value ?? const <Category>[]) c.id: c.label},
);
