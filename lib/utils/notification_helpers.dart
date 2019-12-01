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

Future<TimeOfDay> pickTime(BuildContext context, TimeOfDay selectedTime) async {
  print('pickTime() called');

  TimeOfDay pickedTime = await showTimePicker(
    context: context,
    initialTime: selectedTime,
  );

  if (pickedTime != null) {
    selectedTime = pickedTime;
  } // will still notify at current time

  return selectedTime; // TODO: fix time == null
}

Future<TimeOfDay> createDailyNotification(BuildContext context) async {
  print('createDailyNotification() called');

  TimeOfDay selectedTime = TimeOfDay.now(); // initial time is current time
  selectedTime = await pickTime(context, selectedTime);
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
    'Looking for a Rickshaw?',
    'Open Fliver and mark your location!',
    notificationTime,
    platformSpecifics,
  );

  print('Notification set for $selectedTime');
  return selectedTime;
}
