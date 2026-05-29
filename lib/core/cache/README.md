# `core/cache/`

Cache local TTL-based pour les lectures réseau — pattern
**cache-then-network avec fallback stale**.

## Fichiers

- `cache_store.dart` — interface `CacheStore` + impl `SharedPrefsCacheStore`
  + `InMemoryCacheStore` (tests) + helper `cacheThenNetwork<T>()`

## Quand utiliser

Pour les endpoints **idempotents en lecture** dont la fraîcheur est
tolérable à plusieurs minutes près :
- liste des matières (rarement modifiée)
- semaine d'emploi du temps (modifiée par admin école)
- notes (mises à jour ponctuellement par prof)
- devoirs (créés par les profs, peuvent attendre 5 min)

**Ne pas cacher** : auth, profil utilisateur (changement immédiat
attendu), mutations.

## Pattern d'utilisation

```dart
final subjectsProvider = FutureProvider<List<Subject>>((ref) async {
  final cache = ref.watch(cacheStoreProvider);
  final repo = ref.watch(notesRepositoryProvider);
  return cacheThenNetwork<List<Subject>>(
    cache: cache,
    key: 'notes/subjects',
    ttl: const Duration(minutes: 10),
    fetch: repo.fetchSubjects,
    encode: (list) => jsonEncode(list.map(_subjectToJson).toList()),
    decode: (raw) =>
        (jsonDecode(raw) as List).map((e) => _subjectFromJson(e)).toList(),
  );
});
```

## Comportement en cas d'erreur réseau

1. Cherche dans le cache (frais OU expiré)
2. Si frais → retourne
3. Sinon, fetch réseau
4. Si fetch OK → cache + retourne
5. Si fetch KO → tente de retourner la version expirée (stale)
6. Si pas de stale → relance l'exception
