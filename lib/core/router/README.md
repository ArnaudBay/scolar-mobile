# `core/router/`

Routing transverse Scolar (GoRouter).

## Fichiers

- `app_routes.dart` — constantes de chemins (utiliser **uniquement** celles-ci)
- `app_router.dart` — provider Riverpod du `GoRouter`
- `route_guards.dart` — logique de redirection (splash → update → onboarding → auth)

## Règles

- **Ne jamais** hardcoder `'/login'` ou `'/home'` — passer par `AppRoutes.login`.
- Pour naviguer : `context.go(AppRoutes.home)` ou `context.goNamed('home')`.
- Toute nouvelle route doit être ajoutée **à la fois** dans `app_routes.dart`
  et dans `app_router.dart`.
- Les guards lisent l'état via Riverpod — ne pas dupliquer la logique dans
  les écrans.

## TODO Sprint 1

- [ ] Brancher `refreshListenable` pour que GoRouter réagisse aux changements
      d'auth et de version sans reload.
- [ ] Wrapper les routes privées dans un `ShellRoute` partageant le
      `BottomNavigationBar`.
- [ ] Ajouter les transitions personnalisées (slide, fade) par route.
