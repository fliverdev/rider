import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/Constants/Helpers.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:rider/utils/colors.dart';

import 'map_view_page.dart';

class MyIntroPage extends StatefulWidget {
  @override
  _MyIntroPageState createState() => _MyIntroPageState();
}

class _MyIntroPageState extends State<MyIntroPage> {
  @override
  Widget build(BuildContext context) {
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
                    'assets/images/fliver-black.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 175.0,
                  height: 175.0,
                  child: Image.asset(
                    'assets/images/rickshaw.png',
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
                  'Swipe to get started.',
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 175.0,
                  height: 175.0,
                  child: Image.asset(
                    'assets/images/fliver-green.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 175.0,
                  height: 175.0,
                  child: Image.asset(
                    'assets/images/rickshaw.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Dark Mode🌚',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22.0,
                    color: MyColors.primaryColor,
                  ),
                ),
                SizedBox(
                  height: 50.0,
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
                  width: 175.0,
                  height: 175.0,
                  child: Image.asset(
                    'assets/images/fliver-black.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 175.0,
                  height: 175.0,
                  child: Image.asset(
                    'assets/images/rickshaw.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Light Mode🌝',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22.0,
                    color: MyColors.black,
                  ),
                ),
                SizedBox(
                  height: 50.0,
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
    ];

    return LiquidSwipe(
      pages: pages,
      fullTransitionValue: 350.0,
      enableLoop: false,
      waveType: WaveType.liquidReveal, // two types available
    );
  }
}
