import 'change_logs_model.dart';

class UpdateInfo {
  final bool hasUpdate;
  final String? latestVersion;
  final String? currentVersion;
  final bool isForcedUpdate;
  final String? minSupportedVersion;
  final String? downloadUrl;
  final Changelog? changelog;
  final String? releaseDate;

  UpdateInfo({
    this.hasUpdate = false,
    this.latestVersion,
    this.currentVersion,
    this.isForcedUpdate = false,
    this.minSupportedVersion,
    this.downloadUrl,
    this.changelog,
    this.releaseDate,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      hasUpdate: json['has_update'] ?? false,
      latestVersion: json['latest_version'] ?? '',
      currentVersion: json['current_version'] ?? '',
      isForcedUpdate: json['is_forced_update'] ?? false,
      minSupportedVersion: json['min_supported_version'] ?? '',
      downloadUrl: json['download_url'] ?? '',
      changelog: Changelog.fromJson(json['changelog'] ?? {}),
      releaseDate: json['release_date'] ?? '',
    );
  }
}
