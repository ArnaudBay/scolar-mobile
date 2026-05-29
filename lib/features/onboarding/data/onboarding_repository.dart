import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gestion de l'état "onboarding terminé" dans le stockage local.
///
/// Implémenté par défaut sur `SharedPreferences`. Le flag est posé
/// **une seule fois** à la fin du dernier slide d'onboarding et n'est
/// jamais ré-affiché ensuite (sauf désinstallation / clear data).
abstract class OnboardingRepository {
  /// `true` si l'onboarding a déjà été complété.
  bool isDone();

  /// Marque l'onboarding comme terminé (idempotent).
  Future<void> markDone();
}

/// Provider — doit être **overridé** au bootstrap avec une vraie instance
/// `SharedPreferences` (voir `main.dart`).
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  throw UnimplementedError(
    'onboardingRepositoryProvider doit être overridé au bootstrap '
    '(SharedPreferences pas encore initialisé).',
  );
});

/// Implémentation mémoire — utile pour les tests widget.
class InMemoryOnboardingRepository implements OnboardingRepository {
  InMemoryOnboardingRepository({bool initiallyDone = false})
    : _done = initiallyDone;
  bool _done;

  @override
  bool isDone() => _done;

  @override
  Future<void> markDone() async {
    _done = true;
  }
}

/// Implémentation `SharedPreferences` — utilisée en production.
class SharedPrefsOnboardingRepository implements OnboardingRepository {
  SharedPrefsOnboardingRepository(this._prefs);

  static const String _key = 'onboarding_done';
  final SharedPreferences _prefs;

  @override
  bool isDone() => _prefs.getBool(_key) ?? false;

  @override
  Future<void> markDone() async {
    await _prefs.setBool(_key, true);
  }
}
