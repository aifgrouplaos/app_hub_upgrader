import 'dart:io';

class AppException extends HttpException {
  final int statusCode;
  final String message;

  AppException(this.message, this.statusCode) : super(message);
}
