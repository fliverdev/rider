import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:rider/pages/map_view_page.dart';
import 'package:rider/pages/onboarding_page.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FirstPage extends StatefulWidget {
  FirstPage({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  void firstPageChecker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    String uuid = prefs.getString('uuid') ?? Uuid().v4();
    // generates random uuid as string

    if (isFirstLaunch) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyOnboardingPage(
                    helper: prefs,
                    flag: isFirstLaunch,
                    identity: uuid,
                    analytics: widget.analytics,
                    observer: widget.observer,
                  )),
          (Route<dynamic> route) => false);
      // very first launch since install
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyMapViewPage(
                    helper: prefs,
                    identity: uuid,
                    analytics: widget.analytics,
                    observer: widget.observer,
                  )),
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
