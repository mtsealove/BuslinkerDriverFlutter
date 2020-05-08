import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  final String ID;

  LocationService(this.ID);

  Future<void> postLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.latitude);
    print(_locationData.longitude);

    http.Response res = await http.post(
        Uri.encodeFull('http://3.17.182.55:3300/Driver/Update/Location'),
        headers: {'Content-Type': "application/json"},
        body: jsonEncode({
          'ID': ID,
          'Latitude': _locationData.latitude,
          'Longitude': _locationData.longitude
        }));
    print(res.body);
  }

  Timer timer;

  void StartTracking() {
    showToast('운행이 시작되었습니다.');
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      postLocation();
    });
  }

  void StopTracking() {
    showToast('운행이 종료되었습니다.');
    if (timer != null) {
      timer.cancel();
    }
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromRGBO(0, 31, 70, 1),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
