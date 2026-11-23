import 'dart:async';

import 'package:bs_road/app/theme.dart';
import 'package:bs_road/core/geo/amap_links.dart';
import 'package:bs_road/core/geo/geo.dart';
import 'package:bs_road/core/links/open_link.dart';
import 'package:bs_road/features/places/domain/place.dart';
import 'package:bs_road/features/places/presentation/places_providers.dart';
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
    final added = place.added;

    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
        actions: [
          IconButton(
            tooltip: state.favorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
            isSelected: state.favorite,
            icon: const Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star, color: scheme.primary),
            onPressed: () => repo.setFavorite(place.id, favorite: !state.favorite),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          _Plaque(place: place),
          if (place.alert != null) ...[const SizedBox(height: 12), _AlertBox(alert: place.alert!)],
          const SizedBox(height: 16),
          Text(
            place.name.toUpperCase(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
          ),
          const SizedBox(height: 2),
          Text(
            [
              place.area,
              place.categoryIds.map((c) => labels[c] ?? c).join(', '),
              if (added != null) 'ajouté le ${DateFormat.yMMMMd('fr').format(added)}',
            ].join(' · '),
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          SegmentedButton<PlaceStatus>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: PlaceStatus.undecided, label: Text('Pas décidé')),
              ButtonSegment(value: PlaceStatus.toVisit, label: Text('À visiter')),
              ButtonSegment(value: PlaceStatus.visited, label: Text('Visité')),
            ],
            selected: {state.status},
            onSelectionChanged: (s) => repo.setStatus(place.id, s.first),
          ),
          const SizedBox(height: 20),
          const _Heading('Y aller en bus ou en métro'),
          _TransitCard(place: place),
          const SizedBox(height: 20),
          const _Heading('Ce qu’on y trouve'),
          Text(place.sells),
          const SizedBox(height: 16),
          _InfoRow(label: 'Horaires', value: place.hours),
          _InfoRow(label: 'Minimum de commande', value: place.moq),
          _InfoRow(label: 'Adresse', value: place.address),
          if (place.tips.isNotEmpty) ...[
            const SizedBox(height: 12),
            const _Heading('Conseils'),
            for (final t in place.tips)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 2, right: 8), child: Text('•')),
                    Expanded(child: Text(t)),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 12),
          const _Heading('Ma note'),
          _NoteField(placeId: place.id, initial: state.note),
          if (place.sources.isNotEmpty) ...[
            const SizedBox(height: 20),
            const _Heading('Sources'),
            for (final s in place.sources)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                  onPressed: () => openExternal(context, Uri.parse(s.url)),
                  child: Text(s.title, textAlign: TextAlign.left),
                ),
              ),
          ],
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
    return Material(
      color: bs.plaque,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go('/lieu/${place.id}/chauffeur'),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'À MONTRER AU CHAUFFEUR · TOUCHER POUR AGRANDIR',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: bs.plaqueInk.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 6),
              Text(place.zh, style: zhStyle(34, color: bs.plaqueInk)),
              if (place.addressZh != null) ...[
                const SizedBox(height: 6),
                Text(
                  place.addressZh!,
                  style: zhStyle(17, color: bs.plaqueInk, weight: FontWeight.w600),
                ),
              ],
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
    final color = alert.type == AlertType.info ? context.bs.visited : context.bs.warning;
    final title = switch (alert.type) {
      AlertType.closed => 'Signalé comme fermé ou déménagé',
      AlertType.verify => 'À revérifier',
      AlertType.info => 'Du nouveau',
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border(left: BorderSide(color: color, width: 4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${title.toUpperCase()} · ${DateFormat.yMMMMd('fr').format(alert.date)}',
            style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(alert.text),
          if (alert.source != null)
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () => openExternal(context, Uri.parse(alert.source!.url)),
              child: Text(alert.source!.title),
            ),
        ],
      ),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (stops.isEmpty)
              Text(
                'Aucun arrêt relevé à proximité. Utilise le bouton Amap.',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            for (final s in stops) _StopRow(stop: s),
            if (stops.isNotEmpty) const Divider(height: 20),
            Text(place.access),
            const SizedBox(height: 8),
            Text(
              place.isApprox
                  ? 'Position approximative : ${place.approxNote}.'
                  : 'Distances à vol d’oiseau. Les lignes changent : vérifie le trajet dans Amap.',
              style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Text(metro ? 'Métro' : 'Bus', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stop.zh, style: zhStyle(18, weight: FontWeight.w700)),
                Text(
                  [stop.en, if (stop.exit != null) 'sortie ${stop.exit}'].join(' · '),
                  style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
                ),
                if (shown.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (final l in shown) LineChip(l, metro: metro),
                      if (more > 0) Text('+$more ligne${more > 1 ? 's' : ''}', style: const TextStyle(fontSize: 12.5)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Text(formatDistance(stop.distanceM.toDouble()), style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value),
      ],
    ),
  );
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
    decoration: const InputDecoration(hintText: 'Prix vus, contacts, impressions…', border: OutlineInputBorder()),
    onChanged: _changed,
  );
}

/// Barre fixe du bas : itinéraire Amap et copie du nom chinois.
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final uri = place.isApprox
        ? AmapLinks.search(place.amapQuery)
        : AmapLinks.transitRoute(to: place.location, toName: place.zh);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                icon: const Icon(Icons.directions_transit),
                label: Text(place.isApprox ? 'Chercher dans Amap' : 'Itinéraire dans Amap'),
                onPressed: () => openExternal(context, uri),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 50)),
              icon: const Icon(Icons.copy, size: 18),
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
    );
  }
}
