import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/scolar_theme.dart';
import 'update_providers.dart';

/// Écran **non-dismissible** affiché quand la version installée est
/// inférieure au minimum requis. Seule action possible : aller mettre à
/// jour l'app sur le store.
class UpdateRequiredScreen extends ConsumerWidget {
  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: ScolarColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(ScolarSpacing.screenPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.system_update_alt,
                  size: 72,
                  color: ScolarColors.primary,
                ),
                const SizedBox(height: ScolarSpacing.lg),
                Text(
                  'Mise à jour requise',
                  style: ScolarTypography.h1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ScolarSpacing.md),
                Text(
                  'Une nouvelle version de Scolar est disponible. '
                  'Mets l\'application à jour pour continuer.',
                  style: ScolarTypography.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ScolarSpacing.xl),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(updateServiceProvider).launchUpdate(),
                  child: const Text('Mettre à jour'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
