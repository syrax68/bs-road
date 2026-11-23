import 'package:bs_road/app/theme.dart';
import 'package:bs_road/core/ui/zh_text.dart';
import 'package:material_ui/material_ui.dart';

/// Petit titre en capitales espacées, au-dessus d'un bloc.
class Overline extends StatelessWidget {
  const Overline(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.1,
      color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}

/// Sceau carré vermillon, comme un tampon chinois : lettre de quartier,
/// marque de l'app.
class Seal extends StatelessWidget {
  const Seal(this.text, {this.size = 24, this.color, this.zh = false, super.key});

  final String text;
  final double size;
  final Color? color;

  /// Caractère chinois : police à empattement.
  final bool zh;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? Theme.of(context).colorScheme.primary;
    final fg = Theme.of(context).colorScheme.onPrimary;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(size * 0.22)),
      child: Text(
        text,
        style: zh
            ? zhStyle(size * 0.6, color: fg)
            : TextStyle(fontSize: size * 0.52, fontWeight: FontWeight.w900, color: fg, height: 1),
      ),
    );
  }
}

/// Pastille sélectionnable : filtres, choix rapides.
class BsPill extends StatelessWidget {
  const BsPill({required this.label, required this.selected, required this.onTap, this.icon, super.key});

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bs = context.bs;
    final fg = selected ? scheme.surface : scheme.onSurface;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? scheme.onSurface : bs.card,
        shape: StadiumBorder(side: BorderSide(color: selected ? scheme.onSurface : bs.hairline)),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.fromLTRB(icon == null ? 14 : 10, 8, 14, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[Icon(icon, size: 16, color: fg), const SizedBox(width: 5)],
                Text(
                  label,
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bloc blanc à filet fin, posé sur le papier.
class BsCard extends StatelessWidget {
  const BsCard({required this.child, this.padding = const EdgeInsets.all(16), this.onTap, super.key});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bs = context.bs;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(BsRadius.card),
      side: BorderSide(color: bs.hairline),
    );
    return Material(
      color: bs.card,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? Padding(padding: padding, child: child)
          : InkWell(
              onTap: onTap,
              child: Padding(padding: padding, child: child),
            ),
    );
  }
}

/// Titre de section dans une fiche : capitales discrètes, puis le bloc.
class BsSection extends StatelessWidget {
  const BsSection({required this.title, required this.child, this.trailing, super.key});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
          child: Row(
            children: [
              Expanded(child: Overline(title)),
              ?trailing,
            ],
          ),
        ),
        child,
      ],
    ),
  );
}
