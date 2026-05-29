import 'student.dart';

/// Contrat du repository d'authentification.
///
/// Implémentation réelle (Sprint 1) : Dev 2 dans
/// `features/auth/data/auth_repository_impl.dart`.
///
/// Toute implémentation doit :
/// - persister le token avec `flutter_secure_storage`
/// - exposer la session courante via [currentStudent] (`null` si déconnecté)
/// - notifier les changements via [sessionChanges]
abstract class AuthRepository {
  /// Tente de restaurer une session depuis le stockage sécurisé.
  /// Retourne l'élève si le token est valide, `null` sinon.
  Future<Student?> restoreSession();

  /// Connexion par identifiants. Lève [AuthException] en cas d'échec.
  Future<Student> login({required String email, required String password});

  /// Création de compte élève.
  Future<Student> register({
    required String fullName,
    required String email,
    required String password,
  });

  /// Déconnexion : purge le token et notifie [sessionChanges].
  Future<void> logout();

  /// Élève courant, `null` si non connecté.
  Student? get currentStudent;

  /// Flux des changements de session (connexion / déconnexion / refresh).
  Stream<Student?> get sessionChanges;
}

class AuthException implements Exception {
  const AuthException(this.message, {this.code});
  final String message;
  final String? code;

  @override
  String toString() => 'AuthException($code): $message';
}
