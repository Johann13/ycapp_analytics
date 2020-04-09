import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:ycapp_analytics/method_channel_ycapp_analytics.dart';

abstract class YAnalyticsPlatform extends PlatformInterface {
  YAnalyticsPlatform() : super(token: _token);
  static final Object _token = Object();
  static YAnalyticsPlatform _instance = MethodChannelYAnalytics();

  static YAnalyticsPlatform get instance => _instance;

  static set instance(YAnalyticsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> getId() {
    throw UnimplementedError('id');
  }

  Future<void> log(String name, {Map<String, dynamic> parameters}) {
    throw UnimplementedError('log');
  }

  Future<void> enable(bool enable) {
    throw UnimplementedError('enable');
  }

  Future<void> user() {
    throw UnimplementedError('');
  }

  Future<void> logUserSub(int hours) {
    throw UnimplementedError('');
  }
}
