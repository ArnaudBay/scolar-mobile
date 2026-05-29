import 'package:dio/dio.dart';

import 'token_storage.dart';

/// Attache automatiquement le bearer token à chaque requête sortante.
///
/// Si le token est absent (utilisateur non connecté), la requête part
/// quand même — c'est au backend de renvoyer 401 et à
/// [ErrorInterceptor] de mapper vers une exception métier.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.read();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
