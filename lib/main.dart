import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:rider/pages/intro_page.dart';
import 'package:rider/pages/map_view_page.dart';
import 'package:rider/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isFirstLaunchSinceInstall;
    firstScreenChecker().then((flag) {
      isFirstLaunchSinceInstall = flag;
    });

    print('IS IT TRUE? $isFirstLaunchSinceInstall');

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
          home: isFirstLaunchSinceInstall ? MyIntroPage() : MyMapViewPage(),
        );
      },
    );
  }

  Future<bool> firstScreenChecker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunchSinceInstall =
        prefs.getBool('isFirstLaunchSinceInstall') ?? true;

    print('BOOL IS CURRENTLY SET TO $isFirstLaunchSinceInstall');

    if (isFirstLaunchSinceInstall) {
      await prefs.setBool('isFirstLaunchSinceInstall', false);
      return true;
    } else {
      return false;
    }
  }
}
