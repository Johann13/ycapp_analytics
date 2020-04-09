import 'package:flutter/services.dart';
import 'package:ycapp_analytics/ycapp_analytics_platform.dart';
import 'package:ycapp_foundation/prefs/prefs.dart';

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
  Future<void> enable(bool enable) {
    return _channel.invokeListMethod('enable', {'enable': enable});
  }

  Future<void> user() {
    return _channel.invokeMethod('user');
  }

  Future<void> logUserSub(int hours) async {
    int lastUserLog = await Prefs.getInt('lastUserLog',
        DateTime.now().subtract(Duration(days: 7)).millisecondsSinceEpoch);
    DateTime now = DateTime.now();
    DateTime lastLogDate = DateTime.fromMillisecondsSinceEpoch(lastUserLog);
    Duration duration = now.difference(lastLogDate);
    if (duration.inHours >= hours) {
      await user();
      await Prefs.setInt('lastUserLog', now.millisecondsSinceEpoch);
    }
  }

}
