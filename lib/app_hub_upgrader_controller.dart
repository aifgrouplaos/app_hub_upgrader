import 'package:flutter/material.dart';

import 'models/version_info_model.dart';
import 'services/version_checker_service.dart';
import 'widgets/update_dialog.dart';

/// Main controller class for checking app updates and displaying update dialogs
class AppHubUpgrader {
  final VersionCheckerService _versionChecker;
  final BuildContext? context;
  final bool useProduction;
  final UpdateDialogConfig? dialogConfig;

  AppHubUpgrader({
    required String appID,
    this.context,
    this.useProduction = true,
    this.dialogConfig,
  }) : _versionChecker = VersionCheckerService(appID: appID);

  /// Check for app updates and automatically show dialog if update is available
  Future<UpdateInfo?> checkForUpdate({
    BuildContext? context,
    String? platform,
    String? currentVersion,
    bool showDialog = true,
    bool checkOnly = false,
  }) async {
    try {
      final updateInfo = await _versionChecker.checkForUpdate(
        platform: platform,
        currentVersion: currentVersion,
        useProduction: useProduction,
      );

      if (checkOnly) {
        return updateInfo;
      }

      if (updateInfo.hasUpdate && showDialog) {
        final dialogContext = context ?? this.context;
        if (dialogContext != null && dialogContext.mounted) {
          await _showUpdateDialog(dialogContext, updateInfo);
        }
      }

      return updateInfo;
    } catch (e) {
      debugPrint('AppHubUpgrader Error: $e');
      return null;
    }
  }

  /// Show update dialog manually
  Future<void> showUpdateDialog(
    BuildContext context,
    UpdateInfo updateInfo,
  ) async {
    await _showUpdateDialog(context, updateInfo);
  }

  Future<void> _showUpdateDialog(
    BuildContext context,
    UpdateInfo updateInfo,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: !updateInfo.isForcedUpdate,
      builder: (context) => UpdateDialog(
        updateInfo: updateInfo,
        title: dialogConfig?.title,
        updateButtonText: dialogConfig?.updateButtonText,
        laterButtonText: dialogConfig?.laterButtonText,
        onUpdate: dialogConfig?.onUpdate,
        onLater: dialogConfig?.onLater,
        primaryColor: dialogConfig?.primaryColor,
        backgroundColor: dialogConfig?.backgroundColor,
        titleStyle: dialogConfig?.titleStyle,
        contentStyle: dialogConfig?.contentStyle,
        customIcon: dialogConfig?.customIcon,
      ),
    );
  }
}

/// Configuration class for customizing the update dialog appearance and behavior
class UpdateDialogConfig {
  final String? title;
  final String? updateButtonText;
  final String? laterButtonText;
  final VoidCallback? onUpdate;
  final VoidCallback? onLater;
  final Color? primaryColor;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final Widget? customIcon;

  const UpdateDialogConfig({
    this.title,
    this.updateButtonText,
    this.laterButtonText,
    this.onUpdate,
    this.onLater,
    this.primaryColor,
    this.backgroundColor,
    this.titleStyle,
    this.contentStyle,
    this.customIcon,
  });
}
