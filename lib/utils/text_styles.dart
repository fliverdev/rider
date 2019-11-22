import 'package:flutter/material.dart';
import 'package:rider/utils/colors.dart';

// use these for any text styling, add more if needed
// TODO: group three styles per class

class MyTextStyles {
  static const titleStyleLight = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    color: MyColors.white,
  );
  static const titleStyleDark = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    color: MyColors.black,
  );
  static const titleStylePrimary = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    color: MyColors.primaryColor,
  );

  static const subTitleStyleLight = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: MyColors.white,
  );
  static const subTitleStyleDark = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: MyColors.black,
  );
  static const subTitleStylePrimary = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: MyColors.primaryColor,
  );

  static const bodyStyleLight = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: MyColors.white,
  );
  static const bodyStyleDark = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: MyColors.black,
  );
  static const bodyStylePrimary = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: MyColors.primaryColor,
  );
  static const bodyStyleLightItalic = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: MyColors.white,
  );
  static const bodyStyleDarkItalic = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: MyColors.black,
  );
  static const bodyStylePrimaryItalic = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: MyColors.primaryColor,
  );
  static const labelStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: MyColors.black,
  );
}
