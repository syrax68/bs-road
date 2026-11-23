import 'dart:io';

import 'package:bs_road/app/providers.dart';
import 'package:bs_road/core/map/offline_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// Dossiers où vivent les cartes : copies des paquets embarqués et paquets
/// téléchargés. Remplacé dans les tests.
final mapDirectoriesProvider = FutureProvider<({Directory work, Directory downloaded})>((ref) async {
  final support = await getApplicationSupportDirectory();
  return (work: Directory('${support.path}/maps/embedded'), downloaded: Directory('${support.path}/maps/packs'));
});

/// Carte hors ligne ouverte une fois pour toute l'app ; null si l'app a été
/// construite sans cartes. Invalidée après le téléchargement d'un paquet.
final offlineMapProvider = FutureProvider<OfflineMap?>((ref) async {
  final dirs = await ref.watch(mapDirectoriesProvider.future);
  final map = await openOfflineMap(
    bundle: ref.watch(assetBundleProvider),
    workDir: dirs.work,
    downloadedDir: dirs.downloaded,
  );
  ref.onDispose(() => map?.dispose());
  return map;
});
