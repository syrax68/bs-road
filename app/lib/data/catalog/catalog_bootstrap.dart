import 'package:bs_road/data/catalog/catalog_bundle.dart';
import 'package:bs_road/data/catalog/catalog_importer.dart';
import 'package:flutter/services.dart' show AssetBundle;

/// Chemin du catalogue embarqué dans l'app (voir pubspec.yaml).
const bundledCatalogAsset = 'assets/catalog/catalog.json.gz';

/// État du catalogue après le démarrage.
class CatalogStatus {
  const CatalogStatus({required this.version, required this.outcome});

  final int version;
  final ImportOutcome outcome;
}

/// Au démarrage, installe le catalogue embarqué s'il est plus récent que
/// celui de la base (premier lancement, ou app mise à jour). Ne demande
/// aucun réseau.
class CatalogBootstrap {
  CatalogBootstrap(this._importer, this._assets);

  final CatalogImporter _importer;
  final AssetBundle _assets;

  Future<CatalogStatus> ensureInstalled() async {
    final data = await _assets.load(bundledCatalogAsset);
    final bundle = CatalogBundle.fromGzip(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    final outcome = await _importer.import(bundle);
    final version = await _importer.installedVersion() ?? bundle.version;
    return CatalogStatus(version: version, outcome: outcome);
  }
}
