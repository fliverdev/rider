import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/first_page.dart';
import 'package:rider/utils/notification_helpers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initNotifications();

  createDailyNotification(0, Time(9, 0, 0));
  createDailyNotification(1, Time(12, 0, 0));
  createDailyNotification(2, Time(17, 0, 0));
  createDailyNotification(3, Time(18, 30, 0));
  createDailyNotification(4, Time(20, 0, 0));
  createDailyNotification(5, Time(21, 30, 0));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        fontFamily: 'AvenirNextRounded',
        primaryColor: MyColors.primary,
        accentColor: MyColors.accent,
        brightness: brightness, // default is light
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Fliver Rider',
          theme: theme,
          home: FirstPage(),
        );
      },
    );
  }
}
