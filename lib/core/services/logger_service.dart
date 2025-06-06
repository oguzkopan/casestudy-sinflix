import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

abstract class LoggerService {
  void log(String message, {dynamic error, StackTrace? stackTrace});
  void d(String message);
  void e(String message, {dynamic error, StackTrace? stackTrace});
  void i(String message);
  void w(String message);
}

@LazySingleton(as: LoggerService)
class LoggerServiceImpl implements LoggerService {
  @override
  void log(String message, {error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('[LOG] $message');
      if (error != null) {
        print('[LOG_ERROR] $error');
      }
      if (stackTrace != null) {
        print('[LOG_STACKTRACE] $stackTrace');
      }
    }
  }

  @override
  void d(String message) {
    if (kDebugMode) print('[DEBUG] $message');
  }

  @override
  void e(String message, {error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('[ERROR] $message');
      if (error != null) print('[ERROR_DETAIL] $error');
      if (stackTrace != null) print('[ERROR_STACKTRACE] $stackTrace');
    }
  }

  @override
  void i(String message) {
    if (kDebugMode) print('[INFO] $message');
  }

  @override
  void w(String message) {
    if (kDebugMode) print('[WARNING] $message');
  }
}