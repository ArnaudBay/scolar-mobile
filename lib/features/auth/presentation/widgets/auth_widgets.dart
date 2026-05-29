import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme/scolar_theme.dart';

/// Bouton back rond blanc utilisé dans les écrans d'auth (style img.png).
class CircleBackButton extends StatelessWidget {
  const CircleBackButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ScolarColors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            Icons.chevron_left_rounded,
            color: ScolarColors.ink,
            size: 22,
          ),
        ),
      ),
    );
  }
}

/// Label de champ en majuscules muted (style img.png).
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: ScolarColors.muted,
        letterSpacing: 0.8,
      ),
    );
  }
}

/// Champ blanc plat sans bordure visible (style img.png).
class FlatField extends StatelessWidget {
  const FlatField({
    super.key,
    required this.controller,
    this.hintText,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.validator,
  });

  final TextEditingController controller;
  final String? hintText;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      autocorrect: autocorrect,
      style: GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: ScolarColors.ink,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.dmSans(fontSize: 15, color: ScolarColors.muted),
        filled: true,
        fillColor: ScolarColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ScolarColors.ink, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ScolarColors.danger, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ScolarColors.danger, width: 1.4),
        ),
        errorStyle: GoogleFonts.dmSans(
          fontSize: 12,
          color: ScolarColors.danger,
        ),
      ),
      validator: validator,
    );
  }
}

/// CTA primaire noir façon img.png — pleine largeur, coins arrondis.
class BlackPillButton extends StatelessWidget {
  const BlackPillButton({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: busy ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ScolarColors.ink,
          foregroundColor: ScolarColors.white,
          disabledBackgroundColor: ScolarColors.ink.withValues(alpha: 0.4),
          disabledForegroundColor: ScolarColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          textStyle: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: busy
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: ScolarColors.white,
                ),
              )
            : Text(label),
      ),
    );
  }
}

/// Bannière d'erreur compacte sous un formulaire d'auth.
class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ScolarSpacing.sm),
      decoration: BoxDecoration(
        color: ScolarColors.danger.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: ScolarColors.danger, size: 18),
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
