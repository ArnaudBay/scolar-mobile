/// Contrat du service de vérification des mises à jour.
///
/// Implémentation réelle (Sprint 1, Dev 1) : `in_app_update` sur Android,
/// fallback `url_launcher` vers l'App Store sur iOS.
abstract class UpdateService {
  /// Compare la version installée à la version minimale requise.
  Future<UpdateStatus> check();

  /// Lance la flow de mise à jour (Play Store / App Store).
  Future<void> launchUpdate();
}

enum UpdateStatus {
  /// L'app est à jour ou la version est acceptable.
  upToDate,

  /// Une nouvelle version est disponible mais non bloquante.
  optional,

  /// La version installée est inférieure au minimum requis → bloquant.
  required,
}
