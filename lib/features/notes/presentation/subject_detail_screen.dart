import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/fr_date.dart';
import '../../../theme/scolar_theme.dart';
import '../domain/notes_repository.dart';
import 'notes_providers.dart';

/// Détail des notes d'une matière donnée.
class SubjectDetailScreen extends ConsumerWidget {
  const SubjectDetailScreen({super.key, required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradesAsync = ref.watch(gradesForSubjectProvider(subjectId));
    final subjectsAsync = ref.watch(subjectsProvider);

    final subject = subjectsAsync.maybeWhen(
      data: (list) => list.firstWhere(
        (s) => s.id == subjectId,
        orElse: () => const Subject(id: '?', name: '—', average: 0),
      ),
      orElse: () => const Subject(id: '?', name: '...', average: 0),
    );

    return Scaffold(
      backgroundColor: ScolarColors.background,
      appBar: AppBar(title: Text(subject.name)),
      body: gradesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(ScolarSpacing.lg),
            child: Text('Erreur : $e', style: ScolarTypography.body),
          ),
        ),
        data: (grades) => ListView(
          padding: const EdgeInsets.all(ScolarSpacing.md),
          children: [
            _AverageHero(subject: subject),
            const SizedBox(height: ScolarSpacing.lg),
            Text('Notes du trimestre', style: ScolarTypography.h3),
            const SizedBox(height: ScolarSpacing.sm),
            if (grades.isEmpty)
              Padding(
                padding: const EdgeInsets.all(ScolarSpacing.lg),
                child: Text(
                  'Aucune note pour le moment.',
                  style: ScolarTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...grades.map((g) => _GradeTile(grade: g)),
          ],
        ),
      ),
    );
  }
}

class _AverageHero extends StatelessWidget {
  const _AverageHero({required this.subject});
  final Subject subject;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (subject.teacherName ?? '').toUpperCase(),
            style: ScolarTypography.label.copyWith(color: ScolarColors.white),
          ),
          const SizedBox(height: ScolarSpacing.sm),
          Text(
            subject.average.toStringAsFixed(2),
            style: ScolarTypography.display.copyWith(
              color: ScolarColors.white,
              fontSize: 56,
            ),
          ),
          Text(
            '/ 20 — moyenne du trimestre',
            style: ScolarTypography.bodySmall.copyWith(
              color: ScolarColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeTile extends StatelessWidget {
  const _GradeTile({required this.grade});
  final Grade grade;

  @override
  Widget build(BuildContext context) {
    final percent = grade.value / grade.max;
    final color = percent >= 0.5 ? ScolarColors.success : ScolarColors.danger;
    return Container(
      margin: const EdgeInsets.only(bottom: ScolarSpacing.sm),
      padding: const EdgeInsets.all(ScolarSpacing.md),
      decoration: BoxDecoration(
        color: ScolarColors.white,
        borderRadius: ScolarRadius.all16,
        boxShadow: ScolarShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: ScolarRadius.all12,
            ),
            alignment: Alignment.center,
            child: Text(
              grade.value.toStringAsFixed(
                grade.value.truncateToDouble() == grade.value ? 0 : 1,
              ),
              style: ScolarTypography.h3.copyWith(color: color),
            ),
          ),
          const SizedBox(width: ScolarSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(grade.label, style: ScolarTypography.body),
                const SizedBox(height: 4),
                Text(
                  '${FrDate.shortDate(grade.date)} · coef. ${grade.coefficient.toStringAsFixed(0)}',
                  style: ScolarTypography.caption,
                ),
              ],
            ),
          ),
          Text(
            '/ ${grade.max.toStringAsFixed(0)}',
            style: ScolarTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
