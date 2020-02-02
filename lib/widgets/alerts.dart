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
        'Congratulations! There are 3 or more Fliver Riders in your area.'
        '\n\nWhenever this happens, a hotspot is created which Drivers can see and come to pick you up',
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

void showNotEnoughRidersAlert(BuildContext context) {
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
        'There aren\'t enough Fliver Riders in your area. Tell your friends to download the app and mark their locations!',
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
                'Download Fliver Rider now and help me get a Rickshaw! https://github.com/fliverdev/rider'); // replace with App Store link
            logAnalyticsEvent('share_click');
          },
        ),
      ],
    ),
  );
}

void showRateAlert(BuildContext context) {
  showDialog(
    context: context,
    child: AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'Enjoying Fliver?',
        style: isThemeCurrentlyDark(context)
            ? TitleStyles.white
            : TitleStyles.black,
      ),
      content: Text(
        'Rate the app on Google Play!',
        style:
            isThemeCurrentlyDark(context) ? BodyStyles.white : BodyStyles.black,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Nah'),
          textColor: invertColorsStrong(context),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          child: Text('Okay'),
          color: invertColorsTheme(context),
          textColor: invertInvertColorsStrong(context),
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          onPressed: () {
            Navigator.pop(context);
            launchUrl(
                'https://play.google.com/store/apps/details?id=dev.fliver.rider');
            logAnalyticsEvent('url_click_rate');
          },
        ),
      ],
    ),
  );
}
