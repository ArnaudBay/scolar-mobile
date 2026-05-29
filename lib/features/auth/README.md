# `features/auth/`

Authentification élève (login, register, gestion du token).

## Owner

Dev 2 — branche `feature/auth`.

## Structure

```
auth/
├── domain/
│   ├── auth_repository.dart   # contrat abstrait (figé Sprint 0)
│   ├── auth_state.dart        # AuthLoading / AuthAuthenticated / AuthUnauthenticated
│   └── student.dart           # modèle métier
├── data/
│   └── auth_repository_impl.dart  # impl Sprint 1 (Dio + secure_storage)
└── presentation/
    ├── auth_controller.dart   # StateNotifier Riverpod
    ├── login_screen.dart
    └── register_screen.dart
```

## Règles

- **Token** : `flutter_secure_storage` uniquement, **jamais** `SharedPreferences`.
- L'écran ne fait **pas** de logique métier — il appelle `authController.login(...)`.
- Le repository expose un `Stream<Student?>` pour que `GoRouter` puisse
  refresh via `refreshListenable`.
- Pas de mocks en dur dans les écrans — passer par `AuthRepository`
  (un `FakeAuthRepository` peut être fourni en `data/` pour les tests).
