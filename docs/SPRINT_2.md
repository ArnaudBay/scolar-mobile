# Sprint 2 — Backend wiring & polish

Suite directe de [Sprint 0](./SPRINT_0.md) (foundations) et de Sprint 1
(features mockées sur repositories abstraits).

## Objectif

Brancher la stack sur du vrai HTTP (Dio + interceptors + erreurs typées),
persister la session côté `flutter_secure_storage`, livrer les vraies
implémentations de `UpdateService` (Android + iOS), refondre le
dashboard Home sur les vrais providers, et couvrir l'app avec une
batterie de tests widget.

## Ce qui a changé

### ➕ Couche réseau (`lib/core/network/`)

- `api_config.dart` — base URL + timeouts pilotés par `--dart-define`
- `dio_client.dart` — provider Riverpod du `Dio` avec interceptors
- `auth_interceptor.dart` — attache le `Bearer <token>` à chaque requête
- `error_interceptor.dart` — mappe `DioException` → `ApiException`
- `token_storage.dart` — abstraction `flutter_secure_storage` + impl
  `InMemoryTokenStorage` pour tests

### ➕ Erreurs métier (`lib/core/errors/api_exception.dart`)

Hiérarchie `sealed class ApiException` :
`Timeout`, `Network`, `Unauthorized`, `Forbidden`, `NotFound`, `Server`,
`BadRequest`, `Unknown`. Chacune expose un `userMessage` FR utilisable
directement dans l'UI.

### ➕ Implémentations Dio

- `DioAuthRepository` — `POST /auth/login`, `POST /auth/register`,
  `GET /auth/me`, `POST /auth/logout` ; gère la purge du token sur 401.
- `DioNotesRepository` — `GET /students/me/subjects` etc.
- `DioScheduleRepository` — `GET /students/me/schedule?week_start=YYYY-MM-DD`

### ➕ Mises à jour plateforme (`PlatformUpdateService`)

- **Android** : `InAppUpdate.checkForUpdate()` + `performImmediateUpdate()`
  avec fallback Play Store via `url_launcher`.
- **iOS** : compare la version installée (`PackageInfo`) à un minimum,
  ouvre l'App Store via `url_launcher`.
- Comparateur sémantique `1.0.2 < 1.1.0` inclus.

### 🔄 Persistance du token

`FakeAuthRepository` persiste maintenant la session (JSON) via
`TokenStorage` → la session **survit** au redémarrage de l'app, même
sans backend.

### 🔄 Switch fakes ↔ Dio

Chaque `xxxRepositoryProvider` lit `ApiConfig.useFakes` (par défaut
`true`) et choisit `FakeXxx` ou `DioXxx`. Switch sans toucher au code :

```bash
flutter run                                # défaut : fakes
flutter run --dart-define=SCOLAR_USE_FAKES=false \
            --dart-define=SCOLAR_API_URL=https://staging.scolar.cf/api
```

### 🔄 Refonte `StudentHomePage`

Passe de `StatelessWidget` + données en dur à `ConsumerWidget` câblé
sur :

- `authControllerProvider` → prénom dans le header, classe/établissement
  dans le hero
- `overallAverageProvider` → carte « Moyenne générale »
- `todayScheduleProvider` (filtre sur le jour courant) → carte « Cours
  aujourd'hui » + section « Prochains cours » (filtre `end > now`)
- `subjectsProvider` → carrousel « Mes matières » (avatar coloré +
  moyenne)
- `RefreshIndicator` qui invalide les 3 providers en pull-to-refresh
- Tap sur les cartes / actions → `context.go(AppRoutes.notes)` ou
  `AppRoutes.schedule`

### ✅ Tests widget (`test/features/`)

| Fichier | Couverture |
|---|---|
| `onboarding_test.dart` | Affichage 1er slide, navigation slide 1→2, flag posé au "Commencer" + redirect `/login` |
| `login_test.dart` | Champs visibles, validation vide, validation email invalide, login OK → `AuthAuthenticated` |
| `notes_test.dart` | Loading puis liste matières, format moyenne `X.XX / 20` |
| `schedule_test.dart` | Jours visibles, cours du template, `mondayOf()` calcule bien le lundi |
| `profile_test.dart` | Hero avec initiales, état `Non connecté` |

Total : **15 tests verts**, exécution en ~17 s.

## Décisions techniques

| # | Décision | Pourquoi |
|---|---|---|
| 1 | Token = JSON encodé en fake (pas juste un string opaque) | Permet à `restoreSession()` de reconstituer le `Student` sans backend, donc on peut tester le flow auth complet hors-ligne |
| 2 | `ApiException` typée et sealed | UI attrape un seul type, exhaustivité garantie par `switch` (sealed) |
| 3 | Interceptor d'erreur séparé de l'interceptor d'auth | SRP — les deux sont activés/désactivés indépendamment, plus faciles à tester |
| 4 | Pas de retry automatique en Sprint 2 | À ajouter en S3 si nécessaire — le retry mal pensé masque les vrais problèmes |
| 5 | `ApiConfig.useFakes` au build time (`bool.fromEnvironment`) | Switch sans condition runtime, et le code mort des fakes est tree-shaké en prod |

## Ce qu'il reste pour Sprint 3 / + tard

- [ ] Endpoint backend `GET /app/min-version` → injecter dans `PlatformUpdateService`
- [ ] Refresh token côté `DioAuthRepository` (retry sur 401 avec refresh)
- [ ] Feature **Devoirs** (`HomeworksRepository`) — actuellement la 3e carte stats affiche `—`
- [ ] Tests intégration `integration_test/` (flow boot → login → home)
- [ ] Crashlytics / Sentry
- [ ] Mode offline (cache local sur `shared_preferences` ou `hive`)
- [ ] Accessibilité (`Semantics`, contrastes audités)
- [ ] i18n (intl + flutter_localizations) si on cible plusieurs langues

## Validation locale

```bash
flutter pub get
flutter analyze              # 0 issue
flutter test                 # 15/15 verts
dart format --output=none --set-exit-if-changed .   # clean
flutter run                  # démo fakes
```
