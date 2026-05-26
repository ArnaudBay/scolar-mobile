import 'package:flutter/material.dart';

import 'features/showcase/showcase_screen.dart';
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
      home: const ShowcaseScreen(),
    );
  }
}
