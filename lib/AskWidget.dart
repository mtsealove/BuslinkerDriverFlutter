import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AskWidget extends StatefulWidget {
  @override
  _AskWidgetState createState() => _AskWidgetState();
}

class _AskWidgetState extends State<AskWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Stack(
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
                              '문의',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(0, 31, 70, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ))
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Image.asset(
              'images/logo.png',
              width: 100,
              height: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  'Bus',
                  style: TextStyle(
                      fontFamily: 'eurostile',
                      fontSize: 40,
                      color: Color.fromRGBO(0, 31, 70, 1)),
                ),
                Text(
                  'Linker',
                  style: TextStyle(
                      fontFamily: 'eurostile',
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(0, 31, 70, 1)),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Image.asset(
              'images/ask_addr.png',
              height: 30,
              width: 30,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '서울시 강남구 영동대로 510',
              style:
                  TextStyle(color: Color.fromRGBO(0, 31, 70, 1), fontSize: 15),
            ),
            SizedBox(
              height: 30,
            ),
            Image.asset(
              'images/ask_time.png',
              width: 30,
              height: 30,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '월요일 ~ 금요일',
              style:
                  TextStyle(color: Color.fromRGBO(0, 31, 70, 1), fontSize: 15),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              '08:00 ~ 20:00',
              style:
                  TextStyle(color: Color.fromRGBO(0, 31, 70, 1), fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '토요일 ~ 일요일',
              style:
                  TextStyle(color: Color.fromRGBO(0, 31, 70, 1), fontSize: 15),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              '08:00 ~ 12:00',
              style:
                  TextStyle(color: Color.fromRGBO(0, 31, 70, 1), fontSize: 15),
            ),
            SizedBox(
              height: 70,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      launch('tel://01047138131');
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      width: 150,
                      height: 60,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 31, 70, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('images/phone.png', width: 20, height: 20,),
                          SizedBox(width: 10,),
                          Text(
                            '전화문의',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      launch('http://pf.kakao.com/_Vxdxlsxb');
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      width: 150,
                      height: 60,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 31, 70, 1),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/chat.png',
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '채팅문의',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
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
