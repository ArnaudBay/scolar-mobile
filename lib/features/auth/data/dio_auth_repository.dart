import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/errors/api_exception.dart';
import '../../../core/network/token_storage.dart';
import '../domain/auth_repository.dart';
import '../domain/student.dart';

/// Impl Dio — utilisée quand `ApiConfig.useFakes = false`.
///
/// Endpoints attendus côté backend :
///   POST /auth/login    → { token, student }
///   POST /auth/register → { token, student }
///   GET  /auth/me       → { student } (avec Bearer token)
///   POST /auth/logout   → 204
class DioAuthRepository implements AuthRepository {
  DioAuthRepository(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final StreamController<Student?> _sessionController =
      StreamController<Student?>.broadcast();
  Student? _current;

  @override
  Student? get currentStudent => _current;

  @override
  Stream<Student?> get sessionChanges => _sessionController.stream;

  @override
  Future<Student?> restoreSession() async {
    final token = await _tokenStorage.read();
    if (token == null || token.isEmpty) return null;
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');
      final student = _parseStudent(response.data?['student']);
      _current = student;
      _sessionController.add(student);
      return student;
    } on DioException catch (e) {
      final apiErr = e.error;
      if (apiErr is UnauthorizedApiException) {
        await _tokenStorage.delete();
        return null;
      }
      throw _toAuthException(apiErr);
    }
  }

  @override
  Future<Student> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return _handleAuthResponse(response.data);
    } on DioException catch (e) {
      throw _toAuthException(e.error);
    }
  }

  @override
  Future<Student> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: {'full_name': fullName, 'email': email, 'password': password},
      );
      return _handleAuthResponse(response.data);
    } on DioException catch (e) {
      throw _toAuthException(e.error);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post<void>('/auth/logout');
    } on DioException {
      // Logout côté serveur best-effort — on purge localement de toute façon.
    } finally {
      await _tokenStorage.clear();
      _current = null;
      _sessionController.add(null);
    }
  }

  Future<Student> _handleAuthResponse(Map<String, dynamic>? data) async {
    if (data == null) {
      throw const AuthException('Réponse vide du serveur');
    }
    final token = data['token'] as String?;
    if (token == null || token.isEmpty) {
      throw const AuthException('Token manquant dans la réponse');
    }
    await _tokenStorage.write(token);
    final refresh = data['refresh_token'] as String?;
    if (refresh != null && refresh.isNotEmpty) {
      await _tokenStorage.writeRefresh(refresh);
    }
    final student = _parseStudent(data['student']);
    _current = student;
    _sessionController.add(student);
    return student;
  }

  Student _parseStudent(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      throw const AuthException('Format élève invalide');
    }
    return Student(
      id: raw['id'] as String,
      fullName: raw['full_name'] as String,
      email: raw['email'] as String,
      classLabel: raw['class_label'] as String?,
      schoolName: raw['school_name'] as String?,
      avatarUrl: raw['avatar_url'] as String?,
    );
  }

  AuthException _toAuthException(Object? error) {
    if (error is UnauthorizedApiException) {
      return const AuthException(
        'Identifiants invalides',
        code: 'invalid-credentials',
      );
    }
    if (error is BadRequestApiException) {
      return AuthException(
        error.userMessage,
        code: 'bad-request-${error.statusCode}',
      );
    }
    if (error is ApiException) {
      return AuthException(error.userMessage, code: error.message);
    }
    return AuthException(error?.toString() ?? 'Erreur inconnue');
  }
}
