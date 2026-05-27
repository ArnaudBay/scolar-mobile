// ──────────────────────────────────────────────────────────────────────────
// Scolar — Design System pour Flutter
// Version 1.0 · Mai 2026
//
// Source unique de vérité pour les couleurs, typographies, espacements,
// rayons et ombres de l'application Scolar.
//
// Les polices sont fournies via le package `google_fonts`
// (DM Serif Display + DM Sans). Aucun fichier .ttf à embarquer.
// ──────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ╔══════════════════════════════════════════════════════════════════════╗
// ║                          1. COULEURS                                 ║
// ╚══════════════════════════════════════════════════════════════════════╝

class ScolarColors {
  ScolarColors._();

  /// Bleu électrique — boutons primaires, accents, en-têtes.
  static const Color primary = Color(0xFF0D02FE);

  /// Bleu profond — état hover / pressed des boutons.
  static const Color primaryDark = Color(0xFF0A02CC);

  /// Bleu glacé — fonds doux, surfaces secondaires.
  static const Color secondary = Color(0xFFEEF1FF);

  /// Orange vif — mises en valeur, badges, notes hautes.
  static const Color accent = Color(0xFFFF6B00);

  /// Encre navy — texte principal, titres.
  static const Color text = Color(0xFF0A2540);

  /// Gris ardoise — texte secondaire, légendes.
  static const Color muted = Color(0xFF6B7B95);

  /// Blanc pur — cartes, fonds d'écran principaux.
  static const Color white = Color(0xFFFFFFFF);

  /// Bordure douce — séparateurs, contours discrets.
  static const Color border = Color(0xFFE5E9F5);

  /// Fond de page neutre (hors écrans principaux).
  static const Color background = Color(0xFFF7F8FC);

  /// Vert validation — états positifs, tendance ↑.
  static const Color success = Color(0xFF10B981);

  /// Rouge alerte — erreurs, tendance ↓, suppression.
  static const Color danger = Color(0xFFEF4444);

  /// MaterialColor swatch pour ThemeData.primarySwatch.
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF0D02FE,
    <int, Color>{
      50:  Color(0xFFEEF1FF),
      100: Color(0xFFD6DEFF),
      200: Color(0xFFB0B8FF),
      300: Color(0xFF8090FF),
      400: Color(0xFF4D5BFF),
      500: Color(0xFF0D02FE),
      600: Color(0xFF0B02E5),
      700: Color(0xFF0A02CC),
      800: Color(0xFF0801B3),
      900: Color(0xFF050099),
    },
  );
}

// ╔══════════════════════════════════════════════════════════════════════╗
// ║                          2. TYPOGRAPHIE                              ║
// ╚══════════════════════════════════════════════════════════════════════╝

class ScolarTypography {
  ScolarTypography._();

  static TextStyle _serif({
    required double fontSize,
    double? height,
    double? letterSpacing,
    Color color = ScolarColors.text,
  }) =>
      GoogleFonts.dmSerifDisplay(
        fontSize: fontSize,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );

  static TextStyle _sans({
    required double fontSize,
    double? height,
    FontWeight fontWeight = FontWeight.w400,
    double? letterSpacing,
    Color color = ScolarColors.text,
  }) =>
      GoogleFonts.dmSans(
        fontSize: fontSize,
        height: height,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        color: color,
      );

  // ─── Headings (DM Serif Display) ──────────────────────────────────────

  /// Display — Splash, hero wordmark.
  static TextStyle get display =>
      _serif(fontSize: 56, height: 1.07, letterSpacing: -1.2);

  /// H1 — titres principaux d'écran.
  static TextStyle get h1 =>
      _serif(fontSize: 36, height: 1.10, letterSpacing: -0.5);

  /// H2 — titres de section.
  static TextStyle get h2 =>
      _serif(fontSize: 24, height: 1.16, letterSpacing: -0.3);

  /// H3 — sous-titres, cartes.
  static TextStyle get h3 =>
      _serif(fontSize: 20, height: 1.20, letterSpacing: -0.2);

  /// Chiffres mis en valeur — moyennes, notes.
  static TextStyle get numeric =>
      _serif(fontSize: 26, height: 1.0, letterSpacing: -0.5);

  // ─── Body (DM Sans) ───────────────────────────────────────────────────

  /// Corps de texte principal.
  static TextStyle get body => _sans(fontSize: 16, height: 1.50);

  /// Corps de texte secondaire / légendes.
  static TextStyle get bodySmall =>
      _sans(fontSize: 14, height: 1.50, color: ScolarColors.muted);

  /// Label de champ — UPPERCASE, gras, espacé.
  static TextStyle get label => _sans(
        fontSize: 11,
        height: 1.20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: ScolarColors.primary,
      );

  /// Texte de bouton.
  static TextStyle get button => _sans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: ScolarColors.white,
      );

  /// Caption — micro-texte, méta-informations.
  static TextStyle get caption => _sans(
        fontSize: 12,
        height: 1.40,
        fontWeight: FontWeight.w500,
        color: ScolarColors.muted,
      );
}

// ╔══════════════════════════════════════════════════════════════════════╗
// ║                3. ESPACEMENTS / RAYONS / OMBRES                      ║
// ╚══════════════════════════════════════════════════════════════════════╝

class ScolarSpacing {
  ScolarSpacing._();
  /// Échelle 4 px — utiliser uniquement ces valeurs.
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 16;
  static const double lg   = 24;
  static const double xl   = 32;
  static const double xxl  = 48;
  static const double xxxl = 64;

  /// Marge latérale standard d'un écran mobile.
  static const double screenPadding = 24;
}

class ScolarRadius {
  ScolarRadius._();
  static const double sm   = 12;
  static const double md   = 16;
  static const double lg   = 20;
  static const double xl   = 28;
  static const double pill = 999;

  static const BorderRadius all12 = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius all16 = BorderRadius.all(Radius.circular(md));
  static const BorderRadius all20 = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius all28 = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius allPill = BorderRadius.all(Radius.circular(pill));
}

class ScolarShadows {
  ScolarShadows._();

  /// Ombre douce — cartes neutres.
  static const List<BoxShadow> soft = <BoxShadow>[
    BoxShadow(
      color: Color.fromRGBO(10, 37, 64, 0.07),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// Ombre de marque — boutons primaires, CTA.
  static const List<BoxShadow> brand = <BoxShadow>[
    BoxShadow(
      color: Color.fromRGBO(13, 2, 254, 0.18),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  /// Ombre élevée — modales, éléments flottants.
  static const List<BoxShadow> elevated = <BoxShadow>[
    BoxShadow(
      color: Color.fromRGBO(10, 37, 64, 0.16),
      blurRadius: 50,
      offset: Offset(0, 24),
    ),
  ];
}

// ╔══════════════════════════════════════════════════════════════════════╗
// ║                          4. THÈME GLOBAL                             ║
// ╚══════════════════════════════════════════════════════════════════════╝

class ScolarTheme {
  ScolarTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        primaryColor: ScolarColors.primary,
        scaffoldBackgroundColor: ScolarColors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ScolarColors.primary,
          primary: ScolarColors.primary,
          onPrimary: ScolarColors.white,
          secondary: ScolarColors.accent,
          onSecondary: ScolarColors.white,
          surface: ScolarColors.white,
          onSurface: ScolarColors.text,
          error: ScolarColors.danger,
        ),
        textTheme: TextTheme(
          displayLarge: ScolarTypography.display,
          headlineLarge: ScolarTypography.h1,
          headlineMedium: ScolarTypography.h2,
          headlineSmall: ScolarTypography.h3,
          bodyLarge: ScolarTypography.body,
          bodyMedium: ScolarTypography.bodySmall,
          labelLarge: ScolarTypography.button,
          labelMedium: ScolarTypography.label,
          labelSmall: ScolarTypography.caption,
        ),

        // ── Bouton primaire ────────────────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ScolarColors.primary,
            foregroundColor: ScolarColors.white,
            minimumSize: const Size.fromHeight(56),
            shape: const RoundedRectangleBorder(
              borderRadius: ScolarRadius.all20,
            ),
            textStyle: ScolarTypography.button,
            elevation: 0,
            shadowColor: ScolarColors.primary.withValues(alpha: 0.18),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
        ),

        // ── Bouton secondaire ──────────────────────────────────────────
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: ScolarColors.text,
            minimumSize: const Size.fromHeight(54),
            side: const BorderSide(color: ScolarColors.border, width: 1.5),
            shape: const RoundedRectangleBorder(
              borderRadius: ScolarRadius.all20,
            ),
            textStyle:
                ScolarTypography.button.copyWith(color: ScolarColors.text),
          ),
        ),

        // ── Bouton texte ───────────────────────────────────────────────
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: ScolarColors.primary,
            textStyle: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // ── Champs de saisie (underline minimaliste) ───────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          labelStyle: ScolarTypography.label,
          floatingLabelStyle: ScolarTypography.label,
          hintStyle: GoogleFonts.dmSans(
            fontSize: 16,
            color: ScolarColors.muted,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ScolarColors.border, width: 1.5),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ScolarColors.primary, width: 1.5),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ScolarColors.danger, width: 1.5),
          ),
        ),

        // ── App bar ────────────────────────────────────────────────────
        appBarTheme: AppBarTheme(
          backgroundColor: ScolarColors.white,
          foregroundColor: ScolarColors.text,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: ScolarTypography.h3,
          iconTheme: const IconThemeData(color: ScolarColors.text, size: 22),
        ),

        // ── Cards ──────────────────────────────────────────────────────
        cardTheme: const CardThemeData(
          color: ScolarColors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: ScolarRadius.all20),
        ),

        // ── Bottom navigation ──────────────────────────────────────────
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: ScolarColors.white,
          selectedItemColor: ScolarColors.primary,
          unselectedItemColor: ScolarColors.muted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showUnselectedLabels: true,
          selectedLabelStyle: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),

        // ── Chips (sélecteur de classe) ────────────────────────────────
        chipTheme: ChipThemeData(
          backgroundColor: ScolarColors.white,
          selectedColor: ScolarColors.primary,
          labelStyle: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ScolarColors.text,
          ),
          secondaryLabelStyle: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ScolarColors.white,
          ),
          side: const BorderSide(color: ScolarColors.border),
          shape: const RoundedRectangleBorder(
            borderRadius: ScolarRadius.allPill,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        ),
      );
}
