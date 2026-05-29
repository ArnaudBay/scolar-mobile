import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scolar_mobile/features/notes/presentation/notes_screen.dart';
import 'package:scolar_mobile/theme/scolar_theme.dart';

void main() {
  Widget wrap(Widget child) {
    return ProviderScope(
      child: MaterialApp(theme: ScolarTheme.light, home: child),
    );
  }

  testWidgets('Affiche un loading puis la liste des matières', (tester) async {
    await tester.pumpWidget(wrap(const NotesScreen()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Laisse les Future.delayed du FakeNotesRepository s'écouler.
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('Mes notes'), findsOneWidget);
    expect(find.text('Moyenne générale'), findsOneWidget);
    // Premières matières visibles sans scroller.
    expect(find.text('Mathématiques'), findsOneWidget);
    expect(find.text('Physique-Chimie'), findsOneWidget);
  });

  testWidgets('La moyenne générale s\'affiche au format X.XX / 20', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const NotesScreen()));
    await tester.pump(const Duration(milliseconds: 800));

    final avgFinder = find.textContaining(' / 20');
    expect(avgFinder, findsOneWidget);
  });
}
