import '../utils/app_logger.dart';

class ApiConfig {
  // Get production URL from .env or use default
  static String get baseURLProd {
    final url =
        'https://apphub-service.aifgrouplaos.com/api/v1/app-versions/check-update';
    AppLogger.debug('Using production API URL: $url', 'ApiConfig');
    return url;
  }

  // Get development URL from .env or use default
  static String get baseURLDev {
    final url = 'http://10.69.200.39:31100/api/v1/app-versions/check-update';
    AppLogger.debug('Using development API URL: $url', 'ApiConfig');
    return url;
  }
}
