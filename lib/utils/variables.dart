import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

var currentLocation;
var zoom = [15.0, 17.5];
var bearing = [0.0, 90.0];
var tilt = [0.0, 45.0];
var locationAnimation = 0;

const interval = const Duration(seconds: 10);

final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
final Set<Circle> hotspots = {};

bool isFirstLaunch = true;
bool isFirstLaunchSinceInstall = true;
bool isSwipeButtonVisible = true;
bool isFabVisible = false;

GoogleMapController mapController;
Firestore firestore = Firestore.instance;
StreamSubscription subscription;
Geoflutterfire geo = Geoflutterfire();
Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

BehaviorSubject<double> radius = BehaviorSubject.seeded(100.0);
Stream<dynamic> query;
