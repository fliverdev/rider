import 'package:flutter/material.dart';
import 'package:rider/utils/ui_helpers.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: invertInvertColorsStrong(context),
      child: Center(
        child: Container(
          width: 225.0,
          height: 225.0,
          child: Image.asset(
            'assets/other/splash-screen.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
