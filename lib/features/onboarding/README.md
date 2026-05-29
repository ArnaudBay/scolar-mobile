# `features/onboarding/`

Onboarding 3 écrans — affiché uniquement à la **première installation**.

## Owner

Tech Lead — branche `feature/onboarding` (déjà bien avancé).

## Structure

```
onboarding/
├── data/
│   └── onboarding_repository.dart   # contrat + impl SharedPreferences
└── onboarding_screen.dart           # PageView + 3 illustrations + dots
```

## Règles

- Le flag `onboarding_done` est posé via `OnboardingRepository.markDone()`,
  **jamais** directement via `SharedPreferences` (testabilité).
- Le routing décide tout seul de skip l'onboarding (voir `route_guards.dart`).
- Le bouton "Continuer comme invité" doit poser le flag puis rediriger
  vers `/home` en mode public.
- Le bouton "Commencer" doit poser le flag puis rediriger vers `/login`.
