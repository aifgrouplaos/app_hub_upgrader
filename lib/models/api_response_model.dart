import 'package:app_hub_upgrader/models/version_info_model.dart';

class ApiResponse {
  final int statusCode;
  final bool isSuccess;
  final String? message;
  final UpdateInfo? data;

  ApiResponse({
    this.statusCode = 0,
    this.isSuccess = false,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['status_code'] ?? 0,
      isSuccess: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UpdateInfo.fromJson(json['data']) : null,
    );
  }
}
