import 'dart:io';

import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/app_metadata_repository.dart';
import '../domain/update_service.dart';

/// Impl plateforme :
/// - Android : `in_app_update` (flow Google natif)
/// - iOS : compare la version installée à `AppMetadataRepository.minVersion`,
///         ouvre l'App Store via `url_launcher` si dépassée.
class PlatformUpdateService implements UpdateService {
  PlatformUpdateService({
    required AppMetadataRepository metadataRepository,
    String? iosAppStoreUrl,
  }) : _metadata = metadataRepository,
       _iosAppStoreUrl =
           iosAppStoreUrl ?? 'https://apps.apple.com/app/scolar/id000000000';

  final AppMetadataRepository _metadata;
  final String _iosAppStoreUrl;

  @override
  Future<UpdateStatus> check() async {
    if (Platform.isAndroid) {
      try {
        final info = await InAppUpdate.checkForUpdate();
        switch (info.updateAvailability) {
          case UpdateAvailability.updateAvailable:
            return info.immediateUpdateAllowed
                ? UpdateStatus.required
                : UpdateStatus.optional;
          case UpdateAvailability.updateNotAvailable:
          case UpdateAvailability.unknown:
          case UpdateAvailability.developerTriggeredUpdateInProgress:
            return UpdateStatus.upToDate;
        }
      } catch (_) {
        return UpdateStatus.upToDate;
      }
    }
    if (Platform.isIOS) {
      try {
        final metadata = await _metadata.fetch();
        final info = await PackageInfo.fromPlatform();
        if (_versionLessThan(info.version, metadata.minVersion)) {
          return UpdateStatus.required;
        }
        if (_versionLessThan(info.version, metadata.latestVersion)) {
          return UpdateStatus.optional;
        }
      } catch (_) {
        // Backend down → on n'embête pas l'utilisateur.
      }
      return UpdateStatus.upToDate;
    }
    return UpdateStatus.upToDate;
  }

  @override
  Future<void> launchUpdate() async {
    if (Platform.isAndroid) {
      try {
        await InAppUpdate.performImmediateUpdate();
      } catch (_) {
        // Fallback : ouvrir le Play Store.
        await _launchUrl(
          'https://play.google.com/store/apps/details?id=cf.scolar.mobile',
        );
      }
      return;
    }
    if (Platform.isIOS) {
      await _launchUrl(_iosAppStoreUrl);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Comparaison sémantique simple : `1.0.2 < 1.1.0`.
  bool _versionLessThan(String installed, String minRequired) {
    List<int> parse(String v) =>
        v.split('.').map((p) => int.tryParse(p) ?? 0).toList();
    final a = parse(installed);
    final b = parse(minRequired);
    final len = a.length > b.length ? a.length : b.length;
    for (int i = 0; i < len; i++) {
      final ai = i < a.length ? a[i] : 0;
      final bi = i < b.length ? b[i] : 0;
      if (ai < bi) return true;
      if (ai > bi) return false;
    }
    return false;
  }
}
