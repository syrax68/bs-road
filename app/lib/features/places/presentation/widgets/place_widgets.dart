import 'package:bs_road/app/theme.dart';
import 'package:bs_road/core/catalog/place.dart';
import 'package:bs_road/core/ui/zh_text.dart';
import 'package:material_ui/material_ui.dart';

export 'package:bs_road/core/ui/zh_text.dart';

/// Petite étiquette en capitales (« Nouveau », « À visiter »…).
class Tag extends StatelessWidget {
  const Tag(this.label, {required this.color, this.filled = false, super.key});

  final String label;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
    decoration: BoxDecoration(
      color: filled ? color : null,
      border: filled ? null : Border.all(color: color, width: 1.5),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: filled ? Theme.of(context).colorScheme.onPrimary : color,
      ),
    ),
  );
}

/// Étiquettes d'un lieu : signalement puis nouveauté.
List<Widget> placeTags(BuildContext context, Place place, DateTime now) {
  final bs = context.bs;
  final alert = place.alert;
  return [
    if (alert != null)
      Tag(switch (alert.type) {
        AlertType.closed => 'Fermé ?',
        AlertType.verify => 'À revérifier',
        AlertType.info => 'Du nouveau',
      }, color: alert.type == AlertType.info ? bs.visited : bs.warning),
    if (place.isNew(now)) Tag('Nouveau', color: bs.visited),
  ];
}

/// Statut de visite, tel qu'affiché dans la liste.
Widget? statusTag(BuildContext context, PlaceStatus status) => switch (status) {
  PlaceStatus.undecided => null,
  PlaceStatus.toVisit => Tag('À visiter', color: Theme.of(context).colorScheme.primary, filled: true),
  PlaceStatus.visited => Tag('Visité', color: context.bs.visited),
};

/// Numéro de ligne de métro ou de bus.
class LineChip extends StatelessWidget {
  const LineChip(this.line, {required this.metro, super.key});

  final String line;
  final bool metro;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: metro ? scheme.primary : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        metro ? 'L$line' : line,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: metro ? scheme.onPrimary : scheme.onSurface,
          fontFamilyFallback: zhFontFallback,
        ),
      ),
    );
  }
}
