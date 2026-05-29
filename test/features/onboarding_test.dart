import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:scolar_mobile/features/onboarding/data/onboarding_repository.dart';
import 'package:scolar_mobile/features/onboarding/onboarding_screen.dart';
import 'package:scolar_mobile/theme/scolar_theme.dart';

void main() {
  Widget wrap(Widget child, {required OnboardingRepository repo}) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, _) => child),
        GoRoute(
          path: '/login',
          builder: (_, _) =>
              const Scaffold(body: Center(child: Text('LOGIN-PAGE'))),
        ),
      ],
    );
    return ProviderScope(
      overrides: <Override>[
        onboardingRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp.router(theme: ScolarTheme.light, routerConfig: router),
    );
  }

  testWidgets('Affiche le premier slide et le bouton Suivant', (tester) async {
    await tester.pumpWidget(
      wrap(const OnboardingScreen(), repo: InMemoryOnboardingRepository()),
    );
    await tester.pump();

    expect(find.text('Scolar'), findsOneWidget);
    expect(find.text('Suivez vos notes'), findsOneWidget);
    expect(find.text('Suivant'), findsOneWidget);
    expect(find.text('Passer'), findsOneWidget);
  });

  testWidgets('Tap sur Suivant navigue au slide 2', (tester) async {
    await tester.pumpWidget(
      wrap(const OnboardingScreen(), repo: InMemoryOnboardingRepository()),
    );
    await tester.pump();

    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();

    expect(find.text('Emploi du temps'), findsOneWidget);
  });

  testWidgets('Marque l\'onboarding comme fait au "Commencer"', (tester) async {
    final repo = InMemoryOnboardingRepository();
    await tester.pumpWidget(wrap(const OnboardingScreen(), repo: repo));
    await tester.pump();

    // Avancer jusqu'au dernier slide.
    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Suivant'));
    await tester.pumpAndSettle();

    expect(find.text('Commencer'), findsOneWidget);
    expect(repo.isDone(), isFalse);

    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    expect(repo.isDone(), isTrue);
    expect(find.text('LOGIN-PAGE'), findsOneWidget);
  });
}
