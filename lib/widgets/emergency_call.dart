import 'package:flutter/material.dart';
import 'package:rider/services/firebase_analytics.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:url_launcher/url_launcher.dart';

void showEmergencyPopup(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            'Emergency Helpline',
            style: isThemeCurrentlyDark(context)
                ? TitleStyles.white
                : TitleStyles.black,
          ),
          content: Text(
            'You can call Emergency Services or the RTO of India to file a complaint in case of accident, rude behaviour of drivers, etc.'
            '\n\nPlease note that we, the Developers of Fliver, do not guarantee your complaint being lodged as we have no affiliation with these government organizations.',
            style: isThemeCurrentlyDark(context)
                ? BodyStyles.white
                : BodyStyles.black,
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
              child: Text('RTO'),
              color: MyColors.primary,
              textColor: MyColors.accent,
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              onPressed: () {
                Navigator.pop(context);
                launch('tel:1800220110');
                logAnalyticsEvent('rto_click');
              },
            ),
            RaisedButton(
              child: Text('SOS'),
              color: MaterialColors.red,
              textColor: MyColors.white,
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              onPressed: () {
                Navigator.pop(context);
                launch('tel:112');
                logAnalyticsEvent('sos_click');
              },
            ),
          ],
        );
      });
}
