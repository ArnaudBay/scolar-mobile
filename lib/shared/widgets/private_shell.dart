import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../theme/scolar_theme.dart';

/// Shell partagé entre les routes privées : enveloppe `child` dans un
/// `Scaffold` avec un `BottomNavigationBar` Scolar.
///
/// L'item actif est calculé à partir du chemin courant — pas besoin de
/// gérer un état "index" séparé.
class PrivateShell extends StatelessWidget {
  const PrivateShell({
    super.key,
    required this.currentLocation,
    required this.child,
  });

  final String currentLocation;
  final Widget child;

  static final List<_NavDestination> _destinations = <_NavDestination>[
    const _NavDestination(
      path: AppRoutes.home,
      label: 'Accueil',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    const _NavDestination(
      path: AppRoutes.notes,
      label: 'Notes',
      icon: Icons.note_alt_outlined,
      activeIcon: Icons.note_alt_rounded,
    ),
    const _NavDestination(
      path: AppRoutes.schedule,
      label: 'Planning',
      icon: Icons.calendar_month_outlined,
      activeIcon: Icons.calendar_month_rounded,
    ),
    const _NavDestination(
      path: AppRoutes.profile,
      label: 'Profil',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  int _currentIndex() {
    for (int i = 0; i < _destinations.length; i++) {
      if (currentLocation.startsWith(_destinations[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex();
    return Scaffold(
      body: child,
      bottomNavigationBar: Semantics(
        label: 'Navigation principale',
        explicitChildNodes: true,
        child: NavigationBar(
          selectedIndex: index,
          backgroundColor: ScolarColors.white,
          indicatorColor: ScolarColors.secondary,
          onDestinationSelected: (i) => context.go(_destinations[i].path),
          destinations: _destinations
              .map(
                (d) => NavigationDestination(
                  icon: Icon(d.icon, semanticLabel: d.label),
                  selectedIcon: Icon(
                    d.activeIcon,
                    color: ScolarColors.primary,
                    semanticLabel: '${d.label} (actif)',
                  ),
                  label: d.label,
                  tooltip: d.label,
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.path,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
  final String path;
  final String label;
  final IconData icon;
  final IconData activeIcon;
}
