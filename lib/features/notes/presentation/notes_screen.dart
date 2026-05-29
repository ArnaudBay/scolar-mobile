import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../theme/scolar_theme.dart';
import '../domain/notes_repository.dart';
import 'notes_providers.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectsProvider);
    final averageAsync = ref.watch(overallAverageProvider);

    return Scaffold(
      backgroundColor: ScolarColors.background,
      appBar: AppBar(
        title: const Text('Mes notes'),
        backgroundColor: ScolarColors.background,
      ),
      body: subjectsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(ScolarSpacing.lg),
            child: Text('Erreur : $e', style: ScolarTypography.body),
          ),
        ),
        data: (subjects) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(subjectsProvider);
            ref.invalidate(overallAverageProvider);
            await ref.read(subjectsProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.all(ScolarSpacing.md),
            children: [
              _OverallAverageCard(averageAsync: averageAsync),
              const SizedBox(height: ScolarSpacing.lg),
              Text('Matières', style: ScolarTypography.h3),
              const SizedBox(height: ScolarSpacing.sm),
              ...subjects.map((s) => _SubjectTile(subject: s)),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverallAverageCard extends StatelessWidget {
  const _OverallAverageCard({required this.averageAsync});
  final AsyncValue<double> averageAsync;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ScolarSpacing.lg),
      decoration: BoxDecoration(
        color: ScolarColors.white,
        borderRadius: ScolarRadius.all20,
        boxShadow: ScolarShadows.soft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: ScolarColors.secondary,
              borderRadius: ScolarRadius.all16,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.trending_up_rounded,
              color: ScolarColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: ScolarSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Moyenne générale', style: ScolarTypography.label),
                const SizedBox(height: 4),
                averageAsync.when(
                  loading: () => const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, _) => Text('—', style: ScolarTypography.h2),
                  data: (avg) => Text(
                    '${avg.toStringAsFixed(2)} / 20',
                    style: ScolarTypography.h2,
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

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({required this.subject});
  final Subject subject;

  Color _averageColor() {
    if (subject.average >= 14) return ScolarColors.success;
    if (subject.average >= 10) return ScolarColors.primary;
    return ScolarColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final color = _averageColor();
    return Container(
      margin: const EdgeInsets.only(bottom: ScolarSpacing.sm),
      decoration: BoxDecoration(
        color: ScolarColors.white,
        borderRadius: ScolarRadius.all16,
        boxShadow: ScolarShadows.soft,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ScolarSpacing.md,
          vertical: ScolarSpacing.sm,
        ),
        shape: const RoundedRectangleBorder(borderRadius: ScolarRadius.all16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: ScolarRadius.all12,
          ),
          alignment: Alignment.center,
          child: Text(
            subject.average.toStringAsFixed(1),
            style: ScolarTypography.body.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(subject.name, style: ScolarTypography.body),
        subtitle: subject.teacherName == null
            ? null
            : Text(subject.teacherName!, style: ScolarTypography.caption),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: ScolarColors.muted,
        ),
        onTap: () => context.go(AppRoutes.noteDetailFor(subject.id)),
      ),
    );
  }
}
