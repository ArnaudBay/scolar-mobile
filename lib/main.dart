import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/cache/cache_store.dart';
import 'core/monitoring/monitoring.dart';
import 'core/router/app_router.dart';
import 'features/onboarding/data/onboarding_repository.dart';
import 'theme/scolar_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge : la barre de statut (heure, batterie) et la barre de
  // navigation système sont entièrement transparentes — le contenu de l'app
  // passe en dessous.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    ),
  );

  final prefs = await SharedPreferences.getInstance();

  await Monitoring.bootstrap(() async {
    runApp(
      ProviderScope(
        overrides: <Override>[
          onboardingRepositoryProvider.overrideWithValue(
            SharedPrefsOnboardingRepository(prefs),
          ),
          cacheStoreProvider.overrideWithValue(SharedPrefsCacheStore(prefs)),
        ],
        child: const ScolarApp(),
      ),
    );
  });
}

class ScolarApp extends ConsumerWidget {
  const ScolarApp({super.key});

  /// Overlay style appliqué globalement à l'app — barres système (status +
  /// nav) entièrement transparentes, icônes sombres adaptées aux fonds
  /// clairs (crème, blanc).
  static const SystemUiOverlayStyle _overlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemStatusBarContrastEnforced: false,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    // AnnotatedRegion réapplique l'overlay à chaque frame : indispensable
    // car AppBar/BottomNavigationBar repoussent leur propre style sinon.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: MaterialApp.router(
        title: 'Scolar',
        debugShowCheckedModeBanner: false,
        theme: ScolarTheme.light,
        routerConfig: router,
        // i18n — scaffolding FR + EN ; la migration des écrans existants
        // se fait progressivement (voir lib/l10n/README.md).
        locale: const Locale('fr'),
        supportedLocales: const <Locale>[Locale('fr'), Locale('en')],
        localizationsDelegates: const <LocalizationsDelegate<Object>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
