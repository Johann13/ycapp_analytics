import 'package:firebase/firebase.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:ycapp_analytics/ycapp_analytics_platform.dart';

class YAnalyticsWebPlugin extends YAnalyticsPlatform {
  static void registerWith(Registrar registrar) {
    YAnalyticsPlatform.instance = YAnalyticsWebPlugin();
  }

  Future<void> log(String name, {Map<String, dynamic> parameters}) {
    analytics().logEvent(name, parameters);
  }
}
