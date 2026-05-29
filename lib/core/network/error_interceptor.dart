import 'package:dio/dio.dart';

import '../errors/api_exception.dart';

/// Mappe les erreurs Dio vers des exceptions métier `ApiException`.
///
/// Permet à l'UI d'attraper un seul type d'exception au lieu de jongler
/// avec `DioException`, `SocketException`, `TimeoutException`, etc.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = _map(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: mapped,
        type: err.type,
        response: err.response,
        message: mapped.message,
      ),
    );
  }

  ApiException _map(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const ApiException.timeout();
      case DioExceptionType.connectionError:
        return const ApiException.network();
      case DioExceptionType.cancel:
        return const ApiException.cancelled();
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode ?? 0;
        if (status == 401) return const ApiException.unauthorized();
        if (status == 403) return const ApiException.forbidden();
        if (status == 404) return const ApiException.notFound();
        if (status >= 500) return ApiException.server(status);
        return ApiException.badRequest(
          status,
          _messageFromResponse(err.response),
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return ApiException.unknown(err.message ?? 'Erreur inconnue');
    }
  }

  String? _messageFromResponse(Response<dynamic>? response) {
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      final msg = data['message'] ?? data['error'];
      if (msg is String) return msg;
    }
    return null;
  }
}
