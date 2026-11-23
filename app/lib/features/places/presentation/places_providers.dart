import 'package:bs_road/app/providers.dart';
import 'package:bs_road/features/places/data/places_repository.dart';
import 'package:bs_road/features/places/domain/place.dart';
import 'package:bs_road/features/places/domain/place_filter.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderFamily;

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

/// Critères de la liste, gardés le temps de la session.
class PlaceFilterController extends Notifier<PlaceFilter> {
  @override
  PlaceFilter build() => const PlaceFilter();

  void setQuery(String query) => state = state.copyWith(query: query);

  void setCategory(String? id) => state = state.copyWith(categoryId: () => id);

  void setRegion(RegionFilter region) => state = state.copyWith(region: region);

  void setOnlyToVisit({required bool value}) => state = state.copyWith(onlyToVisit: value);

  void reset() => state = const PlaceFilter();
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
  });

  final List<PlaceSection> sections;
  final int total;
  final int shown;
  final List<Category> categories;
  final Map<String, PlaceState> states;
}

final placeListViewProvider = Provider<AsyncValue<PlaceListView>>((ref) {
  final places = ref.watch(placesProvider);
  final zones = ref.watch(zonesProvider);
  final categories = ref.watch(categoriesProvider);
  final states = ref.watch(placeStatesProvider);
  final filter = ref.watch(placeFilterProvider);

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
  return AsyncValue.data(
    PlaceListView(sections: groupPlaces(visible, z), total: p.length, shown: visible.length, categories: c, states: s),
  );
});

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
