import 'package:bs_road/core/geo/cluster.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Offset at(Offset p) => p;

  test('des points éloignés restent seuls', () {
    final c = clusterByPixels([Offset.zero, const Offset(100, 0), const Offset(0, 100)], at);
    expect(c, hasLength(3));
    expect(c.every((g) => g.isSingle), isTrue);
  });

  test('des points proches sont regroupés autour de leur centre', () {
    final c = clusterByPixels([Offset.zero, const Offset(10, 0), const Offset(200, 200)], at);
    expect(c, hasLength(2));
    expect(c.first.items, hasLength(2));
    expect(c.first.center, const Offset(5, 0));
    expect(c.last.isSingle, isTrue);
  });

  test('l’ordre d’entrée est conservé', () {
    final c = clusterByPixels(['a', 'b', 'c'], (s) => Offset(s.codeUnitAt(0) * 100.0, 0));
    expect([for (final g in c) g.items.single], ['a', 'b', 'c']);
  });
}
