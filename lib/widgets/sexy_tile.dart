import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/ui_helpers.dart';

Widget sexyTile(BuildContext context, Widget child, {Function() onTap}) {
  return Container(
    margin: EdgeInsets.all(10.0),
    child: Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      shadowColor: shadowColor(context),
      child: InkWell(
        child: child,
        borderRadius: BorderRadius.circular(10.0),
        onTap: onTap != null
            ? () => onTap()
            : () {
                print('Nothing set yet!');
              },
      ),
    ),
  );
}
