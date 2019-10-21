import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rider/pages/intro_page.dart';
import 'package:rider/pages/map_view_page.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void firstScreenChecker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      prefs.setBool('isFirstLaunch', false);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyIntroPage();
      }));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyMapViewPage();
      }));
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(splashScreenDuration, () {
      firstScreenChecker();
    });
  }

  Widget build(BuildContext context) {
    return Container(
      color: MyColors.accentColor,
      child: Center(
        child: Container(
          width: 225.0,
          height: 225.0,
          child: Image.asset(
            'assets/images/splash-screen.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
