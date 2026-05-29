import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scolar_mobile/features/schedule/presentation/schedule_providers.dart';
import 'package:scolar_mobile/features/schedule/presentation/schedule_screen.dart';
import 'package:scolar_mobile/theme/scolar_theme.dart';

void main() {
  Widget wrap(Widget child) {
    return ProviderScope(
      child: MaterialApp(theme: ScolarTheme.light, home: child),
    );
  }

  testWidgets('Affiche les jours de la semaine', (tester) async {
    await tester.pumpWidget(wrap(const ScheduleScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('Emploi du temps'), findsOneWidget);
    // Lundi est en haut de liste — Vendredi nécessiterait un scroll.
    expect(find.textContaining('Lundi'), findsOneWidget);
  });

  testWidgets('Affiche les cours du template', (tester) async {
    await tester.pumpWidget(wrap(const ScheduleScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    // Mathématiques est dans la 1ère section (Lundi).
    expect(find.text('Mathématiques'), findsWidgets);
  });

  test('mondayOf renvoie le lundi à 00:00', () {
    final wednesday = DateTime(2026, 5, 27); // mercredi
    final monday = mondayOf(wednesday);
    expect(monday.weekday, equals(DateTime.monday));
    expect(monday.day, equals(25));
    expect(monday.hour, equals(0));
  });
}
