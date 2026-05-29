import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/pages/student_home_page.dart';
import '../../features/homeworks/presentation/homeworks_screen.dart';
import '../../features/notes/presentation/notes_screen.dart';
import '../../features/notes/presentation/subject_detail_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/schedule/presentation/schedule_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/updates/presentation/update_required_screen.dart';
import '../../shared/widgets/private_shell.dart';
import 'app_routes.dart';
import 'route_guards.dart';

/// Provider GoRouter de l'app.
///
/// Le router est rebuild automatiquement quand l'état d'auth change
/// (via [_GoRouterRefreshStream] qui écoute le `authControllerProvider`).
final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = _GoRouterRefreshStream(
    ref.watch(authControllerProvider.notifier).stream,
  );
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: refresh,
    redirect: (context, state) => RouteGuards.redirect(ref, state),
    routes: <RouteBase>[
      // ── Bootstrap ─────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.updateRequired,
        name: 'updateRequired',
        builder: (_, _) => const UpdateRequiredScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (_, _) => const OnboardingScreen(),
      ),

      // ── Auth (public) ─────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (_, _) => const RegisterScreen(),
      ),

      // ── Private (Shell partagé : BottomNav + Scaffold) ────────────────
      ShellRoute(
        builder: (context, state, child) {
          return PrivateShell(
            currentLocation: state.matchedLocation,
            child: child,
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (_, _) => const StudentHomePage(),
          ),
          GoRoute(
            path: AppRoutes.notes,
            name: 'notes',
            builder: (_, _) => const NotesScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: ':subjectId',
                name: 'noteDetail',
                builder: (context, state) {
                  final id = state.pathParameters['subjectId']!;
                  return SubjectDetailScreen(subjectId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.schedule,
            name: 'schedule',
            builder: (_, _) => const ScheduleScreen(),
          ),
          GoRoute(
            path: AppRoutes.homeworks,
            name: 'homeworks',
            builder: (_, _) => const HomeworksScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (_, _) => const ProfileScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => _NotFoundScreen(uri: state.uri.toString()),
  );
});

/// Bridge `Stream` → `Listenable` pour `GoRouter.refreshListenable`.
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<AuthState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen({required this.uri});
  final String uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page introuvable')),
      body: Center(child: Text('Route inconnue : $uri')),
    );
  }
}
