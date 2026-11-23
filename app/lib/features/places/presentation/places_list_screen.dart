import 'package:bs_road/app/providers.dart';
import 'package:bs_road/features/places/domain/place.dart';
import 'package:bs_road/features/places/domain/place_filter.dart';
import 'package:bs_road/features/places/presentation/places_providers.dart';
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
      appBar: AppBar(
        title: const Text('BS Road'),
        actions: [
          IconButton(
            tooltip: 'Essai carte',
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.go('/essai-carte'),
          ),
        ],
      ),
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
        slivers: [
          const SliverToBoxAdapter(child: _Filters()),
          SliverToBoxAdapter(
            child: _CountLine(shown: v.shown, total: v.total),
          ),
          if (v.sections.isEmpty) const SliverFillRemaining(hasScrollBody: false, child: _Empty()),
          for (final s in v.sections) ...[
            SliverToBoxAdapter(child: _SectionHeader(section: s)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: s.places.length,
                separatorBuilder: (_, _) => const SizedBox(height: 6),
                itemBuilder: (context, i) => PlaceCard(place: s.places[i], state: v.states[s.places[i].id]),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchBar(
            controller: _search,
            hintText: 'Produit, marché, ville',
            leading: const Icon(Icons.search),
            elevation: const WidgetStatePropertyAll(0),
            trailing: [
              if (filter.query.isNotEmpty)
                IconButton(
                  tooltip: 'Effacer',
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _search.clear();
                    ctrl.setQuery('');
                  },
                ),
            ],
            onChanged: ctrl.setQuery,
          ),
          const SizedBox(height: 10),
          SegmentedButton<RegionFilter>(
            showSelectedIcon: false,
            // Quatre segments sur 360 points : marges réduites pour que
            // « Guangzhou » tienne sur une ligne.
            style: SegmentedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 13.5),
              visualDensity: VisualDensity.compact,
            ),
            segments: const [
              ButtonSegment(value: RegionFilter.all, label: Text('Tout')),
              ButtonSegment(value: RegionFilter.guangzhou, label: Text('Guangzhou')),
              ButtonSegment(value: RegionFilter.shenzhen, label: Text('Shenzhen')),
              ButtonSegment(value: RegionFilter.elsewhere, label: Text('Ailleurs')),
            ],
            selected: {filter.region},
            onSelectionChanged: (s) => ctrl.setRegion(s.first),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _CategoryChip(label: 'Tout', selected: filter.categoryId == null, onTap: () => ctrl.setCategory(null)),
                for (final c in categories)
                  _CategoryChip(
                    label: c.label,
                    selected: filter.categoryId == c.id,
                    onTap: () => ctrl.setCategory(filter.categoryId == c.id ? null : c.id),
                  ),
              ],
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const Text('À visiter seulement'),
            value: filter.onlyToVisit,
            onChanged: (v) => ctrl.setOnlyToVisit(value: v),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 6),
    child: ChoiceChip(label: Text(label), selected: selected, showCheckmark: false, onSelected: (_) => onTap()),
  );
}

class _CountLine extends StatelessWidget {
  const _CountLine({required this.shown, required this.total});

  final int shown;
  final int total;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
    child: Text(
      shown == total ? '$total lieux' : '$shown lieux sur $total',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Row(
        children: [
          if (section.letter != null) ...[
            CircleAvatar(
              radius: 11,
              backgroundColor: scheme.onSurface,
              child: Text(
                section.letter!,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: scheme.surface),
              ),
            ),
            const SizedBox(width: 8),
          ],
          // Le nom du quartier passe avant l'accès : jusqu'aux 3/5 de la ligne.
          Flexible(
            flex: 3,
            child: Text(
              section.title.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.6),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              section.subtitle,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte d'un lieu dans la liste : le nom chinois en grand, comme une enseigne.
class PlaceCard extends ConsumerWidget {
  const PlaceCard({required this.place, this.state, super.key});

  final Place place;
  final PlaceState? state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final labels = ref.watch(categoryLabelsProvider);
    final tags = placeTags(context, place, DateTime.now());
    final status = statusTag(context, state?.status ?? PlaceStatus.undecided);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/lieu/${place.id}'),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.zh, style: zhStyle(21)),
                    const SizedBox(height: 2),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          place.alt == null ? place.name : '${place.name} · ${place.alt}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        ...tags,
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (place.region != Region.guangzhou && place.cityName != null) place.cityName!,
                        place.categoryIds.map((c) => labels[c] ?? c).join(' · '),
                      ].join(' — '),
                      style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (state?.favorite ?? false)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(Icons.star, size: 18, color: scheme.primary, semanticLabel: 'Favori'),
                ),
              if (status != null) Padding(padding: const EdgeInsets.only(left: 6), child: status),
              Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _Empty extends ConsumerWidget {
  const _Empty();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.all(32),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Aucun lieu ne correspond.', textAlign: TextAlign.center),
        TextButton(onPressed: () => ref.read(placeFilterProvider.notifier).reset(), child: const Text('Tout afficher')),
      ],
    ),
  );
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
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) TextButton(onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    ),
  );
}
