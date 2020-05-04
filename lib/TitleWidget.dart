import 'package:flutter/material.dart';

class TitleWidget extends StatefulWidget {
  @override
  _TitleWidgetState createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'bus',
              style:
                  TextStyle(fontSize: 25, color: Color.fromRGBO(0, 31, 70, 1), fontFamily: 'eurostile',),
            ),
            Text(
              'Linker',
              style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(0, 31, 70, 1),
                  fontFamily: 'eurostile',
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        Image.asset(
          'images/logo.png',
          height: 30,
          width: 30,
        )
      ],
    );
  }
}
