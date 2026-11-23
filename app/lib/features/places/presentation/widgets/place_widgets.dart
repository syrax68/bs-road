import 'package:bs_road/app/theme.dart';
import 'package:bs_road/core/catalog/place.dart';
import 'package:bs_road/core/ui/zh_text.dart';
import 'package:material_ui/material_ui.dart';

export 'package:bs_road/core/ui/bs_ui.dart';
export 'package:bs_road/core/ui/zh_text.dart';

/// Petite étiquette (« Nouveau », « À visiter »…) : fond doux, texte coloré.
class Tag extends StatelessWidget {
  const Tag(this.label, {required this.color, required this.background, this.icon, super.key});

  final String label;
  final Color color;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(icon == null ? 7 : 5, 3, 7, 3),
    decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(6)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 12, color: color), const SizedBox(width: 3)],
        Text(
          label,
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: color, height: 1.2),
        ),
      ],
    ),
  );
}

/// Étiquettes d'un lieu : signalement puis nouveauté.
List<Widget> placeTags(BuildContext context, Place place, DateTime now) {
  final bs = context.bs;
  final alert = place.alert;
  return [
    if (alert != null && alert.type == AlertType.info)
      Tag('Du nouveau', color: bs.visited, background: bs.visitedSoft)
    else if (alert != null)
      Tag(
        alert.type == AlertType.closed ? 'Fermé ?' : 'À revérifier',
        color: bs.warning,
        background: bs.warningSoft,
        icon: Icons.warning_amber_rounded,
      ),
    if (place.isNew(now)) Tag('Nouveau', color: bs.visited, background: bs.visitedSoft),
  ];
}

/// Statut de visite, tel qu'affiché dans la liste.
Widget? statusTag(BuildContext context, PlaceStatus status) => switch (status) {
  PlaceStatus.undecided => null,
  PlaceStatus.toVisit => Tag(
    'À visiter',
    color: Theme.of(context).colorScheme.primary,
    background: context.bs.accentSoft,
    icon: Icons.flag_rounded,
  ),
  PlaceStatus.visited => Tag(
    'Visité',
    color: context.bs.visited,
    background: context.bs.visitedSoft,
    icon: Icons.check_rounded,
  ),
};

/// Numéro de ligne de métro ou de bus.
class LineChip extends StatelessWidget {
  const LineChip(this.line, {required this.metro, super.key});

  final String line;
  final bool metro;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bs = context.bs;
    return Container(
      constraints: const BoxConstraints(minWidth: 26),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: metro ? scheme.onSurface : bs.sunken,
        borderRadius: BorderRadius.circular(metro ? 6 : 5),
      ),
      child: Text(
        metro ? 'L$line' : line,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          height: 1.1,
          color: metro ? scheme.surface : scheme.onSurface,
          fontFamilyFallback: zhFontFallback,
        ),
      ),
    );
  }
}
