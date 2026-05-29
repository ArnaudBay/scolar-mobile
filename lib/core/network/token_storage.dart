import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstraction du stockage sécurisé des tokens d'auth.
///
/// Gère deux slots : access token (court terme) et refresh token (long
/// terme). L'access token est lu à chaque requête sortante par
/// `AuthInterceptor` ; le refresh token est utilisé par
/// `RefreshInterceptor` pour renouveler l'access token sur 401.
abstract class TokenStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> delete();

  Future<String?> readRefresh();
  Future<void> writeRefresh(String token);
  Future<void> deleteRefresh();

  /// Purge access + refresh.
  Future<void> clear();
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _accessKey = 'scolar_auth_token';
  static const String _refreshKey = 'scolar_refresh_token';
  final FlutterSecureStorage _storage;

  @override
  Future<String?> read() => _storage.read(key: _accessKey);

  @override
  Future<void> write(String token) =>
      _storage.write(key: _accessKey, value: token);

  @override
  Future<void> delete() => _storage.delete(key: _accessKey);

  @override
  Future<String?> readRefresh() => _storage.read(key: _refreshKey);

  @override
  Future<void> writeRefresh(String token) =>
      _storage.write(key: _refreshKey, value: token);

  @override
  Future<void> deleteRefresh() => _storage.delete(key: _refreshKey);

  @override
  Future<void> clear() async {
    await Future.wait(<Future<void>>[delete(), deleteRefresh()]);
  }
}

/// Impl en mémoire — pour tests widget.
class InMemoryTokenStorage implements TokenStorage {
  String? _access;
  String? _refresh;

  @override
  Future<String?> read() async => _access;
  @override
  Future<void> write(String token) async => _access = token;
  @override
  Future<void> delete() async => _access = null;

  @override
  Future<String?> readRefresh() async => _refresh;
  @override
  Future<void> writeRefresh(String token) async => _refresh = token;
  @override
  Future<void> deleteRefresh() async => _refresh = null;

  @override
  Future<void> clear() async {
    _access = null;
    _refresh = null;
  }
}

/// Provider du `TokenStorage` — prod = SecureTokenStorage.
final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => SecureTokenStorage(),
);
