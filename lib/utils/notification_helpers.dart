import 'package:flutter/material.dart';
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

Future<TimeOfDay> pickTime(BuildContext context) async {
  print('pickTime() called');

  TimeOfDay pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  return pickedTime;
}

Future<void> createDailyNotification(
    BuildContext context, TimeOfDay selectedTime) async {
  print('createDailyNotification() called');

  var notificationTime = Time(selectedTime.hour, selectedTime.minute, 0);

  var androidSpecifics = AndroidNotificationDetails(
    'channelId',
    'Location Marking Suggestions',
    'Reminders to mark your location when you usually need a Rickshaw',
    importance: Importance.High,
    priority: Priority.High,
    icon: 'app_icon',
  );
  var iOSSpecifics = IOSNotificationDetails();
  var platformSpecifics = NotificationDetails(androidSpecifics, iOSSpecifics);

  await notificationsPlugin.showDailyAtTime(
    0,
    'Hunting for a Rickshaw?',
    'Open Fliver and mark your location!',
    notificationTime,
    platformSpecifics,
  );

  print('Notification created: $notificationTime');
}
