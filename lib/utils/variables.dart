import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

var currentLocation;
var locationAnimation = 0; // used to switch between two kinds of animations
var ridersWithinRadius = 0; // number of riders nearby for hotspot
var previousMarkersWithinRadius = 0;
var currentMarkersWithinRadius = 0;
var allMarkersWithinRadius = [];

final zoom = [15.0, 17.5]; // zoom levels (0/1)
final bearing = [0.0, 90.0]; // bearing level (0/1)
final tilt = [0.0, 45.0]; // axis tilt (0/1)

final hotspotRadius = 100.0; // radius that defines if a marker is 'nearby'
final displayMarkersRadius = 5000.0; // radius up to which markers are loaded

final markerRefreshInterval =
    Duration(seconds: 5); // timeout to repopulate markers

final GlobalKey<ScaffoldState> scaffoldKey =
    GlobalKey<ScaffoldState>(); // for snackbar
final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
final Set<Circle> hotspots = {};

bool isFirstLaunch = true; // for dark mode fix
bool isSwipeButtonVisible = true; // to show/hide fab and swipe button correctly
bool isFabVisible = false;
bool isSnackbarEnabled = false; // to display snackbars correctly
bool isPermissionButtonVisible = true; // for intro page
bool isMarkerWithinRadius = false; // to identify nearby markers
bool isMyMarkerPlotted = false; // if user has swiped correctly

GoogleMapController mapController;
Firestore firestore = Firestore.instance;
StreamSubscription subscription;
Geoflutterfire geo = Geoflutterfire();
BehaviorSubject<double> circleRadius = BehaviorSubject.seeded(100.0);
Future<Position> position;
