import 'dart:async';

import 'package:bs_road/app/theme.dart';
import 'package:bs_road/core/location/location_service.dart';
import 'package:bs_road/core/location/origin.dart';
import 'package:bs_road/data/settings/origin_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Ouvre le choix du point de départ des distances.
Future<void> showOriginSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (_) => const OriginSheet(),
);

/// Bouton « Départ : … » qui ouvre le choix, suivi d'une action éventuelle.
class OriginLine extends ConsumerWidget {
  const OriginLine({super.key, this.trailing});

  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final origin = ref.watch(originProvider);
    final scheme = Theme.of(context).colorScheme;
    final bs = context.bs;
    return Row(
      children: [
        Flexible(
          child: Material(
            color: origin == null ? bs.accentSoft : bs.card,
            shape: StadiumBorder(side: BorderSide(color: origin == null ? Colors.transparent : bs.hairline)),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => showOriginSheet(context),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 9, 14, 9),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_icon(origin?.source), size: 17, color: origin == null ? scheme.primary : scheme.onSurface),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        origin == null ? 'Indiquer d’où je pars' : 'Départ : ${origin.label}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: origin == null ? scheme.primary : scheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.expand_more_rounded,
                      size: 18,
                      color: origin == null ? scheme.primary : scheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}

IconData _icon(OriginSource? s) => switch (s) {
  OriginSource.gps => Icons.my_location_rounded,
  OriginSource.hotel => Icons.hotel_rounded,
  OriginSource.pinned => Icons.push_pin_rounded,
  null => Icons.my_location_rounded,
};

class OriginSheet extends ConsumerWidget {
  const OriginSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(originSettingsProvider).value ?? const OriginSettings();
    final gps = ref.watch(gpsAvailabilityProvider).value ?? LocationAvailability.unknown;
    final fix = ref.watch(gpsFixProvider).value;
    final origin = ref.watch(originProvider);
    final ctrl = ref.read(originControllerProvider);

    final gpsText = switch (gps) {
      LocationAvailability.unknown => 'Le téléphone demandera l’autorisation.',
      LocationAvailability.denied => 'Refusé : autorise la position pour BS Road dans les réglages du téléphone.',
      LocationAvailability.serviceOff => 'Localisation coupée dans les réglages du téléphone.',
      LocationAvailability.granted =>
        settings.preferred != OriginSource.gps
            ? 'Autorisé. Marche sans réseau.'
            : fix == null
            ? 'En attente du signal GPS… (à l’extérieur, c’est plus rapide)'
            : 'Position reçue. Elle n’est jamais enregistrée.',
    };

    void place(String what) {
      Navigator.of(context).pop();
      context.go('/carte?poser=$what');
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
              child: Text('Point de départ', style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
              child: Text(
                origin == null
                    ? 'Les distances et le tri « autour de moi » partent de ce point.'
                    : 'Les distances partent de ${origin.label}. Elles sont à vol d’oiseau.',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
            _Choice(
              icon: Icons.my_location_rounded,
              title: 'Ma position GPS',
              subtitle: gpsText,
              selected: settings.preferred == OriginSource.gps,
              onTap: () async {
                await ctrl.usePreferred(OriginSource.gps);
                await ref.read(gpsAvailabilityProvider.notifier).request();
              },
            ),
            _Choice(
              icon: Icons.hotel_rounded,
              title: 'Mon hôtel',
              subtitle: settings.hotel == null ? 'Pas encore posé sur la carte.' : 'Posé sur la carte.',
              selected: settings.preferred == OriginSource.hotel,
              onTap: settings.hotel == null ? () => place('hotel') : () => ctrl.usePreferred(OriginSource.hotel),
              action: TextButton(
                onPressed: () => place('hotel'),
                child: Text(settings.hotel == null ? 'Poser' : 'Déplacer'),
              ),
            ),
            _Choice(
              icon: Icons.push_pin_rounded,
              title: 'Un point posé à la main',
              subtitle: settings.pinned == null
                  ? 'Si le GPS ne répond pas : touche la carte là où tu es.'
                  : 'Posé sur la carte.',
              selected: settings.preferred == OriginSource.pinned,
              onTap: settings.pinned == null ? () => place('point') : () => ctrl.usePreferred(OriginSource.pinned),
              action: TextButton(
                onPressed: () => place('point'),
                child: Text(settings.pinned == null ? 'Poser' : 'Déplacer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.action,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final FutureOr<void> Function() onTap;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bs = context.bs;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        selected: selected,
        child: Material(
          color: bs.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BsRadius.card),
            side: BorderSide(color: selected ? scheme.onSurface : bs.hairline, width: selected ? 1.5 : 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => unawaited(Future.sync(onTap)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: selected ? scheme.onSurface : bs.sunken,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 20, color: selected ? scheme.surface : scheme.onSurface),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(subtitle, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  ?action,
                  if (action == null && selected)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(Icons.check_circle_rounded, color: scheme.onSurface),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
