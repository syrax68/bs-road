import 'dart:async';

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

/// Ligne « Départ : … » avec le bouton qui ouvre le choix.
class OriginLine extends ConsumerWidget {
  const OriginLine({super.key, this.trailing});

  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final origin = ref.watch(originProvider);
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(_icon(origin?.source), size: 18, color: scheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () => showOriginSheet(context),
            child: Text(
              origin == null ? 'Indiquer d’où je pars' : 'Départ : ${origin.label}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

IconData _icon(OriginSource? s) => switch (s) {
  OriginSource.gps => Icons.my_location,
  OriginSource.hotel => Icons.hotel_outlined,
  OriginSource.pinned => Icons.push_pin_outlined,
  null => Icons.location_searching,
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
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text('Point de départ', style: Theme.of(context).textTheme.titleLarge),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                origin == null
                    ? 'Les distances et le tri « autour de moi » partent de ce point.'
                    : 'Les distances partent de ${origin.label}. Elles sont à vol d’oiseau.',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
            _Choice(
              icon: Icons.my_location,
              title: 'Ma position GPS',
              subtitle: gpsText,
              selected: settings.preferred == OriginSource.gps,
              onTap: () async {
                await ctrl.usePreferred(OriginSource.gps);
                await ref.read(gpsAvailabilityProvider.notifier).request();
              },
            ),
            _Choice(
              icon: Icons.hotel_outlined,
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
              icon: Icons.push_pin_outlined,
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
    return ListTile(
      selected: selected,
      leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked),
      title: Row(
        children: [
          Icon(icon, size: 18, color: selected ? scheme.primary : scheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Flexible(child: Text(title)),
        ],
      ),
      subtitle: Text(subtitle),
      trailing: action,
      onTap: () => unawaited(Future.sync(onTap)),
    );
  }
}
