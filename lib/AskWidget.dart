import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AskWidget extends StatefulWidget {
  @override
  _AskWidgetState createState() => _AskWidgetState();
}

class _AskWidgetState extends State<AskWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              width: 128,
              height: 128,
            ),
            SizedBox(height: 20,),
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
            
          ],
        ),
      ),
    );
  }
}
