import 'package:material_ui/material_ui.dart';

/// Direction « carnet de route » : papier chaud, encre presque noire,
/// vermillon réservé à l'action et aux sceaux, jade pour « visité », ambre
/// pour les signalements. Plaque sombre pour le nom chinois à montrer.
abstract final class BsColors {
  // Clair.
  static const paper = Color(0xFFF4F1EA);
  static const card = Color(0xFFFFFFFF);
  static const sunken = Color(0xFFEBE6DC);
  static const ink = Color(0xFF1A1714);
  static const muted = Color(0xFF706960);
  static const hairline = Color(0xFFE3DDD2);
  static const accent = Color(0xFFD2351D);
  static const accentSoft = Color(0xFFFBE7E1);
  static const jade = Color(0xFF187555);
  static const jadeSoft = Color(0xFFE1F0E8);
  static const amber = Color(0xFF9A6200);
  static const amberSoft = Color(0xFFF7ECD6);
  static const plaque = Color(0xFF1A1714);
  static const plaqueInk = Color(0xFFF6F1E7);

  // Sombre.
  static const paperDark = Color(0xFF121110);
  static const cardDark = Color(0xFF1D1B19);
  static const sunkenDark = Color(0xFF26231F);
  static const inkDark = Color(0xFFF1ECE4);
  static const mutedDark = Color(0xFFA39B90);
  static const hairlineDark = Color(0xFF302C27);
  static const accentDark = Color(0xFFFF6B4E);
  static const accentSoftDark = Color(0xFF3B1E16);
  static const jadeDark = Color(0xFF5ECBA2);
  static const jadeSoftDark = Color(0xFF15302A);
  static const amberDark = Color(0xFFE5AC3F);
  static const amberSoftDark = Color(0xFF33280F);
  static const plaqueDark = Color(0xFF2A2622);
}

/// Couleurs sémantiques qui ne rentrent pas dans le ColorScheme Material.
@immutable
class BsPalette extends ThemeExtension<BsPalette> {
  const BsPalette({
    required this.visited,
    required this.visitedSoft,
    required this.warning,
    required this.warningSoft,
    required this.accentSoft,
    required this.plaque,
    required this.plaqueInk,
    required this.card,
    required this.sunken,
    required this.hairline,
  });

  final Color visited;
  final Color visitedSoft;
  final Color warning;
  final Color warningSoft;
  final Color accentSoft;
  final Color plaque;
  final Color plaqueInk;

  /// Fond des cartes, posées sur le papier.
  final Color card;

  /// Fond en creux : champs, pastilles inactives.
  final Color sunken;

  /// Filet fin des cartes et séparateurs.
  final Color hairline;

  static const light = BsPalette(
    visited: BsColors.jade,
    visitedSoft: BsColors.jadeSoft,
    warning: BsColors.amber,
    warningSoft: BsColors.amberSoft,
    accentSoft: BsColors.accentSoft,
    plaque: BsColors.plaque,
    plaqueInk: BsColors.plaqueInk,
    card: BsColors.card,
    sunken: BsColors.sunken,
    hairline: BsColors.hairline,
  );

  static const dark = BsPalette(
    visited: BsColors.jadeDark,
    visitedSoft: BsColors.jadeSoftDark,
    warning: BsColors.amberDark,
    warningSoft: BsColors.amberSoftDark,
    accentSoft: BsColors.accentSoftDark,
    plaque: BsColors.plaqueDark,
    plaqueInk: BsColors.plaqueInk,
    card: BsColors.cardDark,
    sunken: BsColors.sunkenDark,
    hairline: BsColors.hairlineDark,
  );

  @override
  BsPalette copyWith({
    Color? visited,
    Color? visitedSoft,
    Color? warning,
    Color? warningSoft,
    Color? accentSoft,
    Color? plaque,
    Color? plaqueInk,
    Color? card,
    Color? sunken,
    Color? hairline,
  }) => BsPalette(
    visited: visited ?? this.visited,
    visitedSoft: visitedSoft ?? this.visitedSoft,
    warning: warning ?? this.warning,
    warningSoft: warningSoft ?? this.warningSoft,
    accentSoft: accentSoft ?? this.accentSoft,
    plaque: plaque ?? this.plaque,
    plaqueInk: plaqueInk ?? this.plaqueInk,
    card: card ?? this.card,
    sunken: sunken ?? this.sunken,
    hairline: hairline ?? this.hairline,
  );

  @override
  BsPalette lerp(BsPalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return BsPalette(
      visited: l(visited, other.visited),
      visitedSoft: l(visitedSoft, other.visitedSoft),
      warning: l(warning, other.warning),
      warningSoft: l(warningSoft, other.warningSoft),
      accentSoft: l(accentSoft, other.accentSoft),
      plaque: l(plaque, other.plaque),
      plaqueInk: l(plaqueInk, other.plaqueInk),
      card: l(card, other.card),
      sunken: l(sunken, other.sunken),
      hairline: l(hairline, other.hairline),
    );
  }
}

extension BsThemeX on BuildContext {
  BsPalette get bs => Theme.of(this).extension<BsPalette>() ?? BsPalette.light;
}

/// Rayons communs.
abstract final class BsRadius {
  static const card = 18.0;
  static const control = 14.0;
  static const small = 8.0;
}

ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final bs = dark ? BsPalette.dark : BsPalette.light;
  final paper = dark ? BsColors.paperDark : BsColors.paper;
  final ink = dark ? BsColors.inkDark : BsColors.ink;
  final muted = dark ? BsColors.mutedDark : BsColors.muted;
  final accent = dark ? BsColors.accentDark : BsColors.accent;
  final onAccent = dark ? const Color(0xFF1B0D09) : Colors.white;

  // Schéma posé à la main : pas de teintes dérivées du vermillon sur les
  // surfaces (c'est ce qui rendait tout rose).
  final scheme = ColorScheme(
    brightness: brightness,
    primary: accent,
    onPrimary: onAccent,
    primaryContainer: bs.accentSoft,
    onPrimaryContainer: accent,
    secondary: ink,
    onSecondary: paper,
    secondaryContainer: bs.sunken,
    onSecondaryContainer: ink,
    tertiary: bs.visited,
    onTertiary: onAccent,
    error: dark ? const Color(0xFFFF8A80) : const Color(0xFFB3261E),
    onError: onAccent,
    surface: paper,
    onSurface: ink,
    onSurfaceVariant: muted,
    surfaceDim: bs.sunken,
    surfaceBright: bs.card,
    surfaceContainerLowest: bs.card,
    surfaceContainerLow: bs.card,
    surfaceContainer: bs.card,
    surfaceContainerHigh: bs.card,
    surfaceContainerHighest: bs.sunken,
    outline: muted,
    outlineVariant: bs.hairline,
    inverseSurface: ink,
    onInverseSurface: paper,
    inversePrimary: dark ? BsColors.accent : BsColors.accentDark,
    surfaceTint: Colors.transparent,
  );

  final base = ThemeData(colorScheme: scheme, brightness: brightness);
  final text = base.textTheme
      .apply(bodyColor: ink, displayColor: ink)
      .copyWith(
        headlineLarge: base.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          color: ink,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
          color: ink,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          color: ink,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3, color: ink),
        titleMedium: base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: ink),
        labelLarge: base.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0),
      );

  final controlShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(BsRadius.control));
  final hairlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(BsRadius.control),
    borderSide: BorderSide(color: bs.hairline),
  );

  return base.copyWith(
    scaffoldBackgroundColor: paper,
    canvasColor: paper,
    textTheme: text,
    extensions: [bs],
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: paper,
      foregroundColor: ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge,
    ),
    cardTheme: CardThemeData(
      color: bs.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BsRadius.card),
        side: BorderSide(color: bs.hairline),
      ),
    ),
    dividerTheme: DividerThemeData(color: bs.hairline, thickness: 1, space: 1),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: bs.card,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 64,
      indicatorColor: bs.sunken,
      indicatorShape: const StadiumBorder(),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(color: s.contains(WidgetState.selected) ? ink : muted, size: 24),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => TextStyle(
          fontSize: 12,
          fontWeight: s.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
          color: s.contains(WidgetState.selected) ? ink : muted,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bs.card,
      hintStyle: TextStyle(color: muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: hairlineBorder,
      enabledBorder: hairlineBorder,
      focusedBorder: hairlineBorder.copyWith(borderSide: BorderSide(color: ink, width: 1.5)),
      prefixIconColor: muted,
      suffixIconColor: muted,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: onAccent,
        minimumSize: const Size(0, 52),
        shape: controlShape,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        backgroundColor: bs.card,
        minimumSize: const Size(0, 52),
        side: BorderSide(color: bs.hairline, width: 1.5),
        shape: controlShape,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accent,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: bs.card,
      foregroundColor: ink,
      elevation: 2,
      highlightElevation: 4,
      shape: const CircleBorder(),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: paper,
      surfaceTintColor: Colors.transparent,
      dragHandleColor: bs.hairline,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ink,
      contentTextStyle: TextStyle(color: paper, fontWeight: FontWeight.w500),
      actionTextColor: dark ? BsColors.accent : BsColors.accentDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BsRadius.control)),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: bs.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BsRadius.control),
        side: BorderSide(color: bs.hairline),
      ),
    ),
    listTileTheme: ListTileThemeData(selectedColor: accent, iconColor: muted),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: accent),
    textSelectionTheme: TextSelectionThemeData(cursorColor: accent),
  );
}
