import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/widgets/scolar_logo.dart';
import '../../theme/scolar_theme.dart';

// ─── Données des slides ───────────────────────────────────────────────────

class _Slide {
  const _Slide({
    required this.title,
    required this.description,
    required this.illustration,
  });
  final String title;
  final String description;
  final Widget illustration;
}

// ─── Écran principal ──────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  late final _slides = <_Slide>[
    const _Slide(
      title: 'Suivez vos notes',
      description:
          'Consultez vos résultats et suivez votre progression tout au long de l\'année universitaire.',
      illustration: _GradesIllustration(),
    ),
    const _Slide(
      title: 'Emploi du temps',
      description:
          'Accédez à votre planning et ne manquez plus aucun cours, TD ou examen.',
      illustration: _ScheduleIllustration(),
    ),
    const _Slide(
      title: 'Vos devoirs',
      description:
          'Organisez vos travaux et recevez des rappels pour ne jamais rater une échéance.',
      illustration: _HomeworkIllustration(),
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
      _startApp();
    }
  }

  void _startApp() {
    // TODO: naviguer vers l'écran d'authentification
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _slides.length - 1;
    return Scaffold(
      backgroundColor: ScolarColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── En-tête marque ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ScolarSpacing.screenPadding,
                vertical: ScolarSpacing.md,
              ),
              child: Row(
                children: [
                  const ScolarLogoMark(size: 32),
                  const SizedBox(width: ScolarSpacing.sm),
                  Text('Scolar', style: ScolarTypography.h3),
                  const Spacer(),
                  if (!isLast)
                    TextButton(
                      onPressed: _startApp,
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
            // ── PageView ───────────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlidePage(slide: _slides[i]),
              ),
            ),
            // ── Barre inférieure ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                ScolarSpacing.screenPadding,
                ScolarSpacing.md,
                ScolarSpacing.screenPadding,
                ScolarSpacing.xl,
              ),
              child: Column(
                children: [
                  _DotsIndicator(count: _slides.length, current: _page),
                  const SizedBox(height: ScolarSpacing.lg),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: ScolarRadius.all20,
                      boxShadow: ScolarShadows.brand,
                    ),
                    child: ElevatedButton(
                      onPressed: _next,
                      child: Text(isLast ? 'Commencer' : 'Suivant'),
                    ),
                  ),
                  const SizedBox(height: ScolarSpacing.sm),
                  TextButton(
                    onPressed: _startApp,
                    style: TextButton.styleFrom(
                      foregroundColor: ScolarColors.muted,
                      textStyle: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('Continuer comme invité'),
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

// ─── Page de slide ────────────────────────────────────────────────────────

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
          // Illustration (format paysage, ~55 % de la hauteur)
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.only(bottom: ScolarSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                child: slide.illustration,
              ),
            ),
          ),
          // Texte centré
          Expanded(
            flex: 7,
            child: Column(
              children: [
                Text(
                  slide.title,
                  style: ScolarTypography.h1,
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
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? ScolarColors.text : ScolarColors.border,
            borderRadius: ScolarRadius.allPill,
          ),
        );
      }),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// ILLUSTRATIONS
// ══════════════════════════════════════════════════════════════════════════

// ─── Slide 1 — Suivez vos notes ──────────────────────────────────────────
// Scène : amphithéâtre universitaire avec bulletin de notes

class _GradesIllustration extends StatelessWidget {
  const _GradesIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFCDD3FE), Color(0xFFEEF1FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: ScolarRadius.all28,
      ),
      child: Stack(
        children: [
          // Rangées d'amphithéâtre + silhouettes d'étudiants
          const Positioned.fill(
            child: CustomPaint(painter: _AmphibeatrePainter()),
          ),
          // Blob décoratif haut-droit
          Positioned(
            top: -30,
            right: -20,
            child: _Blob(140, ScolarColors.primary.withValues(alpha: 0.08)),
          ),
          // Bulletin de notes central
          Align(
            alignment: const Alignment(0, 0.55),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: ScolarColors.white,
                borderRadius: ScolarRadius.all20,
                boxShadow: ScolarShadows.elevated,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '14,75',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 48,
                      color: ScolarColors.primary,
                      height: 1.0,
                    ),
                  ),
                  Text('/ 20 — Mention Bien', style: ScolarTypography.caption),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _GradeChip(
                        label: 'Maths',
                        grade: '16',
                        color: ScolarColors.success,
                      ),
                      SizedBox(width: 6),
                      _GradeChip(
                        label: 'Info',
                        grade: '18',
                        color: ScolarColors.primary,
                      ),
                      SizedBox(width: 6),
                      _GradeChip(
                        label: 'Physique',
                        grade: '14',
                        color: ScolarColors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmphibeatrePainter extends CustomPainter {
  const _AmphibeatrePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rowPaint = Paint()
      ..color = const Color(0xFF0D02FE).withValues(alpha: 0.07)
      ..style = PaintingStyle.fill;
    final dotPaint = Paint()
      ..color = const Color(0xFF0D02FE).withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    for (int i = 0; i < 4; i++) {
      final rowW = w * (0.55 + i * 0.11);
      final left = (w - rowW) / 2;
      final top = h * (0.08 + i * 0.095);

      // Marche de gradin
      canvas.drawRRect(
        RRect.fromLTRBR(
          left,
          top,
          left + rowW,
          top + 14,
          const Radius.circular(7),
        ),
        rowPaint,
      );

      // Têtes d'étudiants sur la marche
      final count = 3 + i * 2;
      final spacing = rowW / (count + 1);
      for (int j = 0; j < count; j++) {
        canvas.drawCircle(
          Offset(left + spacing * (j + 1), top - 10),
          7,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _GradeChip extends StatelessWidget {
  const _GradeChip({
    required this.label,
    required this.grade,
    required this.color,
  });
  final String label;
  final String grade;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: ScolarRadius.allPill,
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(
        '$label $grade',
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─── Slide 2 — Emploi du temps ────────────────────────────────────────────
// Scène : façade université + planning de la semaine

class _ScheduleIllustration extends StatelessWidget {
  const _ScheduleIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF3E8), Color(0xFFFFE4CC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: ScolarRadius.all28,
      ),
      child: Stack(
        children: [
          // Bâtiment universitaire + arbres
          const Positioned.fill(child: CustomPaint(painter: _CampusPainter())),
          Positioned(
            top: -20,
            left: -20,
            child: _Blob(100, ScolarColors.accent.withValues(alpha: 0.08)),
          ),
          // Carte planning semaine
          Align(
            alignment: const Alignment(0, 0.6),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ScolarColors.white,
                borderRadius: ScolarRadius.all20,
                boxShadow: ScolarShadows.soft,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ma semaine', style: ScolarTypography.label),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      _CourseBlock(
                        label: 'Maths\n8h–10h',
                        color: ScolarColors.primary,
                      ),
                      SizedBox(width: 6),
                      _CourseBlock(
                        label: 'Anglais\n10h–12h',
                        color: ScolarColors.accent,
                      ),
                      SizedBox(width: 6),
                      _CourseBlock(
                        label: 'Info\n14h–16h',
                        color: ScolarColors.success,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampusPainter extends CustomPainter {
  const _CampusPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final orange = const Color(0xFFFF6B00);

    final buildingPaint = Paint()..color = orange.withValues(alpha: 0.18);
    final windowPaint = Paint()..color = orange.withValues(alpha: 0.28);

    // Corps du bâtiment principal
    canvas.drawRRect(
      RRect.fromLTRBR(
        w * 0.14,
        h * 0.10,
        w * 0.86,
        h * 0.46,
        const Radius.circular(6),
      ),
      buildingPaint,
    );
    // Tour centrale
    canvas.drawRRect(
      RRect.fromLTRBR(
        w * 0.40,
        h * 0.02,
        w * 0.60,
        h * 0.12,
        const Radius.circular(6),
      ),
      buildingPaint,
    );
    // Fenêtres (2 rangées × 4)
    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 4; col++) {
        canvas.drawRRect(
          RRect.fromLTRBR(
            w * (0.20 + col * 0.155),
            h * (0.17 + row * 0.11),
            w * (0.20 + col * 0.155) + w * 0.085,
            h * (0.17 + row * 0.11) + h * 0.065,
            const Radius.circular(3),
          ),
          windowPaint,
        );
      }
    }
    // Pelouse
    final grassPaint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.18);
    canvas.drawRRect(
      RRect.fromLTRBR(0, h * 0.44, w, h * 0.52, const Radius.circular(4)),
      grassPaint,
    );
    // Arbres
    final treePaint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.30);
    canvas.drawCircle(Offset(w * 0.09, h * 0.40), 22, treePaint);
    canvas.drawCircle(Offset(w * 0.91, h * 0.40), 18, treePaint);
    canvas.drawCircle(
      Offset(w * 0.09, h * 0.40),
      14,
      treePaint..color = const Color(0xFF10B981).withValues(alpha: 0.45),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _CourseBlock extends StatelessWidget {
  const _CourseBlock({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: ScolarRadius.all12,
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: color,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

// ─── Slide 3 — Vos devoirs ────────────────────────────────────────────────
// Scène : bibliothèque avec liste de tâches

class _HomeworkIllustration extends StatelessWidget {
  const _HomeworkIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: ScolarRadius.all28,
      ),
      child: Stack(
        children: [
          // Rayons de bibliothèque + livres
          const Positioned.fill(child: CustomPaint(painter: _LibraryPainter())),
          Positioned(
            bottom: -25,
            right: -15,
            child: _Blob(90, ScolarColors.success.withValues(alpha: 0.12)),
          ),
          // Liste de tâches
          Align(
            alignment: const Alignment(0, 0.5),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: ScolarColors.white,
                borderRadius: ScolarRadius.all20,
                boxShadow: ScolarShadows.soft,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _TaskRow(label: 'Rapport de TP chimie', done: true),
                  SizedBox(height: 10),
                  _TaskRow(label: 'DM analyse numérique', done: true),
                  SizedBox(height: 10),
                  _TaskRow(label: 'Exposé histoire des sciences', done: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryPainter extends CustomPainter {
  const _LibraryPainter();

  static const _bookColors = <Color>[
    Color(0xFF10B981),
    Color(0xFF0D02FE),
    Color(0xFFFF6B00),
    Color(0xFF0A2540),
    Color(0xFF6B7B95),
    Color(0xFF10B981),
    Color(0xFFFF6B00),
    Color(0xFF0D02FE),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    for (int shelf = 0; shelf < 2; shelf++) {
      final shelfTop = h * (0.06 + shelf * 0.20);

      // Planche du rayon
      final shelfPaint = Paint()
        ..color = const Color(0xFFBCAAA4).withValues(alpha: 0.55);
      canvas.drawRRect(
        RRect.fromLTRBR(
          w * 0.04,
          shelfTop + h * 0.098,
          w * 0.96,
          shelfTop + h * 0.122,
          const Radius.circular(3),
        ),
        shelfPaint,
      );

      // Livres sur le rayon
      double bookX = w * 0.07;
      for (int b = 0; b < 8; b++) {
        final bookW = w * 0.092;
        final bookH = h * (0.065 + (b % 3) * 0.018);
        final bookPaint = Paint()
          ..color = _bookColors[b % _bookColors.length].withValues(alpha: 0.38);
        canvas.drawRRect(
          RRect.fromLTRBR(
            bookX,
            shelfTop + h * 0.098 - bookH,
            bookX + bookW - 3,
            shelfTop + h * 0.098,
            const Radius.circular(3),
          ),
          bookPaint,
        );
        bookX += bookW;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.label, required this.done});
  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? ScolarColors.success : Colors.transparent,
            border: Border.all(
              color: done ? ScolarColors.success : ScolarColors.border,
              width: 1.5,
            ),
          ),
          child: done
              ? const Icon(Icons.check, size: 12, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: done ? ScolarColors.muted : ScolarColors.text,
              decoration: done ? TextDecoration.lineThrough : null,
              decorationColor: ScolarColors.muted,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Utilitaires ──────────────────────────────────────────────────────────

class _Blob extends StatelessWidget {
  const _Blob(this.size, this.color);
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
