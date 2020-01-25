import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider/services/firebase_analytics.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:share/share.dart';

void showNearbyRidersAlert(BuildContext context) {
  showDialog(
    context: context,
    child: AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'Nearby Riders',
        style: isThemeCurrentlyDark(context)
            ? TitleStyles.white
            : TitleStyles.black,
      ),
      content: Text(
        'Congratulations! Looks like there are 3 or more Fliver Riders in your area.'
        '\n\nEach time this threshold is reached, a hotspot is created to notify Drivers of demand so that they can come to pick you and your friends up.',
        style:
            isThemeCurrentlyDark(context) ? BodyStyles.white : BodyStyles.black,
      ),
      actions: <Widget>[
        RaisedButton(
          child: Text('Okay'),
          color: invertColorsTheme(context),
          textColor: invertInvertColorsStrong(context),
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

void showNotEnoughRidersAlert(
    BuildContext context, currentMarkersWithinRadius) {
  showDialog(
    context: context,
    child: AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'Not Enough Riders',
        style: isThemeCurrentlyDark(context)
            ? TitleStyles.white
            : TitleStyles.black,
      ),
      content: Text(
        'Drivers get notified when there are 3 or more Riders in the same area.'
        '\n\nRight now, there are only ${currentMarkersWithinRadius - 1} other Riders near you, so tell your friends to download the app and mark their locations!',
        style:
            isThemeCurrentlyDark(context) ? BodyStyles.white : BodyStyles.black,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          textColor: invertColorsStrong(context),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          child: Text('Share'),
          color: invertColorsTheme(context),
          textColor: invertInvertColorsStrong(context),
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          onPressed: () {
            Navigator.pop(context);
            Share.share(
                'Download Fliver Rider now and help me get a rickshaw! https://github.com/fliverdev/rider');
            logAnalyticsEvent('share_click');
          },
        ),
      ],
    ),
  );
}
