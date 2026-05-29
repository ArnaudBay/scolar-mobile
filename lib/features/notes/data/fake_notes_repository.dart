import 'dart:async';

import '../domain/notes_repository.dart';

/// Données mockées contextualisées Bangui — utilisées pendant Sprint 1.
class FakeNotesRepository implements NotesRepository {
  static final List<Subject> _subjects = [
    const Subject(
      id: 'maths',
      name: 'Mathématiques',
      average: 16.2,
      teacherName: 'Mme Ngouabi',
    ),
    const Subject(
      id: 'physique',
      name: 'Physique-Chimie',
      average: 14.5,
      teacherName: 'M. Mokoko',
    ),
    const Subject(
      id: 'francais',
      name: 'Français',
      average: 13.8,
      teacherName: 'Mme Diallo',
    ),
    const Subject(
      id: 'philo',
      name: 'Philosophie',
      average: 12.9,
      teacherName: 'Mme Yandé',
    ),
    const Subject(
      id: 'histoire',
      name: 'Histoire-Géographie',
      average: 15.1,
      teacherName: 'M. Sangaré',
    ),
    const Subject(
      id: 'anglais',
      name: 'Anglais',
      average: 17.3,
      teacherName: 'Mr. Koffi',
    ),
    const Subject(
      id: 'svt',
      name: 'SVT',
      average: 14.0,
      teacherName: 'Mme Bouenga',
    ),
  ];

  static final Map<String, List<Grade>> _grades = {
    'maths': [
      Grade(
        id: 'm1',
        label: 'DS — Fonctions',
        value: 17,
        max: 20,
        date: DateTime(2026, 5, 12),
        coefficient: 2,
      ),
      Grade(
        id: 'm2',
        label: 'DM — Suites',
        value: 15,
        max: 20,
        date: DateTime(2026, 5, 5),
      ),
      Grade(
        id: 'm3',
        label: 'Interrogation',
        value: 16.5,
        max: 20,
        date: DateTime(2026, 4, 22),
      ),
    ],
    'physique': [
      Grade(
        id: 'p1',
        label: 'TP — Électricité',
        value: 14,
        max: 20,
        date: DateTime(2026, 5, 10),
      ),
      Grade(
        id: 'p2',
        label: 'DS — Mécanique',
        value: 15,
        max: 20,
        date: DateTime(2026, 4, 28),
        coefficient: 2,
      ),
    ],
    'francais': [
      Grade(
        id: 'f1',
        label: 'Dissertation',
        value: 13,
        max: 20,
        date: DateTime(2026, 5, 8),
        coefficient: 2,
      ),
      Grade(
        id: 'f2',
        label: 'Commentaire',
        value: 14.5,
        max: 20,
        date: DateTime(2026, 4, 15),
      ),
    ],
    'philo': [
      Grade(
        id: 'ph1',
        label: 'Dissertation',
        value: 12,
        max: 20,
        date: DateTime(2026, 5, 3),
      ),
      Grade(
        id: 'ph2',
        label: 'Explication de texte',
        value: 13.5,
        max: 20,
        date: DateTime(2026, 4, 18),
      ),
    ],
    'histoire': [
      Grade(
        id: 'h1',
        label: 'Composition — Guerre froide',
        value: 15,
        max: 20,
        date: DateTime(2026, 5, 14),
        coefficient: 2,
      ),
    ],
    'anglais': [
      Grade(
        id: 'a1',
        label: 'Oral expression',
        value: 18,
        max: 20,
        date: DateTime(2026, 5, 11),
      ),
      Grade(
        id: 'a2',
        label: 'Writing',
        value: 16.5,
        max: 20,
        date: DateTime(2026, 4, 30),
      ),
    ],
    'svt': [
      Grade(
        id: 's1',
        label: 'TP — Génétique',
        value: 14,
        max: 20,
        date: DateTime(2026, 5, 9),
      ),
    ],
  };

  @override
  Future<List<Subject>> fetchSubjects() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_subjects);
  }

  @override
  Future<List<Grade>> fetchGrades(String subjectId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_grades[subjectId] ?? const <Grade>[]);
  }

  @override
  Future<double> fetchOverallAverage() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final sum = _subjects.fold<double>(0, (acc, s) => acc + s.average);
    return double.parse((sum / _subjects.length).toStringAsFixed(2));
  }
}
