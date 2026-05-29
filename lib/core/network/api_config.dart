/// Configuration de l'API backend Scolar.
///
/// Modifié uniquement via `--dart-define=SCOLAR_API_URL=...` au build.
/// Aucune URL en dur dans le code applicatif.
class ApiConfig {
  ApiConfig._();

  /// Base URL du backend. Override possible :
  /// `flutter run --dart-define=SCOLAR_API_URL=https://staging.scolar.cf/api`
  static const String baseUrl = String.fromEnvironment(
    'SCOLAR_API_URL',
    defaultValue: 'https://api.scolar.cf/v1',
  );

  /// Timeout réseau par défaut (30 s — Bangui = connexion parfois lente).
  static const Duration timeout = Duration(seconds: 30);

  /// `true` si l'app doit utiliser les fakes au lieu du vrai backend.
  /// Pratique pour les démos hors-ligne.
  static const bool useFakes = bool.fromEnvironment(
    'SCOLAR_USE_FAKES',
    defaultValue: true,
  );
}
