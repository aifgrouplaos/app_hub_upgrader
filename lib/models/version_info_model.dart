import 'change_logs_model.dart';

class UpdateInfo {
  final bool updateAvailable;
  final String? latestVersion;
  final bool isForced;
  final String? downloadURL;
  final Changelog? changelog;

  UpdateInfo({
    this.updateAvailable = false,
    this.latestVersion,
    this.isForced = false,
    this.changelog,
    this.downloadURL,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      updateAvailable: json['updateAvailable'] ?? false,
      latestVersion: json['latestVersion'],
      isForced: json['isForced'] ?? false,
      changelog: json['changelog'] != null
          ? Changelog.fromJson(json['changelog'])
          : null,
      downloadURL: json['downloadURL'],
    );
  }
}
