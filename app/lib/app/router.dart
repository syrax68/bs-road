import 'package:bs_road/features/map/presentation/map_spike_screen.dart';
import 'package:bs_road/features/places/presentation/driver_card_screen.dart';
import 'package:bs_road/features/places/presentation/place_detail_screen.dart';
import 'package:bs_road/features/places/presentation/places_list_screen.dart';
import 'package:go_router/go_router.dart';

/// Routes de l'app. Chemins en français, comme les liens partagés plus tard.
GoRouter buildRouter() => GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PlacesListScreen(),
      routes: [
        // Essai de la phase 0, retiré quand la carte définitive arrivera.
        GoRoute(path: 'essai-carte', builder: (context, state) => const MapSpikeScreen()),
        GoRoute(
          path: 'lieu/:id',
          builder: (context, state) => PlaceDetailScreen(placeId: state.pathParameters['id']!),
          routes: [
            GoRoute(
              path: 'chauffeur',
              builder: (context, state) => DriverCardScreen(placeId: state.pathParameters['id']!),
            ),
          ],
        ),
      ],
    ),
  ],
);
