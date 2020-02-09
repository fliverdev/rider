import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider/services/firebase_analytics.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:rider/widgets/sexy_tile.dart';

class MyAboutPage extends StatefulWidget {
  @override
  _MyAboutPageState createState() => _MyAboutPageState();
}

class _MyAboutPageState extends State<MyAboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: invertInvertColorsStrong(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 40.0,
                left: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    tooltip: 'Go back',
                    iconSize: 20.0,
                    color: invertColorsStrong(context),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Credits',
                    style: isThemeCurrentlyDark(context)
                        ? TitleStyles.white
                        : TitleStyles.black,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 2.3, // increase/decrease tile height
                children: <Widget>[
                  SexyTile(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('./assets/credits/urmil.jpg'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Urmil Shroff',
                              style: isThemeCurrentlyDark(context)
                                  ? TitleStyles.white
                                  : TitleStyles.black,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'I like to develop apps.',
                              style: isThemeCurrentlyDark(context)
                                  ? BodyStylesItalic.white
                                  : BodyStylesItalic.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                    splashColor: MyColors.primary,
                    onTap: () {
                      launchUrl('https://urmilshroff.tech');
                      logAnalyticsEvent('url_click_urmil');
                    },
                  ),
                  SexyTile(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image:
                                  AssetImage('./assets/credits/priyansh.jpg'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Priyansh Ramnani',
                              style: isThemeCurrentlyDark(context)
                                  ? TitleStyles.white
                                  : TitleStyles.black,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'I like to code.',
                              style: isThemeCurrentlyDark(context)
                                  ? BodyStylesItalic.white
                                  : BodyStylesItalic.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                    splashColor: MyColors.primary,
                    onTap: () {
                      launchUrl('https://github.com/prince1998');
                      logAnalyticsEvent('url_click_priyansh');
                    },
                  ),
                  SexyTile(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('./assets/credits/vinay.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Vinay Kolwankar',
                              style: isThemeCurrentlyDark(context)
                                  ? TitleStyles.white
                                  : TitleStyles.black,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'I like to design UI.',
                              style: isThemeCurrentlyDark(context)
                                  ? BodyStylesItalic.white
                                  : BodyStylesItalic.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                    splashColor: MyColors.primary,
                    onTap: () {
                      launchUrl('http://www.decaf.co.in');
                      logAnalyticsEvent('url_click_vinay');
                    },
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Built using Flutter 📲'
                          '\nCompletely free & Open Source'
                          '\nMade with ❤️ in Mumbai, India',
                          style: isThemeCurrentlyDark(context)
                              ? BodyStyles.white
                              : BodyStyles.black,
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              child: Text('FAQ'),
                              textColor: invertColorsStrong(context),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              onPressed: () {
                                launchUrl('https://fliverdev.github.io/faq/');
                                logAnalyticsEvent('url_click_faq');
                              },
                            ),
                            FlatButton(
                              child: Text('Privacy Policy'),
                              textColor: invertColorsStrong(context),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              onPressed: () {
                                launchUrl(
                                    'https://fliverdev.github.io/privacy_policy/');
                                logAnalyticsEvent('url_click_privacy_policy');
                              },
                            ),
                            FlatButton(
                              child: Text('Feedback'),
                              textColor: invertColorsStrong(context),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              onPressed: () {
                                launchUrl('mailto:urmilshroff@gmail'
                                    '.com?subject=Fliver Rider feedback');
                                logAnalyticsEvent('url_click_feedback');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
