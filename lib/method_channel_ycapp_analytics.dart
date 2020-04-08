import 'package:flutter/services.dart';
import 'package:ycapp_analytics/ycapp_analytics_platform.dart';

class MethodChannelYAnalytics extends YAnalyticsPlatform {
  static const MethodChannel _channel = const MethodChannel('ycappanalytics');

  @override
  Future<void> log(String name, {Map<String, dynamic> parameters}) {
    return _channel.invokeMethod(
      "log",
      {
        "name": name,
        "parameters": parameters,
      },
    );
  }

  @override
  Future<void> enable(bool enable) {
    return _channel.invokeListMethod('enable', {'enable': enable});
  }
}
