// Captures de l'écran « Essai carte » avec les deux lecteurs de tuiles.
// Même usage que screenshots_test.dart ; demande les cartes de assets/maps/.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:bs_road/app/app.dart';
import 'package:bs_road/app/providers.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../test/helpers.dart';

Future<void> _loadFonts() async {
  final sans = FontLoader('Roboto');
  for (final f in ['Regular', 'Bold']) {
    sans.addFont(
      Future.value(ByteData.sublistView(File('/usr/share/fonts/opentype/noto/NotoSansCJK-$f.ttc').readAsBytesSync())),
    );
  }
  await sans.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(
      Future.value(
        ByteData.sublistView(
          File('${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf')
              .readAsBytesSync(),
        ),
      ),
    );
  await icons.load();
}

Future<void> _shot(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byType(RepaintBoundary).first);
  final image = await tester.runAsync(() => boundary.toImage(pixelRatio: 2));
  final bytes = await tester.runAsync(() => image!.toByteData(format: ui.ImageByteFormat.png));
  Directory('build/screenshots').createSync(recursive: true);
  File('build/screenshots/$name.png').writeAsBytesSync(bytes!.buffer.asUint8List());
}

Future<void> _wait(WidgetTester tester, int rounds) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('carte', (tester) async {
    final support = Directory.systemTemp.createTempSync('bsroad');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => support.path,
    );
    await tester.runAsync(_loadFonts);
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final db = memoryDatabase();
    await tester.pumpWidget(
      RepaintBoundary(
        child: ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db), assetBundleProvider.overrideWithValue(FileAssetBundle())],
          child: const BsRoadApp(),
        ),
      ),
    );
    await settle(tester);
    await tester.tap(find.byTooltip('Essai carte'));
    await _wait(tester, 40);
    await _shot(tester, '4-carte-pmtiles');
    await tester.tap(find.text('MBTiles'));
    await _wait(tester, 40);
    await _shot(tester, '5-carte-mbtiles');
    await finish(tester);
    await db.close();
  });
}
