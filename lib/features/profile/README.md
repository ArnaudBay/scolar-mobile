# `features/profile/`

Profil élève — infos personnelles, déconnexion.

## Owner

Dev 3 — Sprint 2.

## Règles

- Logout doit appeler `AuthController.logout()` (qui purge le token via
  `AuthRepository`), **jamais** toucher `flutter_secure_storage` directement.
- Toute donnée affichée vient de `authController.student`.
