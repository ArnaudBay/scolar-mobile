import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/token_storage.dart';
import '../data/dio_auth_repository.dart';
import '../data/fake_auth_repository.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_state.dart';
import '../domain/student.dart';

/// Identifiant interne de l'utilisateur "invité" — pas de token persisté,
/// la session disparaît au redémarrage de l'app.
const String _guestStudentId = 'stud_guest';

/// Provider du `AuthRepository` — switch automatique fakes/Dio selon
/// `ApiConfig.useFakes`.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (ApiConfig.useFakes) {
    return FakeAuthRepository(ref.watch(tokenStorageProvider));
  }
  return DioAuthRepository(
    ref.watch(dioClientProvider),
    ref.watch(tokenStorageProvider),
  );
});

/// Provider central de l'état d'authentification.
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.watch(authRepositoryProvider)),
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthLoading()) {
    _bootstrap();
    _repository.sessionChanges.listen(_onSessionChanged);
  }

  final AuthRepository _repository;

  Future<void> _bootstrap() async {
    final student = await _repository.restoreSession();
    if (!mounted) return;
    state = student != null
        ? AuthAuthenticated(student)
        : const AuthUnauthenticated();
  }

  void _onSessionChanged(Student? student) {
    if (!mounted) return;
    state = student != null
        ? AuthAuthenticated(student)
        : const AuthUnauthenticated();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthLoading();
    try {
      final student = await _repository.login(email: email, password: password);
      state = AuthAuthenticated(student);
    } on AuthException catch (e) {
      state = AuthUnauthenticated(reason: e.message);
      rethrow;
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final student = await _repository.register(
        fullName: fullName,
        email: email,
        password: password,
      );
      state = AuthAuthenticated(student);
    } on AuthException catch (e) {
      state = AuthUnauthenticated(reason: e.message);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthUnauthenticated();
  }

  /// Ouvre une session "invité" éphémère — pas de token persisté, ressort
  /// à `Unauthenticated` au prochain démarrage. Permet de visiter le
  /// dashboard depuis l'onboarding sans créer de compte.
  void continueAsGuest() {
    const guest = Student(
      id: _guestStudentId,
      fullName: 'Invité',
      email: 'invite@scolar.local',
      classLabel: 'Terminale S',
      schoolName: 'Démo Scolar',
    );
    state = const AuthAuthenticated(guest);
  }
}
