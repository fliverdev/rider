import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/first_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

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
          home: FirstPage(
            analytics: analytics,
            observer: observer,
          ),
        );
      },
    );
  }
}
