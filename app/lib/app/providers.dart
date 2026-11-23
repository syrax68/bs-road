import 'package:bs_road/data/catalog/catalog_bootstrap.dart';
import 'package:bs_road/data/catalog/catalog_importer.dart';
import 'package:bs_road/data/db/app_database.dart';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base locale de l'app. Remplacée par une base en mémoire dans les tests.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
});

/// Fichiers embarqués. Remplaçable dans les tests.
final assetBundleProvider = Provider<AssetBundle>((ref) => rootBundle);

final catalogImporterProvider = Provider<CatalogImporter>((ref) => CatalogImporter(ref.watch(databaseProvider)));

/// Installe le catalogue embarqué au démarrage si besoin. Sans réseau.
final catalogReadyProvider = FutureProvider<CatalogStatus>(
  (ref) => CatalogBootstrap(ref.watch(catalogImporterProvider), ref.watch(assetBundleProvider)).ensureInstalled(),
);
