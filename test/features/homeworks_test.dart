import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scolar_mobile/features/homeworks/data/fake_homeworks_repository.dart';
import 'package:scolar_mobile/features/homeworks/presentation/homeworks_providers.dart';
import 'package:scolar_mobile/features/homeworks/presentation/homeworks_screen.dart';
import 'package:scolar_mobile/theme/scolar_theme.dart';

void main() {
  testWidgets('Affiche les devoirs en attente puis terminés', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          homeworksRepositoryProvider.overrideWith(
            (ref) => FakeHomeworksRepository(),
          ),
        ],
        child: MaterialApp(
          theme: ScolarTheme.light,
          home: const HomeworksScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Mes devoirs'), findsOneWidget);
    expect(find.text('Exercices fonctions ch. 7'), findsOneWidget);
  });

  testWidgets('Toggle d\'un devoir : marque comme fait', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          homeworksRepositoryProvider.overrideWith(
            (ref) => FakeHomeworksRepository(),
          ),
        ],
        child: MaterialApp(
          theme: ScolarTheme.light,
          home: const HomeworksScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Le titre "Exercices fonctions ch. 7" est en gras normal (pending).
    final titleFinder = find.text('Exercices fonctions ch. 7');
    expect(titleFinder, findsOneWidget);
    final beforeDecoration = (tester
        .widget<Text>(titleFinder)
        .style
        ?.decoration);
    expect(beforeDecoration, anyOf(isNull, equals(TextDecoration.none)));

    // Tap la pastille de hw1 (clé stable).
    await tester.tap(find.byKey(const ValueKey('hw-toggle-hw1')));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 400));

    // Le titre est maintenant barré.
    final afterDecoration = (tester
        .widget<Text>(find.text('Exercices fonctions ch. 7'))
        .style
        ?.decoration);
    expect(afterDecoration, equals(TextDecoration.lineThrough));
  });
}
