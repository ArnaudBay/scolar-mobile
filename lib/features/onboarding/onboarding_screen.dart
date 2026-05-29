import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/router/app_routes.dart';
import '../../shared/widgets/scolar_logo.dart';
import '../../theme/scolar_theme.dart';
import '../auth/presentation/auth_controller.dart';
import 'data/onboarding_repository.dart';

// ─── Données des slides ───────────────────────────────────────────────────

class _Slide {
  const _Slide({
    required this.title,
    required this.description,
    required this.ctaLabel,
    required this.illustration,
  });
  final String title;
  final String description;
  final String ctaLabel;
  final String illustration;
}

// ─── Écran principal ──────────────────────────────────────────────────────

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = <_Slide>[
    _Slide(
      title: 'Suivez vos notes',
      description:
          'Consultez vos moyennes, vos progrès et toutes vos notes en un seul endroit.',
      ctaLabel: 'Continuer',
      illustration: 'assets/onboarding/notes.svg',
    ),
    _Slide(
      title: 'Emploi du temps',
      description:
          'Votre semaine de cours toujours à portée de main, avec rappels et changements de salle.',
      ctaLabel: 'Continuer',
      illustration: 'assets/onboarding/planning.svg',
    ),
    _Slide(
      title: 'Notifications utiles',
      description:
          'Soyez prévenu des nouvelles notes, devoirs à rendre et messages des professeurs.',
      ctaLabel: 'Commencer',
      illustration: 'assets/onboarding/notifications.svg',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await ref.read(onboardingRepositoryProvider).markDone();
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  Future<void> _continueAsGuest() async {
    await ref.read(onboardingRepositoryProvider).markDone();
    if (!mounted) return;
    ref.read(authControllerProvider.notifier).continueAsGuest();
    // Le guard d'auth verra `AuthAuthenticated(guest)` et laissera passer.
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScolarColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // ── En-tête marque + "Passer" ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                ScolarSpacing.screenPadding,
                ScolarSpacing.md,
                ScolarSpacing.md,
                0,
              ),
              child: Row(
                children: [
                  const ScolarLogoMark(
                    size: 24,
                    color: ScolarColors.primaryLight,
                  ),
                  const SizedBox(width: ScolarSpacing.sm),
                  Text(
                    'Scolar',
                    style: GoogleFonts.dmSerifDisplay(
                      textStyle: const TextStyle(
                        inherit: false,
                        color: ScolarColors.ink,
                        fontSize: 18,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _finish,
                    style: TextButton.styleFrom(
                      foregroundColor: ScolarColors.muted,
                      textStyle: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('Passer'),
                  ),
                ],
              ),
            ),
            // ── Slides ─────────────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlidePage(slide: _slides[i]),
              ),
            ),
            // ── Bas : dots + CTA ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                ScolarSpacing.screenPadding,
                ScolarSpacing.lg,
                ScolarSpacing.screenPadding,
                ScolarSpacing.xl,
              ),
              child: Column(
                children: [
                  _DotsIndicator(count: _slides.length, current: _page),
                  const SizedBox(height: ScolarSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ScolarColors.primaryLight,
                        foregroundColor: ScolarColors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: ScolarRadius.all20,
                        ),
                        elevation: 0,
                        shadowColor: ScolarColors.primaryLight.withValues(
                          alpha: 0.30,
                        ),
                        textStyle: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_slides[_page].ctaLabel),
                          const SizedBox(width: ScolarSpacing.sm),
                          const Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: ScolarSpacing.sm),
                  TextButton(
                    onPressed: _continueAsGuest,
                    style: TextButton.styleFrom(
                      foregroundColor: ScolarColors.muted,
                      textStyle: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Continuer en tant qu\'invité'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Page de slide : illustration en haut, texte plus bas ────────────────

class _SlidePage extends StatelessWidget {
  const _SlidePage({required this.slide});
  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ScolarSpacing.screenPadding,
      ),
      child: Column(
        children: [
          const SizedBox(height: ScolarSpacing.lg),
          // ── Zone illustration (~55 % de la slide) ──────────────────
          Expanded(
            flex: 11,
            child: _OnboardingIllustration(assetPath: slide.illustration),
          ),
          const SizedBox(height: ScolarSpacing.lg),
          // ── Texte (titre + description), centré bas ────────────────
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Text(
                  slide.title,
                  style: ScolarTypography.h1.copyWith(
                    fontSize: 32,
                    color: ScolarColors.ink,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ScolarSpacing.sm),
                Text(
                  slide.description,
                  style: ScolarTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Illustration SVG avec fallback placeholder ───────────────────────────
//
// Charge l'asset à la volée pour pouvoir détecter une absence de fichier
// (le projet est livré sans SVG ; les illus seront déposées dans
// `assets/onboarding/` au fil de l'eau).
class _OnboardingIllustration extends StatefulWidget {
  const _OnboardingIllustration({required this.assetPath});
  final String assetPath;

  @override
  State<_OnboardingIllustration> createState() =>
      _OnboardingIllustrationState();
}

class _OnboardingIllustrationState extends State<_OnboardingIllustration> {
  late Future<Uint8List?> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Uint8List?> _load() async {
    try {
      final data = await rootBundle.load(widget.assetPath);
      return data.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _future,
      builder: (_, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const _IllustrationPlaceholder();
        }
        final bytes = snap.data;
        if (bytes == null || bytes.isEmpty) {
          return const _IllustrationPlaceholder();
        }
        return Center(child: SvgPicture.memory(bytes, fit: BoxFit.contain));
      },
    );
  }
}

class _IllustrationPlaceholder extends StatelessWidget {
  const _IllustrationPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: ScolarColors.creamDark.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(ScolarSpacing.xl),
          child: Icon(
            Icons.image_outlined,
            size: 56,
            color: ScolarColors.muted.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

// ─── Indicateur de points ─────────────────────────────────────────────────

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.current});
  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? ScolarColors.primaryLight
                : ScolarColors.primaryLight.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
