# `features/splash/`

Écran de démarrage Scolar — affiché à chaque ouverture.

## Owner

Dev 1 — branche `feature/splash-update`.

## Responsabilités

1. Affichage logo + tagline (~2 s).
2. Vérification de la version applicative (`UpdateService`) → redirige vers
   `/update-required` si obsolète.
3. Restauration de session via `AuthRepository.restoreSession()`.
4. Redirection :
   - flag onboarding absent → `/onboarding`
   - token valide → `/home`
   - sinon → `/login`

## Notes techniques

- Le **vrai** splash natif (logo immédiat avant le 1er frame Flutter)
  est géré par `flutter_native_splash` (config dans `pubspec.yaml`).
- Cet écran Dart vient juste **après** le splash natif pour gérer la
  logique de redirection.
- Ne pas dépendre directement de `SharedPreferences` ici → passer par
  `OnboardingRepository` (et `AuthRepository` pour le token).
