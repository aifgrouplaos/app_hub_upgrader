import 'dart:convert';
import 'dart:io';

import 'package:app_hub_upgrader/config/api_config.dart';
import 'package:app_hub_upgrader/exception/app_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../models/api_response_model.dart';
import '../models/version_info_model.dart';

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

      final String appVersion = currentVersion ?? await _version();
      final String platformName = platform ?? _platform;

      debugPrint('Checking for update: $baseUrl');

      final uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          'app_id': appID,
          'current_version': appVersion,
          'platform': platformName,
        },
      );

      final response = await http.get(uri);
      final jsonData = json.decode(response.body);
      final apiResponse = ApiResponse.fromJson({
        'status_code': response.statusCode,
        'is_success': response.statusCode == 200 || response.statusCode == 201,
        'message': jsonData['message'],
        'data': jsonData['data'],
      });

      if (!apiResponse.isSuccess) {
        throw AppException(
          apiResponse.message.toString(),
          apiResponse.statusCode,
        );
      }

      if (apiResponse.data == null) {
        throw AppException('No data found', 404);
      }

      return apiResponse.data!;
    } catch (e) {
      debugPrint('Error checking for update: $e');
      throw AppException(e.toString(), 500);
    }
  }

  String get _platform => Platform.isAndroid ? 'android' : 'ios';

  Future<String> _version() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version;
      return version;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
