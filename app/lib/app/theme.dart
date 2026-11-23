import 'package:material_ui/material_ui.dart';

/// Couleurs reprises du prototype Carnet Chine : vermillon pour l'action,
/// jade pour « visité », ambre pour les signalements, plaque sombre pour le
/// nom chinois à montrer.
abstract final class BsColors {
  static const accent = Color(0xFFD2351D);
  static const accentDark = Color(0xFFFF6B4E);
  static const jade = Color(0xFF187555);
  static const jadeDark = Color(0xFF5ECBA2);
  static const amber = Color(0xFF9A6200);
  static const amberDark = Color(0xFFE5AC3F);
  static const plaque = Color(0xFF16201D);
  static const plaqueDark = Color(0xFF232E2A);
  static const plaqueInk = Color(0xFFF3F5F1);
}

/// Couleurs sémantiques qui ne rentrent pas dans le ColorScheme Material.
@immutable
class BsPalette extends ThemeExtension<BsPalette> {
  const BsPalette({required this.visited, required this.warning, required this.plaque, required this.plaqueInk});

  final Color visited;
  final Color warning;
  final Color plaque;
  final Color plaqueInk;

  static const light = BsPalette(
    visited: BsColors.jade,
    warning: BsColors.amber,
    plaque: BsColors.plaque,
    plaqueInk: BsColors.plaqueInk,
  );

  static const dark = BsPalette(
    visited: BsColors.jadeDark,
    warning: BsColors.amberDark,
    plaque: BsColors.plaqueDark,
    plaqueInk: BsColors.plaqueInk,
  );

  @override
  BsPalette copyWith({Color? visited, Color? warning, Color? plaque, Color? plaqueInk}) => BsPalette(
    visited: visited ?? this.visited,
    warning: warning ?? this.warning,
    plaque: plaque ?? this.plaque,
    plaqueInk: plaqueInk ?? this.plaqueInk,
  );

  @override
  BsPalette lerp(BsPalette? other, double t) {
    if (other == null) return this;
    return BsPalette(
      visited: Color.lerp(visited, other.visited, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      plaque: Color.lerp(plaque, other.plaque, t)!,
      plaqueInk: Color.lerp(plaqueInk, other.plaqueInk, t)!,
    );
  }
}

extension BsThemeX on BuildContext {
  BsPalette get bs => Theme.of(this).extension<BsPalette>() ?? BsPalette.light;
}

ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(seedColor: BsColors.accent, brightness: brightness).copyWith(
    primary: dark ? BsColors.accentDark : BsColors.accent,
    onPrimary: dark ? const Color(0xFF1B0D09) : Colors.white,
    surface: dark ? const Color(0xFF0F1513) : const Color(0xFFEEF0EC),
    surfaceContainerLow: dark ? const Color(0xFF19211E) : Colors.white,
    onSurface: dark ? const Color(0xFFE8EDE9) : const Color(0xFF16201D),
    onSurfaceVariant: dark ? const Color(0xFF98A6A0) : const Color(0xFF5F6B66),
    outlineVariant: dark ? const Color(0xFF2B3732) : const Color(0xFFDDE2DC),
  );
  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    extensions: [if (dark) BsPalette.dark else BsPalette.light],
    appBarTheme: AppBarTheme(backgroundColor: scheme.surface, surfaceTintColor: Colors.transparent, centerTitle: false),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerLow,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
