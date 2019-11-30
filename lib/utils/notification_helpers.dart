import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initNotifications() async {
  print('initNotifications() called');

  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var initSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initSettingsIOS = IOSInitializationSettings();
  var initSettings =
      InitializationSettings(initSettingsAndroid, initSettingsIOS);

  notificationsPlugin.initialize(initSettings);

  var androidSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics =
      NotificationDetails(androidSpecifics, iOSSpecifics);

  await notificationsPlugin.show(
      0, 'Notification Title', 'Notification Body', platformChannelSpecifics,
      payload: 'notification payload');
//  await Navigator.push(
//    context,
//    new MaterialPageRoute(builder: (context) => SecondScreen(payload)),
//  );
//  var scheduledNotificationTime =
//      Time(selectedTime.hour, selectedTime.minute, 0);
//
//  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//      "goalNotificationChannelId",
//      "Goal Deadlines",
//      "Reminders to complete your goals in time",
//      importance: Importance.Max,
//      priority: Priority.High,
//      ticker: 'ticker',
//      icon: '@mipmap/ic_launcher',
//      largeIcon: '@mipmap/ic_launcher',
//      largeIconBitmapSource: BitmapSource.Drawable);
//
//  var iosPlatformChannelSpecifics = IOSNotificationDetails();
//
//  var platformChannelSpecifics = NotificationDetails(
//      androidPlatformChannelSpecifics, iosPlatformChannelSpecifics);
//
//  await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
//      0,
//      "Reminder: $goalTitle",
//      "Hope you're working on completing your goal!",
//      Day.Wednesday,
//      scheduledNotificationTime,
//      platformChannelSpecifics);
//
//  var time = Time(0, 40, 0);
//  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//      'repeatDailyAtTime channel id',
//      'repeatDailyAtTime channel name',
//      'repeatDailyAtTime description');
//  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//  var platformChannelSpecifics = NotificationDetails(
//      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//  await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'Ride with Fliver!',
//      'Daily notification shown!', time, platformChannelSpecifics);
}
