import 'package:flutter/foundation.dart';

class Logger {
  static void debug(String message) {
    if (kDebugMode) {
      print('[DEBUG] ${DateTime.now().toIso8601String()}: $message');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      print('[INFO] ${DateTime.now().toIso8601String()}: $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      print('[WARNING] ${DateTime.now().toIso8601String()}: $message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[ERROR] ${DateTime.now().toIso8601String()}: $message');
      if (error != null) print('Detail Error: $error');
      if (stackTrace != null) print('StackTrace:\n$stackTrace');
    }
  }
}