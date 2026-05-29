import 'dart:async';
import 'dart:convert';

import '../../../core/network/token_storage.dart';
import '../domain/auth_repository.dart';
import '../domain/student.dart';

/// Implémentation in-memory + token persisté — utilisée tant que le
/// backend n'est pas branché. Le token est un JSON encodé contenant la
/// session, ce qui permet de simuler `restoreSession()` au redémarrage.
///
/// Validation :
/// - n'importe quel email valide / mot de passe ≥ 6 caractères → succès
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(this._tokenStorage);

  final TokenStorage _tokenStorage;
  final StreamController<Student?> _sessionController =
      StreamController<Student?>.broadcast();
  Student? _current;

  @override
  Student? get currentStudent => _current;

  @override
  Stream<Student?> get sessionChanges => _sessionController.stream;

  @override
  Future<Student?> restoreSession() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final raw = await _tokenStorage.read();
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final student = Student(
        id: json['id'] as String,
        fullName: json['full_name'] as String,
        email: json['email'] as String,
        classLabel: json['class_label'] as String?,
        schoolName: json['school_name'] as String?,
      );
      _current = student;
      _sessionController.add(student);
      return student;
    } catch (_) {
      await _tokenStorage.delete();
      return null;
    }
  }

  Future<void> _persist(Student s) async {
    await _tokenStorage.write(
      jsonEncode(<String, dynamic>{
        'id': s.id,
        'full_name': s.fullName,
        'email': s.email,
        'class_label': s.classLabel,
        'school_name': s.schoolName,
      }),
    );
  }

  @override
  Future<Student> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!email.contains('@')) {
      throw const AuthException('Email invalide', code: 'invalid-email');
    }
    if (password.length < 6) {
      throw const AuthException(
        'Mot de passe trop court (6 caractères min.)',
        code: 'weak-password',
      );
    }

    final student = Student(
      id: 'stud_${email.hashCode.abs()}',
      fullName: _displayNameFromEmail(email),
      email: email,
      classLabel: 'Terminale S',
      schoolName: 'Lycée Pierre-Marie de Bangui',
    );
    await _persist(student);
    _current = student;
    _sessionController.add(student);
    return student;
  }

  @override
  Future<Student> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (fullName.trim().length < 2) {
      throw const AuthException('Nom complet requis', code: 'invalid-name');
    }
    if (!email.contains('@')) {
      throw const AuthException('Email invalide', code: 'invalid-email');
    }
    if (password.length < 6) {
      throw const AuthException(
        'Mot de passe trop court (6 caractères min.)',
        code: 'weak-password',
      );
    }

    final student = Student(
      id: 'stud_${email.hashCode.abs()}',
      fullName: fullName.trim(),
      email: email,
      classLabel: 'Terminale S',
      schoolName: 'Lycée Pierre-Marie de Bangui',
    );
    await _persist(student);
    _current = student;
    _sessionController.add(student);
    return student;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await _tokenStorage.delete();
    _current = null;
    _sessionController.add(null);
  }

  String _displayNameFromEmail(String email) {
    final local = email.split('@').first;
    if (local.isEmpty) return 'Élève Scolar';
    return local
        .replaceAll(RegExp(r'[._-]+'), ' ')
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((p) => p[0].toUpperCase() + p.substring(1).toLowerCase())
        .join(' ');
  }
}
