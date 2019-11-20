import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rider/bloc/map_event.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/first_page.dart';

import 'bloc/map_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapBloc>(
      builder: (BuildContext context) => MapBloc()
        ..add(GetLocation()), // Start retrieving location right at start of app
      child: DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => ThemeData(
          fontFamily: 'LexendDeca',
          primaryColor: MyColors.primaryColor,
          accentColor: MyColors.accentColor,
          brightness: brightness, // default is dark
        ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Fliver Rider',
            theme: theme,
            home: FirstPage(),
          );
        },
      ),
    );
  }
}
