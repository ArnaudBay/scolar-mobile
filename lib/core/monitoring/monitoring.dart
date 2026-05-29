import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'monitoring_config.dart';

/// Bootstrap monitoring (Sentry).
///
/// Si `MonitoringConfig.sentryDsn` est vide → no-op (utilisé en dev/CI).
/// Sinon, initialise Sentry puis lance [appRunner] dans la zone Sentry.
///
/// Capture aussi les erreurs Flutter framework et async non rattrapées.
class Monitoring {
  Monitoring._();

  static Future<void> bootstrap(FutureOr<void> Function() appRunner) async {
    if (!MonitoringConfig.isEnabled) {
      await appRunner();
      return;
    }

    await SentryFlutter.init((options) {
      options.dsn = MonitoringConfig.sentryDsn;
      options.environment = MonitoringConfig.environment;
      options.tracesSampleRate = kReleaseMode ? 0.2 : 1.0;
      options.attachStacktrace = true;
      options.sendDefaultPii = false;
    }, appRunner: appRunner);
  }

  /// Helper pour rapporter une erreur métier (catch + report + rethrow).
  static Future<void> report(
    Object error,
    StackTrace? stack, {
    String? hint,
  }) async {
    if (!MonitoringConfig.isEnabled) return;
    await Sentry.captureException(
      error,
      stackTrace: stack,
      hint: hint == null ? null : Hint.withMap({'detail': hint}),
    );
  }
}
