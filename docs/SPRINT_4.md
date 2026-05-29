# Sprint 4 — Monitoring, i18n, accessibilité, intégration

Suite directe de Sprint 3 (Devoirs + refresh token + cache).

## Objectif

Préparer la mise en prod : monitoring crash (Sentry), scaffolding
multi-langue (FR/EN), audit accessibilité ciblé, premier test
d'intégration end-to-end.

## Ce qui a changé

### ➕ Monitoring (`lib/core/monitoring/`)

- `MonitoringConfig` : DSN Sentry + environnement, lus via
  `--dart-define=SENTRY_DSN=...` et `--dart-define=SCOLAR_ENV=production`
- `Monitoring.bootstrap(appRunner)` :
  - DSN vide → no-op (dev/CI ne paie pas le coût Sentry)
  - DSN renseigné → initialise `SentryFlutter` puis `runApp` dans la
    zone Sentry, capture les erreurs framework + async non rattrapées
  - `tracesSampleRate` : 100 % en debug, 20 % en release
- `Monitoring.report(error, stack, hint:)` helper pour catch + report
  ciblés (à utiliser dans les blocs `catch` sensibles, ex: refresh
  token échoué)
- `main.dart` wrappe `runApp` dans `await Monitoring.bootstrap(...)`

### ➕ Internationalisation (`lib/l10n/`)

- `l10n.yaml` au root + `pubspec.yaml` avec `flutter: generate: true`
- `app_fr.arb` (référence, ~60 clés) + `app_en.arb` (traductions
  complètes)
- `flutter_localizations` + `intl` ajoutés en dépendances
- `MaterialApp.router` configuré avec :
  - `locale: Locale('fr')` par défaut
  - `supportedLocales: [fr, en]`
  - `localizationsDelegates` Material/Widgets/Cupertino
- Documentation d'adoption progressive dans `lib/l10n/README.md` —
  les écrans existants seront migrés écran-par-écran (auth →
  onboarding → erreurs en priorité)

### ➕ Accessibilité

Audits ciblés sur les composants à fort impact a11y :

- **Splash** : `Semantics(liveRegion: true)` pour annoncer "Scolar —
  chargement de l'application", `ExcludeSemantics` sur le logo
  décoratif (évite la duplication avec le titre)
- **PrivateShell BottomNav** : `Semantics(label: 'Navigation
  principale', explicitChildNodes: true)`, `semanticLabel` sur chaque
  icon (active + inactive), `tooltip` pour les screen readers
- **Pastille de devoir** : `Semantics(button: true, checked:
  isDone, label: "Marquer comme fait|non fait")` — le `checked`
  permet aux lecteurs d'écran d'annoncer l'état

À faire en S5 : audit complet contrastes (DM Serif sur fond bleu vif
peut ne pas atteindre WCAG AA), focus order, tap targets ≥ 48×48,
labels sur tous les champs de formulaire (déjà OK pour login/register).

### ➕ Tests d'intégration (`integration_test/`)

- `integration_test/auth_flow_test.dart` : E2E **boot → login → home**
  - démarre l'app avec un `onboardingDone: true` + fakes
  - attend le splash (1.5 s min display)
  - vérifie l'arrivée sur `/login`
  - remplit les champs + tape "Se connecter"
  - vérifie l'arrivée sur la home (greeting "Bonjour, Aminata")
- Lancement : `flutter test integration_test/` (run sur un device
  réel ou émulateur — pas en CI Linux headless tel quel)

## État final repo (après S0 → S4)

- **80+ fichiers Dart** dans `lib/`
- **17 tests widget** verts (+ 1 test d'intégration)
- `flutter analyze` : **0 issue**
- Format conforme CI
- Tous les contrats `Repository` ont une **double impl** (Fake + Dio)
- Switch fakes ↔ backend au build time via `SCOLAR_USE_FAKES`
- Tokens auth en `flutter_secure_storage` + refresh interceptor
- Cache offline opt-in via `cacheThenNetwork()`
- Sentry opt-in via `SENTRY_DSN`
- i18n FR + EN scaffold, MaterialApp configuré

## Variables de build

| Variable | Défaut | Description |
|---|---|---|
| `SCOLAR_API_URL` | `https://api.scolar.cf/v1` | Base URL backend |
| `SCOLAR_USE_FAKES` | `true` | Force fakes (démo hors-ligne) |
| `SCOLAR_ENV` | `dev` | Environnement remonté à Sentry |
| `SENTRY_DSN` | (vide) | Active Sentry si renseigné |

Exemple build prod :

```bash
flutter build apk --release \
  --dart-define=SCOLAR_USE_FAKES=false \
  --dart-define=SCOLAR_API_URL=https://api.scolar.cf/v1 \
  --dart-define=SCOLAR_ENV=production \
  --dart-define=SENTRY_DSN=https://xxx@sentry.io/123
```

## Reste à faire (Sprint 5+)

- [ ] Adopter `cacheThenNetwork()` dans `subjectsProvider`,
      `weekScheduleProvider`, `homeworksProvider`
- [ ] Migrer les littéraux FR des écrans vers `AppLocalizations`
- [ ] Notifications push (FCM + APNs)
- [ ] Mode sombre (`ScolarTheme.dark`)
- [ ] Animation Lottie sur l'onboarding et le splash
- [ ] Audit WCAG complet (contrastes, tap targets)
- [ ] CI : ajouter `flutter test integration_test/` sur un émulateur
      Android via GitHub Actions matrix
- [ ] Feature **Communication** (messages prof ↔ élève)
- [ ] Feature **Justificatifs d'absence**
