import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/fr_date.dart';
import '../../../../shared/widgets/scolar_logo.dart';
import '../../../../theme/scolar_theme.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../auth/presentation/auth_controller.dart';
import '../../../homeworks/presentation/homeworks_providers.dart';
import '../../../notes/domain/notes_repository.dart';
import '../../../notes/presentation/notes_providers.dart';
import '../../../schedule/domain/schedule_repository.dart';
import '../../../schedule/presentation/schedule_providers.dart';

// Couleurs spécifiques au dashboard absentes du design system global —
// si elles deviennent réutilisées ailleurs, les remonter dans `ScolarColors`.
const Color _kCardNavy = Color(0xFF1E2452);
const Color _kBarIndigo = Color(0xFF6366F1);

class StudentHomePage extends ConsumerWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final firstName = switch (authState) {
      AuthAuthenticated(student: final s) => s.firstName,
      _ => 'Élève',
    };
    final classLabel = switch (authState) {
      AuthAuthenticated(student: final s) =>
        '${s.classLabel ?? "Terminale S"} · ${s.schoolName ?? "Lycée Pierre-Marie de Bangui"}',
      _ => '',
    };

    return ColoredBox(
      color: ScolarColors.background,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(overallAverageProvider);
            ref.invalidate(weekScheduleProvider);
            ref.invalidate(subjectsProvider);
            ref.invalidate(pendingHomeworksCountProvider);
            await ref.read(overallAverageProvider.future);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(child: _Header(firstName: firstName)),
              SliverToBoxAdapter(child: _Hero(classLabel: classLabel)),
              const SliverToBoxAdapter(child: _StatsRow()),
              const SliverToBoxAdapter(child: _UpcomingCourses()),
              const SliverToBoxAdapter(child: _RecentSubjects()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.firstName});
  final String firstName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const _BrandAvatar(),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour,',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: ScolarColors.muted,
                    ),
                  ),
                  Text(
                    firstName,
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 20,
                      color: ScolarColors.text,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const _NotificationBellWidget(),
        ],
      ),
    );
  }
}

class _BrandAvatar extends StatelessWidget {
  const _BrandAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: ScolarColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const ScolarLogoMark(size: 24),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.classLabel});
  final String classLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Ta semaine\nen un coup d\'œil.',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 32,
              color: ScolarColors.text,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: ScolarColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  classLabel,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ScolarColors.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}

// ─── Stats row ────────────────────────────────────────────────────────────

class _StatsRow extends ConsumerWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final averageAsync = ref.watch(overallAverageProvider);
    final todayAsync = ref.watch(todayScheduleProvider);
    final pendingHomeworksAsync = ref.watch(pendingHomeworksCountProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: _StatCard(
                background: _kCardNavy,
                value: averageAsync.maybeWhen(
                  data: (v) => v.toStringAsFixed(1),
                  orElse: () => '—',
                ),
                label: 'Moyenne\ngénérale',
                onTap: () => context.go(AppRoutes.notes),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: _StatCard(
                background: ScolarColors.accent,
                value: todayAsync.maybeWhen(
                  data: (slots) => slots.length.toString(),
                  orElse: () => '—',
                ),
                label: 'Cours\naujourd\'hui',
                onTap: () => context.go(AppRoutes.schedule),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: _StatCard(
                background: ScolarColors.white,
                textColor: ScolarColors.text,
                value: pendingHomeworksAsync.maybeWhen(
                  data: (c) => c.toString(),
                  orElse: () => '—',
                ),
                label: 'Devoirs à\nrendre',
                hasBorder: true,
                onTap: () => context.go(AppRoutes.homeworks),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.background,
    required this.value,
    required this.label,
    this.textColor = ScolarColors.white,
    this.hasBorder = false,
    this.onTap,
  });

  final Color background;
  final String value;
  final String label;
  final Color textColor;
  final bool hasBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: hasBorder
            ? Border.all(color: const Color(0xFFE5E7EB), width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.dmSerifDisplay(fontSize: 30, color: textColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textColor == ScolarColors.white
                  ? const Color(0xE6FFFFFF)
                  : ScolarColors.muted,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: card,
      ),
    );
  }
}

// ─── Upcoming courses ────────────────────────────────────────────────────

class _UpcomingCourses extends ConsumerWidget {
  const _UpcomingCourses();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayAsync = ref.watch(todayScheduleProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'Prochains cours',
            actionLabel: 'Voir tout',
            onAction: () => context.go(AppRoutes.schedule),
          ),
          const SizedBox(height: 14),
          todayAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('—', style: ScolarTypography.bodySmall),
            data: (slots) {
              final upcoming = _filterUpcoming(slots).take(3).toList();
              if (upcoming.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Pas d\'autre cours aujourd\'hui.',
                    style: ScolarTypography.bodySmall,
                  ),
                );
              }
              return Column(
                children: upcoming
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _CourseItem(slot: c),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  List<CourseSlot> _filterUpcoming(List<CourseSlot> all) {
    final now = DateTime.now();
    return all.where((c) => c.end.isAfter(now)).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
  }
}

class _CourseItem extends StatelessWidget {
  const _CourseItem({required this.slot});
  final CourseSlot slot;

  bool get _isOngoing {
    final now = DateTime.now();
    return now.isAfter(slot.start) && now.isBefore(slot.end);
  }

  Color get _barColor {
    final hash = slot.subjectName.hashCode.abs() % 3;
    switch (hash) {
      case 0:
        return ScolarColors.primary;
      case 1:
        return ScolarColors.accent;
      default:
        return _kBarIndigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ScolarColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              FrDate.hourMinute(slot.start),
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: ScolarColors.text,
              ),
            ),
          ),
          Container(
            width: 4,
            height: 50,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: _barColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.subjectName,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: ScolarColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${slot.teacherName} · Salle ${slot.room}',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ScolarColors.muted,
                  ),
                ),
              ],
            ),
          ),
          if (_isOngoing) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _kCardNavy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'EN COURS',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: ScolarColors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Recent subjects (carrousel) ──────────────────────────────────────────

class _RecentSubjects extends ConsumerWidget {
  const _RecentSubjects();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectsProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SectionHeader(
              title: 'Notes récentes',
              actionLabel: 'Voir tout',
              onAction: () => context.go(AppRoutes.notes),
            ),
          ),
          const SizedBox(height: 14),
          subjectsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => const SizedBox.shrink(),
            data: (subjects) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: subjects
                    .take(5)
                    .map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _SubjectChip(subject: s),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectChip extends StatelessWidget {
  const _SubjectChip({required this.subject});
  final Subject subject;

  Color _avatarColor() {
    final hash = subject.name.hashCode.abs() % 4;
    switch (hash) {
      case 0:
        return ScolarColors.primary;
      case 1:
        return ScolarColors.accent;
      case 2:
        return const Color(0xFF8B5CF6);
      default:
        return _kBarIndigo;
    }
  }

  String get _initials {
    final parts = subject.name.split(RegExp(r'[ -]'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first.substring(
      0,
      parts.first.length >= 2 ? 2 : 1,
    );
    return first[0].toUpperCase() + (first.length > 1 ? first[1] : '');
  }

  @override
  Widget build(BuildContext context) {
    final color = _avatarColor();
    final isPositive = subject.average >= 10;
    final deltaColor = isPositive ? ScolarColors.success : ScolarColors.danger;

    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ScolarColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  _initials,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ScolarColors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: deltaColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 10,
                      color: deltaColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      subject.average.toStringAsFixed(1),
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: deltaColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            subject.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ScolarColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bits réutilisables ───────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: ScolarColors.text,
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionLabel,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ScolarColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationBellWidget extends StatelessWidget {
  const _NotificationBellWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(
          Icons.notifications_none_rounded,
          size: 26,
          color: ScolarColors.text,
        ),
        Positioned(
          right: -1,
          top: -1,
          child: Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
              color: ScolarColors.accent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
