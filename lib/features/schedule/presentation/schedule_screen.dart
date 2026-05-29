import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/fr_date.dart';
import '../../../theme/scolar_theme.dart';
import '../domain/schedule_repository.dart';
import 'schedule_providers.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekStart = ref.watch(selectedWeekProvider);
    final weekAsync = ref.watch(weekScheduleProvider);
    final weekEnd = weekStart.add(const Duration(days: 4));

    return Scaffold(
      backgroundColor: ScolarColors.background,
      appBar: AppBar(
        title: const Text('Emploi du temps'),
        backgroundColor: ScolarColors.background,
      ),
      body: Column(
        children: [
          _WeekNavigator(weekStart: weekStart, weekEnd: weekEnd),
          Expanded(
            child: weekAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(ScolarSpacing.lg),
                  child: Text('Erreur : $e', style: ScolarTypography.body),
                ),
              ),
              data: (slots) => _WeekContent(weekStart: weekStart, slots: slots),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekNavigator extends ConsumerWidget {
  const _WeekNavigator({required this.weekStart, required this.weekEnd});
  final DateTime weekStart;
  final DateTime weekEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(ScolarSpacing.md),
      padding: const EdgeInsets.symmetric(
        horizontal: ScolarSpacing.sm,
        vertical: ScolarSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: ScolarColors.white,
        borderRadius: ScolarRadius.all16,
        boxShadow: ScolarShadows.soft,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            color: ScolarColors.primary,
            onPressed: () => ref.read(selectedWeekProvider.notifier).state =
                weekStart.subtract(const Duration(days: 7)),
          ),
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Text(
                    '${FrDate.dayMonth(weekStart)} — ${FrDate.dayMonth(weekEnd)}',
                    style: ScolarTypography.body,
                  ),
                  Text(
                    FrDate.capitalize(FrDate.monthYear(weekStart)),
                    style: ScolarTypography.caption,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            color: ScolarColors.primary,
            onPressed: () => ref.read(selectedWeekProvider.notifier).state =
                weekStart.add(const Duration(days: 7)),
          ),
        ],
      ),
    );
  }
}

class _WeekContent extends StatelessWidget {
  const _WeekContent({required this.weekStart, required this.slots});
  final DateTime weekStart;
  final List<CourseSlot> slots;

  @override
  Widget build(BuildContext context) {
    final byDay = <int, List<CourseSlot>>{};
    for (final s in slots) {
      byDay.putIfAbsent(s.start.weekday, () => <CourseSlot>[]).add(s);
    }
    for (final list in byDay.values) {
      list.sort((a, b) => a.start.compareTo(b.start));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: ScolarSpacing.md),
      itemCount: 5, // lun → ven
      itemBuilder: (_, i) {
        final day = weekStart.add(Duration(days: i));
        final dayCourses = byDay[i + 1] ?? const <CourseSlot>[];
        return _DaySection(day: day, courses: dayCourses);
      },
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({required this.day, required this.courses});
  final DateTime day;
  final List<CourseSlot> courses;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ScolarSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: ScolarSpacing.xs,
              bottom: ScolarSpacing.sm,
            ),
            child: Text(
              FrDate.capitalize(FrDate.longDay(day)),
              style: ScolarTypography.label,
            ),
          ),
          if (courses.isEmpty)
            Container(
              padding: const EdgeInsets.all(ScolarSpacing.md),
              decoration: BoxDecoration(
                color: ScolarColors.white,
                borderRadius: ScolarRadius.all16,
                boxShadow: ScolarShadows.soft,
              ),
              child: Text('Pas de cours.', style: ScolarTypography.bodySmall),
            )
          else
            ...courses.map((c) => _CourseSlotTile(slot: c)),
        ],
      ),
    );
  }
}

class _CourseSlotTile extends StatelessWidget {
  const _CourseSlotTile({required this.slot});
  final CourseSlot slot;

  bool get _isOngoing {
    final now = DateTime.now();
    return now.isAfter(slot.start) && now.isBefore(slot.end);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: ScolarSpacing.sm),
      padding: const EdgeInsets.all(ScolarSpacing.md),
      decoration: BoxDecoration(
        color: ScolarColors.white,
        borderRadius: ScolarRadius.all16,
        boxShadow: ScolarShadows.soft,
        border: _isOngoing
            ? Border.all(color: ScolarColors.primary, width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FrDate.hourMinute(slot.start),
                style: ScolarTypography.body.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                FrDate.hourMinute(slot.end),
                style: ScolarTypography.caption,
              ),
            ],
          ),
          const SizedBox(width: ScolarSpacing.md),
          Container(
            width: 4,
            height: 44,
            decoration: BoxDecoration(
              color: _isOngoing ? ScolarColors.primary : ScolarColors.border,
              borderRadius: ScolarRadius.allPill,
            ),
          ),
          const SizedBox(width: ScolarSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(slot.subjectName, style: ScolarTypography.body),
                Text(
                  '${slot.teacherName} · Salle ${slot.room}',
                  style: ScolarTypography.caption,
                ),
              ],
            ),
          ),
          if (_isOngoing)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ScolarSpacing.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: ScolarColors.primary,
                borderRadius: ScolarRadius.allPill,
              ),
              child: Text(
                'EN COURS',
                style: ScolarTypography.label.copyWith(
                  color: ScolarColors.white,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
