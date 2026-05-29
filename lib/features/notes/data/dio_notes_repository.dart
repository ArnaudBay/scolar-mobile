import 'package:dio/dio.dart';

import '../domain/notes_repository.dart';

/// Impl Dio — utilisée quand `ApiConfig.useFakes = false`.
///
/// Endpoints attendus :
///   GET /students/me/subjects                 → [{id, name, average, teacher_name}]
///   GET /students/me/subjects/:id/grades      → [{id, label, value, max, date, coefficient}]
///   GET /students/me/overall-average          → { value: 14.5 }
class DioNotesRepository implements NotesRepository {
  DioNotesRepository(this._dio);
  final Dio _dio;

  @override
  Future<List<Subject>> fetchSubjects() async {
    final response = await _dio.get<List<dynamic>>('/students/me/subjects');
    return (response.data ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(_parseSubject)
        .toList(growable: false);
  }

  @override
  Future<List<Grade>> fetchGrades(String subjectId) async {
    final response = await _dio.get<List<dynamic>>(
      '/students/me/subjects/$subjectId/grades',
    );
    return (response.data ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(_parseGrade)
        .toList(growable: false);
  }

  @override
  Future<double> fetchOverallAverage() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/students/me/overall-average',
    );
    final value = response.data?['value'];
    if (value is num) return value.toDouble();
    return 0;
  }

  Subject _parseSubject(Map<String, dynamic> raw) => Subject(
    id: raw['id'] as String,
    name: raw['name'] as String,
    average: (raw['average'] as num).toDouble(),
    teacherName: raw['teacher_name'] as String?,
  );

  Grade _parseGrade(Map<String, dynamic> raw) => Grade(
    id: raw['id'] as String,
    label: raw['label'] as String,
    value: (raw['value'] as num).toDouble(),
    max: (raw['max'] as num).toDouble(),
    date: DateTime.parse(raw['date'] as String),
    coefficient: ((raw['coefficient'] as num?) ?? 1).toDouble(),
  );
}
