import 'dart:math' as math;
import 'dart:typed_data';

import 'package:bs_road/core/map/offline_map.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as fvt;
import 'package:flutter_test/flutter_test.dart';

/// Paquet factice : répond une tuile marquée de son nom, ou « absente ».
class _FakeProvider extends fvt.VectorTileProvider {
  _FakeProvider(this.name, {this.empty = false});

  final String name;
  final bool empty;
  final asked = <fvt.TileKey>[];

  @override
  int get minimumZoom => 0;
  @override
  int get maximumZoom => 15;
  @override
  String get cacheKey => name;

  @override
  Future<fvt.TileResponse> load(fvt.TileKey tile, {fvt.CancellationToken? cancellation}) async {
    asked.add(tile);
    return empty ? const fvt.TileResponseNotFound() : fvt.TileResponseData(Uint8List.fromList(name.codeUnits));
  }
}

const _china = PackBounds(west: 97, south: 18, east: 123, north: 42);
const _guangzhou = PackBounds(west: 113.19, south: 23.07, east: 113.40, north: 23.19);

/// Tuile qui contient le point, au zoom donné (formule Web Mercator).
fvt.TileKey _tileAt(double lat, double lng, int z) {
  final n = 1 << z;
  final r = lat * math.pi / 180;
  final x = ((lng + 180) / 360 * n).floor();
  final y = ((1 - math.log(math.tan(r) + 1 / math.cos(r)) / math.pi) / 2 * n).floor();
  final key = fvt.TileKey(z, x, y);
  final b = PackBounds.ofTile(z, x, y);
  assert(lng >= b.west && lng < b.east && lat <= b.north && lat > b.south, 'ofTile et _tileAt divergent');
  return key;
}

void main() {
  test('emprise d’une tuile', () {
    final world = PackBounds.ofTile(0, 0, 0);
    expect(world.west, -180);
    expect(world.east, 180);
    expect(world.north, closeTo(85.0511, 1e-3));
    final ne = PackBounds.ofTile(1, 1, 0);
    expect(ne.west, 0);
    expect(ne.south, closeTo(0, 1e-9));
  });

  group('PackTileProvider', () {
    late _FakeProvider chine;
    late _FakeProvider gz;
    late PackTileProvider packs;

    setUp(() {
      chine = _FakeProvider('chine');
      gz = _FakeProvider('guangzhou');
      packs = PackTileProvider([
        MapPackSource(id: 'chine', provider: chine, bounds: _china, minZoom: 0, maxZoom: 7),
        MapPackSource(id: 'guangzhou', provider: gz, bounds: _guangzhou, minZoom: 8, maxZoom: 15),
      ]);
    });

    test('zooms de l’ensemble', () {
      expect(packs.minimumZoom, 0);
      expect(packs.maximumZoom, 15);
      expect(packs.cacheBytesToDisk, isFalse);
    });

    test('petite échelle : le paquet Chine répond', () async {
      final r = await packs.load(_tileAt(23.13, 113.26, 6));
      expect(String.fromCharCodes((r as fvt.TileResponseData).bytes), 'chine');
      expect(gz.asked, isEmpty);
    });

    test('à Guangzhou en détail : le paquet de la ville répond', () async {
      final r = await packs.load(_tileAt(23.13, 113.26, 14));
      expect(String.fromCharCodes((r as fvt.TileResponseData).bytes), 'guangzhou');
      expect(chine.asked, isEmpty);
    });

    test('hors de tout paquet : tuile absente, aucun fichier lu', () async {
      final r = await packs.load(_tileAt(48.85, 2.35, 12));
      expect(r, isA<fvt.TileResponseNotFound>());
      expect(chine.asked, isEmpty);
      expect(gz.asked, isEmpty);
    });

    test('un paquet sans la tuile laisse répondre le suivant', () async {
      final empty = _FakeProvider('vide', empty: true);
      final fallback = _FakeProvider('large');
      final p = PackTileProvider([
        MapPackSource(id: 'vide', provider: empty, bounds: _guangzhou, minZoom: 8, maxZoom: 15),
        MapPackSource(id: 'large', provider: fallback, bounds: _china, minZoom: 8, maxZoom: 12),
      ]);
      final r = await p.load(_tileAt(23.13, 113.26, 10));
      expect(String.fromCharCodes((r as fvt.TileResponseData).bytes), 'large');
      expect(empty.asked, hasLength(1));
    });
  });
}
