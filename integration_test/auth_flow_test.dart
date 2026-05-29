import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:scolar_mobile/core/cache/cache_store.dart';
import 'package:scolar_mobile/core/network/token_storage.dart';
import 'package:scolar_mobile/features/onboarding/data/onboarding_repository.dart';
import 'package:scolar_mobile/main.dart';

/// E2E :
/// - app démarre (splash)
/// - onboarding marqué fait → splash redirige vers /login
/// - on remplit le formulaire login → on atterrit sur la home dashboard
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Boot → login → home dashboard', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          onboardingRepositoryProvider.overrideWithValue(
            InMemoryOnboardingRepository(initiallyDone: true),
          ),
          tokenStorageProvider.overrideWithValue(InMemoryTokenStorage()),
          cacheStoreProvider.overrideWithValue(InMemoryCacheStore()),
        ],
        child: const ScolarApp(),
      ),
    );

    // Laisse le splash + bootstrap auth s'exécuter (1.5s min display).
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Devrait être sur l'écran login.
    expect(find.text('Bon retour !'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'aminata@scolar.cf',
    );
    await tester.enterText(find.byType(TextFormField).last, 'azerty123');
    await tester.tap(find.text('Se connecter'));

    // Login fake = 600ms.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Sur la home.
    expect(find.text('Bonjour,'), findsOneWidget);
    expect(find.text('Aminata'), findsOneWidget);
  });
}
