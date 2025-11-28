import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/version_info_model.dart';
import '../utils/app_logger.dart';

/// A customizable dialog widget for displaying app update information
class UpdateDialog extends StatelessWidget {
  final UpdateInfo updateInfo;
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
  final Widget? customLaterButton;
  final Widget? customUpdateButton;

  const UpdateDialog({
    super.key,
    required this.updateInfo,
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
    this.customLaterButton,
    this.customUpdateButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultPrimaryColor = primaryColor ?? theme.colorScheme.primary;
    final defaultBackgroundColor =
        backgroundColor ?? theme.dialogBackgroundColor;

    return PopScope(
      canPop: !updateInfo.isForced,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: defaultBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              if (customIcon != null)
                customIcon!
              else
                Icon(Icons.system_update, size: 64, color: defaultPrimaryColor),
              const SizedBox(height: 16),

              // Title
              Text(
                title ?? 'Update Available',
                style:
                    titleStyle ??
                    theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Version info
              if (updateInfo.latestVersion != null)
                Text(
                  'Version ${updateInfo.latestVersion} is now available',
                  style:
                      contentStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 16),

              // Changelog
              if (updateInfo.changelog != null &&
                  updateInfo.changelog!.fixes.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What\'s New:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...updateInfo.changelog!.fixes.map(
                        (fix) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  fix,
                                  style:
                                      contentStyle ??
                                      theme.textTheme.bodySmall?.copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!updateInfo.isForced && laterButtonText != null)
                    Expanded(
                      child:
                          customLaterButton ??
                          TextButton(
                            onPressed: () {
                              AppLogger.info(
                                'User clicked "Later" button',
                                'UpdateDialog',
                              );
                              Navigator.of(context).pop();
                              onLater?.call();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: defaultPrimaryColor,
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Text(laterButtonText!),
                          ),
                    ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child:
                        customUpdateButton ??
                        ElevatedButton(
                          onPressed: () {
                            AppLogger.info(
                              'User clicked "Update" button',
                              'UpdateDialog',
                            );
                            Navigator.of(context).pop();
                            onUpdate?.call();
                            _launchUpdateUrl();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: defaultPrimaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Text(updateButtonText ?? 'Update Now'),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUpdateUrl() async {
    if (updateInfo.downloadURL != null && updateInfo.downloadURL!.isNotEmpty) {
      final uri = Uri.parse(updateInfo.downloadURL!);
      AppLogger.info(
        'Launching download URL: ${uri.toString()}',
        'UpdateDialog',
      );

      if (await canLaunchUrl(uri)) {
        AppLogger.debug('URL can be launched, opening...', 'UpdateDialog');
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        AppLogger.info('Download URL launched successfully', 'UpdateDialog');
      } else {
        AppLogger.warning(
          'Cannot launch URL: ${uri.toString()}',
          'UpdateDialog',
        );
      }
    } else {
      AppLogger.warning('No download URL available', 'UpdateDialog');
    }
  }
}
