import 'package:flutter/material.dart';
import 'package:rider/pages/intro_page.dart';
import 'package:rider/pages/map_view_page.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  void firstPageChecker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyIntroPage(
                    helper: prefs,
                    flag: isFirstLaunch,
                  )),
          (Route<dynamic> route) => false);
      // very first launch since install
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyMapViewPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    firstPageChecker();
  }

  Widget build(BuildContext context) {
    return Container(
      color: invertInvertColorsStrong(context), // blank screen
    );
  }
}
