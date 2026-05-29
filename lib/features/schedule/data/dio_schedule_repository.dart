import 'package:dio/dio.dart';

import '../domain/schedule_repository.dart';

/// Impl Dio — utilisée quand `ApiConfig.useFakes = false`.
///
/// Endpoints attendus :
///   GET /students/me/schedule?week_start=YYYY-MM-DD
///       → [{id, subject_name, teacher_name, room, start, end}]
class DioScheduleRepository implements ScheduleRepository {
  DioScheduleRepository(this._dio);
  final Dio _dio;

  @override
  Future<List<CourseSlot>> fetchWeek(DateTime weekStart) async {
    final iso = _isoDate(weekStart);
    final response = await _dio.get<List<dynamic>>(
      '/students/me/schedule',
      queryParameters: {'week_start': iso},
    );
    return (response.data ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(_parseSlot)
        .toList(growable: false);
  }

  CourseSlot _parseSlot(Map<String, dynamic> raw) => CourseSlot(
    id: raw['id'] as String,
    subjectName: raw['subject_name'] as String,
    teacherName: raw['teacher_name'] as String,
    room: raw['room'] as String,
    start: DateTime.parse(raw['start'] as String),
    end: DateTime.parse(raw['end'] as String),
  );

  String _isoDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }
}
