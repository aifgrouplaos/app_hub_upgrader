import 'dart:convert';
import 'dart:io';

import 'package:app_hub_upgrader/config/api_config.dart';
import 'package:app_hub_upgrader/exception/app_exception.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../models/api_response_model.dart';
import '../models/version_info_model.dart';
import '../utils/app_logger.dart';

class VersionCheckerService {
  final String appID;

  VersionCheckerService({required this.appID});

  Future<UpdateInfo> checkForUpdate({
    String? platform,
    String? currentVersion,
    bool useProduction = true,
  }) async {
    try {
      String baseUrl = useProduction
          ? ApiConfig.baseURLProd
          : ApiConfig.baseURLDev;

      AppLogger.info(
        'Using ${useProduction ? "production" : "development"} API: $baseUrl',
        'VersionCheckerService',
      );

      final String appVersion = currentVersion ?? await getVersion();
      final String platformName = _platform;

      AppLogger.debug(
        'App version: $appVersion, Platform: $platformName, App ID: $appID',
        'VersionCheckerService',
      );

      final uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          'app_id': appID,
          'current_version': appVersion,
          'platform': platformName,
        },
      );

      AppLogger.info(
        'Requesting update check from: ${uri.toString()}',
        'VersionCheckerService',
      );

      final response = await http.get(uri);

      AppLogger.debug(
        'API response - Status: ${response.statusCode}, '
            'Body length: ${response.body.length}',
        'VersionCheckerService',
      );

      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      final apiResponse = ApiResponse.fromJson({
        'status_code': response.statusCode,
        'is_success': response.statusCode == 200 || response.statusCode == 201,
        'message': jsonData['message'],
        'data': jsonData['data'],
      });

      AppLogger.info('API response: $jsonData');

      if (!apiResponse.isSuccess) {
        AppLogger.error(
          'API request failed - Status: ${apiResponse.statusCode}, '
              'Message: ${apiResponse.message}',
          null,
          'VersionCheckerService',
        );
        throw AppException(
          apiResponse.message.toString(),
          apiResponse.statusCode,
        );
      }

      if (apiResponse.data == null) {
        AppLogger.warning(
          'API returned success but no data',
          'VersionCheckerService',
        );
        throw AppException('No data found', 404);
      }

      AppLogger.info(
        'Update check successful - hasUpdate: ${apiResponse.data!.hasUpdate}',
        'VersionCheckerService',
      );

      return apiResponse.data!;
    } catch (e, stackTrace) {
      if (e is AppException) {
        AppLogger.error(
          'Update check failed with AppException',
          e,
          'VersionCheckerService',
        );
        rethrow;
      }
      AppLogger.error(
        'Update check failed with unexpected error',
        e,
        'VersionCheckerService',
      );
      AppLogger.debug('Stack trace: $stackTrace', 'VersionCheckerService');
      throw AppException(e.toString(), 500);
    }
  }

  String get _platform => Platform.isAndroid ? 'android' : 'ios';

  Future<String> getVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version;
      AppLogger.debug(
        'Detected app version: $version',
        'VersionCheckerService',
      );
      return version;
    } catch (e) {
      AppLogger.error('Failed to get app version', e, 'VersionCheckerService');
      throw Exception(e.toString());
    }
  }
}
