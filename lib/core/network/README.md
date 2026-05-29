# `core/network/`

Infrastructure HTTP partagée — Dio configuré avec interceptors et
gestion d'erreurs centralisée.

## Fichiers

- `api_config.dart` — base URL + timeouts (override via `--dart-define`)
- `dio_client.dart` — provider Dio instancié avec interceptors
- `auth_interceptor.dart` — attache le bearer token à chaque requête
- `error_interceptor.dart` — mappe `DioException` → `ApiException`
- `token_storage.dart` — abstraction `flutter_secure_storage`

## Règles

- **Jamais** `Dio()` direct dans les repositories → toujours
  `ref.watch(dioClientProvider)`.
- **Jamais** lire `flutter_secure_storage` direct → toujours via
  `TokenStorage`.
- L'UI attrape **uniquement** `ApiException` (jamais `DioException`).
- Une nouvelle erreur backend → l'ajouter dans
  `core/errors/api_exception.dart` ET mapper dans `error_interceptor.dart`.

## Switcher fakes ↔ vrai backend

```bash
# Démo offline (fakes) — défaut
flutter run

# Pointer vers staging
flutter run --dart-define=SCOLAR_USE_FAKES=false \
            --dart-define=SCOLAR_API_URL=https://staging.scolar.cf/api
```
