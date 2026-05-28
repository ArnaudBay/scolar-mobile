import 'package:flutter_test/flutter_test.dart';

import 'package:scolar_mobile/main.dart';

void main() {
  testWidgets('L\'app démarre et affiche l\'onboarding', (tester) async {
    await tester.pumpWidget(const ScolarApp());
    await tester.pumpAndSettle();

    expect(find.text('Suivez vos notes'), findsOneWidget);
  });
}
