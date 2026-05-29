/// Contrat du repository des devoirs.
abstract class HomeworksRepository {
  Future<List<Homework>> fetchAll();
  Future<int> countPending();
  Future<void> setDone(String id, {required bool done});
}

class Homework {
  const Homework({
    required this.id,
    required this.subjectName,
    required this.title,
    required this.dueDate,
    this.description,
    this.isDone = false,
  });

  final String id;
  final String subjectName;
  final String title;
  final String? description;
  final DateTime dueDate;
  final bool isDone;

  Homework copyWith({bool? isDone}) => Homework(
    id: id,
    subjectName: subjectName,
    title: title,
    description: description,
    dueDate: dueDate,
    isDone: isDone ?? this.isDone,
  );

  bool get isOverdue =>
      !isDone && dueDate.isBefore(DateTime.now()) && !_isToday();

  bool _isToday() {
    final now = DateTime.now();
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }
}
