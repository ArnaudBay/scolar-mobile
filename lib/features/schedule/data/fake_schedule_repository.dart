import 'dart:async';

import '../domain/schedule_repository.dart';

/// Données mockées contextualisées Bangui — utilisées pendant Sprint 1.
///
/// Génère un emploi du temps déterministe pour toute semaine demandée, à
/// partir d'un pattern hebdomadaire fixe. Permet à l'écran de tester la
/// navigation semaine ±1 sans dépendre du backend.
class FakeScheduleRepository implements ScheduleRepository {
  /// Pattern : `(jour de la semaine 1=lundi … 5=vendredi, heure début, durée min, matière, prof, salle)`
  static const List<_SlotTemplate> _template = [
    _SlotTemplate(1, 8, 0, 90, 'Mathématiques', 'Mme Ngouabi', 'B12'),
    _SlotTemplate(1, 10, 0, 60, 'Physique-Chimie', 'M. Mokoko', 'C04'),
    _SlotTemplate(1, 14, 0, 120, 'Philosophie', 'Mme Yandé', 'A21'),
    _SlotTemplate(2, 8, 0, 60, 'Anglais', 'Mr. Koffi', 'L03'),
    _SlotTemplate(2, 9, 30, 90, 'Histoire-Géographie', 'M. Sangaré', 'A15'),
    _SlotTemplate(2, 14, 0, 120, 'SVT', 'Mme Bouenga', 'S02'),
    _SlotTemplate(3, 8, 0, 120, 'Mathématiques', 'Mme Ngouabi', 'B12'),
    _SlotTemplate(3, 10, 30, 60, 'Français', 'Mme Diallo', 'L01'),
    _SlotTemplate(4, 8, 0, 90, 'Physique-Chimie', 'M. Mokoko', 'C04'),
    _SlotTemplate(4, 10, 0, 60, 'Anglais', 'Mr. Koffi', 'L03'),
    _SlotTemplate(4, 14, 0, 120, 'Histoire-Géographie', 'M. Sangaré', 'A15'),
    _SlotTemplate(5, 9, 0, 90, 'Français', 'Mme Diallo', 'L01'),
    _SlotTemplate(5, 11, 0, 60, 'Philosophie', 'Mme Yandé', 'A21'),
    _SlotTemplate(5, 14, 0, 90, 'EPS', 'M. Mbaye', 'Gymnase'),
  ];

  @override
  Future<List<CourseSlot>> fetchWeek(DateTime weekStart) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    // Aligner weekStart au lundi 00:00.
    final monday = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    ).subtract(Duration(days: weekStart.weekday - 1));

    return _template
        .map((t) {
          final day = monday.add(Duration(days: t.dayOfWeek - 1));
          final start = DateTime(
            day.year,
            day.month,
            day.day,
            t.startHour,
            t.startMinute,
          );
          final end = start.add(Duration(minutes: t.durationMinutes));
          return CourseSlot(
            id: '${t.dayOfWeek}_${t.startHour}${t.startMinute}_${t.subjectName}',
            subjectName: t.subjectName,
            teacherName: t.teacherName,
            room: t.room,
            start: start,
            end: end,
          );
        })
        .toList(growable: false);
  }
}

class _SlotTemplate {
  const _SlotTemplate(
    this.dayOfWeek,
    this.startHour,
    this.startMinute,
    this.durationMinutes,
    this.subjectName,
    this.teacherName,
    this.room,
  );
  final int dayOfWeek;
  final int startHour;
  final int startMinute;
  final int durationMinutes;
  final String subjectName;
  final String teacherName;
  final String room;
}
