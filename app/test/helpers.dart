import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bs_road/core/geo/geo.dart';
import 'package:bs_road/core/location/location_service.dart';
import 'package:bs_road/data/catalog/catalog_bootstrap.dart';
import 'package:bs_road/data/db/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show SizedBox;
import 'package:flutter_test/flutter_test.dart';

/// Base SQLite en mémoire, neuve pour chaque test.
AppDatabase memoryDatabase() => AppDatabase(
  DatabaseConnection(
    NativeDatabase.memory(),
    // Évite les minuteries en attente à la fin des tests de widgets.
    closeStreamsSynchronously: true,
  ),
);

/// Le catalogue réellement embarqué dans l'app (assets/catalog/).
List<int> bundledCatalogBytes() => File(bundledCatalogAsset).readAsBytesSync();

/// Un paquet catalogue construit à la main, pour les cas limites.
List<int> gzipJson(Object json) => gzip.encode(utf8.encode(jsonEncode(json)));

Map<String, Object?> minimalBundle({
  int version = 202601010000,
  int schemaVersion = 1,
  List<Map<String, Object?>>? places,
  List<Map<String, Object?>> alerts = const [],
}) => {
  'schemaVersion': schemaVersion,
  'version': version,
  'publishedAt': '2026-01-01T00:00:00Z',
  'categories': [
    {'id': 'sacs', 'label': 'Sacs'},
    {'id': 'moto', 'label': 'Pièces moto'},
  ],
  'zones': [
    {'id': 'gare', 'letter': 'A', 'name': 'Gare de Guangzhou', 'access': 'Métro L2'},
  ],
  'places': places ?? [minimalPlace('alpha'), minimalPlace('beta', zh: '乙市场')],
  'alerts': alerts,
};

Map<String, Object?> minimalPlace(String id, {String zh = '甲市场', String zone = 'gare'}) => {
  'id': id,
  'zh': zh,
  'name': 'Marché $id',
  'city': 'gz',
  'zone': zone,
  'area': 'Yuexiu, Guangzhou',
  'categories': ['sacs'],
  'amapQuery': '广州 $zh',
  'address': '1 rue $id',
  'access': 'Métro L2',
  'hours': '9h à 18h',
  'sells': 'Des sacs.',
  'moq': 'Non trouvé.',
  'tips': ['Venir tôt.'],
  'sources': [
    {'title': 'Guide', 'url': 'https://example.org/$id'},
  ],
  'lat': 23.15,
  'lng': 113.26,
};

/// AssetBundle de test qui lit les fichiers du dossier de l'app.
class FileAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    // Lecture synchrone : une vraie entrée-sortie asynchrone ne se termine
    // pas dans l'horloge simulée des tests de widgets.
    final bytes = File(key).readAsBytesSync();
    return ByteData.sublistView(Uint8List.fromList(bytes));
  }
}

/// Laisse la base et les flux finir leur travail, image par image.
/// (pumpAndSettle seul attendrait sans fin derrière un indicateur de chargement.)
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 5)));
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// Démonte l'app avant la fermeture de la base : les flux de requêtes se
/// referment proprement au lieu de rester suspendus dans l'horloge simulée.
Future<void> finish(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await settle(tester);
}

/// GPS factice : autorisation et positions pilotées par le test.
class FakeLocationService implements LocationService {
  FakeLocationService({this.status = LocationAvailability.unknown, this.afterRequest = LocationAvailability.granted});

  LocationAvailability status;

  /// Ce que répond la fenêtre d'autorisation.
  LocationAvailability afterRequest;
  final _positions = StreamController<GeoPoint>.broadcast();
  GeoPoint? last;
  int requests = 0;

  void emit(GeoPoint p) {
    last = p;
    _positions.add(p);
  }

  @override
  Future<LocationAvailability> availability() async => status;

  @override
  Future<LocationAvailability> request() async {
    requests++;
    return status = afterRequest;
  }

  @override
  Stream<GeoPoint> positions() async* {
    if (last != null) yield last!;
    yield* _positions.stream;
  }
}

/// Dossiers de cartes jetables, pour ne pas toucher au vrai stockage.
({Directory work, Directory downloaded}) tempMapDirectories() {
  final root = Directory.systemTemp.createTempSync('bs_road_maps_');
  addTearDown(() => root.deleteSync(recursive: true));
  return (work: Directory('${root.path}/embedded'), downloaded: Directory('${root.path}/packs'));
}
