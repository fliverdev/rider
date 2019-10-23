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
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                  ),
                  Text(
                    'Simple as a Swipe!',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: MyColors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: 152.0,
                    height: 114.0,
                    child: Image.asset(
                      'assets/other/marker.gif',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'When you want a taxi, just open the app and swipe the button to mark your location.'
                    '\n\nIf there are 3 or more Riders in your area, a hotspot will be displayed and Drivers will be notified.'
                    '\n\nThe Drivers will see where there is high demand and will come accordingly to pick you and your friends up!',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      color: MyColors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                  ),
                  Text(
                    'Location Permissions',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      color: MyColors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 120.0,
                    height: 90.0,
                    child: Image.asset(
                      'assets/other/toggle.gif',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'We need to access your phone\'s location in order to find nearby Riders and notify Drivers when there is demand in your area.'
                    '\n\nDon\'t worry - we believe in your privacy and keep your location completely anonymous without requiring any additional details or permissions.'
                    '\n\nThe source code is also available on GitHub, in case you\'re still doubtful😉',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      color: MyColors.black,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  RaisedButton(
                    child: Text('GRANT ACCESS'),
                    color: MyColors.black,
                    textColor: MyColors.white,
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
        color: Colors.white,
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
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: MyColors.black,
                  ),
                ),
                Text(
                  '(Swipe right to change)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                    color: MyColors.black,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  width: 150.0,
                  height: 150.0,
                  child: Image.asset(
                    'assets/other/sun.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Light Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                    color: MyColors.black,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                RaisedButton(
                  child: Text('LET\'S GO'),
                  color: MyColors.black,
                  textColor: MyColors.white,
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  onPressed: () {
                    DynamicTheme.of(context).setBrightness(Brightness.light);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyMapViewPage()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ],
            )
          ],
        ),
      ),
      Container(
        color: Colors.black,
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
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: MyColors.primaryColor,
                  ),
                ),
                Text(
                  '(Swipe left to change)',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                    color: MyColors.primaryColor,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  width: 150.0,
                  height: 150.0,
                  child: Image.asset(
                    'assets/other/moon.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                    color: MyColors.primaryColor,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                RaisedButton(
                  child: Text('LET\'S GO'),
                  color: MyColors.primaryColor,
                  textColor: MyColors.black,
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  onPressed: () {
                    DynamicTheme.of(context).setBrightness(Brightness.dark);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyMapViewPage()),
                        (Route<dynamic> route) => false);
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
      enableSlideIcon: true,
      positionSlideIcon: 0.6,
      slideIconWidget: Icon(
        Icons.arrow_back_ios,
        color: Colors.black,
      ),
      waveType: WaveType.liquidReveal,
    );
  }
}
