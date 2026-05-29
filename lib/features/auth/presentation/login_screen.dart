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

enum _LoginMode { email, identifier }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  _LoginMode _mode = _LoginMode.email;
  bool _obscurePassword = true;
  bool _busy = false;
  String? _errorMessage;

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _errorMessage = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(
            email: _identifierCtrl.text.trim(),
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
    final isEmail = _mode == _LoginMode.email;
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
                CircleBackButton(
                  onTap: () {
                    final ctx = context;
                    if (Navigator.of(ctx).canPop()) {
                      Navigator.of(ctx).pop();
                    } else {
                      ctx.go(AppRoutes.onboarding);
                    }
                  },
                ),
                const SizedBox(height: ScolarSpacing.lg),

                // ── Logo Scolar ────────────────────────────────────────
                const ScolarLogoMark(size: 36),
                const SizedBox(height: ScolarSpacing.lg),

                // ── Titre + sous-titre ─────────────────────────────────
                Text(
                  'Bon retour.',
                  style: ScolarTypography.h1.copyWith(
                    fontSize: 38,
                    color: ScolarColors.ink,
                  ),
                ),
                const SizedBox(height: ScolarSpacing.sm),
                Text(
                  'Connecte-toi pour accéder à tes notes,\nton emploi du temps et tes devoirs.',
                  style: ScolarTypography.bodySmall,
                ),
                const SizedBox(height: ScolarSpacing.lg),

                // ── Switch Email / Identifiant ─────────────────────────
                _SegmentedSwitch(
                  selected: _mode,
                  onChanged: (m) => setState(() => _mode = m),
                ),
                const SizedBox(height: ScolarSpacing.lg),

                // ── Champ identifiant ──────────────────────────────────
                FieldLabel(isEmail ? 'EMAIL' : 'IDENTIFIANT'),
                const SizedBox(height: ScolarSpacing.sm),
                FlatField(
                  controller: _identifierCtrl,
                  hintText: isEmail
                      ? 'aminata.diallo@lyc-bangui.cf'
                      : 'aminata.diallo',
                  keyboardType: isEmail
                      ? TextInputType.emailAddress
                      : TextInputType.text,
                  autocorrect: false,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return isEmail ? 'E-mail requis' : 'Identifiant requis';
                    }
                    if (isEmail && !v.contains('@')) {
                      return 'E-mail invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: ScolarSpacing.md),

                // ── Champ mot de passe ─────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FieldLabel('MOT DE PASSE'),
                    TextButton(
                      onPressed: _busy ? null : () {},
                      style: TextButton.styleFrom(
                        foregroundColor: ScolarColors.accent,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Mot de passe oublié ?'),
                    ),
                  ],
                ),
                const SizedBox(height: ScolarSpacing.sm),
                FlatField(
                  controller: _passwordCtrl,
                  hintText: '••••••••••',
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
                    if (v == null || v.isEmpty) return 'Mot de passe requis';
                    if (v.length < 6) return 'Minimum 6 caractères';
                    return null;
                  },
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: ScolarSpacing.md),
                  AuthErrorBanner(message: _errorMessage!),
                ],

                const SizedBox(height: ScolarSpacing.lg),

                // ── CTA noir ───────────────────────────────────────────
                BlackPillButton(
                  busy: _busy,
                  label: 'Se connecter',
                  onPressed: _submit,
                ),
                const SizedBox(height: ScolarSpacing.md),

                // ── Footer ─────────────────────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: _busy ? null : () => context.go(AppRoutes.register),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: ScolarColors.muted,
                        ),
                        children: [
                          const TextSpan(text: 'Pas encore de compte ? '),
                          TextSpan(
                            text: 'Créer un compte',
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

// ─── Switch segmenté Email / Identifiant ──────────────────────────────────

class _SegmentedSwitch extends StatelessWidget {
  const _SegmentedSwitch({required this.selected, required this.onChanged});
  final _LoginMode selected;
  final ValueChanged<_LoginMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ScolarColors.creamDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _SegmentedItem(
            label: 'Email',
            active: selected == _LoginMode.email,
            onTap: () => onChanged(_LoginMode.email),
          ),
          _SegmentedItem(
            label: 'Identifiant',
            active: selected == _LoginMode.identifier,
            onTap: () => onChanged(_LoginMode.identifier),
          ),
        ],
      ),
    );
  }
}

class _SegmentedItem extends StatelessWidget {
  const _SegmentedItem({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? ScolarColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: active ? ScolarColors.ink : ScolarColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}
