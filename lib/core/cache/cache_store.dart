import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache local clé→valeur basé sur `SharedPreferences`, avec TTL.
///
/// Stratégie « cache-then-network » :
/// - `read(key)` retourne la valeur si présente ET non expirée
/// - `readStale(key)` retourne la valeur même expirée (utile en cas
///   d'erreur réseau pour servir une donnée potentiellement obsolète)
///
/// Les valeurs sont sérialisées en JSON pour ne pas perdre les types.
abstract class CacheStore {
  Future<String?> read(String key, {required Duration maxAge});
  Future<String?> readStale(String key);
  Future<void> write(String key, String value);
  Future<void> remove(String key);
  Future<void> clear();
}

class SharedPrefsCacheStore implements CacheStore {
  SharedPrefsCacheStore(this._prefs);

  static const String _prefix = 'scolar_cache_';
  final SharedPreferences _prefs;

  String _k(String key) => '$_prefix$key';

  @override
  Future<String?> read(String key, {required Duration maxAge}) async {
    final raw = _prefs.getString(_k(key));
    if (raw == null) return null;
    final entry = _decode(raw);
    if (entry == null) return null;
    final age = DateTime.now().difference(entry.savedAt);
    if (age > maxAge) return null;
    return entry.value;
  }

  @override
  Future<String?> readStale(String key) async {
    final raw = _prefs.getString(_k(key));
    if (raw == null) return null;
    return _decode(raw)?.value;
  }

  @override
  Future<void> write(String key, String value) async {
    final entry = _CacheEntry(value: value, savedAt: DateTime.now());
    await _prefs.setString(_k(key), _encode(entry));
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(_k(key));
  }

  @override
  Future<void> clear() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith(_prefix)).toList();
    await Future.wait(keys.map(_prefs.remove));
  }

  String _encode(_CacheEntry e) => jsonEncode(<String, dynamic>{
    'v': e.value,
    't': e.savedAt.toIso8601String(),
  });

  _CacheEntry? _decode(String raw) {
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return _CacheEntry(
        value: json['v'] as String,
        savedAt: DateTime.parse(json['t'] as String),
      );
    } catch (_) {
      return null;
    }
  }
}

class _CacheEntry {
  const _CacheEntry({required this.value, required this.savedAt});
  final String value;
  final DateTime savedAt;
}

/// Impl en mémoire — pour tests widget.
class InMemoryCacheStore implements CacheStore {
  final Map<String, _CacheEntry> _store = <String, _CacheEntry>{};

  @override
  Future<String?> read(String key, {required Duration maxAge}) async {
    final e = _store[key];
    if (e == null) return null;
    if (DateTime.now().difference(e.savedAt) > maxAge) return null;
    return e.value;
  }

  @override
  Future<String?> readStale(String key) async => _store[key]?.value;

  @override
  Future<void> write(String key, String value) async {
    _store[key] = _CacheEntry(value: value, savedAt: DateTime.now());
  }

  @override
  Future<void> remove(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }
}

/// Provider — doit être overridé au bootstrap (SharedPreferences async).
final cacheStoreProvider = Provider<CacheStore>((ref) {
  throw UnimplementedError(
    'cacheStoreProvider doit être overridé au bootstrap.',
  );
});

/// Helper : récupère depuis le cache ou fetch, avec fallback stale en cas
/// d'erreur réseau.
Future<T> cacheThenNetwork<T>({
  required CacheStore cache,
  required String key,
  required Duration ttl,
  required Future<T> Function() fetch,
  required T Function(String json) decode,
  required String Function(T value) encode,
}) async {
  final cached = await cache.read(key, maxAge: ttl);
  if (cached != null) {
    try {
      return decode(cached);
    } catch (_) {
      await cache.remove(key);
    }
  }
  try {
    final fresh = await fetch();
    await cache.write(key, encode(fresh));
    return fresh;
  } catch (e) {
    final stale = await cache.readStale(key);
    if (stale != null) {
      try {
        return decode(stale);
      } catch (_) {
        // ignore
      }
    }
    rethrow;
  }
}
