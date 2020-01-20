import 'package:firebase_analytics/firebase_analytics.dart';

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();

Future<void> logAnalyticsEvent(String event) async {
  print('Logging event $event...');
  await firebaseAnalytics.logEvent(name: '$event');
}
