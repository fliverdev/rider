import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
            Expanded(
              child: StaggeredGridView.count(
                crossAxisCount: 1,
                children: <Widget>[
                  sexyTile(
                    context,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 110.0,
                          height: 110.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: isThemeCurrentlyDark(context)
                                    ? AssetImage(
                                        './assets/images/fliver-green.png')
                                    : AssetImage(
                                        './assets/images/fliver-black.png')),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: Text(
                            'Fliver is an app developed by a bunch of '
                            'developers and designers who believe in open'
                            ' source software.',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: invertColorsStrong(context),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: Text(
                            'We\'re also part-time Computer Engineering '
                            'students, so yeah.',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: invertColorsStrong(context),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                    onTap: doNothing,
                  ),
                  sexyTile(
                    context,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('./assets/images/urmil.png'),
                            ),
                          ),
                        ),
                        Text(
                          'Urmil Shroff',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: invertColorsStrong(context),
                          ),
                        ),
                      ],
                    ),
                    onTap: doNothing,
                  ),
                  sexyTile(
                    context,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image:
                                  AssetImage('./assets/images/priyansh.jpeg'),
                            ),
                          ),
                        ),
                        Text(
                          'Priyansh Ramnani',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: invertColorsStrong(context),
                          ),
                        ),
                      ],
                    ),
                    onTap: doNothing,
                  ),
                  sexyTile(
                    context,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('./assets/images/vinay.png'),
                            ),
                          ),
                        ),
                        Text(
                          'Vinay Kolwankar',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: invertColorsStrong(context),
                          ),
                        ),
                      ],
                    ),
                    onTap: doNothing,
                  ),
                  SizedBox(), // just to add space at the end
                ],
                staggeredTiles: [
                  StaggeredTile.extent(1, 275.0),
                  StaggeredTile.extent(1, 200.0),
                  StaggeredTile.extent(1, 200.0),
                  StaggeredTile.extent(1, 200.0),
                  StaggeredTile.extent(1, 50.0), // for the SizedBox
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        tooltip: 'View source code',
        foregroundColor: invertInvertColorsTheme(context),
        backgroundColor: invertColorsTheme(context),
        elevation: 5.0,
        child: Icon(
          Icons.code,
//          size: 36.0,
        ),
        onPressed: doNothing,
      ),
    );
  }
}
