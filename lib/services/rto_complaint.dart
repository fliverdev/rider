import 'package:call_number/call_number.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/permission_helper.dart';
import 'package:rider/utils/ui_helpers.dart';

void showRtoPopup(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text('RTO Complaint'),
          content: Text('This will directly call the Regional Transport '
              'Office of India. You can then file a complaint in case of '
              'accident, rude behaviour of drivers, etc.\n\nPlease note that '
              'we, the Developers of Fliver, do not guarantee your '
              'complaint being recorded as we have no affiliation with the '
              'Regional Transport Office of India.'),
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
              child: Text('Call'),
              color: MyColors.primaryColor,
              textColor: MyColors.accentColor,
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              onPressed: () {
                callRto();
              },
            ),
          ],
        );
      });
}

void callRto() {
  final String rtoNumber = "1800220110";
  requestPhonePermission();
  CallNumber().callNumber(rtoNumber);
}
