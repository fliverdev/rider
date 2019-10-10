import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:rider/pages/intro_page.dart';
import 'package:rider/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('counter') ?? 0) + 1;
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        primaryColor: MyColors.primaryColor,
        accentColor: MyColors.accentColor,
        brightness: brightness,
        textTheme: TextTheme(
          title: TextStyle(fontWeight: FontWeight.w700),
          body1: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Fliver Rider',
          theme: theme,
          home: MyIntroPage(),
        );
      },
    );
  }
}
