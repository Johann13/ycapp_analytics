import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';

class YAnalytics {
  static FirebaseAnalytics _analytics = FirebaseAnalytics();

  /*
  static Future<String> getId() {
    _analytics.
  }*/

  static Future<void> log(
    String name, {
    Map<String, dynamic> parameters,
  }) async {
    return _analytics.logEvent(name: name, parameters: parameters);
  }

  static Future<void> enable(bool enable) {
    return _analytics.setAnalyticsCollectionEnabled(enable);
  }

  /*
  static Future<void> user() async {
    return YAnalyticsPlatform.instance.user();
  }

  static Future<void> logUserSub(int hours) async {
    return YAnalyticsPlatform.instance.logUserSub(hours);
  }*/
}
