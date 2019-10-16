import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

var currentLocation;
var locationAnimation = 0; // used to switch between two kinds of animations

final zoom = [15.0, 17.5]; // zoom levels (0/1)
final bearing = [0.0, 90.0]; // bearing level (0/1)
final tilt = [0.0, 45.0]; // axis tilt (0/1)

final hotspotRadius = 100.0; // radius that defines if a marker is nearby
final displayMarkersRadius = 5000.0; // radius upto which markers are loaded
// and displayed on the map

final interval = Duration(seconds: 10); // timeout to repopulate markers

final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
final Set<Circle> hotspots = {};

bool isFirstLaunch = true; // for dark mode fix
bool isFirstLaunchSinceInstall = true; // use for app intro screen
bool isSwipeButtonVisible = true; // to show/hide fab and swipe button correctly
bool isFabVisible = false;
bool isMarkerWithinRadius = true; // to color marker correctly

GoogleMapController mapController;
Firestore firestore = Firestore.instance;
StreamSubscription subscription;
Geoflutterfire geo = Geoflutterfire();
Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
BitmapDescriptor markerPrimary;
BitmapDescriptor markerSecondary;

BehaviorSubject<double> circleRadius = BehaviorSubject.seeded(100.0);
Stream<dynamic> query;
