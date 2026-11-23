import 'package:bs_road/app/shell.dart';
import 'package:bs_road/features/map/presentation/map_spike_screen.dart';
import 'package:bs_road/features/places/presentation/driver_card_screen.dart';
import 'package:bs_road/features/places/presentation/place_detail_screen.dart';
import 'package:bs_road/features/places/presentation/places_list_screen.dart';
import 'package:bs_road/features/places/presentation/places_map_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Routes de l'app. Chemins en français, comme les liens partagés plus tard.
///
/// Les onglets (Lieux, Carte…) gardent chacun leur pile. Les fiches et les
/// écrans plein écran s'ouvrent par-dessus les onglets avec `context.push`,
/// pour que « retour » ramène à l'onglet d'où l'on vient.
GoRouter buildRouter() {
  final root = GlobalKey<NavigatorState>(debugLabel: 'root');
  return GoRouter(
    navigatorKey: root,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/', builder: (context, state) => const PlacesListScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/carte',
                builder: (context, state) => PlacesMapScreen(focusPlaceId: state.uri.queryParameters['lieu']),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/lieu/:id',
        parentNavigatorKey: root,
        builder: (context, state) => PlaceDetailScreen(placeId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'chauffeur',
            parentNavigatorKey: root,
            builder: (context, state) => DriverCardScreen(placeId: state.pathParameters['id']!),
          ),
        ],
      ),
      // Essai de la phase 0 : mesures des deux lecteurs de carte sur le téléphone du voyage.
      GoRoute(path: '/essai-carte', parentNavigatorKey: root, builder: (context, state) => const MapSpikeScreen()),
    ],
  );
}
