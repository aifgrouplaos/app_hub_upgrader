class ApiConfig {
  // Get production URL from .env or use default
  static String get baseURLProd {
    return 'https://apphub-service.aifgrouplaos.com/api/v1/app-versions/check-update';
  }

  // Get development URL from .env or use default
  static String get baseURLDev {
    return 'http://10.69.200.39:31100/api/v1/app-versions/check-update';
  }
}
