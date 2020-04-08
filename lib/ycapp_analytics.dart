import 'dart:async';

import 'package:ycapp_analytics/ycapp_analytics_platform.dart';

class YAnalytics {
  static Future<void> log(
    String name, {
    Map<String, dynamic> parameters,
  }) async {
    return YAnalyticsPlatform.instance.log(
      name,
      parameters: parameters,
    );
  }
}
