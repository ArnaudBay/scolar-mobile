import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_config.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'refresh_interceptor.dart';
import 'token_storage.dart';

/// Provider du client Dio configuré (base URL, timeouts, interceptors).
///
/// Toute couche `data/` qui parle au backend Scolar doit utiliser
/// `ref.watch(dioClientProvider)` — jamais instancier `Dio()` directement.
final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      sendTimeout: ApiConfig.timeout,
      contentType: 'application/json',
      responseType: ResponseType.json,
      headers: {'Accept': 'application/json'},
    ),
  );

  final tokenStorage = ref.watch(tokenStorageProvider);
  dio.interceptors.addAll(<Interceptor>[
    AuthInterceptor(tokenStorage),
    // RefreshInterceptor doit être AVANT ErrorInterceptor pour intercepter
    // le 401 brut, sinon on reçoit déjà un UnauthorizedApiException mappé.
    RefreshInterceptor(tokenStorage),
    ErrorInterceptor(),
  ]);

  ref.onDispose(dio.close);
  return dio;
});
