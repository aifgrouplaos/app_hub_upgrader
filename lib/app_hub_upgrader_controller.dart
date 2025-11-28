import 'package:flutter/material.dart';

import 'models/version_info_model.dart';
import 'services/version_checker_service.dart';
import 'utils/app_logger.dart';
import 'widgets/update_dialog.dart';

/// Main controller class for checking app updates and displaying update dialogs
class AppHubUpgrader {
  // Static initialization storage
  static String? _initializedAppID;
  static GlobalKey<NavigatorState>? _initializedNavigatorKey;
  static bool _initializedUseProduction = true;
  static UpdateDialogConfig? _initializedDialogConfig;
  static bool _isInitialized = false;

  final VersionCheckerService _versionChecker;
  final GlobalKey<NavigatorState>? navigatorKey;
  final bool useProduction;
  final UpdateDialogConfig? dialogConfig;

  /// Initialize AppHubUpgrader with global parameters
  ///
  /// Call this once in your app's main function or initialization code.
  /// After initialization, you can create instances without passing these parameters.
  ///
  /// Example:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   // Initialize AppHubUpgrader
  ///   AppHubUpgrader.initialize(
  ///     appID: 'your-app-id',
  ///     navigatorKey: MyApp.navigatorKey,
  ///     useProduction: true,
  ///     dialogConfig: UpdateDialogConfig(
  ///       title: 'Update Available',
  ///       updateButtonText: 'Update Now',
  ///     ),
  ///   );
  ///
  ///   runApp(MyApp());
  /// }
  /// ```
  ///
  /// Then create instances easily:
  /// ```dart
  /// final upgrader = AppHubUpgrader(); // Uses initialized values
  /// await upgrader.checkForUpdate();
  /// ```
  static void initialize({
    required String appID,
    GlobalKey<NavigatorState>? navigatorKey,
    BuildContext? context,
    bool useProduction = true,
    UpdateDialogConfig? dialogConfig,
  }) {
    _initializedAppID = appID;
    _initializedNavigatorKey = navigatorKey;
    _initializedUseProduction = useProduction;
    _initializedDialogConfig = dialogConfig;
    _isInitialized = true;

    AppLogger.info(
      'AppHubUpgrader initialized - appID: $appID, useProduction: $useProduction',
      'AppHubUpgrader',
    );
  }

  /// Check if AppHubUpgrader has been initialized
  static bool get isInitialized => _isInitialized;

  /// Get the initialized app ID
  static String? get initializedAppID => _initializedAppID;

  /// Create an instance of AppHubUpgrader
  ///
  /// If [initialize] has been called, you can omit [appID] and other parameters.
  /// They will be taken from the initialized values.
  ///
  /// [appID] - Your application ID (required if not initialized, otherwise optional)
  /// [navigatorKey] - GlobalKey for NavigatorState for showing dialogs without context (recommended)
  /// [context] - BuildContext for backward compatibility (deprecated, use navigatorKey instead)
  /// [useProduction] - Whether to use production API (default: true or initialized value)
  /// [dialogConfig] - Configuration for the update dialog (optional, uses initialized value if not provided)
  AppHubUpgrader({
    String? appID,
    GlobalKey<NavigatorState>? navigatorKey,
    BuildContext? context,
    bool? useProduction,
    UpdateDialogConfig? dialogConfig,
  }) : navigatorKey = navigatorKey ?? _initializedNavigatorKey,
       useProduction = useProduction ?? _initializedUseProduction,
       dialogConfig = dialogConfig ?? _initializedDialogConfig,
       _versionChecker = VersionCheckerService(
         appID:
             appID ??
             _initializedAppID ??
             (throw ArgumentError(
               'appID is required. Either provide it in the constructor or call AppHubUpgrader.initialize() first.',
             )),
       ) {
    if (!_isInitialized && appID == null) {
      AppLogger.warning(
        'AppHubUpgrader not initialized. Consider calling AppHubUpgrader.initialize() in your main function.',
        'AppHubUpgrader',
      );
    }
  }

  /// Get a valid context for showing dialogs
  ///
  /// Priority order:
  /// 1. Provided context (if valid and mounted)
  /// 2. Navigator key's current context (if available and mounted)
  /// 3. Root navigator context (if available)
  BuildContext? _getValidContext([BuildContext? providedContext]) {
    // Priority 1: Use provided context if valid
    if (providedContext != null && providedContext.mounted) {
      AppLogger.debug('Using provided context', 'AppHubUpgrader');
      return providedContext;
    }

    // Priority 2: Use instance navigator key's context if available
    final keyToUse = navigatorKey ?? _initializedNavigatorKey;
    if (keyToUse != null) {
      final context = keyToUse.currentContext;
      if (context != null && context.mounted) {
        AppLogger.debug('Using navigator key context', 'AppHubUpgrader');
        return context;
      } else {
        AppLogger.debug(
          'Navigator key context is null or not mounted',
          'AppHubUpgrader',
        );
      }
    }

    // Priority 3: Try to find root navigator from the provided context
    if (providedContext != null) {
      try {
        final rootContext = Navigator.of(
          providedContext,
          rootNavigator: true,
        ).context;
        if (rootContext.mounted) {
          AppLogger.debug(
            'Using root navigator context from provided context',
            'AppHubUpgrader',
          );
          return rootContext;
        }
      } catch (e) {
        AppLogger.debug(
          'Could not get root navigator from provided context: $e',
          'AppHubUpgrader',
        );
      }
    }

    AppLogger.debug('No valid context found', 'AppHubUpgrader');
    return null;
  }

  /// Check for app updates and automatically show dialog if update is available
  Future<UpdateInfo?> checkForUpdate({
    BuildContext? context,
    String? platform,
    String? currentVersion,
    bool showDialog = true,
    bool checkOnly = false,
  }) async {
    AppLogger.info(
      'Checking for app update (production: $useProduction, checkOnly: $checkOnly)',
      'AppHubUpgrader',
    );

    try {
      final updateInfo = await _versionChecker.checkForUpdate(
        platform: platform,
        currentVersion: currentVersion,
        useProduction: useProduction,
      );

      AppLogger.info(
        'Update check completed - updateAvailable: ${updateInfo.updateAvailable}, '
            'latestVersion: ${updateInfo.latestVersion}, '
            'isForcedUpdate: ${updateInfo.isForced}',
        'AppHubUpgrader',
      );

      if (checkOnly) {
        AppLogger.debug(
          'Check only mode - returning update info without showing dialog',
          'AppHubUpgrader',
        );
        return updateInfo;
      }

      if (updateInfo.updateAvailable && showDialog) {
        final dialogContext = _getValidContext(context);
        if (dialogContext != null && dialogContext.mounted) {
          AppLogger.info('Showing update dialog', 'AppHubUpgrader');
          await _showUpdateDialog(dialogContext, updateInfo);
        } else {
          AppLogger.warning(
            'Cannot show dialog - no valid context available. '
                'Please provide a BuildContext or GlobalKey for NavigatorState',
            'AppHubUpgrader',
          );
        }
      } else if (!updateInfo.updateAvailable) {
        AppLogger.info(
          'No update available - app is up to date',
          'AppHubUpgrader',
        );
      }

      return updateInfo;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to check for update', e, 'AppHubUpgrader');
      AppLogger.debug('Stack trace: $stackTrace', 'AppHubUpgrader');
      return null;
    }
  }

  /// Show update dialog manually
  ///
  /// If context is not provided, will try to use the navigator key or find root navigator
  Future<void> showUpdateDialog(
    UpdateInfo updateInfo, [
    BuildContext? context,
  ]) async {
    AppLogger.info('Manually showing update dialog', 'AppHubUpgrader');

    final dialogContext = _getValidContext(context);
    if (dialogContext == null || !dialogContext.mounted) {
      AppLogger.error(
        'Cannot show dialog - no valid context available. '
            'Please provide a BuildContext or GlobalKey for NavigatorState',
        null,
        'AppHubUpgrader',
      );
      return;
    }

    await _showUpdateDialog(dialogContext, updateInfo);
  }

  Future<void> _showUpdateDialog(
    BuildContext context,
    UpdateInfo updateInfo,
  ) async {
    AppLogger.debug(
      'Displaying update dialog - forced: ${updateInfo.isForced}, '
          'version: ${updateInfo.latestVersion}',
      'AppHubUpgrader',
    );

    await showDialog(
      context: context,
      barrierDismissible: !updateInfo.isForced,
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

    AppLogger.debug('Update dialog closed', 'AppHubUpgrader');
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
