import 'package:bs_road/app/providers.dart';
import 'package:bs_road/app/theme.dart';
import 'package:bs_road/core/catalog/place.dart';
import 'package:bs_road/core/geo/geo.dart';
import 'package:bs_road/features/places/domain/place_filter.dart';
import 'package:bs_road/features/places/presentation/places_providers.dart';
import 'package:bs_road/features/places/presentation/widgets/origin_sheet.dart';
import 'package:bs_road/features/places/presentation/widgets/place_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Écran d'accueil : les lieux à visiter, filtrés et regroupés par quartier.
class PlacesListScreen extends ConsumerWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ready = ref.watch(catalogReadyProvider);
    return Scaffold(
      // Barre vide : peint la zone de la barre d'état, le contenu défile dessous.
      appBar: AppBar(toolbarHeight: 0),
      body: ready.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _Problem(
          message: 'Le catalogue n’a pas pu être installé.\n$e',
          onRetry: () => ref.invalidate(catalogReadyProvider),
        ),
        data: (_) => const _PlacesBody(),
      ),
    );
  }
}

class _PlacesBody extends ConsumerWidget {
  const _PlacesBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(placeListViewProvider);
    return view.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _Problem(message: 'Lecture impossible.\n$e'),
      data: (v) => CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          const SliverToBoxAdapter(child: _Header()),
          const SliverToBoxAdapter(child: _Filters()),
          SliverToBoxAdapter(child: _OriginBar(hasOrigin: v.origin != null)),
          SliverToBoxAdapter(
            child: _CountLine(shown: v.shown, total: v.total),
          ),
          if (v.sections.isEmpty) const SliverFillRemaining(hasScrollBody: false, child: _Empty()),
          for (final s in v.sections) ...[
            SliverToBoxAdapter(child: _SectionHeader(section: s)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SectionGroup(
                  children: [
                    for (final p in s.places) PlaceCard(place: p, state: v.states[p.id], distance: v.distances[p.id]),
                  ],
                ),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

/// Marque et titre.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
    child: Row(
      children: [
        const Seal('路', size: 40, zh: true),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Overline('BS Road'),
              const SizedBox(height: 2),
              Text('Carnet de sourcing', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Filters extends ConsumerStatefulWidget {
  const _Filters();

  @override
  ConsumerState<_Filters> createState() => _FiltersState();
}

class _FiltersState extends ConsumerState<_Filters> {
  late final TextEditingController _search = TextEditingController(text: ref.read(placeFilterProvider).query);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(placeFilterProvider);
    final ctrl = ref.read(placeFilterProvider.notifier);
    final categories = ref.watch(categoriesProvider).value ?? const <Category>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _search,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Produit, marché, ville',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: filter.query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Effacer',
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        _search.clear();
                        ctrl.setQuery('');
                      },
                    ),
            ),
            onChanged: ctrl.setQuery,
          ),
        ),
        const SizedBox(height: 8),
        _RegionTabs(selected: filter.region, onSelected: ctrl.setRegion),
        const SizedBox(height: 14),
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              BsPill(
                label: 'À visiter',
                icon: Icons.flag_rounded,
                selected: filter.onlyToVisit,
                onTap: () => ctrl.setOnlyToVisit(value: !filter.onlyToVisit),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: VerticalDivider(width: 1, color: context.bs.hairline),
              ),
              _gap(BsPill(label: 'Tout', selected: filter.categoryId == null, onTap: () => ctrl.setCategory(null))),
              for (final c in categories)
                _gap(
                  BsPill(
                    label: c.label,
                    selected: filter.categoryId == c.id,
                    onTap: () => ctrl.setCategory(filter.categoryId == c.id ? null : c.id),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _gap(Widget child) => Padding(padding: const EdgeInsets.only(right: 6), child: child);
}

/// Onglets de région : texte souligné, le plus discret possible.
class _RegionTabs extends StatelessWidget {
  const _RegionTabs({required this.selected, required this.onSelected});

  final RegionFilter selected;
  final ValueChanged<RegionFilter> onSelected;

  static const Map<RegionFilter, String> _labels = {
    RegionFilter.all: 'Tout',
    RegionFilter.guangzhou: 'Guangzhou',
    RegionFilter.shenzhen: 'Shenzhen',
    RegionFilter.elsewhere: 'Ailleurs',
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.bs.hairline)),
      ),
      child: Row(
        children: [
          for (final MapEntry(key: region, value: label) in _labels.entries)
            Expanded(
              child: Semantics(
                button: true,
                selected: region == selected,
                child: InkWell(
                  onTap: () => onSelected(region),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        Text(
                          label,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: region == selected ? FontWeight.w800 : FontWeight.w500,
                            color: region == selected ? scheme.onSurface : scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: region == selected ? scheme.primary : Colors.transparent,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Point de départ et tri par distance.
class _OriginBar extends ConsumerWidget {
  const _OriginBar({required this.hasOrigin});

  final bool hasOrigin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearFirst = ref.watch(placeFilterProvider.select((f) => f.nearFirst));
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: OriginLine(
        trailing: hasOrigin
            ? BsPill(
                label: 'Plus proches',
                icon: Icons.near_me_rounded,
                selected: nearFirst,
                onTap: () => ref.read(placeFilterProvider.notifier).setNearFirst(value: !nearFirst),
              )
            : null,
      ),
    );
  }
}

class _CountLine extends StatelessWidget {
  const _CountLine({required this.shown, required this.total});

  final int shown;
  final int total;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
    child: Text(
      shown == total ? '$total lieux' : '$shown lieux sur $total',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.section});

  final PlaceSection section;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
      child: Row(
        children: [
          if (section.letter != null) ...[Seal(section.letter!), const SizedBox(width: 10)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.9,
                    color: scheme.onSurface,
                  ),
                ),
                if (section.subtitle.isNotEmpty)
                  Text(
                    section.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

/// Lieux d'un même quartier, dans un seul bloc séparé par des filets.
class _SectionGroup extends StatelessWidget {
  const _SectionGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => BsCard(
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[if (i > 0) const Divider(indent: 16), children[i]],
      ],
    ),
  );
}

/// Un lieu dans la liste : le nom chinois en grand, comme une enseigne.
class PlaceCard extends ConsumerWidget {
  const PlaceCard({required this.place, this.state, this.distance, super.key});

  final Place place;
  final PlaceState? state;

  /// Distance au point de départ en mètres, si on en a un.
  final double? distance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final labels = ref.watch(categoryLabelsProvider);
    final tags = placeTags(context, place, DateTime.now());
    final status = statusTag(context, state?.status ?? PlaceStatus.undecided);
    final favorite = state?.favorite ?? false;
    final meta = [
      if (place.region != Region.guangzhou && place.cityName != null) place.cityName!,
      place.categoryIds.map((c) => labels[c] ?? c).join(', '),
    ].join(' · ');
    return InkWell(
      onTap: () => context.push('/lieu/${place.id}'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.zh, style: zhStyle(21, weight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: place.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        if (place.alt != null)
                          TextSpan(
                            text: ' · ${place.alt}',
                            style: TextStyle(color: scheme.onSurfaceVariant),
                          ),
                      ],
                    ),
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(meta, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
                  if (tags.isNotEmpty || distance != null) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (distance != null) _Distance(meters: distance!),
                        ...tags,
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ?status,
                if (favorite)
                  Padding(
                    padding: EdgeInsets.only(top: status == null ? 0 : 8),
                    child: Icon(Icons.star_rounded, size: 20, color: scheme.primary, semanticLabel: 'Favori'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Distance extends StatelessWidget {
  const _Distance({required this.meters});

  final double meters;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.near_me_rounded, size: 13, color: scheme.onSurface),
        const SizedBox(width: 3),
        Text(
          formatDistance(meters),
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: scheme.onSurface),
        ),
      ],
    );
  }
}

class _Empty extends ConsumerWidget {
  const _Empty();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 40, color: scheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            'Aucun lieu ne correspond.',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => ref.read(placeFilterProvider.notifier).reset(),
            child: const Text('Tout afficher'),
          ),
        ],
      ),
    );
  }
}

class _Problem extends StatelessWidget {
  const _Problem({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 40, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) TextButton(onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    ),
  );
}
