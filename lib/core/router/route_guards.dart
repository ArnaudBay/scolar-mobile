import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/onboarding/data/onboarding_repository.dart';
import 'app_routes.dart';

/// Guards de navigation centralisés.
///
/// Logique attendue (à implémenter au Sprint 1) :
///
/// 1. Si la route courante est `/splash` → laisser passer (le splash décide).
/// 2. Sinon, si la version est obsolète → forcer `/update-required`.
/// 3. Sinon, si l'onboarding n'est pas fait → forcer `/onboarding`.
/// 4. Sinon, si l'utilisateur n'est pas authentifié et tente une route
///    privée → forcer `/login`.
/// 5. Sinon, si l'utilisateur est authentifié et tente `/login` ou
///    `/onboarding` → rediriger vers `/home`.
class RouteGuards {
  RouteGuards._();

  static const Set<String> _publicPaths = {
    AppRoutes.splash,
    AppRoutes.updateRequired,
    AppRoutes.onboarding,
    AppRoutes.login,
    AppRoutes.register,
  };

  static bool _isPublic(String path) => _publicPaths.contains(path);

  /// Retourne le chemin vers lequel rediriger, ou `null` pour laisser passer.
  static String? redirect(Ref ref, GoRouterState state) {
    final path = state.matchedLocation;

    // Le splash gère lui-même son flow de démarrage.
    if (path == AppRoutes.splash) return null;

    final onboardingDone = ref.read(onboardingRepositoryProvider).isDone();
    final authState = ref.read(authControllerProvider);

    if (!onboardingDone && path != AppRoutes.onboarding) {
      return AppRoutes.onboarding;
    }

    final isAuthenticated = authState is AuthAuthenticated;

    if (!isAuthenticated && !_isPublic(path)) {
      return AppRoutes.login;
    }

    if (isAuthenticated &&
        (path == AppRoutes.login ||
            path == AppRoutes.register ||
            path == AppRoutes.onboarding)) {
      return AppRoutes.home;
    }

    return null;
  }
}
