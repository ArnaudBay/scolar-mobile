import 'student.dart';

/// État d'authentification de l'app.
///
/// Trois états mutuellement exclusifs :
/// - [AuthLoading]      : on vérifie un token persisté
/// - [AuthAuthenticated]: l'élève est connecté, [student] est disponible
/// - [AuthUnauthenticated] : pas de token ou token invalide
sealed class AuthState {
  const AuthState();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.student);
  final Student student;
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.reason});

  /// Raison optionnelle (token expiré, logout volontaire, etc.) — utile
  /// pour afficher un message sur l'écran de login.
  final String? reason;
}
