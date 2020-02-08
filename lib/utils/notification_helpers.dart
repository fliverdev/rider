import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  print('initNotifications() called');

  var initSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initSettingsIOS = IOSInitializationSettings();
  var initSettings =
      InitializationSettings(initSettingsAndroid, initSettingsIOS);

  notificationsPlugin.initialize(initSettings);
}

Future<void> createDailyNotification(
    int notificationId, Time notificationTime) async {
  print('createDailyNotification() called');

  var androidSpecifics = AndroidNotificationDetails(
    'marking_suggestions',
    'Location Marking Suggestions',
    'Reminders to mark your location when you might need a Rickshaw',
    importance: Importance.High,
    priority: Priority.High,
    icon: 'app_icon',
  );
  var iOSSpecifics = IOSNotificationDetails();
  var platformSpecifics = NotificationDetails(androidSpecifics, iOSSpecifics);

  await notificationsPlugin.showDailyAtTime(
    notificationId,
    'Hunting for a Rickshaw?',
    'Open Fliver and mark your location!',
    notificationTime,
    platformSpecifics,
  );
}
