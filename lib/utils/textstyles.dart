import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/colors.dart';

class MyTextStyles {
  static const titleStyle = TextStyle(
//    fontFamily: '',
    fontWeight: FontWeight.w600,
    fontSize: 20.0,
  ); //used for page titles on the top of the screen

  static const highlightStyle = TextStyle(
//      fontFamily: '',
      fontWeight: FontWeight.w500,
      fontSize: 18.0,
      color: MyColors.accentColor); //used for important text
}
