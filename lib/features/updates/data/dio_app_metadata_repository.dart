import 'package:dio/dio.dart';

import '../domain/app_metadata_repository.dart';

/// Impl Dio — `GET /app/metadata` → `{ min_version: "1.0.0", latest_version: "1.2.3" }`.
class DioAppMetadataRepository implements AppMetadataRepository {
  DioAppMetadataRepository(this._dio);
  final Dio _dio;

  @override
  Future<AppMetadata> fetch() async {
    final response = await _dio.get<Map<String, dynamic>>('/app/metadata');
    final data = response.data ?? const <String, dynamic>{};
    return AppMetadata(
      minVersion: (data['min_version'] as String?) ?? '1.0.0',
      latestVersion: (data['latest_version'] as String?) ?? '1.0.0',
    );
  }
}
