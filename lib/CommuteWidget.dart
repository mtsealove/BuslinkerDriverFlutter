import 'dart:convert';

import 'package:buslinkerpt/QrWidget.dart';
import 'package:buslinkerpt/TitleWidget.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommuteWidget extends StatefulWidget {
  final String id, name;

  CommuteWidget(this.id, this.name);

  @override
  _CommuteWidgetState createState() => _CommuteWidgetState(id, name);
}

class _CommuteWidgetState extends State<CommuteWidget> {
  final String id, name;

  _CommuteWidgetState(this.id, this.name);

  void moveToQr(bool start) {
    String title = '';
    if (start) {
      title = '출근';
    } else {
      title = '퇴근';
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrWidget(title, id)),
    );
  }

  void getCommute() async {
    http.Response res = await http.get(
      Uri.encodeFull('http://3.17.182.55:3300/Commute?ID=${id}'),
      headers: {"Accept": "application/json"},
    );
    var rs = jsonDecode(res.body);
    print(rs);
    bool commute = rs['Result'];
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getCommute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: TitleWidget(),
            ),
            Positioned(
              top: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '환영합니다.',
                    style: TextStyle(
                        fontSize: 30, color: Color.fromRGBO(0, 31, 70, 1)),
                  ),
                  Text(
                    name + '님',
                    style: TextStyle(
                        fontSize: 30,
                        color: Color.fromRGBO(0, 31, 70, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      moveToQr(true);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 31, 70, 1),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '출근하시겠습니까?',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            '출근 QR코드를 생성합니다.',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    onPressed: () {
                      moveToQr(false);
                    },
                    padding: const EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 31, 70, 1),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '퇴근하시겠습니까?',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            '퇴근 QR코드를 생성합니다.',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
