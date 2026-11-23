import 'package:bs_road/core/geo/geo.dart';

/// Liens vers Amap (高德地图), l'outil de navigation de référence en Chine.
///
/// On passe par `uri.amap.com` avec `callnative=1` : la page ouvre l'app Amap
/// si elle est installée, sinon l'itinéraire s'affiche dans le navigateur.
/// Ce format a été vérifié avec le prototype web (redirection vers m.amap.com).
/// Les schémas natifs (`iosamap://`, `androidamap://`) seront branchés après
/// un essai sur téléphone : voir docs/adr/0002-liens-amap.md.
abstract final class AmapLinks {
  static const _source = 'bs-road';

  static String _coord(GeoPoint wgs84) {
    final g = toGcj02(wgs84);
    return '${g.lng.toStringAsFixed(6)},${g.lat.toStringAsFixed(6)}';
  }

  /// Itinéraire en transports en commun vers [to].
  /// Sans [from], Amap part de la position du téléphone.
  static Uri transitRoute({required GeoPoint to, required String toName, GeoPoint? from, String? fromName}) {
    final params = <String>[
      if (from != null) 'from=${_coord(from)},${Uri.encodeComponent(fromName ?? 'Départ')}',
      'to=${_coord(to)},${Uri.encodeComponent(toName)}',
      'mode=bus',
      'src=$_source',
      'callnative=1',
    ];
    return Uri.parse('https://uri.amap.com/navigation?${params.join('&')}');
  }

  /// Recherche par mots-clés chinois, pour les lieux dont la position est
  /// approximative : Amap connaît souvent mieux l'entrée exacte.
  static Uri search(String keywords) =>
      Uri.parse('https://uri.amap.com/search?keyword=${Uri.encodeComponent(keywords)}&callnative=1');
}
