import 'package:bs_road/core/catalog/place.dart';
import 'package:bs_road/core/location/origin.dart';
import 'package:bs_road/data/places/places_providers.dart';
import 'package:bs_road/data/settings/origin_providers.dart';
import 'package:bs_road/features/places/domain/place_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'package:bs_road/data/places/places_providers.dart';
export 'package:bs_road/data/settings/origin_providers.dart';

/// Critères de la liste, gardés le temps de la session.
class PlaceFilterController extends Notifier<PlaceFilter> {
  @override
  PlaceFilter build() => const PlaceFilter();

  void setQuery(String query) => state = state.copyWith(query: query);

  void setCategory(String? id) => state = state.copyWith(categoryId: () => id);

  void setRegion(RegionFilter region) => state = state.copyWith(region: region);

  void setOnlyToVisit({required bool value}) => state = state.copyWith(onlyToVisit: value);

  void setNearFirst({required bool value}) => state = state.copyWith(nearFirst: value);

  /// Efface les critères de sélection ; garde le tri choisi.
  void reset() => state = PlaceFilter(nearFirst: state.nearFirst);
}

final placeFilterProvider = NotifierProvider<PlaceFilterController, PlaceFilter>(PlaceFilterController.new);

/// La liste telle qu'elle s'affiche : lieux filtrés, regroupés par quartier.
class PlaceListView {
  const PlaceListView({
    required this.sections,
    required this.total,
    required this.shown,
    required this.categories,
    required this.states,
    this.distances = const {},
    this.origin,
  });

  final List<PlaceSection> sections;
  final int total;
  final int shown;
  final List<Category> categories;
  final Map<String, PlaceState> states;

  /// Distance de chaque lieu au point de départ, vide sans point de départ.
  final Map<String, double> distances;
  final Origin? origin;
}

final placeListViewProvider = Provider<AsyncValue<PlaceListView>>((ref) {
  final places = ref.watch(placesProvider);
  final zones = ref.watch(zonesProvider);
  final categories = ref.watch(categoriesProvider);
  final states = ref.watch(placeStatesProvider);
  final filter = ref.watch(placeFilterProvider);
  final origin = ref.watch(originProvider);

  for (final v in <AsyncValue<Object>>[places, zones, categories, states]) {
    if (v.hasError) {
      return AsyncValue.error(v.error!, v.stackTrace ?? StackTrace.current);
    }
  }
  final p = places.value;
  final z = zones.value;
  final c = categories.value;
  final s = states.value;
  if (p == null || z == null || c == null || s == null) {
    return const AsyncValue.loading();
  }
  final labels = {for (final cat in c) cat.id: cat.label};
  final visible = filterPlaces(p, filter, states: s, categoryLabels: labels);
  final distances = origin == null ? const <String, double>{} : distancesFrom(origin.point, p);
  return AsyncValue.data(
    PlaceListView(
      sections: filter.nearFirst && origin != null
          ? nearestFirst(visible, distances, fromLabel: origin.label)
          : groupPlaces(visible, z),
      total: p.length,
      shown: visible.length,
      categories: c,
      states: s,
      distances: distances,
      origin: origin,
    ),
  );
});
