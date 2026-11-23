import 'package:bs_road/data/catalog/catalog_bundle.dart';
import 'package:bs_road/features/places/domain/place.dart';
import 'package:bs_road/features/places/domain/place_filter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers.dart';

void main() {
  final bundle = CatalogBundle.fromGzip(bundledCatalogBytes());
  final labels = {for (final c in bundle.categories) c.id: c.label};
  List<Place> run(PlaceFilter f, {Map<String, PlaceState> states = const {}}) =>
      filterPlaces(bundle.places, f, states: states, categoryLabels: labels);

  test('sans filtre, tout est visible', () {
    expect(run(const PlaceFilter()), hasLength(43));
  });

  test('par catégorie', () {
    final moto = run(const PlaceFilter(categoryId: 'moto'));
    expect(moto.map((p) => p.id), unorderedEquals(['motobaiyun', 'xianyunhui', 'jinshazhoumoto']));
  });

  test('par région', () {
    expect(run(const PlaceFilter(region: RegionFilter.shenzhen)).every((p) => p.region == Region.shenzhen), isTrue);
    final ailleurs = run(const PlaceFilter(region: RegionFilter.elsewhere));
    expect(ailleurs.map((p) => p.id), containsAll(['yiwu', 'humen', 'baigou']));
    expect(ailleurs.any((p) => p.region == Region.guangzhou), isFalse);
  });

  test('recherche sans accents ni majuscules, sur le libellé de catégorie', () {
    expect(run(const PlaceFilter(query: 'PIECES moto')), hasLength(3));
    expect(run(const PlaceFilter(query: 'électronique')).isNotEmpty, isTrue);
    final sansAccent = run(const PlaceFilter(query: 'electronique'));
    final avecAccent = run(const PlaceFilter(query: 'Électronique'));
    expect(sansAccent.length, avecAccent.length);
  });

  test('recherche en chinois', () {
    expect(run(const PlaceFilter(query: '摩配')).map((p) => p.id), contains('motobaiyun'));
  });

  test('« à visiter seulement »', () {
    final states = {'buynow': const PlaceState(placeId: 'buynow', status: PlaceStatus.toVisit)};
    expect(run(const PlaceFilter(onlyToVisit: true), states: states).map((p) => p.id), ['buynow']);
  });

  test('regroupe Guangzhou par quartier, puis Shenzhen, les environs, le reste', () {
    final sections = groupPlaces(bundle.places, bundle.zones);
    final keys = sections.map((s) => s.key).toList();
    expect(keys.first, 'zone:gare');
    expect(keys, containsAllInOrder(['zone:gare', 'zone:zengcha', 'shenzhen', 'near', 'far']));
    final k = sections.firstWhere((s) => s.key == 'zone:zengcha');
    expect(k.letter, 'K');
    expect(k.places, hasLength(3));
    expect(sections.expand((s) => s.places), hasLength(43));
  });

  test('un lieu de Guangzhou sans quartier connu a sa propre section', () {
    final loose = CatalogBundle.fromJson(minimalBundle(places: [minimalPlace('x', zone: 'inconnu')]));
    final sections = groupPlaces(loose.places, loose.zones);
    expect(sections.single.key, 'gz:other');
  });

  test('badge Nouveau pendant 45 jours', () {
    final moto = bundle.places.firstWhere((p) => p.id == 'motobaiyun');
    expect(moto.isNew(DateTime(2026, 12, 2)), isTrue);
    expect(moto.isNew(DateTime(2027, 2, 2)), isFalse);
  });
}
