import 'dart:convert';
import 'dart:ui';

import 'package:buslinkerpt/AskWidget.dart';
import 'package:buslinkerpt/ScheduleWidget.dart';
import 'package:buslinkerpt/TitleWidget.dart';
import 'package:buslinkerpt/ToturialWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MainWidget extends StatefulWidget {
  final String id, name, profile;

  MainWidget(this.id, this.name, this.profile);

  @override
  _MainWidgetState createState() => _MainWidgetState(id, name, profile);
}

class _MainWidgetState extends State<MainWidget> {
  final String id, name, profile;

  _MainWidgetState(this.id, this.name, this.profile);

  String routeName = '없음';
  int wayPointCnt = 0;

  @override
  void initState() {
    super.initState();
    print('profile');
    print(profile);
    getMy();
  }

  void getMy() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String id = pref.getString('id');
    http.Response res = await http.get(
      Uri.encodeFull('http://3.17.182.55:3300/Driver/My?ID=${id}'),
      headers: {"Accept": "application/json"},
    );
    var rs = jsonDecode(res.body);
    String route = rs['Name'];
    String wayPoints = rs['Locations'];

    setState(() {
      if (route != null) {
        routeName = route;
      }
      if (wayPoints != null) {
        wayPointCnt = wayPoints.split(',').length;
      }
    });
  }

  void Logout() async {
    await showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text('로그아웃'),
            content: Text('로그아웃 하시겠습니까?'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '확인',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  '취소',
                  style: TextStyle(color: Color.fromRGBO(0, 31, 70, 1)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: TitleWidget(),
              ),
              Positioned(
                top: 50,
                width: MediaQuery.of(context).size.width - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${name}님',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromRGBO(0, 31, 70, 1),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '안녕하세요.',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromRGBO(0, 31, 70, 1),
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    ClipOval(
                      child: Image.network(
                        'http://3.17.182.55/public/uploads/${profile}',
                        width: 50,
                        height: 50,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '오늘의 노선은',
                      style: TextStyle(
                          fontSize: 24, color: Color.fromRGBO(0, 31, 70, 1)),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          routeName,
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromRGBO(0, 31, 70, 1),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '이며',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromRGBO(0, 31, 70, 1)),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '${wayPointCnt}개의 경유지',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromRGBO(0, 31, 70, 1),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '가 있습니다.',
                          style: TextStyle(
                              fontSize: 24,
                              color: Color.fromRGBO(0, 31, 70, 1)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: 40,
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 15,
                            child: RaisedButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ScheduleWidget(id)));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20))),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      'images/main_schedule.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '스케줄 확인',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 31, 71, 1),
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(),
                          ),
                          Expanded(
                            flex: 15,
                            child: RaisedButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        TutorialWidget()));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20))),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      'images/main_tutorial.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '튜토리얼',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 31, 71, 1),
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 15,
                            child: RaisedButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        AskWidget()));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20))),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      'images/main_ask.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '문의하기',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 31, 71, 1),
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(),
                          ),
                          Expanded(
                            flex: 15,
                            child: RaisedButton(
                              color: Colors.white,
                              onPressed: () {
                                Logout();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20))),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      'images/main_logout.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '로그아웃',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 31, 71, 1),
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
