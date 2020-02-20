import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:rider/utils/ui_helpers.dart';

Widget messagePlaceholder(BuildContext context, String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            height: 250.0,
            child: FlareActor(
              'assets/flare/messages.flr',
              animation: 'animation',
            ),
          ),
          Text(
            text,
            style: isThemeCurrentlyDark(context)
                ? BodyStyles.white
                : BodyStyles.black,
          ),
        ],
      ),
    ],
  );
}
