/// Métadonnées de l'app servies par le backend.
///
/// L'app fetch ce contrat au démarrage pour savoir :
/// - la version minimale acceptée (en dessous → écran bloquant)
/// - la dernière version disponible (pour proposition non bloquante)
abstract class AppMetadataRepository {
  Future<AppMetadata> fetch();
}

class AppMetadata {
  const AppMetadata({required this.minVersion, required this.latestVersion});

  final String minVersion;
  final String latestVersion;
}
