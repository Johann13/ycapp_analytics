import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ycapp_analytics/ycapp_analytics_platform.dart';

class MethodChannelYAnalytics extends YAnalyticsPlatform {
  static const MethodChannel _channel = const MethodChannel('ycappanalytics');

  @override
  Future<String> getId() {
    return _channel.invokeMethod('id');
  }

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
  Future<bool> enable(bool enable) {
    return _channel.invokeMethod('enable', {'enable': enable});
  }

  Future<void> user() {
    return _channel.invokeMethod('user');
  }

  Future<void> logUserSub(int hours) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastUserLog = await prefs.getInt('lastUserLog') ??
        DateTime.now().subtract(Duration(days: 7)).millisecondsSinceEpoch;
    DateTime now = DateTime.now();
    DateTime lastLogDate = DateTime.fromMillisecondsSinceEpoch(lastUserLog);
    Duration duration = now.difference(lastLogDate);
    if (duration.inHours >= hours) {
      await user();
      await prefs.setInt('lastUserLog', now.millisecondsSinceEpoch);
    }
  }
}
