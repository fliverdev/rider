import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
        'Congratulations!',
        style: isThemeCurrentlyDark(context)
            ? TitleStyles.white
            : TitleStyles.black,
      ),
      content: Text(
        'There are enough Riders in your area. Drivers can now see your hotspot and come to pick you up.',
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
        'There aren\'t enough Riders in your area. Tell your friends to download the app and mark their locations!',
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
                'Download Fliver Rider and help me get a Rickshaw! https://fliverdev.github.io/');
            logAnalyticsEvent('share_click');
          },
        ),
      ],
    ),
  );
}

void showUserNameInputAlert(BuildContext context, SharedPreferences helper,
    LatLng location, String destination) {
  TextEditingController _controller = TextEditingController();
  showDialog(
    context: context,
    barrierDismissible: false,
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
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Enter a name',
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
          child: Text('Okay'),
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
                  location: location,
                  destination: destination,
                );
              }));
            }
          },
        ),
      ],
    ),
  );
}

Future<String> showDestinationInputAlert(BuildContext context) async {
  String destination;
  TextEditingController _controller = TextEditingController();
  await showDialog(
    context: context,
    barrierDismissible: false,
    child: AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Text(
        'Where do you want to go today?',
        style: isThemeCurrentlyDark(context)
            ? TitleStyles.white
            : TitleStyles.black,
      ),
      content: TextField(
        controller: _controller,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Enter a destination',
          labelStyle: isThemeCurrentlyDark(context)
              ? LabelStyles.white
              : LabelStyles.black,
          hintText: 'This will be public',
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
          onPressed: () async {
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
          onPressed: () async {
            destination = _controller.text;
            Navigator.pop(context);
          },
        ),
      ],
    ),
  ).then((text) {});
  return destination;
}
