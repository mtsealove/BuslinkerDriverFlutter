import 'package:buslinkerpt/CommuteWidget.dart';
import 'package:buslinkerpt/MainWidget.dart';
import 'package:buslinkerpt/RouteWidget.dart';
import 'package:buslinkerpt/TitleWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String id, name;

  Home(this.id, this.name);

  @override
  _HomeState createState() => _HomeState(id, name);
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final String id, name;

  _HomeState(this.id, this.name);

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    tabController.addListener(() {

    });
    getProfile();
  }

  String profile = '';

  void getProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      profile = pref.getString('profile');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromRGBO(245, 245, 245, 1), Colors.white],
              stops: [0, 1])),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(245, 245, 245, 1),
          bottomNavigationBar: Material(
            color: Colors.white,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Color.fromRGBO(0, 31, 70, 1),
              controller: tabController,
              tabs: <Widget>[
                Tab(
                  icon: Image.asset(
                    'images/tab_commute.png',
                    height: 30,
                    width: 30,
                  ),
                ),
                Tab(
                  icon: Image.asset(
                    'images/logo.png',
                    height: 70,
                    width: 70,
                  ),
                ),
                Tab(
                  icon: Image.asset(
                    'images/tab_item.png',
                    height: 30,
                    width: 30,
                  ),
                )
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
//        commute
              CommuteWidget(id, name),
//          main
              MainWidget(id, name, profile),
//          route
              RouteWidget(id)
            ],
          ),
        ),
      ),
    );
  }
}
