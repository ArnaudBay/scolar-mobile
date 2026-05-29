import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scolar_mobile/features/auth/domain/auth_state.dart';
import 'package:scolar_mobile/features/auth/domain/student.dart';
import 'package:scolar_mobile/features/auth/presentation/auth_controller.dart';
import 'package:scolar_mobile/features/profile/presentation/profile_screen.dart';
import 'package:scolar_mobile/theme/scolar_theme.dart';

void main() {
  Widget wrap(Widget child, {required AuthState initialState}) {
    return ProviderScope(
      overrides: <Override>[
        authControllerProvider.overrideWith(
          (ref) => _StubAuthController(initialState),
        ),
      ],
      child: MaterialApp(theme: ScolarTheme.light, home: child),
    );
  }

  testWidgets('Affiche le hero avec nom + initiales', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ProfileScreen(),
        initialState: const AuthAuthenticated(
          Student(
            id: '1',
            fullName: 'Aminata Diallo',
            email: 'aminata@scolar.cf',
            classLabel: 'Terminale S',
            schoolName: 'Lycée Pierre-Marie de Bangui',
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Aminata Diallo'), findsOneWidget);
    expect(find.text('AD'), findsOneWidget); // initiales
    expect(find.text('aminata@scolar.cf'), findsAtLeastNWidgets(1));
    expect(find.text('Terminale S'), findsOneWidget);
    expect(find.text('Se déconnecter'), findsOneWidget);
  });

  testWidgets('Affiche "Non connecté" si pas d\'auth', (tester) async {
    await tester.pumpWidget(
      wrap(const ProfileScreen(), initialState: const AuthUnauthenticated()),
    );
    await tester.pump();

    expect(find.text('Non connecté'), findsOneWidget);
  });
}

/// Stub qui contourne le bootstrap async d'`AuthController`.
class _StubAuthController extends StateNotifier<AuthState>
    implements AuthController {
  _StubAuthController(super.initial);

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> logout() async {
    state = const AuthUnauthenticated();
  }

  @override
  void continueAsGuest() {}
}
