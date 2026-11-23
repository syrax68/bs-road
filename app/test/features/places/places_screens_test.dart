import 'dart:io';

import 'package:bs_road/app/app.dart';
import 'package:bs_road/app/providers.dart';
import 'package:bs_road/core/catalog/place.dart';
import 'package:bs_road/core/geo/geo.dart';
import 'package:bs_road/core/location/origin.dart';
import 'package:bs_road/data/db/app_database.dart';
import 'package:bs_road/data/maps/map_providers.dart';
import 'package:bs_road/data/settings/origin_providers.dart';
import 'package:bs_road/data/settings/settings_repository.dart';
import 'package:bs_road/features/places/presentation/places_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers.dart';

void main() {
  late AppDatabase db;
  late FakeLocationService gps;
  late ({Directory work, Directory downloaded}) maps;

  setUp(() {
    db = memoryDatabase();
    gps = FakeLocationService();
    maps = tempMapDirectories();
  });
  tearDown(() => db.close());

  Future<void> startApp(WidgetTester tester, {bool withMap = false}) async {
    // Écran de téléphone : 390 × 844 points.
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          assetBundleProvider.overrideWithValue(FileAssetBundle()),
          locationServiceProvider.overrideWithValue(gps),
          mapDirectoriesProvider.overrideWith((ref) async => maps),
          // La vraie carte (si elle a été extraite) est essayée dans tool/screenshots.
          if (!withMap) offlineMapProvider.overrideWith((ref) async => null),
        ],
        child: const BsRoadApp(),
      ),
    );
    // Installation du catalogue embarqué : vraie lecture de fichier et vraie base.
    await settle(tester);
  }

  testWidgets('premier lancement : le catalogue embarqué s’affiche sans réseau', (tester) async {
    await startApp(tester);
    expect(find.text('43 lieux'), findsOneWidget);
    expect(find.text('白马服装市场'), findsOneWidget);
    expect(find.text('GARE DE GUANGZHOU'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('filtrer sur « Pièces moto » ne garde que le quartier K', (tester) async {
    await startApp(tester);
    final chips = find.descendant(of: find.byType(ListView), matching: find.byType(Scrollable)).first;
    await tester.scrollUntilVisible(find.text('Pièces moto'), 200, scrollable: chips);
    await tester.ensureVisible(find.text('Pièces moto'));
    await settle(tester);
    await tester.tap(find.text('Pièces moto'));
    await settle(tester);
    expect(find.text('3 lieux sur 43'), findsOneWidget);
    expect(find.text('ZENGCHA LU ET JINSHAZHOU'), findsOneWidget);
    expect(find.text('新白云摩配市场'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('fiche : plaque chinoise, transports, statut enregistré', (tester) async {
    await startApp(tester);
    await tester.enterText(find.byType(SearchBar), '摩配');
    await settle(tester);
    await tester.tap(find.text('新白云摩配市场'));
    await settle(tester);

    expect(find.text('广州市白云区增槎路322号 白云摩配国际产业园'), findsOneWidget);
    expect(find.text('松北'), findsOneWidget);
    expect(find.text('Chercher dans Amap'), findsOneWidget); // position approximative

    await tester.tap(find.text('À visiter'));
    await settle(tester);
    // Le bouton ne passe à « À visiter » qu'après l'aller-retour par la base :
    // l'écran affiche ce que la base contient, pas l'état local du bouton.
    final segmented = tester.widget<SegmentedButton<PlaceStatus>>(find.byType(SegmentedButton<PlaceStatus>));
    expect(segmented.selected, {PlaceStatus.toVisit});
    await finish(tester);
  });

  testWidgets('plein écran chauffeur', (tester) async {
    await startApp(tester);
    await tester.tap(find.text('白马服装市场'));
    await settle(tester);
    await tester.tap(find.textContaining('À MONTRER AU CHAUFFEUR'));
    await settle(tester);
    expect(find.text('请带我去这里，谢谢。'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('tri par distance depuis l’hôtel posé sur la carte', (tester) async {
    // Hôtel posé juste à côté du marché Baima (réglage déjà enregistré).
    await SettingsRepository(db).write(
      originSettingsKey,
      const OriginSettings(preferred: OriginSource.hotel, hotel: GeoPoint(23.1496, 113.2491)).toJson(),
    );
    await startApp(tester);
    expect(find.text('Départ : mon hôtel'), findsOneWidget);
    await tester.tap(find.text('Plus proches'));
    await settle(tester);
    expect(find.text('DU PLUS PROCHE AU PLUS LOIN'), findsOneWidget);
    // Le premier lieu de la liste est Baima, sur place.
    final firstCard = find.byType(PlaceCard).first;
    expect(find.descendant(of: firstCard, matching: find.text('白马服装市场')), findsOneWidget);
    expect(find.descendant(of: firstCard, matching: find.textContaining('sur place')), findsOneWidget);
    await finish(tester);
  });

  testWidgets('GPS : autorisation demandée au choix, distances depuis la position', (tester) async {
    await startApp(tester);
    expect(gps.requests, 0, reason: 'rien n’est demandé au démarrage');
    await tester.tap(find.text('Indiquer d’où je pars'));
    await settle(tester);
    await tester.tap(find.text('Ma position GPS'));
    await settle(tester);
    expect(gps.requests, 1);
    gps.emit(const GeoPoint(23.1174, 113.2572)); // devant Onelink
    await settle(tester);
    expect(find.textContaining('Position reçue'), findsOneWidget);
    await tester.tapAt(const Offset(195, 40)); // ferme la feuille
    await settle(tester);
    expect(find.text('Départ : ma position'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('carte : repères regroupés, lieu centré depuis sa fiche', (tester) async {
    await startApp(tester);
    await tester.tap(find.text('Carte'));
    await settle(tester);
    expect(find.textContaining('Carte absente'), findsOneWidget);
    // Au zoom de départ, les marchés voisins de Guangzhou sont regroupés.
    expect(find.bySemanticsLabel(RegExp(r'^\d+ lieux, toucher pour zoomer$')), findsWidgets);

    await tester.tap(find.text('Lieux'));
    await settle(tester);
    await tester.enterText(find.byType(SearchBar), 'Onelink');
    await settle(tester);
    await tester.tap(find.text('万菱广场'));
    await settle(tester);
    await tester.tap(find.byTooltip('Voir sur la carte'));
    await settle(tester);
    // La carte s'ouvre sur le lieu, sélectionné : sa carte est en bas.
    expect(find.text('Onelink Plaza'), findsOneWidget);
    expect(find.bySemanticsLabel('Onelink Plaza'), findsOneWidget);
    await tester.tap(find.text('万菱广场'));
    await settle(tester);
    expect(find.text('ONELINK PLAZA'), findsOneWidget);
    await finish(tester);
  });
}
