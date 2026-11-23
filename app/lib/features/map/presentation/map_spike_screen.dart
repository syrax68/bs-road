// Essai de la phase 0 : comparer deux façons d'afficher la carte hors ligne
// sur un vrai téléphone, puis garder la meilleure (voir docs/adr/0001-carte.md).
// Cet écran disparaîtra quand la carte définitive arrivera en phase 2.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bs_road/core/catalog/place.dart';
import 'package:bs_road/features/places/presentation/places_providers.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as fvt;
import 'package:flutter_map_vector_tiles_mbtiles/flutter_map_vector_tiles_mbtiles.dart' as fvtm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart' as vmt;
import 'package:vector_map_tiles_pmtiles/vector_map_tiles_pmtiles.dart' as vmtp;

/// Les deux candidats comparés.
enum MapReader {
  /// Fichier PMTiles lu par vector_map_tiles (encore en bêta).
  pmtiles('PMTiles · vector_map_tiles', 'assets/maps/guangzhou.pmtiles'),

  /// Fichier MBTiles lu par flutter_map_vector_tiles (stable).
  mbtiles('MBTiles · flutter_map_vector_tiles', 'assets/maps/guangzhou.mbtiles');

  MapReader(this.label, this.asset);

  final String label;
  final String asset;
}

/// Copie un fichier embarqué vers le stockage de l'app : les deux lecteurs
/// ouvrent un vrai fichier, pas un asset. Renvoie null si le fichier n'a pas
/// été généré (tools/extract_maps.py --app-assets).
Future<File?> assetToFile(String asset) async {
  final ByteData data;
  try {
    data = await rootBundle.load(asset);
  } on Object {
    return null;
  }
  final dir = Directory('${(await getApplicationSupportDirectory()).path}/maps');
  await dir.create(recursive: true);
  final file = File('${dir.path}/${asset.split('/').last}');
  if (!file.existsSync() || file.lengthSync() != data.lengthInBytes) {
    await file.writeAsBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes), flush: true);
  }
  return file;
}

/// Une couche prête à afficher, avec ce qu'il faut libérer ensuite.
class _LoadedLayer {
  _LoadedLayer(this.layer, this.openTime, {this.dispose});

  final Widget layer;
  final Duration openTime;
  final VoidCallback? dispose;
}

Future<_LoadedLayer?> _load(MapReader reader, {required bool dark}) async {
  final file = await assetToFile(reader.asset);
  if (file == null) return null;
  final watch = Stopwatch()..start();
  switch (reader) {
    case MapReader.pmtiles:
      final provider = await vmtp.PmTilesVectorTileProvider.fromSource(file.path);
      watch.stop();
      return _LoadedLayer(
        vmt.VectorTileLayer(
          theme: dark ? vmtp.ProtomapsThemes.darkV4() : vmtp.ProtomapsThemes.lightV4(),
          tileProviders: vmt.TileProviders({'protomaps': provider}),
          // Pas de cache disque : on mesure la lecture du fichier, pas le cache.
          fileCacheTtl: Duration.zero,
        ),
        watch.elapsed,
      );
    case MapReader.mbtiles:
      final provider = await fvtm.MbTilesVectorTileProvider.open(file.path);
      final style = jsonDecode(
        await rootBundle.loadString('assets/map_styles/protomaps-${dark ? 'dark' : 'light'}.json'),
      ) as Map<String, Object?>;
      watch.stop();
      return _LoadedLayer(
        fvt.VectorTileLayer(
          theme: const fvt.ThemeReader().read(style),
          tileProviders: fvt.TileProviders({'protomaps': provider}),
          diskCacheMaximumSizeInBytes: 0,
        ),
        watch.elapsed,
        dispose: provider.dispose,
      );
  }
}

class MapSpikeScreen extends ConsumerStatefulWidget {
  const MapSpikeScreen({super.key});

  @override
  ConsumerState<MapSpikeScreen> createState() => _MapSpikeScreenState();
}

class _MapSpikeScreenState extends ConsumerState<MapSpikeScreen> {
  MapReader _reader = MapReader.pmtiles;
  Future<_LoadedLayer?>? _layer;
  _LoadedLayer? _current;
  final _frames = <FrameTiming>[];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _layer ??= _open(_reader);
  }

  Future<_LoadedLayer?> _open(MapReader reader) {
    _current?.dispose?.call();
    _current = null;
    _frames.clear();
    final dark = Theme.of(context).brightness == Brightness.dark;
    return _load(reader, dark: dark).then((l) => _current = l);
  }

  void _onTimings(List<FrameTiming> timings) {
    if (!mounted) return;
    setState(() {
      _frames.addAll(timings);
      if (_frames.length > 240) _frames.removeRange(0, _frames.length - 240);
    });
  }

  @override
  void dispose() {
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    _current?.dispose?.call();
    super.dispose();
  }

  String _frameStats() {
    if (_frames.isEmpty) return 'Bouge la carte pour mesurer.';
    final ms = _frames.map((f) => f.totalSpan.inMicroseconds / 1000).toList()..sort();
    final mean = ms.reduce((a, b) => a + b) / ms.length;
    final p90 = ms[(ms.length * 0.9).floor().clamp(0, ms.length - 1)];
    final slow = ms.where((m) => m > 16.7).length;
    return '${ms.length} images · moyenne ${mean.toStringAsFixed(1)} ms · 90 % sous '
        '${p90.toStringAsFixed(1)} ms · ${(100 * slow / ms.length).round()} % au-delà de 16,7 ms';
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider).value ?? const <Place>[];
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Essai carte (phase 0)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: SegmentedButton<MapReader>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: MapReader.pmtiles, label: Text('PMTiles')),
                ButtonSegment(value: MapReader.mbtiles, label: Text('MBTiles')),
              ],
              selected: {_reader},
              onSelectionChanged: (s) => setState(() {
                _reader = s.first;
                _layer = _open(_reader);
              }),
            ),
          ),
          Expanded(
            child: FutureBuilder<_LoadedLayer?>(
              future: _layer,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Échec : ${snap.error}', textAlign: TextAlign.center));
                }
                final loaded = snap.data;
                if (loaded == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Carte absente de cette version de l’app.\n'
                        'Lance « python3 tools/extract_maps.py --mbtiles --app-assets » puis reconstruis l’app.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return FlutterMap(
                  key: ValueKey(_reader),
                  options: const MapOptions(
                    initialCenter: LatLng(23.135, 113.28),
                    initialZoom: 13,
                    minZoom: 8,
                    maxZoom: 18,
                  ),
                  children: [
                    loaded.layer,
                    MarkerLayer(
                      markers: [
                        for (final p in places.where((p) => p.region == Region.guangzhou))
                          Marker(
                            point: LatLng(p.location.lat, p.location.lng),
                            width: 18,
                            height: 18,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: p.isApprox ? scheme.surface : scheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: scheme.primary, width: 3),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SimpleAttributionWidget(source: Text('OpenStreetMap · Protomaps')),
                  ],
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            color: scheme.surfaceContainerLow,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: SafeArea(
              top: false,
              child: Text(
                '${_reader.label}\n'
                'Ouverture du fichier : ${_current == null ? '…' : '${_current!.openTime.inMilliseconds} ms'}\n'
                '${_frameStats()}',
                style: const TextStyle(fontSize: 12.5, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
