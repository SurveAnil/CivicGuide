// ignore_for_file: public_member_api_docs
import 'package:flutter/foundation.dart';

/// Standardized error logging utility.
class ErrorLogger {
  /// Logs an error with its associated stack trace.
  /// 
  /// In a production environment, this should route to Crashlytics,
  /// Sentry, or another centralized logging service.
  static void logError(dynamic error, StackTrace? stackTrace) {
    if (kDebugMode) {
      print('=================================');
      print('🚨 ERROR CAPTURED:');
      print(error);
      if (stackTrace != null) {
        print('📌 STACK TRACE:');
        print(stackTrace);
      }
      print('=================================');
    } else {
      // For now, we print securely or ignore if required by privacy policy.
      debugPrint('Error occurred: $error');
    }
  }

  /// Logs a non-fatal warning or informational message.
  static void logInfo(String message) {
    if (kDebugMode) {
      print('ℹ️ INFO: $message');
    }
  }
}
