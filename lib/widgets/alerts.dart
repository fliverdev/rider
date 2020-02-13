import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider/pages/chat_page.dart';
import 'package:rider/services/firebase_analytics.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        '\n\nWhenever this happens, a hotspot is created which Drivers can see to come and pick you up.',
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
                'Download Fliver Rider now and help me get a Rickshaw! https://fliverdev.github.io/');
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

void showUserNameInputAlert(BuildContext context, SharedPreferences helper) {
  TextEditingController _controller = TextEditingController();
  showDialog(
    context: context,
    child: AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'What\'s your name?',
        style: isThemeCurrentlyDark(context)
            ? TitleStyles.white
            : TitleStyles.black,
      ),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Enter name',
          labelStyle: isThemeCurrentlyDark(context)
              ? LabelStyles.white
              : LabelStyles.black,
          hintText: 'To display in the public chat',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: invertColorsStrong(context),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyColors.primary,
            ),
          ),
        ),
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
          child: Text('Confirm'),
          color: invertColorsTheme(context),
          textColor: invertInvertColorsStrong(context),
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          onPressed: () {
            var inputText = _controller.text;
            if (inputText != '') {
              helper.setString('userName', inputText);
              Navigator.pop(context);
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return MyChatPage(
                  helper: helper,
                );
              }));
            }
          },
        ),
      ],
    ),
  );
}
