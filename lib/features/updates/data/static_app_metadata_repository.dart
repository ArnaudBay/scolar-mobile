import '../domain/app_metadata_repository.dart';

/// Impl statique pour les démos hors-ligne (mode fakes).
class StaticAppMetadataRepository implements AppMetadataRepository {
  const StaticAppMetadataRepository({
    this.minVersion = '1.0.0',
    this.latestVersion = '1.0.0',
  });

  final String minVersion;
  final String latestVersion;

  @override
  Future<AppMetadata> fetch() async {
    return AppMetadata(minVersion: minVersion, latestVersion: latestVersion);
  }
}
