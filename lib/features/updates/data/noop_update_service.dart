import '../domain/update_service.dart';

/// Implémentation no-op pour Sprint 1 — renvoie toujours `upToDate`.
///
/// Dev 1 remplace en Sprint 2 par :
/// - Android : `AndroidUpdateService` basé sur `in_app_update`
/// - iOS : `IosUpdateService` basé sur `url_launcher` vers l'App Store
///
/// La version minimale doit venir d'un endpoint backend (`/app/min-version`)
/// ou de Remote Config — jamais codée en dur.
class NoopUpdateService implements UpdateService {
  const NoopUpdateService();

  @override
  Future<UpdateStatus> check() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return UpdateStatus.upToDate;
  }

  @override
  Future<void> launchUpdate() async {
    // No-op — voir TODO ci-dessus.
  }
}
