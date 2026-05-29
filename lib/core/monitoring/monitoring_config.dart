/// Configuration du monitoring (Sentry).
class MonitoringConfig {
  MonitoringConfig._();

  /// DSN Sentry — vide en dev/CI (Sentry désactivé).
  /// Pour activer : `--dart-define=SENTRY_DSN=https://xxx@sentry.io/123`
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

  /// Environnement remonté à Sentry (`production`, `staging`, `dev`).
  static const String environment = String.fromEnvironment(
    'SCOLAR_ENV',
    defaultValue: 'dev',
  );

  /// `true` si Sentry est configuré et doit être initialisé.
  static bool get isEnabled => sentryDsn.isNotEmpty;
}
