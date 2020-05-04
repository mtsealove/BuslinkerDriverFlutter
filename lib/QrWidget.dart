import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

class QrWidget extends StatefulWidget {
  final String start, id;

  QrWidget(this.start, this.id);

  @override
  _QrWidgetState createState() => _QrWidgetState(this.start, this.id);
}

class _QrWidgetState extends State<QrWidget> {
  final String title, id;

  _QrWidgetState(this.title, this.id);

  String code = 'test';

  void getCode() async {
    http.Response res = await http.get(
      Uri.encodeFull('http://3.17.182.55:3300/Driver/QR?ID=${id}'),
      headers: {"Accept": "application/json"},
    );
    var rs = jsonDecode(res.body);
    print(rs);
    code = rs['Code'];
    print(code);
    setState(() {
      countDown();
    });
  }

  @override
  void initState() {
    super.initState();
    getCode();
  }

  int min = 60;

  Timer timer;

  void countDown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      min--;
      if (min == 0) {
        timer.cancel();
        Navigator.pop(context);
      } else
        setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Image.asset(
                          'images/back.png',
                          height: 20,
                          width: 15,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              title,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(0, 31, 70, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ))
                  ],
                )),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '생성된 QR 코드를',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(0, 31, 70, 1)),
                  ),
                  Text(
                    '물류관리 직원에게 보여주세요.',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(0, 31, 70, 1),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '남은시간: ${min}',
                    style: TextStyle(
                        color: Color.fromRGBO(0, 31, 70, 1), fontSize: 15),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                        color: Color.fromRGBO(0, 31, 70, 1), width: 4)),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: QrImage(
                data: code,
                version: QrVersions.auto,
                size: 200,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
