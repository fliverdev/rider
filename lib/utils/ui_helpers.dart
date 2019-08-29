import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/colors.dart';

void doNothing() {
  print('Nothing is happening here (yet)');
} //better than doing null-ing, right? ;)

bool isThemeCurrentlyDark(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return true;
  } else {
    return false;
  }
} //returns current theme status

Color invertColorsTheme(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MyColors.primaryColor;
  } else {
    return MyColors.accentColor;
  }
} //returns appropriate theme colors for ui elements

Color invertInvertColorsTheme(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MyColors.accentColor;
  } else {
    return MyColors.primaryColor;
  }
} //keeps the same colors lol

Color invertColorsMild(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MyColors.light;
  } else {
    return MyColors.dark;
  }
} //returns appropriate mild colors for text visibility

Color invertInvertColorsMild(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MyColors.dark;
  } else {
    return MyColors.light;
  }
} //keeps the same colors lol

Color invertColorsStrong(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MyColors.white;
  } else {
    return MyColors.black;
  }
} //returns appropriate strong colors for text visibility

Color invertInvertColorsStrong(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return MyColors.black;
  } else {
    return MyColors.white;
  }
} //keeps the same colors lol

Color shadowColor(BuildContext context) {
  if (isThemeCurrentlyDark(context)) {
    return ShadowColors.dark;
  } else {
    return ShadowColors.light;
  }
} //returns appropriate colors for raised element shadows
