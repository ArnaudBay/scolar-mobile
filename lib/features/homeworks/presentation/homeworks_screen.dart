import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/fr_date.dart';
import '../../../theme/scolar_theme.dart';
import '../domain/homeworks_repository.dart';
import 'homeworks_providers.dart';

class HomeworksScreen extends ConsumerWidget {
  const HomeworksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(homeworksProvider);

    return Scaffold(
      backgroundColor: ScolarColors.background,
      appBar: AppBar(
        title: const Text('Mes devoirs'),
        backgroundColor: ScolarColors.background,
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(ScolarSpacing.lg),
            child: Text('Erreur : $e', style: ScolarTypography.body),
          ),
        ),
        data: (homeworks) {
          if (homeworks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(ScolarSpacing.xl),
                child: Text(
                  'Aucun devoir à rendre. 🎉',
                  style: ScolarTypography.body,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(homeworksProvider);
              ref.invalidate(pendingHomeworksCountProvider);
              await ref.read(homeworksProvider.future);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(ScolarSpacing.md),
              itemCount: homeworks.length,
              itemBuilder: (_, i) => _HomeworkTile(homework: homeworks[i]),
            ),
          );
        },
      ),
    );
  }
}

class _HomeworkTile extends ConsumerWidget {
  const _HomeworkTile({required this.homework});
  final Homework homework;

  String _dueLabel() {
    final now = DateTime.now();
    final due = DateTime(
      homework.dueDate.year,
      homework.dueDate.month,
      homework.dueDate.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    final diff = due.difference(today).inDays;
    if (diff == 0) return 'Pour aujourd\'hui';
    if (diff == 1) return 'Pour demain';
    if (diff > 1) return 'Dans $diff jours';
    return 'En retard de ${-diff} j';
  }

  Color _accent() {
    if (homework.isDone) return ScolarColors.success;
    if (homework.isOverdue) return ScolarColors.danger;
    return ScolarColors.primary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = _accent();
    return Container(
      margin: const EdgeInsets.only(bottom: ScolarSpacing.sm),
      padding: const EdgeInsets.all(ScolarSpacing.md),
      decoration: BoxDecoration(
        color: ScolarColors.white,
        borderRadius: ScolarRadius.all16,
        boxShadow: ScolarShadows.soft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: homework.isDone
                ? 'Marquer comme non fait'
                : 'Marquer comme fait',
            button: true,
            checked: homework.isDone,
            child: GestureDetector(
              key: ValueKey('hw-toggle-${homework.id}'),
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                await ref
                    .read(homeworksRepositoryProvider)
                    .setDone(homework.id, done: !homework.isDone);
                ref.invalidate(homeworksProvider);
                ref.invalidate(pendingHomeworksCountProvider);
              },
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: homework.isDone ? accent : Colors.transparent,
                  border: Border.all(color: accent, width: 1.8),
                ),
                child: homework.isDone
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
          ),
          const SizedBox(width: ScolarSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  homework.subjectName.toUpperCase(),
                  style: ScolarTypography.label.copyWith(color: accent),
                ),
                const SizedBox(height: 2),
                Text(
                  homework.title,
                  style: ScolarTypography.body.copyWith(
                    decoration: homework.isDone
                        ? TextDecoration.lineThrough
                        : null,
                    color: homework.isDone
                        ? ScolarColors.muted
                        : ScolarColors.text,
                  ),
                ),
                if (homework.description != null) ...[
                  const SizedBox(height: 4),
                  Text(homework.description!, style: ScolarTypography.caption),
                ],
                const SizedBox(height: ScolarSpacing.sm),
                Row(
                  children: [
                    Icon(Icons.event_outlined, size: 14, color: accent),
                    const SizedBox(width: 4),
                    Text(
                      '${FrDate.shortDate(homework.dueDate)} · ${_dueLabel()}',
                      style: ScolarTypography.caption.copyWith(color: accent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
