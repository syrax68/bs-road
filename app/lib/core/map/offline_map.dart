import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as fvt;
import 'package:flutter_map_vector_tiles_mbtiles/flutter_map_vector_tiles_mbtiles.dart' as fvtm;
import 'package:meta/meta.dart';

/// Emprise d'un paquet de carte, en degrés WGS-84.
@immutable
class PackBounds {
  const PackBounds({required this.west, required this.south, required this.east, required this.north});

  /// Emprise de la tuile z/x/y (schéma XYZ, Web Mercator).
  factory PackBounds.ofTile(int z, int x, int y) {
    final n = 1 << z;
    double lat(int row) => math.atan(_sinh(math.pi * (1 - 2 * row / n))) * 180 / math.pi;
    return PackBounds(west: x / n * 360 - 180, east: (x + 1) / n * 360 - 180, north: lat(y), south: lat(y + 1));
  }

  final double west;
  final double south;
  final double east;
  final double north;

  static const world = PackBounds(west: -180, south: -85.0511, east: 180, north: 85.0511);

  bool intersects(PackBounds o) => west < o.east && o.west < east && south < o.north && o.south < north;

  static double _sinh(double v) => (math.exp(v) - math.exp(-v)) / 2;
}

/// Un paquet de carte prêt à lire : un fichier MBTiles et ce qu'il couvre.
class MapPackSource {
  MapPackSource({
    required this.id,
    required this.provider,
    required this.bounds,
    required this.minZoom,
    required this.maxZoom,
  });

  final String id;
  final fvt.VectorTileProvider provider;
  final PackBounds bounds;
  final int minZoom;
  final int maxZoom;
}

/// Assemble plusieurs paquets (Chine à petite échelle, villes en détail) en
/// une seule source de tuiles : pour chaque tuile demandée, le paquet le plus
/// détaillé qui la couvre répond.
class PackTileProvider extends fvt.VectorTileProvider {
  PackTileProvider(List<MapPackSource> packs)
    : _packs = [...packs]..sort((a, b) => b.maxZoom.compareTo(a.maxZoom)),
      assert(packs.isNotEmpty, 'au moins un paquet');

  final List<MapPackSource> _packs;

  List<String> get packIds => [for (final p in _packs) p.id];

  @override
  int get minimumZoom => _packs.map((p) => p.minZoom).reduce(math.min);

  @override
  int get maximumZoom => _packs.map((p) => p.maxZoom).reduce(math.max);

  @override
  String get cacheKey => 'packs:${_packs.map((p) => p.provider.cacheKey).join('|')}';

  @override
  bool get cacheBytesToDisk => false;

  /// Paquets qui peuvent servir cette tuile, du plus détaillé au moins détaillé.
  @visibleForTesting
  List<MapPackSource> candidates(int z, int x, int y) {
    final tile = PackBounds.ofTile(z, x, y);
    return [
      for (final p in _packs)
        if (z >= p.minZoom && z <= p.maxZoom && p.bounds.intersects(tile)) p,
    ];
  }

  @override
  Future<fvt.TileResponse> load(fvt.TileKey tile, {fvt.CancellationToken? cancellation}) async {
    if (!tile.isValid) return const fvt.TileResponseNotFound();
    fvt.TileResponse last = const fvt.TileResponseNotFound();
    for (final p in candidates(tile.z, tile.x, tile.y)) {
      last = await p.provider.load(tile, cancellation: cancellation);
      if (last is fvt.TileResponseData || last is fvt.TileResponseCancelled) return last;
    }
    return last;
  }

  @override
  void dispose() {
    for (final p in _packs) {
      p.provider.dispose();
    }
  }
}

/// Paquets embarqués dans l'app (tools/extract_maps.py --app-assets).
const embeddedPacks = ['chine', 'guangzhou'];

/// Copie un fichier embarqué vers [dir] : le lecteur MBTiles ouvre un vrai
/// fichier, pas un asset. Renvoie null si le fichier n'a pas été généré.
Future<File?> copyAssetToFile(AssetBundle bundle, String asset, Directory dir) async {
  final ByteData data;
  try {
    data = await bundle.load(asset);
  } on Object {
    return null;
  }
  await dir.create(recursive: true);
  final file = File('${dir.path}/${asset.split('/').last}');
  if (!file.existsSync() || file.lengthSync() != data.lengthInBytes) {
    await file.writeAsBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes), flush: true);
  }
  return file;
}

/// Ouvre un paquet MBTiles. L'emprise et les zooms viennent de ses métadonnées.
Future<MapPackSource?> openPack(String id, File file) async {
  try {
    final provider = await fvtm.MbTilesVectorTileProvider.open(file.path);
    final b = provider.metadata.bounds;
    return MapPackSource(
      id: id,
      provider: provider,
      bounds: b == null ? PackBounds.world : PackBounds(west: b.west, south: b.south, east: b.east, north: b.north),
      minZoom: provider.minimumZoom,
      maxZoom: provider.maximumZoom,
    );
  } on Object {
    return null;
  }
}

/// La carte hors ligne : les tuiles de tous les paquets présents et le style.
class OfflineMap {
  OfflineMap({required this.tiles, required this.lightTheme, required this.darkTheme});

  final PackTileProvider tiles;
  final fvt.Theme lightTheme;
  final fvt.Theme darkTheme;

  /// Nom de la source dans le style Protomaps.
  static const sourceName = 'protomaps';

  void dispose() => tiles.dispose();
}

/// Prépare la carte : copie les paquets embarqués, ajoute ceux téléchargés
/// dans [downloadedDir], et lit les deux styles. Null s'il n'y a aucun paquet.
Future<OfflineMap?> openOfflineMap({
  required AssetBundle bundle,
  required Directory workDir,
  Directory? downloadedDir,
}) async {
  final packs = <MapPackSource>[];
  for (final id in embeddedPacks) {
    final file = await copyAssetToFile(bundle, 'assets/maps/$id.mbtiles', workDir);
    final pack = file == null ? null : await openPack(id, file);
    if (pack != null) packs.add(pack);
  }
  if (downloadedDir != null && downloadedDir.existsSync()) {
    for (final f in downloadedDir.listSync().whereType<File>().where((f) => f.path.endsWith('.mbtiles'))) {
      final id = f.uri.pathSegments.last.replaceAll('.mbtiles', '');
      if (packs.any((p) => p.id == id)) continue;
      final pack = await openPack(id, f);
      if (pack != null) packs.add(pack);
    }
  }
  if (packs.isEmpty) return null;
  Future<fvt.Theme> theme(String name) async {
    final style = jsonDecode(await bundle.loadString('assets/map_styles/protomaps-$name.json')) as Map<String, Object?>;
    return const fvt.ThemeReader().read(style);
  }

  return OfflineMap(tiles: PackTileProvider(packs), lightTheme: await theme('light'), darkTheme: await theme('dark'));
}
