import 'dart:async';

import 'package:bs_road/app/theme.dart';
import 'package:bs_road/core/catalog/place.dart';
import 'package:bs_road/core/geo/amap_links.dart';
import 'package:bs_road/core/geo/geo.dart';
import 'package:bs_road/core/links/open_link.dart';
import 'package:bs_road/core/location/origin.dart';
import 'package:bs_road/features/places/presentation/places_providers.dart';
import 'package:bs_road/features/places/presentation/widgets/origin_sheet.dart';
import 'package:bs_road/features/places/presentation/widgets/place_widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Fiche d'un lieu : de quoi s'y rendre, ce qu'on y trouve, et ce que
/// l'utilisateur en a décidé.
class PlaceDetailScreen extends ConsumerWidget {
  const PlaceDetailScreen({required this.placeId, super.key});

  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final place = ref.watch(placeByIdProvider(placeId));
    return place.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('$e')),
      ),
      data: (p) => p == null
          ? Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Ce lieu n’est plus au catalogue.')),
            )
          : _PlaceDetail(place: p),
    );
  }
}

class _PlaceDetail extends ConsumerWidget {
  const _PlaceDetail({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(placeStateProvider(place.id));
    final labels = ref.watch(categoryLabelsProvider);
    final repo = ref.read(placeStatesRepositoryProvider);
    final scheme = Theme.of(context).colorScheme;
    final bs = context.bs;
    final added = place.added;
    final tags = placeTags(context, place, DateTime.now());

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Voir sur la carte',
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.go('/carte?lieu=${place.id}'),
          ),
          IconButton(
            tooltip: state.favorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
            isSelected: state.favorite,
            icon: const Icon(Icons.star_outline_rounded),
            selectedIcon: Icon(Icons.star_rounded, color: scheme.primary),
            onPressed: () => repo.setFavorite(place.id, favorite: !state.favorite),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Overline(place.area),
                const SizedBox(height: 4),
                Text(place.name, style: Theme.of(context).textTheme.headlineMedium),
                if (place.alt != null) Text(place.alt!, style: TextStyle(fontSize: 15, color: scheme.onSurfaceVariant)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final c in place.categoryIds)
                      Tag(labels[c] ?? c, color: scheme.onSurface, background: bs.sunken),
                    ...tags,
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _Plaque(place: place),
          if (place.alert != null) ...[const SizedBox(height: 12), _AlertBox(alert: place.alert!)],
          const SizedBox(height: 12),
          StatusPicker(selected: state.status, onChanged: (s) => repo.setStatus(place.id, s)),
          const SizedBox(height: 12),
          _DistanceRow(place: place),
          BsSection(
            title: 'Y aller en bus ou en métro',
            child: _TransitCard(place: place),
          ),
          BsSection(
            title: 'Ce qu’on y trouve',
            child: BsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.sells, style: const TextStyle(fontSize: 15, height: 1.4)),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 14),
                  _InfoRow(icon: Icons.schedule_rounded, label: 'Horaires', value: place.hours),
                  _InfoRow(icon: Icons.inventory_2_outlined, label: 'Minimum de commande', value: place.moq),
                  _InfoRow(icon: Icons.place_outlined, label: 'Adresse', value: place.address, last: true),
                ],
              ),
            ),
          ),
          if (place.tips.isNotEmpty)
            BsSection(
              title: 'Conseils',
              child: BsCard(
                child: Column(
                  children: [
                    for (final (i, t) in place.tips.indexed)
                      Padding(
                        padding: EdgeInsets.only(bottom: i == place.tips.length - 1 ? 0 : 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: bs.accentSoft, shape: BoxShape.circle),
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: scheme.primary),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(t, style: const TextStyle(height: 1.4))),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          BsSection(
            title: 'Ma note',
            child: _NoteField(placeId: place.id, initial: state.note),
          ),
          if (place.sources.isNotEmpty)
            BsSection(
              title: 'Sources',
              child: BsCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (final (i, s) in place.sources.indexed) ...[
                      if (i > 0) const Divider(indent: 16),
                      ListTile(
                        dense: true,
                        title: Text(s.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                        onTap: () => openExternal(context, Uri.parse(s.url)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          if (added != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Ajouté au carnet le ${DateFormat.yMMMMd('fr').format(added)}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _ActionBar(place: place),
    );
  }
}

/// Nom et adresse en chinois, à montrer au chauffeur. Un appui ouvre le plein écran.
class _Plaque extends StatelessWidget {
  const _Plaque({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final bs = context.bs;
    final faded = bs.plaqueInk.withValues(alpha: 0.6);
    return Material(
      color: bs.plaque,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/lieu/${place.id}/chauffeur'),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Overline('À montrer au chauffeur', color: faded)),
                  const Seal('去', size: 30, zh: true),
                ],
              ),
              const SizedBox(height: 10),
              Text(place.zh, style: zhStyle(36, color: bs.plaqueInk)),
              if (place.addressZh != null) ...[
                const SizedBox(height: 8),
                Text(
                  place.addressZh!,
                  style: zhStyle(17, color: bs.plaqueInk.withValues(alpha: 0.9), weight: FontWeight.w600),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.open_in_full_rounded, size: 15, color: faded),
                  const SizedBox(width: 6),
                  Text(
                    'Toucher pour agrandir',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: faded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertBox extends StatelessWidget {
  const _AlertBox({required this.alert});

  final PlaceAlert alert;

  @override
  Widget build(BuildContext context) {
    final info = alert.type == AlertType.info;
    final color = info ? context.bs.visited : context.bs.warning;
    final bg = info ? context.bs.visitedSoft : context.bs.warningSoft;
    final title = switch (alert.type) {
      AlertType.closed => 'Signalé comme fermé ou déménagé',
      AlertType.verify => 'À revérifier',
      AlertType.info => 'Du nouveau',
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(BsRadius.card)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(info ? Icons.info_outline_rounded : Icons.warning_amber_rounded, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 14.5),
                ),
                Text(
                  DateFormat.yMMMMd('fr').format(alert.date),
                  style: TextStyle(fontSize: 12.5, color: color.withValues(alpha: 0.8)),
                ),
                const SizedBox(height: 6),
                Text(alert.text, style: const TextStyle(height: 1.4)),
                if (alert.source != null)
                  TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, foregroundColor: color),
                    onPressed: () => openExternal(context, Uri.parse(alert.source!.url)),
                    child: Text(alert.source!.title),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Choix du statut de visite : trois boutons côte à côte.
class StatusPicker extends StatelessWidget {
  const StatusPicker({required this.selected, required this.onChanged, super.key});

  final PlaceStatus selected;
  final ValueChanged<PlaceStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bs = context.bs;
    final options = [
      (PlaceStatus.undecided, 'Pas décidé', Icons.radio_button_unchecked_rounded, scheme.onSurface, bs.sunken),
      (PlaceStatus.toVisit, 'À visiter', Icons.flag_rounded, scheme.primary, bs.accentSoft),
      (PlaceStatus.visited, 'Visité', Icons.check_circle_rounded, bs.visited, bs.visitedSoft),
    ];
    return Row(
      children: [
        for (final (i, (status, label, icon, color, soft)) in options.indexed) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: Semantics(
              button: true,
              selected: status == selected,
              child: Material(
                color: status == selected ? soft : bs.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(BsRadius.control),
                  side: BorderSide(
                    color: status == selected ? color : bs.hairline,
                    width: status == selected ? 1.5 : 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => onChanged(status),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Icon(icon, size: 22, color: status == selected ? color : scheme.onSurfaceVariant),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: status == selected ? FontWeight.w800 : FontWeight.w600,
                            color: status == selected ? color : scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _TransitCard extends StatelessWidget {
  const _TransitCard({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final stops = [?place.metro, ...place.buses];
    final scheme = Theme.of(context).colorScheme;
    return BsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (stops.isEmpty)
            Text(
              'Aucun arrêt relevé à proximité. Utilise le bouton Amap.',
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          for (final (i, s) in stops.indexed) ...[
            if (i > 0) const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(indent: 48)),
            _StopRow(stop: s),
          ],
          if (stops.isNotEmpty) const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: context.bs.sunken, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(place.access, style: const TextStyle(height: 1.4)),
                const SizedBox(height: 6),
                Text(
                  place.isApprox
                      ? 'Position approximative : ${place.approxNote}.'
                      : 'Distances à vol d’oiseau. Les lignes changent : vérifie le trajet dans Amap.',
                  style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StopRow extends StatelessWidget {
  const _StopRow({required this.stop});

  final TransitStop stop;

  @override
  Widget build(BuildContext context) {
    final metro = stop.kind == TransitKind.metro;
    final scheme = Theme.of(context).colorScheme;
    const maxLines = 10;
    final shown = stop.lines.take(maxLines).toList();
    final more = stop.lines.length - shown.length;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: metro ? 'Métro' : 'Bus',
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: metro ? scheme.onSurface : context.bs.sunken,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              metro ? Icons.subway_rounded : Icons.directions_bus_rounded,
              size: 20,
              color: metro ? scheme.surface : scheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stop.zh, style: zhStyle(19, weight: FontWeight.w700)),
              Text(
                [stop.en, if (stop.exit != null) 'sortie ${stop.exit}'].join(' · '),
                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
              ),
              if (shown.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (final l in shown) LineChip(l, metro: metro),
                    if (more > 0)
                      Text(
                        '+$more ligne${more > 1 ? 's' : ''}',
                        style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          formatDistance(stop.distanceM.toDouble()),
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.last = false});

  final IconData icon;
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: scheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant)),
                const SizedBox(height: 1),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Note libre, enregistrée une demi-seconde après la dernière frappe.
class _NoteField extends ConsumerStatefulWidget {
  const _NoteField({required this.placeId, required this.initial});

  final String placeId;
  final String initial;

  @override
  ConsumerState<_NoteField> createState() => _NoteFieldState();
}

class _NoteFieldState extends ConsumerState<_NoteField> {
  late final TextEditingController _ctrl = TextEditingController(text: widget.initial);
  Timer? _debounce;

  @override
  void didUpdateWidget(_NoteField old) {
    super.didUpdateWidget(old);
    // Note modifiée ailleurs (restauration…) alors que le champ n'est pas en cours d'édition.
    if (_debounce == null && widget.initial != _ctrl.text) _ctrl.text = widget.initial;
  }

  @override
  void dispose() {
    final pending = _debounce?.isActive ?? false;
    _debounce?.cancel();
    if (pending) {
      unawaited(ref.read(placeStatesRepositoryProvider).setNote(widget.placeId, _ctrl.text));
    }
    _ctrl.dispose();
    super.dispose();
  }

  void _changed(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _debounce = null;
      unawaited(ref.read(placeStatesRepositoryProvider).setNote(widget.placeId, text));
    });
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _ctrl,
    minLines: 2,
    maxLines: 6,
    textCapitalization: TextCapitalization.sentences,
    decoration: const InputDecoration(hintText: 'Prix vus, contacts, impressions…'),
    onChanged: _changed,
  );
}

/// Distance depuis le point de départ ; un appui change le point.
class _DistanceRow extends ConsumerWidget {
  const _DistanceRow({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final origin = ref.watch(originProvider);
    final d = origin == null ? null : distanceMeters(origin.point, place.location);
    final scheme = Theme.of(context).colorScheme;
    return BsCard(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      onTap: () => showOriginSheet(context),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: context.bs.sunken, borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.near_me_rounded, size: 18, color: scheme.onSurface),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: d == null
                ? Text(
                    'Indique d’où tu pars pour voir la distance',
                    style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d < 30 ? 'Tu es sur place.' : formatDistance(d),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'depuis ${origin!.label}, à vol d’oiseau',
                        style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
          ),
          Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

/// Barre fixe du bas : itinéraire Amap et copie du nom chinois.
class _ActionBar extends ConsumerWidget {
  const _ActionBar({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Depuis le GPS, Amap part de sa propre position ; depuis l'hôtel ou un
    // point posé, on lui donne le départ.
    final origin = ref.watch(originProvider);
    final from = origin == null || origin.source == OriginSource.gps ? null : origin;
    final uri = place.isApprox
        ? AmapLinks.search(place.amapQuery)
        : AmapLinks.transitRoute(to: place.location, toName: place.zh, from: from?.point, fromName: from?.label);
    final bs = context.bs;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bs.card,
        border: Border(top: BorderSide(color: bs.hairline)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.directions_transit_rounded),
                  label: Text(place.isApprox ? 'Chercher dans Amap' : 'Itinéraire dans Amap'),
                  onPressed: () => openExternal(context, uri),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('中文'),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await Clipboard.setData(ClipboardData(text: [place.zh, ?place.addressZh].join('\n')));
                  messenger.showSnackBar(const SnackBar(content: Text('Nom et adresse chinois copiés.')));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
