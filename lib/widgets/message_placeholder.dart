import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:rider/utils/ui_helpers.dart';

Widget messagePlaceholder(BuildContext context, String text1, String text2) {
  String flareFile = isThemeCurrentlyDark(context)
      ? 'messages-dark.flr'
      : 'messages-light.flr';
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          Container(
            width: 250.0,
            height: 250.0,
            child: FlareActor(
              'assets/flare/$flareFile',
              animation: 'animation',
            ),
          ),
          Text(
            text1,
            style: isThemeCurrentlyDark(context)
                ? BodyStyles.white
                : BodyStyles.black,
          ),
          Text(
            text2,
            style: isThemeCurrentlyDark(context)
                ? BodyStyles.white
                : BodyStyles.black,
          ),
        ],
      ),
    ],
  );
}
