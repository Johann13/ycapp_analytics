import 'dart:async';

import 'package:ycapp_analytics/ycapp_analytics_platform.dart';

class YAnalytics {
  static Future<String> getId() {
    return YAnalyticsPlatform.instance.getId();
  }

  static Future<void> log(
    String name, {
    Map<String, dynamic> parameters,
  }) async {
    return YAnalyticsPlatform.instance.log(
      name,
      parameters: parameters,
    );
  }

  static Future<bool> enable(bool enable) {
    return YAnalyticsPlatform.instance.enable(enable);
  }

  static Future<void> user() async {
    return YAnalyticsPlatform.instance.user();
  }

  static Future<void> logUserSub(int hours) async {
    return YAnalyticsPlatform.instance.logUserSub(hours);
  }
}
