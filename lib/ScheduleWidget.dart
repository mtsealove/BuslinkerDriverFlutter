import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, EventList;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ScheduleWidget extends StatefulWidget {
  final String id;

  ScheduleWidget(this.id);

  @override
  _ScheduleWidgetState createState() => _ScheduleWidgetState(id);
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  final String id;

  _ScheduleWidgetState(this.id);

  DateTime _currentDate = DateTime.now();
  EventList<Event> _markedDateMap = EventList<Event>(events: {
    DateTime(2020, 4, 26): [
      Event(
        date: DateTime(2019, 1, 24),
        title: '',
        icon: _eventIcon,
      )
    ]
  });

  static Widget _eventIcon = Container(
    height: 10,
    width: 10,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.red),
  );

  void getEventDates() async {
    http.Response res = await http.get(
      Uri.encodeFull('http://3.17.182.55:3300/Driver/Calendar?ID=${id}'),
      headers: {"Accept": "application/json"},
    );
    var rs = jsonDecode(res.body);

    for (var i = 0; i < rs.length; i++) {
//      print(rs[i]['RunDate']);
      String rd = rs[i]['RunDate'];
      int year = int.tryParse(rd.split('-')[0]);
      int month = int.tryParse(rd.split('-')[1]);
      int day = int.tryParse(rd.split('-')[2]);
      _markedDateMap.add(DateTime(year, month, day),
          Event(date: DateTime(year, month, day), icon: _eventIcon));
    }
    setState(() {});
  }

  var locName = [], locTime = [], locAddr = [];

  void getTimeline(DateTime dateTime) async {
    String date = DateFormat('yyyy-MM-dd').format(dateTime);
    http.Response res = await http.get(
      Uri.encodeFull(
          'http://3.17.182.55:3300/Driver/Timeline?ID=${id}&Date=${date}'),
      headers: {"Accept": "application/json"},
    );
    var rs = jsonDecode(res.body);
    var route = rs['route'];
    var timeline = rs['timeline'];
//    print(rs);

    locName = [];
    locTime = [];
    locAddr = [];
    if (timeline != null) {
//      print(timeline);
      for (int i = 0; i < timeline.length; i++) {
        locName.add(timeline[i]['LocName']);
        locTime.add(timeline[i]['RcTime'].substring(0, 5));
        locAddr.add(timeline[i]['LocAddr']);
      }
    }
    setState(() {
      dateStr = date;
      if (route != null) {
        routeName = route['Name'];
        if (route['Num'] != null) {
          carNum = route['Num'];
        } else {
          carNum = '';
        }
      } else {
        routeName = '';
        carNum = '';
      }
    });
  }

  String routeName = '', carNum = '', dateStr = '';

  @override
  void initState() {
    super.initState();
    getEventDates();
    getTimeline(DateTime.now());
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setState(() {
      dateStr = date;
    });
  }

  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Stack(
            key: key,
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
                            '스케줄 확인',
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
          CalendarCarousel<Event>(
            onDayPressed: (DateTime date, List<Event> events) {
              print(date);
              this.getTimeline(date);
              this.setState(() => _currentDate = date);
            },
            weekendTextStyle: TextStyle(
              color: Colors.red,
            ),
            thisMonthDayBorderColor: Colors.transparent,
            weekFormat: false,
            locale: 'ko',
            height: 420.0,
            markedDatesMap: _markedDateMap,
            selectedDateTime: _currentDate,
            daysHaveCircularBorder: true,
            todayButtonColor: Color.fromRGBO(64, 112, 244, 1),
            todayBorderColor: Colors.transparent,
            selectedDayButtonColor: Color.fromRGBO(0, 31, 70, 1),
            selectedDayBorderColor: Colors.transparent,
            iconColor: Color.fromRGBO(0, 31, 70, 1),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dateStr,
                          style: TextStyle(
                              color: Color.fromRGBO(0, 31, 46, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          routeName,
                          style: TextStyle(
                              color: Color.fromRGBO(0, 31, 46, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      carNum,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 31, 70, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ],
            ),
          ),
          ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: 100,
                  maxWidth: double.maxFinite,
                  minWidth: double.maxFinite,
                  maxHeight: 200),
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                color: Colors.white,
                child: ListView.builder(
                  itemBuilder: (context, p) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(226, 226, 226, 0.5)))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                locName[p],
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 31, 70, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                locAddr[p],
                                style: TextStyle(
                                    color: Color.fromRGBO(191, 191, 191, 1),
                                    fontSize: 16),
                              )
                            ],
                          ),
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(0, 31, 70, 1)),
                            child: Center(
                              child: Text(
                                locTime[p],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: locAddr.length,
                ),
              ))
        ],
      ),
    ));
  }
}
