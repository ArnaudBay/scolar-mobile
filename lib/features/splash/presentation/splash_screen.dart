import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/scolar_logo.dart';
import '../../../theme/scolar_theme.dart';
import '../../auth/domain/auth_state.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../onboarding/data/onboarding_repository.dart';
import '../../updates/domain/update_service.dart';
import '../../updates/presentation/update_providers.dart';

/// Splash : check de version → restauration session → redirection.
///
/// Affiché 1,5 s minimum pour l'aspect "intentionnel" (sinon clignotement
/// sur les démarrages rapides).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _minDisplayDuration = Duration(milliseconds: 1800);

  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: _minDisplayDuration,
    )..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final stopwatch = Stopwatch()..start();

    // 1. Check de version.
    final updateStatus = await ref.read(updateServiceProvider).check();
    if (!mounted) return;
    if (updateStatus == UpdateStatus.required) {
      _go(AppRoutes.updateRequired);
      return;
    }

    // 2. Attente d'une résolution de l'auth (le AuthController démarre en
    //    Loading, puis bascule sur Authenticated/Unauthenticated après
    //    restoreSession).
    final AuthState authState = await _waitForAuthResolved();
    if (!mounted) return;

    // 3. Garantir un affichage minimal du splash.
    final remaining = _minDisplayDuration - stopwatch.elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    if (!mounted) return;

    // 4. Redirection finale.
    final onboardingDone = ref.read(onboardingRepositoryProvider).isDone();
    if (!onboardingDone) {
      _go(AppRoutes.onboarding);
    } else if (authState is AuthAuthenticated) {
      _go(AppRoutes.home);
    } else {
      _go(AppRoutes.login);
    }
  }

  Future<AuthState> _waitForAuthResolved() async {
    while (true) {
      final AuthState current = ref.read<AuthState>(authControllerProvider);
      if (current is! AuthLoading) return current;
      if (!mounted) return current;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  void _go(String path) {
    if (!mounted) return;
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScolarColors.white,
      body: Semantics(
        label: 'Scolar — chargement de l\'application',
        liveRegion: true,
        child: SafeArea(
          child: Stack(
            children: [
              // ── Bloc central : logo + wordmark + tagline ───────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExcludeSemantics(child: const ScolarLogoMark(size: 96)),
                    const SizedBox(height: ScolarSpacing.md),
                    Text(
                      'Scolar',
                      style: ScolarTypography.display.copyWith(fontSize: 64),
                    ),
                    const SizedBox(height: ScolarSpacing.xs),
                    Text(
                      'Votre vie scolaire simplifiée',
                      style: ScolarTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              // ── Barre de progression + label en bas ────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: ScolarSpacing.xxxl,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ScolarSpacing.xxxl,
                      ),
                      child: ClipRRect(
                        borderRadius: ScolarRadius.allPill,
                        child: AnimatedBuilder(
                          animation: _progressController,
                          builder: (_, _) => LinearProgressIndicator(
                            value: Curves.easeInOut.transform(
                              _progressController.value,
                            ),
                            minHeight: 6,
                            backgroundColor: ScolarColors.secondary,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              ScolarColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: ScolarSpacing.md),
                    Text(
                      'CHARGEMENT…',
                      style: ScolarTypography.label.copyWith(
                        color: ScolarColors.muted,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
