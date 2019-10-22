import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/Constants/Helpers.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/permission_helper.dart';

import 'map_view_page.dart';

class MyIntroPage extends StatefulWidget {
  @override
  _MyIntroPageState createState() => _MyIntroPageState();
}

class _MyIntroPageState extends State<MyIntroPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    final pages = [
      Container(
        color: MyColors.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 175.0,
                  height: 175.0,
                  child: Image.asset(
                    'assets/logo/fliver-black.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 175.0,
                  height: 175.0,
                  child: Image.asset(
                    'assets/other/rickshaw.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Welcome to Fliver!',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22.0,
                    color: MyColors.black,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Swipe right to get started.',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    color: MyColors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      Container(
        color: MyColors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'It\'s as simple as a swipe!',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.0,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    'When you are waiting for a taxi, open the app and swipe the '
                    'button to mark your location.\n\nOnce marked, a hotspot '
                    'will be displayed if there are 3 or more Riders in '
                    'your area.\n\nTaxi Drivers will get notified and they can '
                    'come to your location to pick you and others up!',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                      color: MyColors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Container(
        color: MyColors.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Location Permissions',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.0,
                      color: MyColors.black,
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    'We need your permission to access your device\'s '
                    'location. We require this in order to display nearby '
                    'Riders and notify Drivers when there is demand in '
                    'your area. \n\nDon\'t worry - we believe in '
                    'your privacy and keep your location completely '
                    'anonymous without requiring any additional details or permissions.',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                      color: MyColors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  RaisedButton(
                    child: Text('Grant access'),
                    color: MyColors.black,
                    textColor: MyColors.primaryColor,
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    onPressed: () {
                      requestLocationPermission();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Container(
        color: MyColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 125.0,
                  height: 125.0,
                  child: Image.asset(
                    'assets/logo/fliver-black.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'Select an app theme',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    color: MyColors.black,
                  ),
                ),
                Text(
                  '(Swipe to change)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                    color: MyColors.black,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  '🌝',
                  style: TextStyle(fontSize: 100.0),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Light Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22.0,
                    color: MyColors.black,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                RaisedButton(
                  child: Text('Let\'s go!'),
                  color: MyColors.black,
                  textColor: MyColors.white,
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  onPressed: () {
                    DynamicTheme.of(context).setBrightness(Brightness.light);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MyMapViewPage();
                        },
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
      Container(
        color: MyColors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 125.0,
                  height: 125.0,
                  child: Image.asset(
                    'assets/logo/fliver-green.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'Select an app theme',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    color: MyColors.primaryColor,
                  ),
                ),
                Text(
                  '(Swipe to change)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                    color: MyColors.primaryColor,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  '🌚',
                  style: TextStyle(fontSize: 100.0),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22.0,
                    color: MyColors.primaryColor,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                RaisedButton(
                  child: Text('Let\'s go!'),
                  color: MyColors.primaryColor,
                  textColor: MyColors.accentColor,
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  onPressed: () {
                    DynamicTheme.of(context).setBrightness(Brightness.dark);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MyMapViewPage();
                        },
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ];

    return LiquidSwipe(
      pages: pages,
      fullTransitionValue: 350.0,
      enableLoop: false,
      waveType: WaveType.circularReveal, // two types available
    );
  }
}
