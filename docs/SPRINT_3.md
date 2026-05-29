# Sprint 3 — Devoirs, refresh token, min-version, offline cache

Suite directe de Sprint 2 (couche réseau + Dio repositories + tests widget).

## Objectif

Compléter la feature manquante (Devoirs), durcir l'auth avec un refresh
token + retry sur 401, brancher la vérification de version au backend,
poser une couche de cache offline-first prête à être adoptée.

## Ce qui a changé

### ➕ Feature Devoirs (`lib/features/homeworks/`)

- `HomeworksRepository` contrat + `Homework` model (id, sujet, titre,
  description, dueDate, isDone, `isOverdue` calculé)
- `FakeHomeworksRepository` (5 devoirs Bangui, dates relatives à
  `DateTime.now()`)
- `DioHomeworksRepository` (`GET /students/me/homeworks`,
  `POST /students/me/homeworks/:id/done`,
  `GET /students/me/homeworks/pending-count`)
- `homeworks_providers.dart` : `homeworksProvider` (liste complète),
  `pendingHomeworksCountProvider` (badge home)
- `HomeworksScreen` : liste triée (pending → done), tap-pastille toggle
  + invalidation des providers, couleurs adaptatives (pending bleu,
  overdue rouge, done vert + barré)
- Route `/homeworks` ajoutée dans `AppRoutes` + Shell route
- **3e carte stats de la home** est maintenant câblée sur
  `pendingHomeworksCountProvider` et navigue vers `/homeworks` au tap

### ➕ Refresh token (`lib/core/network/`)

- `TokenStorage` étendu : 2 slots (`access` + `refresh`) +
  `clear()` qui purge les deux
- `RefreshInterceptor` (`QueuedInterceptor` Dio) :
  - Sur 401 → tente `POST /auth/refresh` avec le refresh token
  - Si OK : écrit le nouveau token, **rejoue** la requête initiale
    une seule fois (flag `_retried` dans `RequestOptions.extra`)
  - Si KO : purge tokens et laisse le 401 remonter (le guard
    redirigera vers `/login` via le `refreshListenable`)
  - Utilise un **Dio "nu"** sans interceptors pour le call refresh
    (sinon boucle infinie)
- `DioAuthRepository` écrit aussi le `refresh_token` retourné par
  `/auth/login` et `/auth/register`, et utilise `clear()` au logout

### ➕ Endpoint `/app/metadata` (`lib/features/updates/`)

- `AppMetadataRepository` contrat + `AppMetadata` (minVersion, latestVersion)
- `DioAppMetadataRepository` (`GET /app/metadata`)
- `StaticAppMetadataRepository` pour fakes
- `PlatformUpdateService` consomme désormais ce repo :
  - **Android** : `in_app_update` natif (ne change pas)
  - **iOS** : `metadata.minVersion` comparée à `PackageInfo.version`
    via le comparateur sémantique. Si version installée < minVersion
    → `UpdateStatus.required`. Si version installée < latestVersion
    → `UpdateStatus.optional`. Sinon `upToDate`. Erreur backend →
    `upToDate` (on n'embête pas l'utilisateur si /app/metadata down)

### ➕ Cache offline (`lib/core/cache/`)

- `CacheStore` interface + `SharedPrefsCacheStore` impl (TTL +
  marqueurs temporels JSON) + `InMemoryCacheStore` (tests)
- Helper générique `cacheThenNetwork<T>()` avec pattern
  **cache-then-network + fallback stale** :
  1. Frais en cache → return
  2. Fetch réseau OK → cache + return
  3. Fetch réseau KO → return stale si dispo, sinon rethrow
- `cacheStoreProvider` overridé dans `main.dart` avec l'instance
  SharedPreferences
- Documentation d'adoption dans `lib/core/cache/README.md` — les
  repositories pourront adopter le pattern à leur rythme (S4+)

### ➕ Tests

- `test/features/homeworks_test.dart` : affichage + toggle visuel
  (vérifie le `TextDecoration.lineThrough` après tap)
- Total : **17/17 tests verts** (~21 s)

## Endpoints backend attendus

| Méthode | Path | Body / Query | Réponse |
|---|---|---|---|
| POST | `/auth/login` | `{email, password}` | `{token, refresh_token, student}` |
| POST | `/auth/register` | `{full_name, email, password}` | `{token, refresh_token, student}` |
| POST | `/auth/refresh` | `{refresh_token}` | `{token, refresh_token?}` |
| POST | `/auth/logout` | — | 204 |
| GET | `/auth/me` | — | `{student}` |
| GET | `/app/metadata` | — | `{min_version, latest_version}` |
| GET | `/students/me/subjects` | — | `[{id, name, average, teacher_name?}]` |
| GET | `/students/me/subjects/:id/grades` | — | `[{id, label, value, max, date, coefficient}]` |
| GET | `/students/me/overall-average` | — | `{value}` |
| GET | `/students/me/schedule` | `?week_start=YYYY-MM-DD` | `[{id, subject_name, teacher_name, room, start, end}]` |
| GET | `/students/me/homeworks` | — | `[{id, subject_name, title, description?, due_date, is_done}]` |
| GET | `/students/me/homeworks/pending-count` | — | `{count}` |
| POST | `/students/me/homeworks/:id/done` | `{done}` | 204 |
