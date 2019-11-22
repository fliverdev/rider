import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:rider/pages/map_view_page.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOnboardingPage extends StatefulWidget {
  final SharedPreferences helper;
  final bool flag;
  final String identity;
  MyOnboardingPage(
      {Key key,
      @required this.helper,
      @required this.flag,
      @required this.identity})
      : super(key: key);
  @override
  _MyOnboardingPageState createState() => _MyOnboardingPageState();
}

class _MyOnboardingPageState extends State<MyOnboardingPage> {
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
                  width: 170.0,
                  height: 54.0,
                  child: Image.asset(
                    'assets/logo/text-black.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 50.0,
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
                  height: 50.0,
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
                  style: MyTextStyles.subTitleStyleDark,
                ),
              ],
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
            Container(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                  ),
                  Container(
                    width: 253.0,
                    height: 120.0,
                    child: Image.asset(
                      'assets/other/howto.gif',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 40.0,
                        height: 40.0,
                        child: Image.asset(
                          'assets/other/arrow.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Waiting for a rickshaw?',
                        style: MyTextStyles.subTitleStyleDark,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Just swipe the button to notify Drivers nearby about your location.',
                    style: MyTextStyles.bodyStyleDark,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 36.0,
                        height: 42.0,
                        child: Image.asset(
                          'assets/other/notification.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'How are Drivers notified?',
                        style: MyTextStyles.subTitleStyleDark,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'When 3 or more Riders near you mark their location, a hotspot is created and Drivers get notified.',
                    style: MyTextStyles.bodyStyleDark,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 36.0,
                        height: 42.0,
                        child: Image.asset(
                          'assets/other/rickshaw-mini.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'What\'s next?',
                        style: MyTextStyles.subTitleStyleDark,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Drivers will see the areas of high demand and come accordingly to pick you and others up!',
                    style: MyTextStyles.bodyStyleDark,
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
                  width: 150.0,
                  height: 47.5,
                  child: Image.asset(
                    'assets/logo/text-black.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 30.0,
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
                  width: 150.0,
                  height: 47.5,
                  child: Image.asset(
                    'assets/logo/text-green.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 30.0,
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
