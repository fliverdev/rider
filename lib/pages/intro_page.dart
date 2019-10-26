import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/Constants/Helpers.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:rider/pages/map_view_page.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/permission_helper.dart';
import 'package:rider/utils/text_styles.dart';

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
                  width: 150.0,
                  height: 150.0,
                  child: Image.asset(
                    'assets/logo/fliver-black.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 150.0,
                  height: 150.0,
                  child: Image.asset(
                    'assets/other/rickshaw.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  'Welcome to Fliver!',
                  style: MyTextStyles.titleStyleDark,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Swipe left to get started.',
                  style: MyTextStyles.bodyStyleDark,
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
                    style: MyTextStyles.titleStyleDark,
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
                    '\n\nIf there are 3 or more Riders in your area, a hotspot will be created and Drivers will be notified.'
                    '\n\nThe Drivers will see where there is high demand and will come accordingly to pick you and your friends up!',
                    style: MyTextStyles.bodyStyleDark,
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
                    style: MyTextStyles.titleStyleDark,
                  ),
                  SizedBox(
                    height: 10.0,
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
                    height: 10.0,
                  ),
                  Text(
                    'We need to access your phone\'s location in order to find nearby Riders and notify Drivers when there is demand in your area.'
                    '\n\nDon\'t worry - we believe in your privacy and keep your location completely anonymous without requiring any additional details or permissions.'
                    '\n\nThe source code is also available on GitHub, in case you\'re still doubtful😉',
                    style: MyTextStyles.bodyStyleDark,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Text('Grant Access'),
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
                  style: MyTextStyles.bodyStyleDark,
                ),
                Text(
                  '(Swipe left to change)',
                  style: MyTextStyles.bodyStyleDarkItalic,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  width: 125.0,
                  height: 125.0,
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
                  style: MyTextStyles.titleStyleDark,
                ),
                SizedBox(
                  height: 30.0,
                ),
                RaisedButton(
                  child: Text('Let\'s Go!'),
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
                  style: MyTextStyles.bodyStylePrimary,
                ),
                Text(
                  '(Swipe right to change)',
                  style: MyTextStyles.bodyStylePrimaryItalic,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  width: 125.0,
                  height: 125.0,
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
                  style: MyTextStyles.titleStylePrimary,
                ),
                SizedBox(
                  height: 30.0,
                ),
                RaisedButton(
                  child: Text('Let\'s Go!'),
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
      enableLoop: false, // last screen shouldn't go back to first
      enableSlideIcon: true,
      slideIconWidget: Icon(
        Icons.arrow_back_ios,
        color: MyColors.black, // gets hidden in dark mode screen
      ),
      waveType: WaveType.liquidReveal, // another one is circularReveal
    );
  }
}
