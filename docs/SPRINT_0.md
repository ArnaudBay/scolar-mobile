# Sprint 0 — Foundations

Branche : `chore/sprint-0-foundations` → à merger sur `develop`.

## Objectif

Éponger la dette structurelle accumulée sur les 4 PR de pré-Sprint 0 et
poser le squelette complet pour que les 5 devs puissent travailler en
parallèle sans se bloquer.

## Ce qui a changé

### 🗑️ Supprimé

- `lib/core/theme/app_colors.dart` — doublait `ScolarColors` avec des
  valeurs différentes (primary `#2B2DE8` vs `#0D02FE`).
- `lib/features/routing/` — l'ancien `AppRouter` basé sur
  `onGenerateRoute` (incompatible avec le plan GoRouter).
- `lib/features/student/student_home_screen.dart` — fichier vide
  doublonnant `features/home/`.
- `lib/features/auth/login_screen.dart` & `registration_screen.dart` —
  fichiers vides, remplacés par des skeletons dans `presentation/`.
- `lib/features/updates/updates_screen.dart` — fichier vide, remplacé
  par `update_required_screen.dart`.

### ➕ Ajouté

```
lib/
├── core/router/
│   ├── app_router.dart           # GoRouter provider Riverpod
│   ├── app_routes.dart           # constantes de chemins
│   ├── route_guards.dart         # redirect splash → onboarding → auth
│   └── README.md
└── features/
    ├── auth/
    │   ├── README.md
    │   ├── domain/
    │   │   ├── auth_repository.dart    # contrat figé
    │   │   ├── auth_state.dart         # sealed AuthState
    │   │   └── student.dart            # modèle métier
    │   └── presentation/
    │       ├── auth_controller.dart    # StateNotifier (skeleton)
    │       ├── login_screen.dart       # skeleton
    │       └── register_screen.dart    # skeleton
    ├── home/README.md
    ├── notes/
    │   ├── README.md
    │   ├── domain/notes_repository.dart    # contrat + Subject + Grade
    │   └── presentation/notes_screen.dart  # skeleton
    ├── onboarding/
    │   ├── README.md
    │   └── data/onboarding_repository.dart # contrat + impl mémoire
    ├── profile/
    │   ├── README.md
    │   └── presentation/profile_screen.dart  # skeleton
    ├── schedule/
    │   ├── README.md
    │   ├── domain/schedule_repository.dart  # contrat + CourseSlot
    │   └── presentation/schedule_screen.dart # skeleton
    ├── splash/
    │   ├── README.md
    │   └── presentation/splash_screen.dart   # skeleton
    └── updates/
        ├── README.md
        ├── domain/update_service.dart        # contrat + UpdateStatus
        └── presentation/update_required_screen.dart  # skeleton bloquant
```

### 🔄 Modifié

- `pubspec.yaml` — ajout de **toutes** les deps de la stack
  (`go_router`, `flutter_riverpod`, `flutter_secure_storage`,
  `shared_preferences`, `in_app_update`, `package_info_plus`,
  `url_launcher`, `dio`, `flutter_native_splash` en dev).
- `lib/main.dart` — passe à `ProviderScope` + `MaterialApp.router`.
- `lib/features/home/presentation/pages/student_home_page.dart` —
  migration `AppColors.*` → `ScolarColors.*` (les 2 couleurs absentes
  du DS sont déclarées en haut comme `_kCardNavy` / `_kBarIndigo`).
- `.github/workflows/flutter-ci.yml` — CI obligatoire sur chaque PR
  (`flutter analyze --fatal-infos --fatal-warnings` + `flutter test` +
  `dart format`).

## Décisions actées

| # | Décision |
|---|---|
| 1 | **Riverpod** retenu pour le state management |
| 2 | **`lib/theme/scolar_theme.dart`** = unique source pour le design system |
| 3 | **GoRouter** avec un seul `appRouterProvider` + `RouteGuards.redirect` |
| 4 | **`AppRoutes.*`** = unique source des chemins (aucun hex de route en dur) |
| 5 | Chaque feature suit la structure `domain/` + `data/` + `presentation/` |
| 6 | Branches dev : `feature/notes` et `feature/schedule` **séparées** (plus de `feature/features`) |

## Prochaines étapes (Sprint 1)

Voir le plan général, mais les contrats à respecter sont :

- `AuthRepository` — Dev 2 doit livrer une impl `data/auth_repository_impl.dart`
- `OnboardingRepository` — Tech Lead remplace l'impl mémoire par `SharedPreferences`
- `NotesRepository` & `ScheduleRepository` — Dev 4 et Dev 5 livrent un
  `FakeXxxRepository` en `data/` pour démarrer sans backend
- `UpdateService` — Dev 1 livre une impl Android (`in_app_update`) et iOS (`url_launcher`)
- `SplashScreen` — Dev 1 remplace le `Future.delayed` par le vrai bootstrap

## Validation locale

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome   # smoke test
```
