import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/functions.dart';

Widget buildTile(
    BuildContext context, Color color, Color splashColor, Widget child,
    {Function() onTap}) {
  return Container(
    margin: EdgeInsets.all(10.0),
    child: Material(
      color: color,
      elevation: 6.0,
      borderRadius: BorderRadius.circular(10.0),
      shadowColor: shadowColor(context),
      child: InkWell(
        onTap: onTap != null
            ? () => onTap()
            : () {
                print('Nothing set yet!');
              },
        child: child,
        splashColor: splashColor,
      ),
    ),
  );
}
