// Captures d'écran de contrôle, pour relire l'interface sans téléphone.
//
// Pas lancé par la CI : il dépend des polices Noto CJK installées sur le poste
// (paquet fonts-noto-cjk sous Linux). Usage, depuis app/ :
//   flutter test tool/screenshots/screenshots_test.dart
// Les images arrivent dans build/screenshots/.
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

const _fonts = {
  // Noto Sans CJK contient aussi l'alphabet latin : il sert de police générale.
  'Roboto': [
    '/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc',
    '/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc',
  ],
  'Noto Serif CJK SC': [
    '/usr/share/fonts/opentype/noto/NotoSerifCJK-Bold.ttc',
    '/usr/share/fonts/opentype/noto/NotoSerifCJK-Black.ttc',
  ],
};

Future<void> _loadFonts() async {
  for (final e in _fonts.entries) {
    final loader = FontLoader(e.key);
    for (final path in e.value) {
      loader.addFont(Future.value(ByteData.sublistView(File(path).readAsBytesSync())));
    }
    await loader.load();
  }
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

void main() {
  testWidgets('captures', (tester) async {
    await tester.runAsync(_loadFonts);
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final db = memoryDatabase();
    for (final brightness in [Brightness.light, Brightness.dark]) {
      tester.platformDispatcher.platformBrightnessTestValue = brightness;
      await tester.pumpWidget(
        RepaintBoundary(
          child: ProviderScope(
            overrides: [
              databaseProvider.overrideWithValue(db),
              assetBundleProvider.overrideWithValue(FileAssetBundle()),
            ],
            child: const BsRoadApp(),
          ),
        ),
      );
      await settle(tester);
      final suffix = brightness == Brightness.dark ? '-sombre' : '';
      await _shot(tester, '1-liste$suffix');

      await tester.tap(find.text('白马服装市场'));
      await settle(tester);
      await _shot(tester, '2-fiche$suffix');
      await tester.drag(find.byType(ListView).last, const Offset(0, -700));
      await settle(tester);
      await _shot(tester, '3-fiche-bas$suffix');
      await finish(tester);
    }
    tester.platformDispatcher.clearPlatformBrightnessTestValue();
    await db.close();
  });
}
