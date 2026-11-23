import 'dart:math' as math;
import 'dart:ui' show Offset;

/// Un repère seul ou un groupe de repères trop proches à l'écran.
class Cluster<T> {
  Cluster(this.items, this.center);

  final List<T> items;

  /// Position moyenne des éléments, en pixels écran.
  final Offset center;

  bool get isSingle => items.length == 1;
}

/// Regroupe les éléments dont les repères se chevaucheraient à l'écran.
///
/// Algorithme glouton, suffisant pour quelques centaines de lieux : chaque
/// élément rejoint le premier groupe dont le centre est à moins de [radius]
/// pixels, sinon il en ouvre un nouveau. L'ordre d'entrée est conservé, ce qui
/// rend le résultat stable d'une image à l'autre.
List<Cluster<T>> clusterByPixels<T>(Iterable<T> items, Offset Function(T) project, {double radius = 28}) {
  final groups = <_Group<T>>[];
  final r2 = radius * radius;
  for (final item in items) {
    final p = project(item);
    _Group<T>? hit;
    for (final g in groups) {
      final d = g.center - p;
      if (d.dx * d.dx + d.dy * d.dy <= r2) {
        hit = g;
        break;
      }
    }
    if (hit == null) {
      groups.add(_Group<T>()..add(item, p));
    } else {
      hit.add(item, p);
    }
  }
  return [for (final g in groups) Cluster<T>(List.unmodifiable(g.items), g.center)];
}

class _Group<T> {
  final items = <T>[];
  double _sx = 0;
  double _sy = 0;

  Offset get center => Offset(_sx / items.length, _sy / items.length);

  void add(T item, Offset p) {
    items.add(item);
    _sx += p.dx;
    _sy += p.dy;
  }
}

/// Zoom qui fait tenir tous les points d'un groupe dans un écran, borné.
double zoomToSeparate(double currentZoom) => math.min(currentZoom + 2, 17);
