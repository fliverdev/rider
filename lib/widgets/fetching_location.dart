import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/ui_helpers.dart';

class FetchingLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: invertInvertColorsStrong(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 225.0,
                  height: 225.0,
                  child: FlareActor(
                    'assets/flare/fetching_location.flr',
                    animation: 'animation',
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Fetching location...',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20.0,
                    color: invertColorsStrong(context),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SpinKitThreeBounce(
                  color: MyColors.primaryColor,
                  size: 30.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
