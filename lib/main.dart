import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:buslinkerpt/DbHelper.dart';
import 'package:buslinkerpt/LocationService.dart';
import 'package:flutter/material.dart';
import 'package:buslinkerpt/Login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

// fcm setting
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<String> getID() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String ID = _pref.getString('id');
  return ID;
}

LocationService _locationService;

void firebaseCloudMessaging_Listeners() async {
  if (Platform.isIOS) iOS_Permission();

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      var action = message['action'];

      if (action != null) {
        print(action);
        if (action == 'start') {
          getID().then((ID) {
            _locationService = LocationService(ID);
            _locationService.StartTracking();
          });
        } else if (action == 'end') {
          _locationService.StopTracking();
        } else if (action == 'schedule') {
          String msg = message['message'];
          DBHelper dbHelper = DBHelper();
          dbHelper.createData(msg);
          dbHelper.getAll().then((list) {
            for(String m in list) {
              print(m);
            }
          });
        }
      }
    },
    onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    },
  );
}

Future sendNoti() async {
  var androidChannel = AndroidNotificationDetails('90', 'buslinker', '버스링커 알림',
      importance: Importance.High, priority: Priority.High);
  var iosChannel = IOSNotificationDetails();
  var notificationDetail = NotificationDetails(androidChannel, iosChannel);

  await _flutterLocalNotificationsPlugin.show(
      0, 'title', 'body', notificationDetail);
}

void iOS_Permission() {
  _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });
}

void main() {
//  postLocation();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: login(),
    );
  }
}

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Login();
  }

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();

    AndroidInitializationSettings _androidSetting =
        AndroidInitializationSettings('@minmap/ic_laucher');
    IOSInitializationSettings _iosSetting = IOSInitializationSettings();
    InitializationSettings _initSetting =
        InitializationSettings(_androidSetting, _iosSetting);
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterLocalNotificationsPlugin.initialize(_initSetting);
  }
}
