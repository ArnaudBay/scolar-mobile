import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/scolar_logo.dart';
import '../../../theme/scolar_theme.dart';
import '../domain/auth_repository.dart';
import 'auth_controller.dart';
import 'widgets/auth_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _schoolCodeCtrl = TextEditingController();
  String _classLevel = '1ère';
  bool _obscurePassword = true;
  bool _busy = false;
  String? _errorMessage;

  static const _classes = <String>[
    '6ème',
    '5ème',
    '4ème',
    '3ème',
    '2nde',
    '1ère',
    'Term.',
  ];

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _schoolCodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _errorMessage = null;
    });
    try {
      final fullName =
          '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}'.trim();
      await ref
          .read(authControllerProvider.notifier)
          .register(
            fullName: fullName,
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScolarColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            ScolarSpacing.lg,
            ScolarSpacing.md,
            ScolarSpacing.lg,
            ScolarSpacing.lg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Back rond blanc ────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleBackButton(
                      onTap: () {
                        final ctx = context;
                        if (Navigator.of(ctx).canPop()) {
                          Navigator.of(ctx).pop();
                        } else {
                          ctx.go(AppRoutes.login);
                        }
                      },
                    ),
                    _StepIndicator(current: 1, total: 2),
                  ],
                ),
                const SizedBox(height: ScolarSpacing.lg),

                // ── Logo ───────────────────────────────────────────────
                const ScolarLogoMark(size: 36),
                const SizedBox(height: ScolarSpacing.lg),

                // ── Titre + sous-titre ─────────────────────────────────
                Text(
                  'Créer ton\ncompte.',
                  style: ScolarTypography.h1.copyWith(
                    fontSize: 38,
                    color: ScolarColors.ink,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: ScolarSpacing.sm),
                Text(
                  'Renseigne tes informations\npour rejoindre Scolar.',
                  style: ScolarTypography.bodySmall,
                ),
                const SizedBox(height: ScolarSpacing.lg),

                // ── Prénom + Nom ───────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FieldLabel('PRÉNOM'),
                          const SizedBox(height: ScolarSpacing.sm),
                          FlatField(
                            controller: _firstNameCtrl,
                            hintText: 'Aminata',
                            textCapitalization: TextCapitalization.words,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Requis';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: ScolarSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FieldLabel('NOM'),
                          const SizedBox(height: ScolarSpacing.sm),
                          FlatField(
                            controller: _lastNameCtrl,
                            hintText: 'Diallo',
                            textCapitalization: TextCapitalization.words,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Requis';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: ScolarSpacing.md),

                // ── E-mail ─────────────────────────────────────────────
                const FieldLabel('EMAIL'),
                const SizedBox(height: ScolarSpacing.sm),
                FlatField(
                  controller: _emailCtrl,
                  hintText: 'aminata.diallo@lyc-bangui.cf',
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'E-mail requis';
                    }
                    if (!v.contains('@')) return 'E-mail invalide';
                    return null;
                  },
                ),
                const SizedBox(height: ScolarSpacing.md),

                // ── Mot de passe ───────────────────────────────────────
                const FieldLabel('MOT DE PASSE'),
                const SizedBox(height: ScolarSpacing.sm),
                FlatField(
                  controller: _passwordCtrl,
                  hintText: 'Au moins 8 caractères',
                  obscureText: _obscurePassword,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: ScolarColors.muted,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 8) {
                      return 'Minimum 8 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: ScolarSpacing.md),

                // ── Classe ─────────────────────────────────────────────
                const FieldLabel('CLASSE'),
                const SizedBox(height: ScolarSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final c in _classes)
                      _ClassChip(
                        label: c,
                        selected: _classLevel == c,
                        onTap: () => setState(() => _classLevel = c),
                      ),
                  ],
                ),
                const SizedBox(height: ScolarSpacing.md),

                // ── Code établissement ─────────────────────────────────
                const FieldLabel('CODE DE L\'ÉTABLISSEMENT'),
                const SizedBox(height: ScolarSpacing.sm),
                FlatField(
                  controller: _schoolCodeCtrl,
                  hintText: 'BGI-2026-LYC',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Code requis';
                    }
                    return null;
                  },
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: ScolarSpacing.md),
                  AuthErrorBanner(message: _errorMessage!),
                ],

                const SizedBox(height: ScolarSpacing.lg),

                // ── CTA ────────────────────────────────────────────────
                BlackPillButton(
                  busy: _busy,
                  label: 'Continuer',
                  onPressed: _submit,
                ),
                const SizedBox(height: ScolarSpacing.md),

                Center(
                  child: GestureDetector(
                    onTap: _busy ? null : () => context.go(AppRoutes.login),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: ScolarColors.muted,
                        ),
                        children: [
                          const TextSpan(text: 'Déjà un compte ? '),
                          TextSpan(
                            text: 'Se connecter',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: ScolarColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Step indicator (2 segments) ──────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final filled = i < current;
        return Container(
          margin: const EdgeInsets.only(left: 4),
          width: 24,
          height: 6,
          decoration: BoxDecoration(
            color: filled ? ScolarColors.ink : ScolarColors.creamDark,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

// ─── Chip classe (style img.png : blanc ↔ noir) ───────────────────────────

class _ClassChip extends StatelessWidget {
  const _ClassChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? ScolarColors.ink : ScolarColors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? ScolarColors.white : ScolarColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
