import 'package:bs_road/app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Une entrée de la barre d'onglets.
class _Tab {
  const _Tab(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const _tabs = [
  _Tab('Lieux', Icons.storefront_outlined, Icons.storefront),
  _Tab('Carte', Icons.map_outlined, Icons.map),
];

/// Cadre commun : la barre d'onglets du bas.
class AppShell extends StatelessWidget {
  const AppShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: shell,
    bottomNavigationBar: DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.bs.hairline)),
      ),
      child: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          for (final t in _tabs)
            NavigationDestination(icon: Icon(t.icon), selectedIcon: Icon(t.selectedIcon), label: t.label),
        ],
      ),
    ),
  );
}
