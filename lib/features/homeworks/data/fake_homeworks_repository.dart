import 'dart:async';

import '../domain/homeworks_repository.dart';

/// Données mockées — contextualisées Bangui, dates relatives à aujourd'hui.
class FakeHomeworksRepository implements HomeworksRepository {
  FakeHomeworksRepository() {
    final today = DateTime.now();
    DateTime addDays(int n) =>
        DateTime(today.year, today.month, today.day).add(Duration(days: n));

    _store = <String, Homework>{
      'hw1': Homework(
        id: 'hw1',
        subjectName: 'Mathématiques',
        title: 'Exercices fonctions ch. 7',
        description: 'Faire les exercices 12 à 18 page 142.',
        dueDate: addDays(1),
      ),
      'hw2': Homework(
        id: 'hw2',
        subjectName: 'Français',
        title: 'Dissertation — argumentation',
        description:
            'Sujet : "La fiction permet-elle de mieux comprendre le réel ?"',
        dueDate: addDays(3),
      ),
      'hw3': Homework(
        id: 'hw3',
        subjectName: 'Physique-Chimie',
        title: 'Compte-rendu de TP',
        description: 'TP sur les circuits RC — graphes et conclusion.',
        dueDate: addDays(0),
      ),
      'hw4': Homework(
        id: 'hw4',
        subjectName: 'Histoire-Géographie',
        title: 'Fiche de révision — décolonisation',
        dueDate: addDays(5),
      ),
      'hw5': Homework(
        id: 'hw5',
        subjectName: 'Anglais',
        title: 'Reading + 5 vocabulary cards',
        description: 'Chapter 4 of the assigned novel.',
        dueDate: addDays(-2),
        isDone: true,
      ),
    };
  }

  late final Map<String, Homework> _store;

  @override
  Future<List<Homework>> fetchAll() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final list = _store.values.toList()
      ..sort((a, b) {
        // Pending d'abord, triés par dueDate ; done à la fin.
        if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
        return a.dueDate.compareTo(b.dueDate);
      });
    return List.unmodifiable(list);
  }

  @override
  Future<int> countPending() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _store.values.where((h) => !h.isDone).length;
  }

  @override
  Future<void> setDone(String id, {required bool done}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final hw = _store[id];
    if (hw != null) _store[id] = hw.copyWith(isDone: done);
  }
}
