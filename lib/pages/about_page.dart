import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:rider/widgets/sexy_tile.dart';

class MyAboutPage extends StatefulWidget {
  @override
  _MyAboutPageState createState() => _MyAboutPageState();
}

class _MyAboutPageState extends State<MyAboutPage> {
  @override
  Widget build(BuildContext context) {
    List<String> contributorNames = [
      'Urmil Shroff',
      'Priyansh Ramnani',
      'Vinay Kolwankar',
    ];

    List<String> contributorDesc = [
      'Developer',
      'Developer',
      'Designer',
    ];

    List<String> contributorPhotos = [
      'urmil.jpg',
      'priyansh.jpg',
      'vinay.png',
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
                    iconSize: 24.0,
                    color: invertColorsStrong(context),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: invertColorsStrong(context),
                    ),
                  ),
                ],
              ),
            ),
//            Expanded(
//              child: GridView.count(
//                crossAxisCount: 1,
//                childAspectRatio: 2,
//                children: <Widget>[
//                  SexyTile(
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        Container(
//                          width: 110.0,
//                          height: 110.0,
//                          decoration: BoxDecoration(
//                            image: DecorationImage(
//                                image: isThemeCurrentlyDark(context)
//                                    ? AssetImage(
//                                        './assets/images/fliver-green.png')
//                                    : AssetImage(
//                                        './assets/images/fliver-black.png')),
//                          ),
//                        )
//                      ],
//                    ),
//                    splashColor: MyColors.primaryColor,
//                    onTap: () => print('Fliver tapped'),
//                  ),
//                ],
//              ),
//            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 1.75,
                children: List.generate(
                  contributorNames.length,
                  (i) {
                    return SexyTile(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                    './assets/credits/${contributorPhotos[i]}'),
                              ),
                            ),
                          ),
                          Text(
                            '${contributorNames[i]}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: invertColorsStrong(context),
                            ),
                          ),
                          Text(
                            '${contributorDesc[i]}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              color: invertColorsStrong(context),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                      splashColor: MyColors.primaryColor,
                      onTap: () => print('${contributorNames[i]} tapped'),
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
        tooltip: 'View source code',
        foregroundColor: invertInvertColorsTheme(context),
        backgroundColor: invertColorsTheme(context),
        elevation: 5.0,
        child: Icon(
          Icons.code,
        ),
        onPressed: doNothing,
      ),
    );
  }
}
