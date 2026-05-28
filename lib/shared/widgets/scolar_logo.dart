import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/scolar_theme.dart';

/// Logomark Scolar — grille 2×2 de formes géométriques.
///
///  ┌──────────┬──────────┐
///  │  ●       │   ◎     │  cercle plein  |  anneau (donut)
///  ├──────────┼──────────┤
///  │  ∩       │   ∪     │  arche         |  écusson arrondi
///  └──────────┴──────────┘
class ScolarLogoMark extends StatelessWidget {
  const ScolarLogoMark({super.key, this.size = 64});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = ScolarColors.primary
      ..style = PaintingStyle.fill;

    final w = size.width;

    // Grille 2×2 : 10 % de gouttière, cellules de 45 % chacune.
    final gap = w * 0.10;
    final cell = (w - gap) / 2;

    final tlX = 0.0;          // origine X cellule haut-gauche
    final trX = cell + gap;   // origine X cellule haut-droite
    final topY = 0.0;         // origine Y rangée haute
    final botY = cell + gap;  // origine Y rangée basse

    // ── 1 · Cercle plein (haut-gauche) ────────────────────────────────
    canvas.drawCircle(
      Offset(tlX + cell / 2, topY + cell / 2),
      cell / 2,
      fill,
    );

    // ── 2 · Anneau / donut (haut-droite) ──────────────────────────────
    final rCenter = Offset(trX + cell / 2, topY + cell / 2);
    final outerO = Path()
      ..addOval(Rect.fromCircle(center: rCenter, radius: cell / 2));
    final innerO = Path()
      ..addOval(Rect.fromCircle(center: rCenter, radius: cell / 2 * 0.44));
    canvas.drawPath(
      Path.combine(PathOperation.difference, outerO, innerO),
      fill,
    );

    // ── 3 · Arche (bas-gauche) ─────────────────────────────────────────
    // Rectangle dont le sommet est un demi-cercle.
    final aL = tlX;
    final aR = tlX + cell;
    final aB = botY + cell;
    final aW = cell; 
    final aRad = aW / 2;
    final aMidY = botY + aRad; 

    final archPath = Path()
      ..moveTo(aL, aB)
      ..lineTo(aL, aMidY)
      ..arcTo(
        Rect.fromCenter(
          center: Offset(aL + aRad, aMidY),
          width: aW,
          height: aW,
        ),
        math.pi,   
        math.pi,   
        false,
      )
      ..lineTo(aR, aB)
      ..close();
    canvas.drawPath(archPath, fill);

    // ── 4 · Écusson arrondi (bas-droite) ──────────────────────────────
    final sL = trX;
    final sR = trX + cell;
    final sT = botY;
    final sB = botY + cell;
    final sW = cell;
    final sRad = sW / 2;
    final sMidY = sB - sRad; 

    final shieldPath = Path()
      ..moveTo(sL, sT)
      ..lineTo(sR, sT)
      ..lineTo(sR, sMidY)
      ..arcTo(
        Rect.fromCenter(
          center: Offset(sL + sRad, sMidY),
          width: sW,
          height: sW,
        ),
        0,         
        math.pi,   
        false,
      )
      ..close(); 
    canvas.drawPath(shieldPath, fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
