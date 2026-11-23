import 'package:bs_road/app/app.dart';
import 'package:bs_road/app/providers.dart';
import 'package:bs_road/data/db/app_database.dart';
import 'package:bs_road/features/places/domain/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = memoryDatabase());
  tearDown(() => db.close());

  Future<void> startApp(WidgetTester tester) async {
    // Écran de téléphone : 390 × 844 points.
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db), assetBundleProvider.overrideWithValue(FileAssetBundle())],
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
}
