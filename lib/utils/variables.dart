import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

var currentLocation;
var locationAnimation = 0; // used to switch between two kinds of animations
var ridersWithinRadius = 0;
var previousMarkersWithinRadius = 0;
var currentMarkersWithinRadius = 0;
var allMarkersWithinRadius = [];

final zoom = [15.0, 17.5]; // zoom levels (0/1)
final bearing = [0.0, 90.0]; // bearing level (0/1)
final tilt = [0.0, 45.0]; // axis tilt (0/1)

final hotspotRadius = 100.0; // radius that defines if a marker is nearby
final displayMarkersRadius = 5000.0; // radius upto which markers are loaded
// and displayed on the map

final markerRefreshInterval = Duration(seconds: 10); // timeout to repopulate markers
final splashScreenDuration = Duration(seconds: 3);

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
final Set<Circle> hotspots = {};

bool isFirstLaunch = true; // for dark mode fix
bool isSwipeButtonVisible = true; // to show/hide fab and swipe button correctly
bool isFabVisible = false;
bool isSnackbarEnabled = false;
bool isMarkerWithinRadius = false; // to identify nearby markers

GoogleMapController mapController;
Firestore firestore = Firestore.instance;
StreamSubscription subscription;
Geoflutterfire geo = Geoflutterfire();
BehaviorSubject<double> circleRadius = BehaviorSubject.seeded(100.0);
