// ignore_for_file: public_member_api_docs
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsEngine {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logScreenOpen(String screenName) async {
    await _analytics.logEvent(
      name: 'screen_view_custom',
      parameters: {'screen_name': screenName},
    );
  }

  static Future<void> logLanguageSelection(String language) async {
    await _analytics.logEvent(
      name: 'select_language',
      parameters: {'language': language},
    );
  }

  static Future<void> logChecklistAction(String itemId, bool completed) async {
    await _analytics.logEvent(
      name: 'checklist_action',
      parameters: {
        'item_id': itemId,
        'completed': completed ? 1 : 0,
      },
    );
  }

  static Future<void> logCountrySelection(String country) async {
    await _analytics.logEvent(
      name: 'select_country',
      parameters: {'country': country},
    );
  }
}
