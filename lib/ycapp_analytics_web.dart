import 'dart:html' as html;

import 'package:firebase/firebase.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ycapp_analytics/ycapp_analytics_platform.dart';

class YAnalyticsWebPlugin extends YAnalyticsPlatform {
  static void registerWith(Registrar registrar) {
    YAnalyticsPlatform.instance = YAnalyticsWebPlugin();
  }

  Future<void> log(String name, {Map<String, dynamic> parameters}) {
    analytics().logEvent(name, parameters);
    return null;
  }

  @override
  Future<bool> enable(bool enable) async {
    analytics().setAnalyticsCollectionEnabled(enable);
    return true;
  }

  Future<void> user() async {
    String url =
        'https://europe-west1-yogscastapp-7e6f0.cloudfunctions.net/userAccessData/user';
    String id = await getId();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> creator = await prefs.getStringList('creatorSubscriptions');
    List<String> twitch = await prefs.getStringList('twitchSubscriptions');
    List<String> youtube = await prefs.getStringList('youtubeSubscriptions');
    Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'creator': creator,
      'twitch': twitch,
      'youtube': youtube,
      'language': html.window.navigator.language,
    };
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    await http.post(
      url,
      headers: headers,
      body: data,
    );
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

  @override
  Future<String> getId() {
    return messaging().getToken();
  }
}
