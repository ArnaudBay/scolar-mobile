import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  static final List<Map<String, dynamic>> _upcomingCourses = [
    {
      'time': '10:00',
      'title': 'Mathématiques',
      'subtitle': 'Mme Ngouabi · Salle B12',
      'barColor': AppColors.barBlue,
      'isOngoing': true,
    },
    {
      'time': '11:00',
      'title': 'Physique-Chimie',
      'subtitle': 'M. Mokoko · Salle C04',
      'barColor': AppColors.barOrange,
      'isOngoing': false,
    },
    {
      'time': '14:00',
      'title': 'Philosophie',
      'subtitle': 'Mme Yandé · Salle A21',
      'barColor': AppColors.barIndigo,
      'isOngoing': false,
    },
  ];

  static final List<Map<String, dynamic>> _recentGrades = [
    {
      'initials': 'Ma',
      'subject': 'Mathématiques',
      'delta': '+1.2',
      'avatarColor': Color(0xFF8B5CF6),
    },
    {
      'initials': 'Hi',
      'subject': 'Histoire',
      'delta': '+0.5',
      'avatarColor': AppColors.cardOrange,
    },
    {
      'initials': 'Fr',
      'subject': 'Français',
      'delta': '-0.3',
      'avatarColor': AppColors.barBlue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildHeroSection()),
            SliverToBoxAdapter(child: _buildStatsRow()),
            SliverToBoxAdapter(child: _buildUpcomingCourses()),
            SliverToBoxAdapter(child: _buildRecentGrades()),
            const SliverToBoxAdapter(child: SizedBox(height: 90)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const _ScolarLogoWidget(),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour,',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Aminata',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
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

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Ta semaine\nen un coup d\'œil.',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Terminale S · Lycée Pierre-Marie de Bangui',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardNavy,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '15.2',
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textOnDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Moyenne\ngénérale',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xE6FFFFFF),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardOrange,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '5',
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textOnDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cours\naujourd\'hui',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xF2FFFFFF),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3',
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Devoirs à\nrendre',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionLabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            actionLabel,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingCourses() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Prochains cours', 'Voir tout'),
          const SizedBox(height: 14),
          Column(
            children: _upcomingCourses.map((course) {
              return Padding(
                key: ValueKey(course['time']),
                padding: const EdgeInsets.only(bottom: 10),
                child: _CourseItem(
                  time: course['time'] as String,
                  title: course['title'] as String,
                  subtitle: course['subtitle'] as String,
                  barColor: course['barColor'] as Color,
                  isOngoing: course['isOngoing'] as bool,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentGrades() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Notes récentes', 'Voir tout'),
          const SizedBox(height: 14),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _recentGrades.map((grade) {
                final bool isPositive = grade['delta'].toString().startsWith(
                  '+',
                );
                return Padding(
                  key: ValueKey(grade['initials']),
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 110,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
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
                          children: [
                            Container(
                              height: 34,
                              width: 34,
                              decoration: BoxDecoration(
                                color: grade['avatarColor'] as Color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                grade['initials'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textOnDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              grade['delta'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isPositive
                                    ? AppColors.positive
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          grade['subject'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _NavItem(icon: Icons.home_rounded, label: 'Accueil', isActive: true),
          _NavItem(
            icon: Icons.note_alt_outlined,
            label: 'Notes',
            isActive: false,
          ),
          _NavItem(
            icon: Icons.calendar_month_outlined,
            label: 'Planning',
            isActive: false,
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: 'Profil',
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class _ScolarLogoWidget extends StatelessWidget {
  const _ScolarLogoWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CustomPaint(painter: _ScolarLogoPainter()),
    );
  }
}

class _ScolarLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double cell = 17;
    const double spacing = 3;
    final paint = Paint()..color = Colors.white;

    final topLeftCenter = Offset(cell / 2, cell / 2);
    canvas.drawCircle(topLeftCenter, cell / 2, paint);

    final topRightCenter = Offset(cell + spacing + cell / 2, cell / 2);
    canvas.drawCircle(topRightCenter, cell / 2, paint);
    canvas.drawCircle(
      topRightCenter,
      cell / 2 - 4,
      Paint()..color = AppColors.primary,
    );

    final bottomLeftRect = Rect.fromLTWH(0, cell + spacing, cell, cell);
    canvas.drawArc(bottomLeftRect, 3.14159, 3.14159, true, paint);

    final bottomRightRect = Rect.fromLTWH(
      cell + spacing,
      cell + spacing,
      cell,
      cell,
    );
    final bottomRightRRect = RRect.fromRectAndCorners(
      bottomRightRect,
      bottomLeft: const Radius.circular(8),
      bottomRight: const Radius.circular(8),
    );
    canvas.drawRRect(bottomRightRRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
          color: AppColors.textPrimary,
        ),
        Positioned(
          right: -1,
          top: -1,
          child: Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
              color: AppColors.notifDot,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _CourseItem extends StatelessWidget {
  const _CourseItem({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.barColor,
    required this.isOngoing,
  });

  final String time;
  final String title;
  final String subtitle;
  final Color barColor;
  final bool isOngoing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
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
            width: 42,
            child: Text(
              time,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            width: 4,
            height: 50,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isOngoing) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.badgeBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'EN COURS',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textOnDark,
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24,
          color: isActive ? AppColors.primary : AppColors.textSecondary,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
