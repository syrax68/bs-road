import 'package:material_ui/material_ui.dart';

/// Police à empattement pour le chinois : donne au nom de l'enseigne
/// l'allure d'une plaque. Les polices CJK du système suffisent
/// (Noto CJK sur Android, PingFang ou Songti sur iPhone).
/// Langue des noms d'enseignes et des adresses.
const zhLocale = Locale('zh', 'CN');

const zhFontFallback = ['Noto Serif SC', 'Noto Serif CJK SC', 'Songti SC', 'serif'];

TextStyle zhStyle(double size, {Color? color, FontWeight weight = FontWeight.w900}) => TextStyle(
  fontSize: size,
  fontWeight: weight,
  height: 1.2,
  color: color,
  fontFamilyFallback: zhFontFallback,
  // Chinois simplifié : sans cette indication, un téléphone réglé en français
  // peut dessiner les caractères avec leurs variantes japonaises.
  locale: zhLocale,
);
