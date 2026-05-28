import 'package:flutter/material.dart';
import '../onboarding/onboarding_screen.dart';

/// Routes nommées centralisées de l'app.
class AppRouter {
  AppRouter._();

  static const String onboarding = '/';
  static const String home = '/home';
  static const String login = '/login';

  // Gestion des routes 
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Route onboarding 
      case onboarding:
        return _buildRoute(
          settings: settings,
          child: const OnboardingScreen(),
        );
      // Route home invité 
      case home:
        return _buildRoute(
          settings: settings,
          child: const _GuestHomeEntryPage(),
        );
      // Route login 
      case login:
        return _buildRoute(
          settings: settings,
          child: const _LoginEntryPage(),
        );
      // Route introuvable 
      default:
        return _buildRoute(
          settings: settings,
          child: const _UnknownRoutePage(),
        );
    }
  }

  // Navigation home invité 

  static Future<void> goToGuestHome(BuildContext context) {
    return Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(
      home,
      (route) => false,
    );
  }

  // Navigation login 

  static Future<void> goToLogin(BuildContext context) {
    return Navigator.of(
      context,
      ).pushNamedAndRemoveUntil(
      login,
      (route) => false,
    );
  }

  // Gestion des routes

  static MaterialPageRoute<dynamic> _buildRoute({
    required RouteSettings settings,
    required Widget child,
  }) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => child,
    );
  }
}

// Écrans temporaires (Onboarding) 
// Seront remplacés par les vrais widgets (OnboardingScreen, StudentHomeScreen…).

// Écrans temporaires (Accueil invité) 
class _GuestHomeEntryPage extends StatelessWidget {
  const _GuestHomeEntryPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Accueil (invité)'),
      ),
    );
  }
}

// Écrans temporaires (Login)
class _LoginEntryPage extends StatelessWidget {
  const _LoginEntryPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Connexion'),
      ),
    );
  }
}

// Écrans temporaires (Route introuvable)
class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Route introuvable'),
      ),
    );
  }
}
