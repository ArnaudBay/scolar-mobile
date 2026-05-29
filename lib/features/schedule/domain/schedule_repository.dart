/// Contrat du repository de l'emploi du temps.
///
/// Implémenté par Dev 5 en Sprint 1 (branche `feature/schedule`).
abstract class ScheduleRepository {
  /// Récupère les cours d'une semaine donnée.
  ///
  /// [weekStart] = lundi 00h00 (heure locale).
  Future<List<CourseSlot>> fetchWeek(DateTime weekStart);
}

class CourseSlot {
  const CourseSlot({
    required this.id,
    required this.subjectName,
    required this.teacherName,
    required this.room,
    required this.start,
    required this.end,
  });

  final String id;
  final String subjectName;
  final String teacherName;
  final String room;
  final DateTime start;
  final DateTime end;

  Duration get duration => end.difference(start);
}
