# Docs Scolar Mobile

| Sprint | Thème | Doc |
|---|---|---|
| **S0** | Foundations & cleanup | [SPRINT_0.md](./SPRINT_0.md) |
| **S1** | Features mockées (auth, notes, schedule, profil) | (inline dans S0) |
| **S2** | Backend wiring (Dio, secure storage, Update natif) | [SPRINT_2.md](./SPRINT_2.md) |
| **S3** | Devoirs + refresh token + min-version + cache | [SPRINT_3.md](./SPRINT_3.md) |
| **S4** | Sentry + i18n FR/EN + accessibilité + integration test | [SPRINT_4.md](./SPRINT_4.md) |

## Schéma d'architecture

```
┌─────────────────────────────────────────────────────────────┐
│ lib/main.dart                                                │
│   ProviderScope overrides ─ SharedPreferences, CacheStore   │
│   Monitoring.bootstrap (Sentry) wraps runApp                │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│ MaterialApp.router  (theme: ScolarTheme.light, locale: fr)  │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│ GoRouter (core/router/)                                      │
│   ├─ /splash  → SplashScreen (bootstrap update + auth)      │
│   ├─ /update-required (PopScope canPop:false)               │
│   ├─ /onboarding (PageView 3 slides + flag SharedPrefs)     │
│   ├─ /login + /register (Form + AuthController.login)       │
│   └─ ShellRoute (PrivateShell + BottomNav)                  │
│       ├─ /home (dashboard ConsumerWidget)                   │
│       ├─ /notes  → /notes/:subjectId                        │
│       ├─ /schedule                                          │
│       ├─ /homeworks                                         │
│       └─ /profile                                           │
│   refreshListenable = stream du AuthController              │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│ Features (feature-first)                                     │
│   features/<X>/                                              │
│     ├─ domain/    (contrats + models, sans deps Flutter)     │
│     ├─ data/                                                 │
│     │   ├─ fake_<X>_repository.dart   (utilisé en démo)     │
│     │   └─ dio_<X>_repository.dart    (prod)                 │
│     └─ presentation/                                         │
│         ├─ <X>_providers.dart  (Riverpod, switch fake/Dio)  │
│         └─ <X>_screen.dart                                   │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│ Core (transverse)                                            │
│   core/network/     Dio + AuthInterceptor + RefreshInter-    │
│                     ceptor + ErrorInterceptor + TokenStorage │
│   core/errors/      ApiException (sealed) avec userMessage  │
│   core/cache/       CacheStore + cacheThenNetwork()         │
│   core/monitoring/  Sentry wrapper                          │
│   core/utils/       FrDate (formatters dates FR sans intl)  │
│   core/router/      GoRouter + AppRoutes + RouteGuards      │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│ Design system (lib/theme/scolar_theme.dart)                  │
│   ScolarColors / ScolarTypography / ScolarSpacing /          │
│   ScolarRadius / ScolarShadows / ScolarTheme.light           │
│   (source unique de vérité, jamais de hex en dur ailleurs)   │
└─────────────────────────────────────────────────────────────┘
```

## Comment switcher les backends

```bash
# Démo fakes (défaut, hors-ligne)
flutter run

# Pointer staging
flutter run --dart-define=SCOLAR_USE_FAKES=false \
            --dart-define=SCOLAR_API_URL=https://staging.scolar.cf/api

# Build prod
flutter build apk --release \
  --dart-define=SCOLAR_USE_FAKES=false \
  --dart-define=SCOLAR_API_URL=https://api.scolar.cf/v1 \
  --dart-define=SCOLAR_ENV=production \
  --dart-define=SENTRY_DSN=https://xxx@sentry.io/123
```
