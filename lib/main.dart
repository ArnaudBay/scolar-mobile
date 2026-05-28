import 'package:flutter/material.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'theme/scolar_theme.dart';

void main() => runApp(const ScolarApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
