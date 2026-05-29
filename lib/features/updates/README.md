# `features/updates/`

Vérification de version et mise à jour forcée.

## Owner

Dev 1 — branche `feature/splash-update`.

## Structure

```
updates/
├── domain/
│   └── update_service.dart       # contrat abstrait + UpdateStatus
├── data/
│   ├── android_update_service.dart   # impl `in_app_update`
│   └── ios_update_service.dart       # impl `url_launcher` → App Store
└── presentation/
    └── update_required_screen.dart   # bloquant, PopScope canPop:false
```

## Règles

- **Jamais** de version minimale codée en dur → la lire depuis le backend
  (endpoint `/app/min-version`) ou Remote Config.
- Sur Android : préférer `in_app_update` (flow Google natif).
- Sur iOS : ouvrir directement l'App Store via `url_launcher`.
- L'écran `UpdateRequiredScreen` doit être impossible à fermer
  (`PopScope(canPop: false)`) — c'est volontaire.
