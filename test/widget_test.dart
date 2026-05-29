import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scolar_mobile/features/onboarding/data/onboarding_repository.dart';
import 'package:scolar_mobile/features/onboarding/onboarding_screen.dart';
import 'package:scolar_mobile/theme/scolar_theme.dart';

void main() {
  testWidgets('L\'onboarding affiche le premier slide', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          onboardingRepositoryProvider.overrideWithValue(
            InMemoryOnboardingRepository(),
          ),
        ],
        child: MaterialApp(
          theme: ScolarTheme.light,
          home: const OnboardingScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Scolar'), findsOneWidget);
    expect(find.text('Suivez vos notes'), findsOneWidget);
    expect(find.text('Suivant'), findsOneWidget);
  });
}
