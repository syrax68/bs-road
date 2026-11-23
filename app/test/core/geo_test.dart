import 'package:bs_road/core/geo/amap_links.dart';
import 'package:bs_road/core/geo/geo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('toGcj02', () {
    // Valeurs de référence calculées par la fonction gcj() du prototype web,
    // dont les liens Amap ont été vérifiés : l'app doit donner exactement
    // les mêmes coordonnées.
    const cases = [
      ('Tiananmen', GeoPoint(39.90734, 116.39089), GeoPoint(39.9087410694, 116.3971309424)),
      ('Xin Baiyun Mopei', GeoPoint(23.16094, 113.21806), GeoPoint(23.1582903682, 113.2234025994)),
      ('Shenzhen', GeoPoint(22.5431, 114.0579), GeoPoint(22.5403828142, 114.0630139986)),
    ];
    for (final (name, wgs, expected) in cases) {
      test(name, () {
        final g = toGcj02(wgs);
        expect(g.lat, closeTo(expected.lat, 1e-9));
        expect(g.lng, closeTo(expected.lng, 1e-9));
      });
    }

    test('le décalage à Guangzhou est de quelques centaines de mètres', () {
      const p = GeoPoint(23.13, 113.26);
      final d = distanceMeters(p, toGcj02(p));
      expect(d, inInclusiveRange(200, 800));
    });

    test('hors de Chine, le point ne bouge pas', () {
      const antananarivo = GeoPoint(-18.8792, 47.5079);
      expect(toGcj02(antananarivo), antananarivo);
    });
  });

  group('distanceMeters', () {
    test('un degré de latitude fait environ 111 km', () {
      expect(distanceMeters(const GeoPoint(0, 0), const GeoPoint(1, 0)), closeTo(111195, 1));
    });

    test('distance nulle sur place', () {
      const p = GeoPoint(23.1, 113.2);
      expect(distanceMeters(p, p), 0);
    });
  });

  group('formatDistance', () {
    test('arrondis du prototype', () {
      expect(formatDistance(10), 'sur place');
      expect(formatDistance(31), '50 m');
      expect(formatDistance(274), '250 m');
      expect(formatDistance(949), '950 m');
      expect(formatDistance(1234), '1,2 km');
      expect(formatDistance(19940), '19,9 km');
      expect(formatDistance(1234567), '1 235 km');
    });
  });

  group('AmapLinks', () {
    test('itinéraire en transports avec coordonnées GCJ-02', () {
      final uri = AmapLinks.transitRoute(to: const GeoPoint(23.16094, 113.21806), toName: '新白云摩配市场');
      expect(uri.host, 'uri.amap.com');
      expect(uri.path, '/navigation');
      expect(uri.queryParameters['to'], '113.223403,23.158290,新白云摩配市场');
      expect(uri.queryParameters['mode'], 'bus');
      expect(uri.queryParameters['callnative'], '1');
      expect(uri.queryParameters.containsKey('from'), isFalse);
    });

    test('point de départ facultatif', () {
      final uri = AmapLinks.transitRoute(
        to: const GeoPoint(23.16094, 113.21806),
        toName: 'X',
        from: const GeoPoint(23.13, 113.26),
        fromName: 'Mon hôtel',
      );
      expect(uri.queryParameters['from'], endsWith(',Mon hôtel'));
    });

    test('recherche par mots-clés chinois', () {
      final uri = AmapLinks.search('广州 西岸云汇摩配');
      expect(uri.queryParameters['keyword'], '广州 西岸云汇摩配');
    });
  });
}
