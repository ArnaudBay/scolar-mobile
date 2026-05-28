import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/widgets/scolar_logo.dart';
import '../../theme/scolar_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScolarColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: ScolarSpacing.screenPadding),
          child: Column(
            children: [
              // ── En-tête ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: ScolarSpacing.md),
                child: Row(
                  children: [
                    const ScolarLogoMark(size: 32),
                    const SizedBox(width: ScolarSpacing.sm),
                    Text(
                      'Scolar',
                      style: ScolarTypography.h3.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Fermer',
                        style: GoogleFonts.dmSans(
                          color: ScolarColors.muted,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: ScolarSpacing.lg),

              // ── Illustration ──────────────────────────────────────────
              const _LoginIllustration(),

              const SizedBox(height: ScolarSpacing.xl),

              // ── Titre ─────────────────────────────────────────────────
              Text(
                'Connexion à Scolar',
                style: ScolarTypography.h1,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: ScolarSpacing.xl),

              // ── Formulaire ────────────────────────────────────────────
              TextField(
                controller: _emailController,
                decoration: _inputDecoration("Email de l'élève"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: ScolarSpacing.md),
              TextField(
                controller: _passwordController,
                decoration: _inputDecoration('Mot de passe'),
                obscureText: true,
              ),

              const SizedBox(height: ScolarSpacing.sm),

              // ── Mot de passe oublié ──────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Mot de passe oublié ?',
                    style: GoogleFonts.dmSans(
                      color: ScolarColors.text,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: ScolarSpacing.xl),

              // ── Bouton Se Connecter ───────────────────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: ScolarRadius.all20,
                  boxShadow: ScolarShadows.brand,
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Se Connecter'),
                ),
              ),

              const SizedBox(height: ScolarSpacing.lg),

              // ── Inscription ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pas encore inscrit ? ',
                    style: ScolarTypography.bodySmall.copyWith(color: ScolarColors.text),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "S'inscrire",
                      style: ScolarTypography.bodySmall.copyWith(
                        color: ScolarColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: ScolarSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: ScolarColors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ScolarSpacing.lg,
        vertical: ScolarSpacing.md,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: ScolarRadius.allPill,
        borderSide: const BorderSide(color: ScolarColors.border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: ScolarRadius.allPill,
        borderSide: const BorderSide(color: ScolarColors.primary, width: 1.5),
      ),
    );
  }
}

// ─── Illustration ─────────────────────────────────────────────────────────

class _LoginIllustration extends StatelessWidget {
  const _LoginIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cercle pointillé en arrière-plan
          CustomPaint(
            size: const Size(200, 200),
            painter: _DottedCirclePainter(),
          ),
          // Points décoratifs sur le cercle
          const Positioned(
            top: 60,
            left: 50,
            child: _DecorativeDot(color: Color(0xFFCDD3FE), size: 10),
          ),
          const Positioned(
            bottom: 40,
            right: 40,
            child: _DecorativeDot(color: Color(0xFFCDD3FE), size: 12),
          ),
          // Personnages (simplifiés)
          Positioned(
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _Character(isAdult: true),
                SizedBox(width: 12),
                _Character(isAdult: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ScolarColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const dashWidth = 3;
    const dashSpace = 5;
    double startAngle = -math.pi; // Commencer à gauche
    const sweepAngle = math.pi;   // Un demi-cercle (haut)

    double currentAngle = startAngle;
    while (currentAngle < startAngle + sweepAngle) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        dashWidth / radius,
        false,
        paint,
      );
      currentAngle += (dashWidth + dashSpace) / radius;
    }

    // Ligne horizontale à la base
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      paint,
    );
    // Petits taquets aux extrémités
    canvas.drawLine(Offset(0, center.dy - 5), Offset(0, center.dy + 5), paint);
    canvas.drawLine(Offset(size.width, center.dy - 5), Offset(size.width, center.dy + 5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DecorativeDot extends StatelessWidget {
  const _DecorativeDot({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _Character extends StatelessWidget {
  const _Character({required this.isAdult});
  final bool isAdult;

  @override
  Widget build(BuildContext context) {
    final bodyHeight = isAdult ? 65.0 : 45.0;
    final bodyWidth = isAdult ? 80.0 : 60.0;
    final shirtColor = const Color(0xFFCDD3FE);

    return SizedBox(
      width: bodyWidth,
      height: 120,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Corps / Vêtement
          Positioned(
            bottom: 0,
            child: Container(
              width: bodyWidth,
              height: bodyHeight,
              decoration: BoxDecoration(
                color: shirtColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                border: Border.all(color: ScolarColors.text, width: 1.5),
              ),
            ),
          ),
          // Col / Détails (V-neck ou chemise)
          Positioned(
            bottom: bodyHeight - 12,
            child: CustomPaint(
              size: Size(bodyWidth, 25),
              painter: _DetailsPainter(isAdult: isAdult),
            ),
          ),
          // Tête et Cheveux
          Positioned(
            bottom: bodyHeight - 5,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Arrière des cheveux (pour l'adulte)
                if (isAdult)
                  Positioned(
                    top: -5,
                    child: CustomPaint(
                      size: Size(bodyWidth * 0.75, bodyWidth * 0.7),
                      painter: _HairPainter(isAdult: isAdult, isBack: true),
                    ),
                  ),
                // Visage
                Container(
                  width: bodyWidth * 0.5,
                  height: bodyWidth * 0.55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(bodyWidth * 0.25),
                    border: Border.all(color: ScolarColors.text, width: 1.5),
                  ),
                ),
                // Avant des cheveux
                Positioned(
                  top: -5,
                  child: CustomPaint(
                    size: Size(bodyWidth * 0.75, bodyWidth * 0.45),
                    painter: _HairPainter(isAdult: isAdult, isBack: false),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsPainter extends CustomPainter {
  _DetailsPainter({required this.isAdult});
  final bool isAdult;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ScolarColors.text
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    if (isAdult) {
      // V-neck élégant
      final path = Path()
        ..moveTo(size.width * 0.35, 0)
        ..lineTo(size.width * 0.5, 12)
        ..lineTo(size.width * 0.65, 0);
      canvas.drawPath(path, paint);
    } else {
      // Col de chemise précis
      final path = Path()
        ..moveTo(size.width * 0.3, 2)
        ..lineTo(size.width * 0.45, 10)
        ..lineTo(size.width * 0.5, 8)
        ..lineTo(size.width * 0.55, 10)
        ..lineTo(size.width * 0.7, 2)
        ..moveTo(size.width * 0.5, 8)
        ..lineTo(size.width * 0.5, 18);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _HairPainter extends CustomPainter {
  _HairPainter({required this.isAdult, required this.isBack});
  final bool isAdult;
  final bool isBack;

  @override
  void paint(Canvas canvas, Size size) {
    final color = isAdult ? const Color(0xFFFDE68A) : const Color(0xFFEAB308);
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = ScolarColors.text
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    if (isAdult) {
      if (isBack) {
        // Cheveux longs derrière
        path.moveTo(0, size.height * 0.8);
        path.quadraticBezierTo(size.width * 0.5, -10, size.width, size.height * 0.8);
        path.lineTo(size.width, size.height);
        path.quadraticBezierTo(size.width * 0.5, size.height + 10, 0, size.height);
        path.close();
      } else {
        // Frange / Coupe devant
        path.moveTo(size.width * 0.1, size.height);
        path.quadraticBezierTo(size.width * 0.5, -5, size.width * 0.9, size.height);
        path.quadraticBezierTo(size.width * 0.5, size.height * 0.4, size.width * 0.1, size.height);
        path.close();
      }
    } else {
      // Coupe garçon
      path.moveTo(size.width * 0.15, size.height);
      path.quadraticBezierTo(size.width * 0.2, 0, size.width * 0.5, 0);
      path.quadraticBezierTo(size.width * 0.8, 0, size.width * 0.85, size.height);
      path.quadraticBezierTo(size.width * 0.5, size.height * 0.7, size.width * 0.15, size.height);
      path.close();
    }

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}


