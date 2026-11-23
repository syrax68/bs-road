import 'package:bs_road/core/geo/geo.dart';
import 'package:bs_road/core/location/origin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const hotel = GeoPoint(23.13, 113.26);
  const pinned = GeoPoint(23.15, 113.25);
  const fix = GeoPoint(23.14, 113.27);

  group('resolveOrigin', () {
    test('rien de connu : pas de point de départ', () {
      expect(resolveOrigin(const OriginSettings(), null), isNull);
    });

    test('GPS préféré et disponible', () {
      final o = resolveOrigin(const OriginSettings(hotel: hotel), fix);
      expect(o?.source, OriginSource.gps);
      expect(o?.point, fix);
      expect(o?.label, 'ma position');
    });

    test('GPS préféré mais sans signal : point posé, puis hôtel', () {
      expect(resolveOrigin(const OriginSettings(hotel: hotel, pinned: pinned), null)?.source, OriginSource.pinned);
      expect(resolveOrigin(const OriginSettings(hotel: hotel), null)?.source, OriginSource.hotel);
    });

    test('hôtel préféré : le GPS ne passe pas devant', () {
      final o = resolveOrigin(const OriginSettings(preferred: OriginSource.hotel, hotel: hotel), fix);
      expect(o?.source, OriginSource.hotel);
      expect(o?.label, 'mon hôtel');
    });

    test('hôtel préféré mais pas posé : repli sur le GPS', () {
      expect(resolveOrigin(const OriginSettings(preferred: OriginSource.hotel), fix)?.source, OriginSource.gps);
    });
  });

  group('OriginSettings JSON', () {
    test('aller-retour', () {
      const s = OriginSettings(preferred: OriginSource.pinned, hotel: hotel, pinned: pinned);
      expect(OriginSettings.fromJson(s.toJson()), s);
    });

    test('valeur abîmée : réglages par défaut, sans exception', () {
      expect(OriginSettings.fromJson('n’importe quoi'), const OriginSettings());
      expect(
        OriginSettings.fromJson(const {
          'preferred': 'lune',
          'hotel': [200, 3],
          'pinned': ['a', 'b'],
        }),
        const OriginSettings(),
      );
    });
  });
}
