import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/widgets/scolar_logo.dart';
import '../../theme/scolar_theme.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  static const routeName = '/register';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;

  // ── Force du mot de passe ─────────────────────────────────────────────────
  int get _passwordStrength {
    final p = _passwordController.text;
    if (p.isEmpty) return 0;
    int score = 0;
    if (p.length >= 8) score++;
    if (p.contains(RegExp(r'[A-Z]'))) score++;
    if (p.contains(RegExp(r'[0-9]'))) score++;
    if (p.contains(RegExp(r'[!@#\$&*~^%]'))) score++;
    return score;
  }

  Color get _strengthColor => switch (_passwordStrength) {
    1 => ScolarColors.danger,
    2 => const Color(0xFFF59E0B),
    3 => ScolarColors.success,
    4 => ScolarColors.success,
    _ => ScolarColors.border,
  };

  String get _strengthLabel => switch (_passwordStrength) {
    1 => 'Faible',
    2 => 'Moyen',
    3 => 'Bon',
    4 => 'Très fort',
    _ => '',
  };

  @override
  void dispose() {
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ── Soumission ────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    setState(() => _errorMessage = null);

    // Validation minimale
    if (_prenomController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmController.text.isEmpty) {
      setState(() => _errorMessage = 'Remplis tous les champs.');
      return;
    }
    if (!_emailController.text.contains('@')) {
      setState(() => _errorMessage = 'Email invalide.');
      return;
    }
    if (_passwordController.text.length < 8) {
      setState(
        () => _errorMessage = 'Mot de passe trop court (8 caractères min).',
      );
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      setState(() => _errorMessage = 'Les mots de passe ne correspondent pas.');
      return;
    }

    setState(() => _isLoading = true);

    // TODO : remplacer par l'appel API réel
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Rediriger vers login après inscription
    Navigator.of(context).pushReplacementNamed('/login');
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScolarColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: ScolarSpacing.screenPadding,
          ),
          child: Column(
            children: [
              // ── En-tête ─────────────────────────────────────────────
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

              // ── Illustration ─────────────────────────────────────────
              const _RegisterIllustration(),

              const SizedBox(height: ScolarSpacing.xl),

              // ── Titre ────────────────────────────────────────────────
              Text(
                'Crée ton compte',
                style: ScolarTypography.h1,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: ScolarSpacing.xl),

              // ── Bandeau erreur ───────────────────────────────────────
              if (_errorMessage != null) ...[
                _ErrorBanner(message: _errorMessage!),
                const SizedBox(height: ScolarSpacing.md),
              ],

              // ── Champ prénom ─────────────────────────────────────────
              TextField(
                controller: _prenomController,
                decoration: _inputDecoration('Ton prénom'),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: ScolarSpacing.md),

              // ── Champ email ──────────────────────────────────────────
              TextField(
                controller: _emailController,
                decoration: _inputDecoration("Email de l'élève"),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: ScolarSpacing.md),

              // ── Champ mot de passe ───────────────────────────────────
              TextField(
                controller: _passwordController,
                decoration: _inputDecoration(
                  'Mot de passe',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: ScolarColors.muted,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() {}),
              ),

              // ── Indicateur de force ──────────────────────────────────
              if (_passwordController.text.isNotEmpty) ...[
                const SizedBox(height: ScolarSpacing.sm),
                _PasswordStrengthBar(
                  strength: _passwordStrength,
                  color: _strengthColor,
                  label: _strengthLabel,
                ),
              ],

              const SizedBox(height: ScolarSpacing.md),

              // ── Confirmation mot de passe ────────────────────────────
              TextField(
                controller: _confirmController,
                decoration: _inputDecoration(
                  'Confirme ton mot de passe',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: ScolarColors.muted,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                obscureText: _obscureConfirm,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),

              const SizedBox(height: ScolarSpacing.xl),

              // ── Bouton Créer mon compte ──────────────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: ScolarRadius.all20,
                  boxShadow: ScolarShadows.brand,
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: ScolarColors.white,
                          ),
                        )
                      : const Text('Créer mon compte'),
                ),
              ),

              const SizedBox(height: ScolarSpacing.lg),

              // ── Lien vers connexion ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Déjà un compte ? ',
                    style: ScolarTypography.bodySmall.copyWith(
                      color: ScolarColors.text,
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed('/login'),
                    child: Text(
                      'Connecte-toi',
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

  // ── Décoration des inputs — style identique à Dorel ──────────────────────
  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: ScolarColors.white,
      suffixIcon: suffixIcon,
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
      errorBorder: OutlineInputBorder(
        borderRadius: ScolarRadius.allPill,
        borderSide: const BorderSide(color: ScolarColors.danger, width: 1.5),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ILLUSTRATION
// ══════════════════════════════════════════════════════════════════════════════

class _RegisterIllustration extends StatelessWidget {
  const _RegisterIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arc décoratif en arrière-plan
          CustomPaint(size: const Size(200, 200), painter: _ArcPainter()),
          // Points décoratifs
          const Positioned(
            top: 55,
            left: 45,
            child: _Dot(color: Color(0xFFCDD3FE), size: 10),
          ),
          const Positioned(
            bottom: 38,
            right: 38,
            child: _Dot(color: Color(0xFFCDD3FE), size: 12),
          ),
          const Positioned(
            top: 30,
            right: 60,
            child: _Dot(color: Color(0xFFFDE68A), size: 8),
          ),
          // Personnage + formulaire d'inscription
          Positioned(
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _StudentCharacter(),
                SizedBox(width: 16),
                _FormCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Arc pointillé — même style que Dorel ─────────────────────────────────────

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ScolarColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    double currentAngle = -math.pi;
    while (currentAngle < 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        3 / radius,
        false,
        paint,
      );
      currentAngle += (3 + 5) / radius;
    }

    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
    canvas.drawLine(Offset(0, center.dy - 5), Offset(0, center.dy + 5), paint);
    canvas.drawLine(
      Offset(size.width, center.dy - 5),
      Offset(size.width, center.dy + 5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Point décoratif ───────────────────────────────────────────────────────────

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ── Personnage élève ─────────────────────────────────────────────────────────

class _StudentCharacter extends StatelessWidget {
  const _StudentCharacter();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 120,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Corps
          Positioned(
            bottom: 0,
            child: Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFCDD3FE),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                border: Border.all(color: ScolarColors.text, width: 1.5),
              ),
            ),
          ),
          // Tête
          Positioned(
            bottom: 44,
            child: Container(
              width: 34,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: ScolarColors.text, width: 1.5),
              ),
            ),
          ),
          // Cheveux
          Positioned(
            bottom: 68,
            child: CustomPaint(
              size: const Size(44, 22),
              painter: _SimpleHairPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleHairPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = const Color(0xFFEAB308)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = ScolarColors.text
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(size.width * 0.1, size.height)
      ..quadraticBezierTo(size.width * 0.5, -4, size.width * 0.9, size.height)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.6,
        size.width * 0.1,
        size.height,
      )
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Carte formulaire dans l'illustration ─────────────────────────────────────

class _FormCard extends StatelessWidget {
  const _FormCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ScolarColors.white,
        borderRadius: ScolarRadius.all12,
        border: Border.all(color: ScolarColors.border, width: 1.2),
        boxShadow: ScolarShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Titre mini
          Container(
            width: 70,
            height: 6,
            decoration: BoxDecoration(
              color: ScolarColors.primary.withValues(alpha: 0.8),
              borderRadius: ScolarRadius.allPill,
            ),
          ),
          const SizedBox(height: 8),
          // Ligne de champ 1
          _MiniField(),
          const SizedBox(height: 6),
          // Ligne de champ 2
          _MiniField(width: 90),
          const SizedBox(height: 6),
          // Ligne de champ 3
          _MiniField(width: 80),
          const SizedBox(height: 10),
          // Mini bouton
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: ScolarColors.primary,
              borderRadius: ScolarRadius.allPill,
            ),
            alignment: Alignment.center,
            child: Text(
              'Créer',
              style: GoogleFonts.dmSans(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: ScolarColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniField extends StatelessWidget {
  const _MiniField({this.width = 110});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 14,
      decoration: BoxDecoration(
        borderRadius: ScolarRadius.allPill,
        border: Border.all(color: ScolarColors.border, width: 1),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// BANDEAU D'ERREUR
// ══════════════════════════════════════════════════════════════════════════════

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ScolarSpacing.md),
      decoration: BoxDecoration(
        color: ScolarColors.danger.withValues(alpha: 0.08),
        borderRadius: ScolarRadius.all12,
        border: Border.all(color: ScolarColors.danger.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: ScolarColors.danger,
            size: 18,
          ),
          const SizedBox(width: ScolarSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: ScolarTypography.caption.copyWith(
                color: ScolarColors.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// INDICATEUR DE FORCE DU MOT DE PASSE
// ══════════════════════════════════════════════════════════════════════════════

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({
    required this.strength,
    required this.color,
    required this.label,
  });

  final int strength;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(4, (i) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                  height: 3,
                  decoration: BoxDecoration(
                    color: i < strength ? color : ScolarColors.border,
                    borderRadius: ScolarRadius.allPill,
                  ),
                ),
              );
            }),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Force : $label',
              style: ScolarTypography.caption.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }
}
