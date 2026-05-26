import 'package:flutter/material.dart';

import '../../theme/scolar_theme.dart';

/// Écran vivant de référence du design system Scolar.
/// Utile pour les équipes design / dev — affiche couleurs, typographies,
/// boutons, champs, cartes et chips.
class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScolarColors.background,
      appBar: AppBar(title: const Text('Design System')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ScolarSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _Section(title: 'Couleurs', child: _ColorGrid()),
            SizedBox(height: ScolarSpacing.xl),
            _Section(title: 'Typographie', child: _TypographyList()),
            SizedBox(height: ScolarSpacing.xl),
            _Section(title: 'Boutons', child: _ButtonsBlock()),
            SizedBox(height: ScolarSpacing.xl),
            _Section(title: 'Champ de saisie', child: _InputBlock()),
            SizedBox(height: ScolarSpacing.xl),
            _Section(title: 'Carte', child: _CardBlock()),
            SizedBox(height: ScolarSpacing.xl),
            _Section(title: 'Chips', child: _ChipsBlock()),
            SizedBox(height: ScolarSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: ScolarTypography.h2),
        const SizedBox(height: ScolarSpacing.md),
        child,
      ],
    );
  }
}

// ─── Couleurs ──────────────────────────────────────────────────────────

class _ColorGrid extends StatelessWidget {
  const _ColorGrid();

  @override
  Widget build(BuildContext context) {
    const swatches = <_Swatch>[
      _Swatch('primary', ScolarColors.primary),
      _Swatch('primaryDark', ScolarColors.primaryDark),
      _Swatch('secondary', ScolarColors.secondary),
      _Swatch('accent', ScolarColors.accent),
      _Swatch('text', ScolarColors.text),
      _Swatch('muted', ScolarColors.muted),
      _Swatch('border', ScolarColors.border),
      _Swatch('background', ScolarColors.background),
      _Swatch('success', ScolarColors.success),
      _Swatch('danger', ScolarColors.danger),
    ];
    return Wrap(
      spacing: ScolarSpacing.sm,
      runSpacing: ScolarSpacing.sm,
      children: swatches.map((s) => s).toList(),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color);
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: ScolarRadius.all12,
              border: Border.all(color: ScolarColors.border),
            ),
          ),
          const SizedBox(height: ScolarSpacing.xs),
          Text(name, style: ScolarTypography.caption),
        ],
      ),
    );
  }
}

// ─── Typographie ───────────────────────────────────────────────────────

class _TypographyList extends StatelessWidget {
  const _TypographyList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display', style: ScolarTypography.display),
        const SizedBox(height: ScolarSpacing.sm),
        Text('Titre H1', style: ScolarTypography.h1),
        const SizedBox(height: ScolarSpacing.sm),
        Text('Titre H2', style: ScolarTypography.h2),
        const SizedBox(height: ScolarSpacing.sm),
        Text('Titre H3', style: ScolarTypography.h3),
        const SizedBox(height: ScolarSpacing.sm),
        Text('14.75', style: ScolarTypography.numeric),
        const SizedBox(height: ScolarSpacing.md),
        Text(
          'Corps — Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          style: ScolarTypography.body,
        ),
        const SizedBox(height: ScolarSpacing.sm),
        Text('Body small — texte secondaire.', style: ScolarTypography.bodySmall),
        const SizedBox(height: ScolarSpacing.sm),
        Text('LABEL DE CHAMP', style: ScolarTypography.label),
        const SizedBox(height: ScolarSpacing.sm),
        Text('Caption — méta-info', style: ScolarTypography.caption),
      ],
    );
  }
}

// ─── Boutons ───────────────────────────────────────────────────────────

class _ButtonsBlock extends StatelessWidget {
  const _ButtonsBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: ScolarRadius.all20,
            boxShadow: ScolarShadows.brand,
          ),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Bouton primaire'),
          ),
        ),
        const SizedBox(height: ScolarSpacing.sm),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Bouton secondaire'),
        ),
        const SizedBox(height: ScolarSpacing.sm),
        TextButton(
          onPressed: () {},
          child: const Text('Bouton texte'),
        ),
      ],
    );
  }
}

// ─── Champs ────────────────────────────────────────────────────────────

class _InputBlock extends StatelessWidget {
  const _InputBlock();

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        labelText: 'EMAIL',
        hintText: 'eleve@scolar.fr',
      ),
    );
  }
}

// ─── Carte ─────────────────────────────────────────────────────────────

class _CardBlock extends StatelessWidget {
  const _CardBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ScolarSpacing.lg),
      decoration: const BoxDecoration(
        color: ScolarColors.white,
        borderRadius: ScolarRadius.all20,
        boxShadow: ScolarShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Moyenne générale', style: ScolarTypography.label),
          const SizedBox(height: ScolarSpacing.xs),
          Text('14,75 / 20', style: ScolarTypography.h1),
          const SizedBox(height: ScolarSpacing.xs),
          Text('En hausse depuis le trimestre dernier',
              style: ScolarTypography.bodySmall),
        ],
      ),
    );
  }
}

// ─── Chips ─────────────────────────────────────────────────────────────

class _ChipsBlock extends StatelessWidget {
  const _ChipsBlock();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: ScolarSpacing.sm,
      runSpacing: ScolarSpacing.sm,
      children: [
        ChoiceChip(label: const Text('Toutes'), selected: true, onSelected: (_) {}),
        ChoiceChip(label: const Text('Maths'), selected: false, onSelected: (_) {}),
        ChoiceChip(label: const Text('Français'), selected: false, onSelected: (_) {}),
        ChoiceChip(label: const Text('Histoire'), selected: false, onSelected: (_) {}),
      ],
    );
  }
}
