import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/colors.dart';

class NoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: MyColors.light,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200.0,
                  height: 200.0,
                  child: FlareActor(
                    'assets/flare/no_connection.flr',
                    animation: 'animation',
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Error: no connection!',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20.0,
                    color: MyColors.dark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
