import 'package:dio/dio.dart';

import '../domain/homeworks_repository.dart';

/// Impl Dio — `ApiConfig.useFakes = false`.
///
/// Endpoints attendus :
///   GET  /students/me/homeworks
///   GET  /students/me/homeworks/pending-count → { count: 3 }
///   POST /students/me/homeworks/:id/done      body: { done: true }
class DioHomeworksRepository implements HomeworksRepository {
  DioHomeworksRepository(this._dio);
  final Dio _dio;

  @override
  Future<List<Homework>> fetchAll() async {
    final response = await _dio.get<List<dynamic>>('/students/me/homeworks');
    return (response.data ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(_parse)
        .toList(growable: false);
  }

  @override
  Future<int> countPending() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/students/me/homeworks/pending-count',
    );
    final v = response.data?['count'];
    return v is int ? v : 0;
  }

  @override
  Future<void> setDone(String id, {required bool done}) async {
    await _dio.post<void>(
      '/students/me/homeworks/$id/done',
      data: {'done': done},
    );
  }

  Homework _parse(Map<String, dynamic> raw) => Homework(
    id: raw['id'] as String,
    subjectName: raw['subject_name'] as String,
    title: raw['title'] as String,
    description: raw['description'] as String?,
    dueDate: DateTime.parse(raw['due_date'] as String),
    isDone: (raw['is_done'] as bool?) ?? false,
  );
}
