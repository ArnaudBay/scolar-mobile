import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scolar_mobile/core/network/token_storage.dart';
import 'package:scolar_mobile/features/auth/data/fake_auth_repository.dart';
import 'package:scolar_mobile/features/auth/domain/auth_state.dart';
import 'package:scolar_mobile/features/auth/presentation/auth_controller.dart';
import 'package:scolar_mobile/features/auth/presentation/login_screen.dart';
import 'package:scolar_mobile/theme/scolar_theme.dart';

void main() {
  Widget wrap(Widget child) {
    final storage = InMemoryTokenStorage();
    return ProviderScope(
      overrides: <Override>[
        tokenStorageProvider.overrideWithValue(storage),
        authRepositoryProvider.overrideWith(
          (ref) => FakeAuthRepository(storage),
        ),
      ],
      child: MaterialApp(theme: ScolarTheme.light, home: child),
    );
  }

  testWidgets('Affiche les champs email + mot de passe', (tester) async {
    await tester.pumpWidget(wrap(const LoginScreen()));
    await tester.pump();

    expect(find.text('Bon retour !'), findsOneWidget);
    expect(find.text('EMAIL'), findsOneWidget);
    expect(find.text('MOT DE PASSE'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('Validation : email vide → message d\'erreur', (tester) async {
    await tester.pumpWidget(wrap(const LoginScreen()));
    await tester.pump();

    await tester.tap(find.text('Se connecter'));
    await tester.pump();

    expect(find.text('Email requis'), findsOneWidget);
    expect(find.text('Mot de passe requis'), findsOneWidget);
  });

  testWidgets('Validation : email sans @ → message d\'erreur', (tester) async {
    await tester.pumpWidget(wrap(const LoginScreen()));
    await tester.pump();

    await tester.enterText(find.byType(TextFormField).first, 'pasunemail');
    await tester.enterText(find.byType(TextFormField).last, 'azerty123');
    await tester.tap(find.text('Se connecter'));
    await tester.pump();

    expect(find.text('Email invalide'), findsOneWidget);
  });

  testWidgets('Login OK met le AuthController en Authenticated', (
    tester,
  ) async {
    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          tokenStorageProvider.overrideWithValue(InMemoryTokenStorage()),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            container = ProviderScope.containerOf(context);
            return MaterialApp(
              theme: ScolarTheme.light,
              home: const LoginScreen(),
            );
          },
        ),
      ),
    );
    await tester.pump();

    await tester.enterText(
      find.byType(TextFormField).first,
      'aminata@scolar.cf',
    );
    await tester.enterText(find.byType(TextFormField).last, 'azerty123');
    await tester.tap(find.text('Se connecter'));

    // Laisse les Future.delayed (200ms restoreSession + 600ms login) s'écouler.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    final state = container.read(authControllerProvider);
    expect(state, isA<AuthAuthenticated>());
  });
}
