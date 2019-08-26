import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
    return Scaffold(
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
//                    fontFamily: '',
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0,
                      fontStyle: FontStyle.italic,
                      color: invertColorsStrong(context),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StaggeredGridView.count(
                crossAxisCount: 1,
                children: <Widget>[
                  sexyTile(
                    context,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/profile/urmil-vector'
                                        '.png')))),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.code,
                              color: invertColorsStrong(context),
                              size: 18.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'with',
                              style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: invertColorsStrong(context)),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.favorite,
                              color: MaterialColors.pink,
                              size: 18.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'by',
                              style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: invertColorsStrong(context)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Urmil Shroff',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22.0,
                              color: invertColorsStrong(context)),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.person,
                                color: invertColorsStrong(context),
                                size: 24.0,
                              ),
                              onPressed: doNothing,
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: doNothing,
                  ),
                  SizedBox(),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(1, 250.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
