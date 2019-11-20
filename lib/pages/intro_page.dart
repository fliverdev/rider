import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:rider/pages/map_view_page.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/permission_helpers.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyIntroPage extends StatefulWidget {
  final SharedPreferences helper;
  final bool flag;
  final String identity;
  MyIntroPage(
      {Key key,
      @required this.helper,
      @required this.flag,
      @required this.identity})
      : super(key: key);
  @override
  _MyIntroPageState createState() => _MyIntroPageState();
}

class _MyIntroPageState extends State<MyIntroPage> {
  String permissionStatusMessage = '';
  bool isPermissionButtonVisible = true;
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
                  height: 30.0,
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
        color: Colors.white, // TODO: change to MyColors.white
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
                      'assets/other/marker.gif', // replace with swipe gif
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'When you want a taxi, just open the app and swipe the button to mark your location.'
                    '\n\nIf there are 3 or more Riders nearby, a hotspot will be created and Drivers will be notified. Then they\'ll come to pick you and your friends up!'
                    '\n\nWe need access to your phone\'s location, so please grant it below.',
                    style: MyTextStyles.bodyStyleDark,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Visibility(
                    visible: isPermissionButtonVisible,
                    child: RaisedButton(
                      child: Text('Grant Access'),
                      color: MyColors.black,
                      textColor: MyColors.white,
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      onPressed: () async {
                        final requestLocation =
                            await requestLocationPermission();
                        final locationChecker = checkLocationPermission();
                        locationChecker.then((isPermissionGranted) {
                          isPermissionGranted
                              ? permissionStatusMessage =
                                  'Swipe left to continue'
                              : permissionStatusMessage =
                                  'Please grant location access!';
                          setState(() {
                            isPermissionButtonVisible = false;
                          });
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: !isPermissionButtonVisible,
                    child: Text(
                      '$permissionStatusMessage',
                      style: MyTextStyles.bodyStyleDarkItalic,
                    ),
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
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    widget.helper.setBool('isFirstLaunch', false);
                    widget.helper.setString('uuid', widget.identity);

                    DynamicTheme.of(context).setBrightness(Brightness.light);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyMapViewPage(
                                helper: prefs, identity: widget.identity)),
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
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    widget.helper.setBool('isFirstLaunch', false);
                    widget.helper.setString('uuid', widget.identity);

                    DynamicTheme.of(context).setBrightness(Brightness.dark);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyMapViewPage(
                                helper: prefs, identity: widget.identity)),
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
      slideIconWidget: Icon(
        Icons.arrow_back_ios,
        color: MyColors.black,
      ),
    );
  }
}
