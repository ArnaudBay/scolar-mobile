import 'package:flutter/material.dart';

import 'features/onboarding/onboarding_screen.dart';
import 'theme/scolar_theme.dart';

void main() => runApp(const ScolarApp());

class ScolarApp extends StatelessWidget {
  const ScolarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scolar',
      debugShowCheckedModeBanner: false,
      theme: ScolarTheme.light,
      home: const OnboardingScreen(),
    );
  }
}
