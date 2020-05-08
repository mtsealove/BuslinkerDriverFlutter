import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class TutorialWidget extends StatefulWidget {
  @override
  _TutorialWidgetState createState() => _TutorialWidgetState();
}

class _TutorialWidgetState extends State<TutorialWidget>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  double position = 0;
  String label = '계속하기';
  VideoPlayerController videoPlayerController0,
      videoPlayerController1,
      videoPlayerController2;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    tabController.addListener(() {
      setState(() {
        position = tabController.index.toDouble();
        if (position == 2) {
          label = '시작하기';
        } else {
          label = '계속하기';
        }
        videoPlayerController0.pause();
        videoPlayerController1.pause();
        videoPlayerController2.pause();
        switch (tabController.index) {
          case 0:
            videoPlayerController0.play();
            break;
          case 1:
            videoPlayerController1.play();
            break;
          case 2:
            videoPlayerController2.play();
            break;
        }
      });
    });
    setVideo();
  }

  void setVideo() {
    videoPlayerController0 = VideoPlayerController.asset('videos/sample.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    videoPlayerController1 = VideoPlayerController.asset('videos/sample.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    videoPlayerController2 = VideoPlayerController.asset('videos/sample.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    videoPlayerController0.setVolume(0);
    videoPlayerController0.play();
    videoPlayerController1.setVolume(0);
    videoPlayerController2.setVolume(0);
  }

  void moveNext() {
    if (position == 2) {
      Navigator.pop(context);
    } else {
      position++;
      tabController.index = position.toInt();
      switch (tabController.index) {
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController0.pause();
    videoPlayerController1.pause();
    videoPlayerController2.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      bottomNavigationBar: Container(
        height: 200,
        child: Column(
          children: <Widget>[
            DotsIndicator(
              dotsCount: 3,
              position: position,
              decorator: DotsDecorator(
                color: Colors.white,
                activeColor: Color.fromRGBO(0, 31, 70, 1),
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: RaisedButton(
                  onPressed: () {
                    moveNext();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                      width: double.maxFinite,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 31, 70, 1),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )),
                ))
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: tabController,
          children: <Widget>[
            Scaffold(
              backgroundColor: Color.fromRGBO(245, 245, 245, 1),
              body: Container(
                padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                child: Center(
                    child: Column(
                  children: <Widget>[
                    videoPlayerController0.value.initialized
                        ? Container(
                            height: 350,
                            child: AspectRatio(
                              aspectRatio:
                                  videoPlayerController0.value.aspectRatio,
                              child: VideoPlayer(videoPlayerController0),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '출근 및 퇴근',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 31, 70, 1)),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '출근 및 퇴근시에는\nQR코드를 생성하여\n아르바이트에게 보여주세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 31, 70, 1), fontSize: 16),
                    )
                  ],
                )),
              ),
            ),
            Scaffold(
              backgroundColor: Color.fromRGBO(245, 245, 245, 1),
              body: Container(
                padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                child: Center(
                    child: Column(
                  children: <Widget>[
                    videoPlayerController1.value.initialized
                        ? Container(
                            height: 350,
                            child: AspectRatio(
                              aspectRatio:
                                  videoPlayerController1.value.aspectRatio,
                              child: VideoPlayer(videoPlayerController1),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '경로 안내',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 31, 70, 1)),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '이동할 위치를 선택하여\n경로를 확인하고\n현재 위치를 알아보세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 31, 70, 1), fontSize: 16),
                    )
                  ],
                )),
              ),
            ),
            Scaffold(
              backgroundColor: Color.fromRGBO(245, 245, 245, 1),
              body: Container(
                padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
                child: Center(
                    child: Column(
                  children: <Widget>[
                    videoPlayerController2.value.initialized
                        ? Container(
                            height: 350,
                            child: AspectRatio(
                              aspectRatio:
                                  videoPlayerController2.value.aspectRatio,
                              child: VideoPlayer(videoPlayerController2),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '사용자 메뉴',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 31, 70, 1)),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '자신의 스케줄을 확인하고\n문의사항을 입력하세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 31, 70, 1), fontSize: 16),
                    )
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
