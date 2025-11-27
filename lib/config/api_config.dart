import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Get production URL from .env or use default
  static String get baseURLProd {
    try {
      final envUrl = dotenv.env['API_BASE_URL_PROD'];
      if (envUrl != null && envUrl.isNotEmpty) {
        return envUrl;
      }
    } catch (e) {
      // .env not loaded or key not found, use default
    }
    return '';
  }

  // Get development URL from .env or use default
  static String get baseURLDev {
    try {
      final envUrl = dotenv.env['API_BASE_URL_DEV'];
      if (envUrl != null && envUrl.isNotEmpty) {
        return envUrl;
      }
    } catch (e) {
      // .env not loaded or key not found, use default
    }
    return '';
  }

  /// Initialize .env file (call this in your app's main function)
  ///
  /// Example:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await AppHubUpgrader.initialize();
  ///   runApp(MyApp());
  /// }
  /// ```
  ///
  /// Or with custom filename:
  /// ```dart
  /// await AppHubUpgrader.initialize(filename: '.env.production');
  /// ```
  static Future<void> loadEnv({String filename = '.env'}) async {
    try {
      await dotenv.load(fileName: filename);
    } catch (e) {
      // .env file not found, will use default values
      // This is fine for packages that may not have .env
    }
  }
}
