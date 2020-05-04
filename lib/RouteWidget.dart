import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';

class RouteWidget extends StatefulWidget {
  final String id;

  RouteWidget(this.id);

  @override
  _RouteWidgetState createState() => _RouteWidgetState(id);
}

class _RouteWidgetState extends State<RouteWidget> {
  final String id;

  _RouteWidgetState(this.id);

  String routeName = '경로명';
  String date = new DateFormat('yyyy-MM-dd').format(DateTime.now());
  String corp = '', carNum = '', logi = '', ptName = '', ptPhone = '';

  var locName = [], locTime = [], locAddr = [], prev = [], next = [];
  var op1 = [], op2 = [], op3 = [];
  String currentName = '',
      currentTime = '',
      currentAddr = '',
      nextName = '',
      moveLabel = '운행 종료',
      nextAddr = '';

  void getTimeline() async {
    http.Response res = await http.get(
      Uri.encodeFull(
          'http://3.17.182.55:3300/Driver/Timeline?ID=${id}&Date=${date}'),
      headers: {"Accept": "application/json"},
    );
    var rs = jsonDecode(res.body);
    var route = rs['route'];
    var timeline = rs['timeline'];
    if (route != null) {
      print(route);
      print(timeline);

      if (route['Num'] != null) {
        carNum = route['Num'];
      }
      routeName = route['Name'];
      if (route['PTName'] != null) {
        ptName = route['PTName'];
      }
      if (route['PTPhone'] != null) {
        ptPhone = route['PTPhone'];
      }

      var now = DateTime.now();
      var date = DateFormat('yyyy-MM-dd ').format(now);
      for (int i = 0; i < timeline.length; i++) {
        locName.add(timeline[i]['LocName']);
        locTime.add(timeline[i]['RcTime'].substring(0, 5));
        locAddr.add(timeline[i]['LocAddr']);

        print(now
            .difference(DateTime.parse(date + timeline[i]['RcTime']))
            .inMinutes);
        if (now
                .difference(DateTime.parse(date + timeline[i]['RcTime']))
                .inMinutes >
            0) {
          prev.add(Color.fromRGBO(0, 31, 70, 1));
        } else {
          prev.add(Color.fromRGBO(248, 188, 1, 1));
        }

        if (i == 0) {
          prev[i] = (Colors.transparent);
        }
      }

      for (int i = 0; i < prev.length; i++) {
        if (i < prev.length - 1) {
          if (prev[i + 1] == Color.fromRGBO(248, 188, 1, 1)) {
            next.add(Color.fromRGBO(248, 188, 1, 1));
          } else {
            next.add(Color.fromRGBO(0, 31, 70, 1));
          }
        } else {
          next.add(Colors.transparent);
        }
      }

      for (int i = 0; i < prev.length; i++) {
        if (prev[i] == Color.fromRGBO(0, 31, 70, 1) &&
            next[i] == Color.fromRGBO(248, 188, 1, 1)) {
          next[i] = Color.fromRGBO(0, 31, 70, 1);
          if (i < prev.length - 1) {
            prev[i + 1] = Color.fromRGBO(0, 31, 70, 1);
          }
          break;
        }
      }

      for (int i = 0; i < prev.length; i++) {
//       current route
        if ((prev[i] == Colors.transparent &&
                next[i] == Color.fromRGBO(248, 188, 1, 1)) ||
            (prev[i] == Color.fromRGBO(0, 31, 70, 1) &&
                next[i] == Color.fromRGBO(248, 188, 1, 1))) {
          op1.add(0.0);
          op2.add(0.0);
          op3.add(1.0);
          currentName = locName[i];
          currentAddr = locAddr[i];
          currentTime = locTime[i];
          if (i <= locName.length - 1) {
            nextName = locName[i + 1];
            moveLabel = '${currentName}에서 ${nextName}(으)로 이동중';
            nextAddr = locAddr[i + 1];
          }
        } else if (next[i] == Color.fromRGBO(248, 188, 1, 1) ||
            next[i] == Colors.transparent) {
          op1.add(1.0);
          op2.add(0.0);
          op3.add(0.0);
        } else {
          op1.add(0.0);
          op2.add(1.0);
          op3.add(0.0);
        }
      }

      setState(() {
        corp = route['Corp'];
        logi = route['LogiName'];
      });
    }
  }

  void getNavigation(String addr) async {
    http.Response res = await http.get(
      Uri.encodeFull(
          'https://maps.googleapis.com/maps/api/geocode/json?address=${addr}&key=AIzaSyB5lgCJ9HTVukxeQCEHVB1kWXPz_4bxCMs'),
      headers: {"Accept": "application/json"},
    );
    var rs = jsonDecode(res.body);
    var latlng = rs['results'][0]['geometry']['bounds']['northeast'];
    double lat = latlng['lat'];
    double lng = latlng['lng'];
    print(lat);
  }

  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 31, 70, 1),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  '경로 안내',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  routeName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  moveLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          currentName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(249, 188, 1, 1),
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(249, 188, 1, 1),
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(249, 188, 1, 1),
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(249, 188, 1, 1),
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(249, 188, 1, 1),
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(249, 188, 1, 1),
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(249, 188, 1, 1),
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(249, 188, 1, 1),
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(249, 188, 1, 1),
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(249, 188, 1, 1),
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          nextName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(237, 244, 255, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.asset(
                            'images/logo_negative.png',
                            width: 40,
                            height: 40,
                          ),
                          Text(
                            date,
                            style:
                                TextStyle(color: Color.fromRGBO(0, 31, 70, 1)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '버스사',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                corp,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '차량번호',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                carNum,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 50,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '물류사',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                logi,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '차량번호',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                carNum,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 50,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '물류관리 직원',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                ptName,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                ptPhone,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 50,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 140,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SlidingUpPanel(
              color: Color.fromRGBO(244, 244, 244, 1),
              maxHeight: 490,
              minHeight: 120,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              panel: Container(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'images/slide_up.png',
                      width: 30,
                      height: 20,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(234, 234, 234, 1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Color.fromRGBO(0, 31, 70, 1), width: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            currentTime,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 31, 70, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                currentName,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                currentAddr,
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 31, 70, 1),
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          Container(
                              width: 50,
                              height: 30,
                              alignment: Alignment.centerRight,
                              child: FloatingActionButton(
                                onPressed: () {
                                  getNavigation(nextAddr);
                                },
                                child: Image.asset(
                                  'images/navigate.png',
                                  width: 20,
                                  height: 16,
                                ),
                                backgroundColor: Color.fromRGBO(0, 31, 70, 1),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: 200,
                      height: 3,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 31, 70, 0.4),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: 100,
                          maxWidth: double.maxFinite,
                          minWidth: double.maxFinite,
                          maxHeight: 320),
                      child: ListView.builder(
                        itemBuilder: (context, p) {
                          return Container(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  locTime[p],
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 31, 70, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      locName[p],
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 31, 70, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      locAddr[p],
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 31, 70, 1)),
                                    )
                                  ],
                                ),
                                Container(
                                  width: 60,
                                  height: 60,
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: Opacity(
                                            child: Container(
                                              width: 4,
                                              height: 30,
                                              color: prev[p],
                                            ),
                                            opacity: 1,
                                          )),
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Opacity(
                                            opacity: 1,
                                            child: Container(
                                              width: 4,
                                              height: 30,
                                              color: next[p],
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Opacity(
                                            opacity: op1[p],
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      248, 188, 1, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 1)),
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Opacity(
                                            opacity: op2[p],
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      0, 31, 70, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 1)),
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Opacity(
                                              opacity: op3[p],
                                              child: Image.asset(
                                                'images/loc_current.png',
                                                height: 25,
                                                width: 25,
                                              ))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: locAddr.length,
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
