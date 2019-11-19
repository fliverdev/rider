import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var currentLocation;
var myMarkerLocation;
var locationAnimation = 0; // used to switch between two kinds of animations
var previousMarkersWithinRadius = 0;
var currentMarkersWithinRadius = 0;
var allMarkersWithinRadius = [];
var markerColor;

final zoom = [15.0, 17.5]; // zoom levels (0/1)
final bearing = [0.0, 90.0]; // bearing level (0/1)
final tilt = [0.0, 45.0]; // axis tilt (0/1)

final hotspotRadius = 100.0; // radius that defines if a marker is 'nearby'
final displayMarkersRadius = 5000.0; // radius up to which markers are loaded

final markerRefreshInterval =
    Duration(seconds: 5); // timeout to repopulate markers
final markerExpireInterval =
    Duration(minutes: 15); // timeout to delete old markers

final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
final Set<Circle> hotspots = {};
final GlobalKey<ScaffoldState> scaffoldKey =
    GlobalKey<ScaffoldState>(); // for snackbar

bool isFirstLaunch = true; // for dark mode fix
bool isFirstCycle = true; // don't display swipe button in first cycle
bool isButtonSwiped = false; // for showing/hiding certain widgets
bool isPermissionGranted = false; // for location permission
bool isPermissionButtonVisible = true; // for intro page
bool isMoving = false; // to check if moving
bool isMarkerDeleted = false; // to check if marker was deleted
bool isMyMarkerPlotted = false; // if user has already marked location
bool isMyMarkerFetched = false; // if user has swiped correctly
bool isMarkerWithinRadius = false; // to identify nearby markers

String permissionStatusMessage = '';

GoogleMapController mapController;
Future<Position> position;
