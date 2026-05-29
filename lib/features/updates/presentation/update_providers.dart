import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_config.dart';
import '../../../core/network/dio_client.dart';
import '../data/dio_app_metadata_repository.dart';
import '../data/noop_update_service.dart';
import '../data/platform_update_service.dart';
import '../data/static_app_metadata_repository.dart';
import '../domain/app_metadata_repository.dart';
import '../domain/update_service.dart';

/// Repository de métadonnées app (min-version + latest-version).
final appMetadataRepositoryProvider = Provider<AppMetadataRepository>((ref) {
  if (ApiConfig.useFakes) return const StaticAppMetadataRepository();
  return DioAppMetadataRepository(ref.watch(dioClientProvider));
});

/// Switch fakes/plateforme.
final updateServiceProvider = Provider<UpdateService>((ref) {
  if (ApiConfig.useFakes) return const NoopUpdateService();
  return PlatformUpdateService(
    metadataRepository: ref.watch(appMetadataRepositoryProvider),
  );
});
