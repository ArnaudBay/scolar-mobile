/// Contrat du repository des notes / résultats scolaires.
///
/// Implémenté par Dev 4 en Sprint 1 (branche `feature/notes`).
abstract class NotesRepository {
  /// Liste des matières de l'élève courant avec leur moyenne.
  Future<List<Subject>> fetchSubjects();

  /// Détail des notes d'une matière.
  Future<List<Grade>> fetchGrades(String subjectId);

  /// Moyenne générale de l'élève courant.
  Future<double> fetchOverallAverage();
}

class Subject {
  const Subject({
    required this.id,
    required this.name,
    required this.average,
    this.teacherName,
  });
  final String id;
  final String name;
  final double average;
  final String? teacherName;
}

class Grade {
  const Grade({
    required this.id,
    required this.label,
    required this.value,
    required this.max,
    required this.date,
    this.coefficient = 1,
  });
  final String id;
  final String label;
  final double value;
  final double max;
  final DateTime date;
  final double coefficient;
}
