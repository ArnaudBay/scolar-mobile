import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/scolar_theme.dart';
import '../../auth/domain/auth_state.dart';
import '../../auth/presentation/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: ScolarColors.background,
      appBar: AppBar(
        title: const Text('Mon profil'),
        backgroundColor: ScolarColors.background,
      ),
      body: switch (authState) {
        AuthLoading() => const Center(child: CircularProgressIndicator()),
        AuthUnauthenticated() => const Center(child: Text('Non connecté')),
        AuthAuthenticated(student: final student) => ListView(
          padding: const EdgeInsets.all(ScolarSpacing.md),
          children: [
            _ProfileHero(fullName: student.fullName, email: student.email),
            const SizedBox(height: ScolarSpacing.lg),
            if (student.classLabel != null)
              _InfoRow(label: 'Classe', value: student.classLabel!),
            if (student.schoolName != null)
              _InfoRow(label: 'Établissement', value: student.schoolName!),
            _InfoRow(label: 'Email', value: student.email),
            const SizedBox(height: ScolarSpacing.xl),
            OutlinedButton.icon(
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Se déconnecter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ScolarColors.danger,
                side: const BorderSide(color: ScolarColors.danger, width: 1.5),
              ),
              onPressed: () => _confirmLogout(context, ref),
            ),
          ],
        ),
      },
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text(
          'Tu devras te reconnecter pour accéder à tes notes et à ton emploi du temps.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Se déconnecter',
              style: TextStyle(color: ScolarColors.danger),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.fullName, required this.email});
  final String fullName;
  final String email;

  String get _initials {
    final parts = fullName
        .trim()
        .split(' ')
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ScolarSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ScolarColors.primary, ScolarColors.primaryDark],
        ),
        borderRadius: ScolarRadius.all20,
        boxShadow: ScolarShadows.brand,
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: ScolarColors.white.withValues(alpha: 0.18),
              borderRadius: ScolarRadius.all20,
            ),
            alignment: Alignment.center,
            child: Text(
              _initials,
              style: ScolarTypography.h2.copyWith(color: ScolarColors.white),
            ),
          ),
          const SizedBox(width: ScolarSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: ScolarTypography.h3.copyWith(
                    color: ScolarColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: ScolarTypography.bodySmall.copyWith(
                    color: ScolarColors.white,
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: ScolarSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: ScolarSpacing.md,
        vertical: ScolarSpacing.md,
      ),
      decoration: BoxDecoration(
        color: ScolarColors.white,
        borderRadius: ScolarRadius.all16,
        boxShadow: ScolarShadows.soft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: ScolarTypography.caption),
          ),
          Expanded(child: Text(value, style: ScolarTypography.body)),
        ],
      ),
    );
  }
}
