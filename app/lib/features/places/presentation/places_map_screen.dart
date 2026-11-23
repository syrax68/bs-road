import 'dart:async';

import 'package:bs_road/app/theme.dart';
import 'package:bs_road/core/catalog/place.dart';
import 'package:bs_road/core/geo/cluster.dart';
import 'package:bs_road/core/geo/geo.dart';
import 'package:bs_road/core/location/location_service.dart';
import 'package:bs_road/core/location/origin.dart';
import 'package:bs_road/core/map/offline_map.dart';
import 'package:bs_road/data/maps/map_providers.dart';
import 'package:bs_road/features/places/presentation/places_providers.dart';
import 'package:bs_road/features/places/presentation/widgets/origin_sheet.dart';
import 'package:bs_road/features/places/presentation/widgets/place_widgets.dart';
import 'package:collection/collection.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as fvt;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

/// Ce que l'on pose en touchant la carte.
enum _Placing { hotel, point }

LatLng _ll(GeoPoint p) => LatLng(p.lat, p.lng);

/// Centre de Guangzhou, vue de départ.
const _guangzhou = LatLng(23.135, 113.28);

/// Carte hors ligne des lieux : mêmes filtres que la liste, repères
/// regroupés selon le zoom, position GPS et point de départ.
class PlacesMapScreen extends ConsumerStatefulWidget {
  const PlacesMapScreen({super.key, this.focusPlaceId});

  /// Lieu à centrer et sélectionner à l'ouverture (`/carte?lieu=…`).
  final String? focusPlaceId;

  @override
  ConsumerState<PlacesMapScreen> createState() => _PlacesMapScreenState();
}

class _PlacesMapScreenState extends ConsumerState<PlacesMapScreen> {
  final _map = MapController();
  String? _selected;
  _Placing? _placing;
  bool _ready = false;
  String? _lastFocus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final poser = GoRouterState.of(context).uri.queryParameters['poser'];
    final placing = switch (poser) {
      'hotel' => _Placing.hotel,
      'point' => _Placing.point,
      _ => null,
    };
    if (placing != null && placing != _placing) setState(() => _placing = placing);
  }

  @override
  void didUpdateWidget(PlacesMapScreen old) {
    super.didUpdateWidget(old);
    if (widget.focusPlaceId != old.focusPlaceId) _focusRequested();
  }

  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  /// Centre la carte sur le lieu demandé par la fiche (« Voir sur la carte »).
  void _focusRequested() {
    final id = widget.focusPlaceId;
    if (id == null || id == _lastFocus || !_ready) return;
    final place = ref.read(placesProvider).value?.firstWhereOrNull((p) => p.id == id);
    if (place == null) return;
    _lastFocus = id;
    setState(() => _selected = id);
    _map.move(_ll(place.location), 15);
  }

  Future<void> _setPoint(_Placing what, LatLng at) async {
    final ctrl = ref.read(originControllerProvider);
    final point = GeoPoint(at.latitude, at.longitude);
    if (what == _Placing.hotel) {
      await ctrl.setHotel(point);
    } else {
      await ctrl.setPinned(point);
    }
    if (!mounted) return;
    setState(() => _placing = null);
    if (GoRouterState.of(context).uri.queryParameters.containsKey('poser')) context.go('/carte');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(what == _Placing.hotel ? 'Hôtel enregistré.' : 'Point de départ enregistré.')),
    );
  }

  Future<void> _onLongPress(LatLng at) async {
    final choice = await showModalBottomSheet<_Placing>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.push_pin_outlined),
              title: const Text('Je suis ici'),
              subtitle: const Text('Point de départ des distances'),
              onTap: () => Navigator.pop(context, _Placing.point),
            ),
            ListTile(
              leading: const Icon(Icons.hotel_outlined),
              title: const Text('Mon hôtel est ici'),
              onTap: () => Navigator.pop(context, _Placing.hotel),
            ),
          ],
        ),
      ),
    );
    if (choice != null) await _setPoint(choice, at);
  }

  Future<void> _locateMe() async {
    final gps = ref.read(gpsAvailabilityProvider.notifier);
    await ref.read(originControllerProvider).usePreferred(OriginSource.gps);
    await gps.request();
    if (!mounted) return;
    final status = ref.read(gpsAvailabilityProvider).value;
    final messenger = ScaffoldMessenger.of(context);
    if (status != LocationAvailability.granted) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            status == LocationAvailability.serviceOff
                ? 'Localisation coupée sur le téléphone. Pose ton point à la main (appui long sur la carte).'
                : 'Position refusée. Pose ton point à la main (appui long sur la carte).',
          ),
        ),
      );
      return;
    }
    final fix = ref.read(gpsFixProvider).value;
    if (fix != null) {
      _map.move(_ll(fix), 15);
    } else {
      messenger.showSnackBar(const SnackBar(content: Text('En attente du signal GPS…')));
    }
  }

  void _fitAll(List<Place> places) {
    if (places.isEmpty) return;
    if (places.length == 1) {
      _map.move(_ll(places.first.location), 15);
      return;
    }
    _map.fitCamera(
      CameraFit.coordinates(
        coordinates: [for (final p in places) _ll(p.location)],
        padding: const EdgeInsets.fromLTRB(48, 120, 48, 160),
        maxZoom: 15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final offline = ref.watch(offlineMapProvider);
    final view = ref.watch(placeListViewProvider).value;
    final places = view == null ? const <Place>[] : [for (final s in view.sections) ...s.places];
    final origin = ref.watch(originProvider);
    final settings = ref.watch(originSettingsProvider).value ?? const OriginSettings();
    final gpsFix = ref.watch(gpsFixProvider).value;
    final selected = places.firstWhereOrNull((p) => p.id == _selected);
    final dark = Theme.of(context).brightness == Brightness.dark;

    ref.listen(placesProvider, (_, _) => _focusRequested());

    final topInset = MediaQuery.paddingOf(context).top;
    final bannerTop = topInset + 72;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _map,
            options: MapOptions(
              initialCenter: _guangzhou,
              initialZoom: 12,
              minZoom: 3,
              maxZoom: 18,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
              onMapReady: () {
                _ready = true;
                _focusRequested();
              },
              onTap: (_, at) {
                if (_placing != null) {
                  unawaited(_setPoint(_placing!, at));
                } else if (_selected != null) {
                  setState(() => _selected = null);
                }
              },
              onLongPress: (_, at) => unawaited(_onLongPress(at)),
            ),
            children: [
              ...switch (offline) {
                AsyncData(:final value?) => [
                  fvt.VectorTileLayer(
                    key: ValueKey('${value.tiles.cacheKey}|$dark'),
                    theme: dark ? value.darkTheme : value.lightTheme,
                    tileProviders: fvt.TileProviders({OfflineMap.sourceName: value.tiles}),
                    diskCacheMaximumSizeInBytes: 0,
                  ),
                ],
                _ => const <Widget>[],
              },
              _PlaceMarkers(
                places: places,
                states: view?.states ?? const {},
                selectedId: _selected,
                onTapPlace: (p) => setState(() => _selected = p.id),
                onTapCluster: _fitAll,
              ),
              MarkerLayer(
                markers: [
                  if (settings.hotel != null)
                    Marker(
                      point: _ll(settings.hotel!),
                      width: 26,
                      height: 26,
                      child: const _OriginDot(icon: Icons.hotel, square: true, label: 'Hôtel'),
                    ),
                  if (settings.pinned != null && origin?.source == OriginSource.pinned)
                    Marker(
                      point: _ll(settings.pinned!),
                      width: 26,
                      height: 26,
                      child: const _OriginDot(icon: Icons.push_pin, label: 'Mon point de départ'),
                    ),
                  if (gpsFix != null)
                    Marker(
                      point: _ll(gpsFix),
                      width: 24,
                      height: 24,
                      child: const _OriginDot(label: 'Ma position'),
                    ),
                ],
              ),
              const _Attribution(),
            ],
          ),
          Positioned(
            top: topInset + 10,
            left: 12,
            right: 12,
            child: _TopBar(
              count: places.length,
              onFit: () => _fitAll(places),
              onMenu: (v) => switch (v) {
                'depart' => showOriginSheet(context),
                'essai' => context.push('/essai-carte'),
                _ => null,
              },
            ),
          ),
          if (offline case AsyncData(value: null))
            _Banner(top: bannerTop, text: 'Carte absente de cette version de l’app. Les repères restent utilisables.'),
          if (offline case AsyncError(:final error)) _Banner(top: bannerTop, text: 'Carte illisible : $error'),
          if (_placing != null)
            _Banner(
              top: bannerTop,
              text: _placing == _Placing.hotel
                  ? 'Touche la carte à l’endroit de ton hôtel. Zoome d’abord pour être précis.'
                  : 'Touche la carte à l’endroit où tu te trouves. Zoome d’abord pour être précis.',
              onClose: () {
                setState(() => _placing = null);
                context.go('/carte');
              },
            )
          else if (view != null && view.shown != view.total)
            _Banner(
              top: bannerTop,
              text: '${view.shown} lieux sur ${view.total} : filtres de la liste appliqués.',
              actionLabel: 'Tout afficher',
              onAction: () => ref.read(placeFilterProvider.notifier).reset(),
            ),
          Positioned(
            right: 16,
            bottom: selected == null ? 24 : 176,
            child: FloatingActionButton(
              heroTag: 'gps',
              tooltip: 'Ma position',
              onPressed: _locateMe,
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
          if (selected != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 16,
              child: _SelectedCard(
                place: selected,
                state: view?.states[selected.id],
                distance: view?.distances[selected.id],
                fromLabel: origin?.label,
              ),
            ),
        ],
      ),
    );
  }
}

/// Repères des lieux, regroupés quand ils se chevauchent au zoom actuel.
class _PlaceMarkers extends StatelessWidget {
  const _PlaceMarkers({
    required this.places,
    required this.states,
    required this.selectedId,
    required this.onTapPlace,
    required this.onTapCluster,
  });

  final List<Place> places;
  final Map<String, PlaceState> states;
  final String? selectedId;
  final ValueChanged<Place> onTapPlace;
  final ValueChanged<List<Place>> onTapCluster;

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.of(context);
    final clusters = clusterByPixels(places, (p) => camera.latLngToScreenOffset(_ll(p.location)));
    return MarkerLayer(
      markers: [
        for (final c in clusters)
          if (c.isSingle)
            Marker(
              key: ValueKey(c.items.first.id),
              point: _ll(c.items.first.location),
              width: 34,
              height: 34,
              child: _PlacePin(
                place: c.items.first,
                status: states[c.items.first.id]?.status ?? PlaceStatus.undecided,
                selected: c.items.first.id == selectedId,
                onTap: () => onTapPlace(c.items.first),
              ),
            )
          else
            Marker(
              point: camera.screenOffsetToLatLng(c.center),
              width: 40,
              height: 40,
              child: _ClusterBubble(count: c.items.length, onTap: () => onTapCluster(c.items)),
            ),
      ],
    );
  }
}

class _PlacePin extends StatelessWidget {
  const _PlacePin({required this.place, required this.status, required this.selected, required this.onTap});

  final Place place;
  final PlaceStatus status;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (status) {
      PlaceStatus.toVisit => scheme.primary,
      PlaceStatus.visited => context.bs.visited,
      PlaceStatus.undecided => scheme.onSurface,
    };
    // Position approximative : pastille creuse.
    final approx = place.isApprox;
    final size = selected ? 28.0 : 20.0;
    return Semantics(
      button: true,
      label: '${place.name}${approx ? ', position approximative' : ''}',
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutBack,
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: approx ? context.bs.card : color,
              shape: BoxShape.circle,
              border: Border.all(color: approx ? color : context.bs.card, width: approx ? 4 : 3),
              boxShadow: [
                const BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(0, 2)),
                if (selected) BoxShadow(color: color.withValues(alpha: 0.3), spreadRadius: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ClusterBubble extends StatelessWidget {
  const _ClusterBubble({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: '$count lieux, toucher pour zoomer',
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.onSurface,
              shape: BoxShape.circle,
              border: Border.all(color: context.bs.card, width: 3),
              boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(0, 2))],
            ),
            child: Text(
              '$count',
              style: TextStyle(color: scheme.surface, fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}

/// Point bleu (GPS), punaise (point posé) ou carré (hôtel).
class _OriginDot extends StatelessWidget {
  const _OriginDot({required this.label, this.icon, this.square = false});

  final String label;
  final IconData? icon;
  final bool square;

  static const _blue = Color(0xFF1B66D2);

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    child: Container(
      decoration: BoxDecoration(
        color: _blue,
        shape: square ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: square ? BorderRadius.circular(7) : null,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [BoxShadow(color: _blue.withValues(alpha: 0.22), spreadRadius: 7)],
      ),
      child: icon == null ? null : Icon(icon, size: 12, color: Colors.white),
    ),
  );
}

/// Ombre douce des éléments posés sur la carte.
const _floatShadow = [BoxShadow(color: Color(0x26000000), blurRadius: 16, offset: Offset(0, 4))];

/// Barre flottante en haut de la carte : nombre de lieux et actions.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.count, required this.onFit, required this.onMenu});

  final int count;
  final VoidCallback onFit;
  final ValueChanged<String> onMenu;

  @override
  Widget build(BuildContext context) {
    final bs = context.bs;
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.fromLTRB(10, 6, 2, 6),
      decoration: BoxDecoration(
        color: bs.card,
        borderRadius: BorderRadius.circular(BsRadius.card),
        border: Border.all(color: bs.hairline),
        boxShadow: _floatShadow,
      ),
      child: Row(
        children: [
          const Seal('路', size: 32, zh: true),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Carte hors ligne',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
                ),
                Text(
                  '$count lieu${count > 1 ? 'x' : ''} affiché${count > 1 ? 's' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.5, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          IconButton(tooltip: 'Tous les lieux affichés', icon: const Icon(Icons.fit_screen_outlined), onPressed: onFit),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: onMenu,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'depart', child: Text('Point de départ…')),
              PopupMenuItem(value: 'essai', child: Text('Essai des lecteurs de carte')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.top, required this.text, this.actionLabel, this.onAction, this.onClose});

  final double top;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Positioned(
      top: top,
      left: 12,
      right: 12,
      child: Container(
        decoration: BoxDecoration(
          color: scheme.onSurface,
          borderRadius: BorderRadius.circular(BsRadius.control),
          boxShadow: _floatShadow,
        ),
        padding: const EdgeInsets.fromLTRB(14, 6, 4, 6),
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 13.5, color: scheme.surface, fontWeight: FontWeight.w500),
              ),
            ),
            if (actionLabel != null)
              TextButton(
                style: TextButton.styleFrom(foregroundColor: scheme.inversePrimary),
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            if (onClose != null)
              IconButton(
                tooltip: 'Annuler',
                color: scheme.surface,
                icon: const Icon(Icons.close_rounded),
                onPressed: onClose,
              ),
          ],
        ),
      ),
    );
  }
}

/// Carte du lieu touché, en bas de l'écran.
class _SelectedCard extends StatelessWidget {
  const _SelectedCard({required this.place, required this.state, required this.distance, required this.fromLabel});

  final Place place;
  final PlaceState? state;
  final double? distance;
  final String? fromLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bs = context.bs;
    final status = statusTag(context, state?.status ?? PlaceStatus.undecided);
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), boxShadow: _floatShadow),
      child: Material(
        color: bs.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: bs.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/lieu/${place.id}'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 12, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.zh, style: zhStyle(22, weight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(place.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(
                        [
                          if (distance != null) 'À ${formatDistance(distance!)} de $fromLabel',
                          if (place.isApprox) 'position approximative',
                        ].join(' · ').ifEmpty(place.area),
                        style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                if (status != null) Padding(padding: const EdgeInsets.only(right: 8), child: status),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: scheme.onSurface, shape: BoxShape.circle),
                  child: Icon(Icons.arrow_forward_rounded, size: 20, color: scheme.surface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on String {
  String ifEmpty(String other) => isEmpty ? other : this;
}

/// Mention obligatoire des données OpenStreetMap (licence ODbL), discrète.
class _Attribution extends StatelessWidget {
  const _Attribution();

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.bottomLeft,
    child: Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text('© OpenStreetMap · Protomaps', style: TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
    ),
  );
}
