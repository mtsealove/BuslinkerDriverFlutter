import 'dart:ui';

import 'dart:async';
import 'dart:convert';
import 'package:buslinkerpt/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  String token;

  var alignment = Alignment.center;
  double op = 0;
  FocusNode node1;
  TextEditingController idController = TextEditingController(),
      pwController = TextEditingController();

  @override
  void initState() {
    super.initState();
    node1 = FocusNode();
    animate();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));

    _firebaseMessaging.getToken().then((token) {
      print('token:' + token);
      this.token = token;
    });
  }

  void animate() {
    var future = Future.delayed(const Duration(seconds: 1));
    future.asStream().listen((event) {
      setState(() {
        alignment = Alignment.topCenter;
        op = 1;
      });
    });
  }

  void checkInput() {
    String id = idController.text;
    String pw = pwController.text;
    if (id.length == 0) {
      _showDialog('실패', '아이디를 입력하세요.');
    } else if (pw.length == 0) {
      _showDialog('실패', '비밀번호를 입력하세요.');
    } else {
      login(id, pw);
    }
  }

  void login(String id, String pw) async {
    http.Response res = await http.post(
        Uri.encodeFull('http://3.17.182.55:3300/Login'),
        headers: {'Content-Type': "application/json"},
        body: jsonEncode({'ID': id, 'Password': pw, 'Cat': 6, 'Token': token}));
    var account = jsonDecode(res.body);
    print(account);
    String name = account["Name"];
    String profile = account['ProfilePath'];
    print(name);
    if (name != null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('name', name);
      pref.setString('id', id);
      pref.setString('profile', profile);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(id, name)),
      );
    } else {
      _showDialog('로그인 실패', '아이디와 비밀번호를 확인하세요');
    }
  }

  void _showDialog(String title, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  var keep = true;
  SharedPreferences pref;

  void initPref() async {}

//ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: alignment,
          padding: EdgeInsets.fromLTRB(30, 100, 30, 100),
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            children: <Widget>[
              Expanded(
                child: AnimatedAlign(
                  duration: Duration(seconds: 1),
                  alignment: alignment,
                  child: Wrap(
                    direction: Axis.vertical,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: <Widget>[
                      Image.asset(
                        'images/logo.png',
                        width: 100,
                        height: 100,
                      ),
                      Row(
                        children: <Widget>[
                          Text('Bus',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'eurostile',
                                  color: Color.fromRGBO(0, 31, 70, 1))),
                          Text('Linker',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'eurostile',
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(0, 31, 70, 1))),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: op,
                duration: Duration(seconds: 1),
                child: Column(
                  children: <Widget>[
                    TextField(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(node1);
                      },
                      decoration: InputDecoration(
                          hintText: '이메일을 입력하세요.',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      style: TextStyle(fontSize: 15),
                      keyboardType: TextInputType.emailAddress,
                      controller: idController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onEditingComplete: checkInput,
                      focusNode: node1,
                      controller: pwController,
                      decoration: InputDecoration(
                          hintText: '비밀번호를 입력하세요.',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      style: TextStyle(fontSize: 15),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                    CheckboxListTile(
                      onChanged: (bool value) {
                        setState(() {
                          keep = value;
                        });
                      },
                      title: Text('로그인 유지'),
                      value: keep,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Colors.transparent,
                      onPressed: checkInput,
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(0, 31, 70, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: const Text('로그인',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          )),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
