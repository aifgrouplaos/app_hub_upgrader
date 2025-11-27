import 'package:flutter/foundation.dart';

/// Logger utility that only logs in debug mode
class AppLogger {
  /// Log info message (only in debug mode)
  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      final tagPrefix = tag != null ? '[$tag] ' : '';
      debugPrint('$tagPrefix$message');
    }
  }

  /// Log error message (only in debug mode)
  static void error(String message, [Object? error, String? tag]) {
    if (kDebugMode) {
      final tagPrefix = tag != null ? '[$tag] ' : '';
      final errorInfo = error != null ? ' - Error: $error' : '';
      debugPrint('${tagPrefix}ERROR: $message$errorInfo');
    }
  }

  /// Log warning message (only in debug mode)
  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      final tagPrefix = tag != null ? '[$tag] ' : '';
      debugPrint('${tagPrefix}WARNING: $message');
    }
  }

  /// Log debug message (only in debug mode)
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final tagPrefix = tag != null ? '[$tag] ' : '';
      debugPrint('${tagPrefix}DEBUG: $message');
    }
  }
}
