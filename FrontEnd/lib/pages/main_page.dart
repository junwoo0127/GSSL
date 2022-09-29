import 'package:GSSL/components/main/main_header_bar.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/pages/bogam_page.dart';
import 'package:GSSL/pages/diary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/bottomNavBar.dart';
import '../components/main/main_function_box.dart';
import '../components/util/double_click_pop.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: pColor, // status bar color
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavBar(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool result = doubleClickPop();
        return await Future.value(result);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Container(
          color: nWColor,
          child: Column(
            children: [
              Flexible(
                child: UserBar(),
                flex: 1,
              ),
              Flexible(
                child: behavior_diagnosis(),
                flex: 2,
              ),
              Flexible(
                child: health_diagnosis(),
                flex: 2,
              ),
              Flexible(
                child: diary(),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserBar extends StatelessWidget {
  const UserBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
        // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(45),
            // color: Color(0xFFFFE6BC),
            ),
        child: MainHeaderBar());
  }
}

class behavior_diagnosis extends StatelessWidget {
  const behavior_diagnosis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견민정음',
      box_color: Color(0x80DFB45B),
      paddings: EdgeInsets.fromLTRB(30, 15.h, 30, 15.h),
      nextPage: GalleryApp(),
    );
  }
}

class health_diagnosis extends StatelessWidget {
  const health_diagnosis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견의보감',
      box_color: Color(0x80506274),
      paddings: EdgeInsets.fromLTRB(30, 15.h, 30, 15.h),
      nextPage: BogamPage(),
    );
  }
}

class diary extends StatefulWidget {
  const diary({Key? key}) : super(key: key);

  @override
  State<diary> createState() => _diaryState();
}

class _diaryState extends State<diary> {
  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견중일기',
      box_color: Color(0x80C66952),
      paddings: EdgeInsets.fromLTRB(30, 15.h, 30, 15.h),
      nextPage: GalleryApp(),
    );
  }
}
