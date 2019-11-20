import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:rider/widgets/sexy_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAboutPage extends StatefulWidget {
  @override
  _MyAboutPageState createState() => _MyAboutPageState();
}

class _MyAboutPageState extends State<MyAboutPage> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      print('Launching $url...');
      await launch(url);
    } else {
      print('Error launching $url!');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> contributorNames = [
      'Urmil Shroff',
      'Priyansh Ramnani',
      'Vinay Kolwankar',
    ];

    List<String> contributorDesc = [
      'I like developing apps.',
      'I like to code.',
      'I like designing UI.',
    ];

    List<String> contributorPhotos = [
      'urmil.jpg',
      'priyansh.jpg',
      'vinay.png',
    ];

    List<String> profileUrls = [
      'https://urmilshroff.tech',
      'https://github.com/prince1998',
      'http://www.decaf.co.in',
    ];

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
                        ? MyTextStyles.titleStyleLight
                        : MyTextStyles.titleStyleDark,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 2.2, // increase/decrease tile height
                children: List.generate(
                  contributorNames.length,
                  (i) {
                    return SexyTile(
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
                                image: AssetImage(
                                    './assets/credits/${contributorPhotos[i]}'),
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
                                '${contributorNames[i]}',
                                style: isThemeCurrentlyDark(context)
                                    ? MyTextStyles.titleStyleLight
                                    : MyTextStyles.titleStyleDark,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                '${contributorDesc[i]}',
                                style: isThemeCurrentlyDark(context)
                                    ? MyTextStyles.bodyStyleLightItalic
                                    : MyTextStyles.bodyStyleDarkItalic,
                              ),
                            ],
                          ),
                        ],
                      ),
                      splashColor: MyColors.primaryColor,
                      onTap: () => _launchURL(profileUrls[i]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        tooltip: 'Source code',
        foregroundColor: invertInvertColorsTheme(context),
        backgroundColor: invertColorsTheme(context),
        elevation: 5.0,
        child: Icon(
          Icons.code,
        ),
        onPressed: () => _launchURL('https://github.com/fliverdev/rider'),
      ),
    );
  }
}
