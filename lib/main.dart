import 'package:flutter/material.dart';
import 'features/routing/app_router.dart';
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
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.onboarding,
    );
  }
}
