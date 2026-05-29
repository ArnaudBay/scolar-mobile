import 'package:dio/dio.dart';

import 'api_config.dart';
import 'token_storage.dart';

/// Sur réponse 401, tente de rafraîchir l'access token via le refresh
/// token, puis rejoue la requête initiale **une seule fois**.
///
/// Si le refresh échoue (refresh token expiré, etc.), purge les deux
/// tokens et laisse le 401 remonter — l'UI redirigera vers `/login`
/// via le guard.
///
/// Utilise son propre `Dio` "nu" (sans interceptors) pour appeler
/// `/auth/refresh` afin d'éviter une boucle infinie.
class RefreshInterceptor extends QueuedInterceptor {
  RefreshInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;
  late final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      contentType: 'application/json',
    ),
  );

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final alreadyRetried = err.requestOptions.extra['_retried'] == true;
    final isRefreshCall =
        err.requestOptions.path == '/auth/refresh' ||
        err.requestOptions.uri.path.endsWith('/auth/refresh');

    if (status != 401 || alreadyRetried || isRefreshCall) {
      return handler.next(err);
    }

    final refreshToken = await _tokenStorage.readRefresh();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _tokenStorage.clear();
      return handler.next(err);
    }

    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final newAccess = response.data?['token'] as String?;
      final newRefresh = response.data?['refresh_token'] as String?;
      if (newAccess == null) {
        await _tokenStorage.clear();
        return handler.next(err);
      }
      await _tokenStorage.write(newAccess);
      if (newRefresh != null) await _tokenStorage.writeRefresh(newRefresh);

      // Rejoue la requête initiale avec le nouveau token.
      final req = err.requestOptions;
      req.extra['_retried'] = true;
      req.headers['Authorization'] = 'Bearer $newAccess';
      final retryResponse = await _refreshDio.fetch<dynamic>(req);
      return handler.resolve(retryResponse);
    } catch (_) {
      await _tokenStorage.clear();
      return handler.next(err);
    }
  }
}
