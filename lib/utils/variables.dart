import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

var currentLocation;
var locationAnimation = 0;

final zoom = [15.0, 17.5];
final bearing = [0.0, 90.0];
final tilt = [0.0, 45.0];

final hotspotRadius = 100.0;
final displayMarkersRadius = 5000.0;

final interval = Duration(seconds: 10);

final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
final Set<Circle> hotspots = {};

bool isFirstLaunch = true;
bool isFirstLaunchSinceInstall = true;
bool isSwipeButtonVisible = true;
bool isFabVisible = false;
bool isMarkerWithinRadius = true;

Color markerColor;
GoogleMapController mapController;
Firestore firestore = Firestore.instance;
StreamSubscription subscription;
Geoflutterfire geo = Geoflutterfire();
Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
BitmapDescriptor markerPrimary;
BitmapDescriptor markerSecondary;

BehaviorSubject<double> circleRadius = BehaviorSubject.seeded(100.0);
Stream<dynamic> query;
