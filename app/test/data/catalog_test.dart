import 'package:bs_road/core/catalog/place.dart';
import 'package:bs_road/data/catalog/catalog_bundle.dart';
import 'package:bs_road/data/catalog/catalog_importer.dart';
import 'package:bs_road/data/db/app_database.dart';
import 'package:bs_road/data/places/places_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  group('CatalogBundle', () {
    test('lit le catalogue embarqué (43 lieux du prototype)', () {
      final b = CatalogBundle.fromGzip(bundledCatalogBytes());
      expect(b.schemaVersion, supportedCatalogSchema);
      expect(b.places, hasLength(43));
      expect(b.categories.map((c) => c.id), contains('moto'));
      expect(b.zones.map((z) => z.letter), containsAllInOrder(['A', 'K']));

      final moto = b.places.firstWhere((p) => p.id == 'motobaiyun');
      expect(moto.zh, '新白云摩配市场');
      expect(moto.zoneId, 'zengcha');
      expect(moto.isApprox, isTrue);
      expect(moto.added, DateTime(2026, 11, 22));
      expect(moto.metro, isNull);
      expect(moto.buses.first.zh, '松北');
      expect(moto.buses.first.lines, contains('B3'));

      final yiwu = b.places.firstWhere((p) => p.id == 'yiwu');
      expect(yiwu.region, Region.far);
      expect(yiwu.zoneId, isNull);
    });

    test('refuse un format plus récent que l’app', () {
      expect(
        () => CatalogBundle.fromGzip(gzipJson(minimalBundle(schemaVersion: 99))),
        throwsA(isA<UnsupportedCatalogException>()),
      );
    });

    test('refuse un fichier corrompu', () {
      expect(() => CatalogBundle.fromGzip([1, 2, 3, 4]), throwsA(isA<CatalogFormatException>()));
    });

    test('dit quel lieu est incomplet', () {
      final broken = minimalPlace('gamma')..remove('zh');
      expect(
        () => CatalogBundle.fromGzip(gzipJson(minimalBundle(places: [broken]))),
        throwsA(isA<CatalogFormatException>().having((e) => e.message, 'message', contains('gamma'))),
      );
    });

    test('rattache les signalements à leur lieu', () {
      final b = CatalogBundle.fromJson(
        minimalBundle(
          alerts: [
            {'place': 'alpha', 'type': 'ferme', 'text': 'Démoli en 2026.', 'date': '2026-03-01'},
          ],
        ),
      );
      expect(b.places.first.alert?.type, AlertType.closed);
      expect(b.places.last.alert, isNull);
    });
  });

  group('CatalogImporter', () {
    late AppDatabase db;
    late CatalogImporter importer;
    late PlacesRepository places;
    late PlaceStatesRepository states;

    setUp(() {
      db = memoryDatabase();
      importer = CatalogImporter(db);
      places = PlacesRepository(db);
      states = PlaceStatesRepository(db);
    });
    tearDown(() => db.close());

    test('installe le catalogue embarqué dans une base vide', () async {
      expect(await importer.installedVersion(), isNull);
      final bundle = CatalogBundle.fromGzip(bundledCatalogBytes());
      expect(await importer.import(bundle), ImportOutcome.imported);
      expect(await importer.installedVersion(), bundle.version);

      final list = await places.watchPlaces().first;
      expect(list, hasLength(43));
      final moto = list.firstWhere((p) => p.id == 'motobaiyun');
      expect(moto.categoryIds, ['moto']);
      expect(moto.tips, hasLength(4));
      expect(moto.buses, hasLength(3));
      expect(moto.sources.first.url, startsWith('https://www.mopei8.com'));
    });

    test('ne réinstalle pas un catalogue aussi ancien', () async {
      await importer.import(CatalogBundle.fromJson(minimalBundle(version: 5)));
      final again = await importer.import(CatalogBundle.fromJson(minimalBundle(version: 5)));
      expect(again, ImportOutcome.upToDate);
      final older = await importer.import(CatalogBundle.fromJson(minimalBundle(version: 4)));
      expect(older, ImportOutcome.upToDate);
    });

    test('une mise à jour remplace le catalogue sans toucher aux notes', () async {
      await importer.import(CatalogBundle.fromJson(minimalBundle(version: 1)));
      await states.setStatus('alpha', PlaceStatus.toVisit);
      await states.setNote('alpha', 'Stand 3B, demander Mme Li');
      await states.setFavorite('beta', favorite: true);

      // Version 2 : beta disparaît, gamma arrive.
      await importer.import(
        CatalogBundle.fromJson(
          minimalBundle(
            version: 2,
            places: [
              minimalPlace('alpha'),
              minimalPlace('gamma', zh: '丙市场'),
            ],
          ),
        ),
      );
      final ids = (await places.watchPlaces().first).map((p) => p.id);
      expect(ids, ['alpha', 'gamma']);

      final s = await states.watchAll().first;
      expect(s['alpha']?.status, PlaceStatus.toVisit);
      expect(s['alpha']?.note, 'Stand 3B, demander Mme Li');
      // La note d'un lieu sorti du catalogue est gardée.
      expect(s['beta']?.favorite, isTrue);
    });

    test('un paquet invalide laisse l’ancien catalogue en place', () async {
      await importer.import(CatalogBundle.fromJson(minimalBundle(version: 1)));
      final dup = minimalBundle(version: 2, places: [minimalPlace('alpha'), minimalPlace('alpha')]);
      await expectLater(importer.import(CatalogBundle.fromJson(dup)), throwsA(anything));
      expect(await importer.installedVersion(), 1);
      expect(await places.watchPlaces().first, hasLength(2));
    });
  });

  group('PlaceStatesRepository', () {
    test('modifier un champ ne remet pas les autres à zéro', () async {
      final db = memoryDatabase();
      addTearDown(db.close);
      final states = PlaceStatesRepository(db);
      await states.setNote('x', 'note');
      await states.setStatus('x', PlaceStatus.visited);
      await states.setFavorite('x', favorite: true);
      final s = (await states.watchAll().first)['x']!;
      expect(s.note, 'note');
      expect(s.status, PlaceStatus.visited);
      expect(s.favorite, isTrue);
    });
  });
}
