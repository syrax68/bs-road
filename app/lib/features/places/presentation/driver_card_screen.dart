import 'package:bs_road/app/theme.dart';
import 'package:bs_road/features/places/presentation/places_providers.dart';
import 'package:bs_road/features/places/presentation/widgets/place_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Plein écran « à montrer au chauffeur » : nom et adresse chinois en très
/// grand, lisibles à bout de bras dans un taxi.
class DriverCardScreen extends ConsumerWidget {
  const DriverCardScreen({required this.placeId, super.key});

  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final place = ref.watch(placeByIdProvider(placeId)).value;
    final bs = context.bs;
    return Scaffold(
      backgroundColor: bs.plaque,
      appBar: AppBar(
        backgroundColor: bs.plaque,
        foregroundColor: bs.plaqueInk,
        title: const Text('À montrer au chauffeur'),
      ),
      body: place == null
          ? const SizedBox.shrink()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(place.zh, style: zhStyle(64, color: bs.plaqueInk)),
                    ),
                    const SizedBox(height: 24),
                    if (place.addressZh != null)
                      Text(
                        place.addressZh!,
                        style: zhStyle(30, color: bs.plaqueInk, weight: FontWeight.w700),
                      ),
                    const Spacer(),
                    Text(
                      '请带我去这里，谢谢。',
                      style: zhStyle(24, color: bs.plaqueInk.withValues(alpha: 0.85), weight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '« Emmenez-moi ici, s’il vous plaît. »',
                      style: TextStyle(color: bs.plaqueInk.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
