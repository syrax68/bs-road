import 'package:bs_road/features/places/domain/place.dart';
import 'package:collection/collection.dart';

/// Filtre « où » de la liste.
enum RegionFilter { all, guangzhou, shenzhen, elsewhere }

/// Critères de la liste des lieux. Immuable : chaque changement crée un filtre.
class PlaceFilter {
  const PlaceFilter({this.query = '', this.categoryId, this.region = RegionFilter.all, this.onlyToVisit = false});

  final String query;
  final String? categoryId;
  final RegionFilter region;
  final bool onlyToVisit;

  PlaceFilter copyWith({String? query, String? Function()? categoryId, RegionFilter? region, bool? onlyToVisit}) =>
      PlaceFilter(
        query: query ?? this.query,
        categoryId: categoryId != null ? categoryId() : this.categoryId,
        region: region ?? this.region,
        onlyToVisit: onlyToVisit ?? this.onlyToVisit,
      );

  bool get isEmpty => query.trim().isEmpty && categoryId == null && region == RegionFilter.all && !onlyToVisit;
}

const _accents = {
  'à': 'a', 'â': 'a', 'ä': 'a', 'ç': 'c', 'é': 'e', 'è': 'e', 'ê': 'e', //
  'ë': 'e', 'î': 'i', 'ï': 'i', 'ô': 'o', 'ö': 'o', 'ù': 'u', 'û': 'u',
  'ü': 'u', 'ÿ': 'y', 'œ': 'oe', 'æ': 'ae', '’': "'",
};

/// Minuscules et sans accents, pour que « electronique » trouve « Électronique ».
String normalizeForSearch(String s) {
  final lower = s.toLowerCase();
  final b = StringBuffer();
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    b.write(_accents[ch] ?? ch);
  }
  return b.toString();
}

/// Applique le filtre. Les lieux arrivent déjà dans l'ordre du catalogue.
List<Place> filterPlaces(
  List<Place> places,
  PlaceFilter filter, {
  required Map<String, PlaceState> states,
  required Map<String, String> categoryLabels,
}) {
  final words = normalizeForSearch(filter.query).split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  return places.where((p) {
    if (filter.categoryId != null && !p.categoryIds.contains(filter.categoryId)) {
      return false;
    }
    final regionOk = switch (filter.region) {
      RegionFilter.all => true,
      RegionFilter.guangzhou => p.region == Region.guangzhou,
      RegionFilter.shenzhen => p.region == Region.shenzhen,
      RegionFilter.elsewhere => p.region == Region.near || p.region == Region.far,
    };
    if (!regionOk) return false;
    if (filter.onlyToVisit && states[p.id]?.status != PlaceStatus.toVisit) {
      return false;
    }
    if (words.isEmpty) return true;
    final haystack = normalizeForSearch(
      [
        p.zh,
        p.name,
        p.alt ?? '',
        p.area,
        p.cityName ?? '',
        p.sells,
        ...p.categoryIds.map((c) => categoryLabels[c] ?? c),
      ].join(' '),
    );
    return words.every(haystack.contains);
  }).toList();
}

/// Un bloc de la liste : un quartier de Guangzhou, ou un groupe de villes.
class PlaceSection {
  const PlaceSection({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.places,
    this.letter,
  });

  final String key;
  final String title;
  final String subtitle;

  /// Lettre du quartier (A à K), pour Guangzhou seulement.
  final String? letter;
  final List<Place> places;
}

/// Regroupe les lieux comme on les visite : quartier par quartier à
/// Guangzhou, puis Shenzhen, les environs et le reste de la Chine.
List<PlaceSection> groupPlaces(List<Place> places, List<Zone> zones) {
  final sections = <PlaceSection>[];
  final byZone = groupBy<Place, String?>(places.where((p) => p.region == Region.guangzhou), (p) => p.zoneId);
  for (final z in zones) {
    final list = byZone[z.id];
    if (list == null || list.isEmpty) continue;
    sections.add(PlaceSection(key: 'zone:${z.id}', letter: z.letter, title: z.name, subtitle: z.access, places: list));
  }
  final knownZones = zones.map((z) => z.id).toSet();
  final loose = places.where((p) => p.region == Region.guangzhou && !knownZones.contains(p.zoneId)).toList();
  if (loose.isNotEmpty) {
    sections.add(
      PlaceSection(
        key: 'gz:other',
        letter: '+',
        title: 'Guangzhou, ailleurs',
        subtitle: 'Hors des quartiers habituels',
        places: loose,
      ),
    );
  }
  void add(Region r, String title, String subtitle) {
    final list = places.where((p) => p.region == r).toList();
    if (list.isEmpty) return;
    sections.add(PlaceSection(key: r.name, title: title, subtitle: subtitle, places: list));
  }

  add(Region.shenzhen, 'Shenzhen', '29 à 45 min de train rapide');
  add(Region.near, 'Autour de Guangzhou', 'Aller-retour dans la journée');
  add(Region.far, 'Plus loin', 'Train long ou avion');
  return sections;
}
