import 'package:bs_road/app/router.dart';
import 'package:bs_road/app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class BsRoadApp extends StatefulWidget {
  const BsRoadApp({super.key, this.router});

  /// Routeur injectable pour les tests.
  final GoRouter? router;

  @override
  State<BsRoadApp> createState() => _BsRoadAppState();
}

class _BsRoadAppState extends State<BsRoadApp> {
  late final GoRouter _router = widget.router ?? buildRouter();

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'BS Road',
    debugShowCheckedModeBanner: false,
    theme: buildTheme(Brightness.light),
    darkTheme: buildTheme(Brightness.dark),
    locale: const Locale('fr'),
    supportedLocales: const [Locale('fr')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    routerConfig: _router,
  );
}
