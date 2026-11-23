import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Une entrée de la barre d'onglets.
class _Tab {
  const _Tab(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const _tabs = [_Tab('Lieux', Icons.list_alt_outlined, Icons.list_alt), _Tab('Carte', Icons.map_outlined, Icons.map)];

/// Cadre commun : la barre d'onglets du bas, comme le prototype.
class AppShell extends StatelessWidget {
  const AppShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: shell,
    bottomNavigationBar: NavigationBar(
      selectedIndex: shell.currentIndex,
      onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
      destinations: [
        for (final t in _tabs)
          NavigationDestination(icon: Icon(t.icon), selectedIcon: Icon(t.selectedIcon), label: t.label),
      ],
    ),
  );
}
