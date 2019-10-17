import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider/utils/variables.dart';

Position getCurrentLocation() {
  print('Getting location...');
  Geolocator().getCurrentPosition().then((currLoc) {
    currentLocation = currLoc;
  });
  print('Current location: $currentLocation');
  return currentLocation;
} // use this anytime you need to get user's location

void animateToCurrentLocation(locationAnimation) async {
  var currentLocation = getCurrentLocation();
  mapController.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: zoom[locationAnimation],
        bearing: bearing[locationAnimation],
        tilt: tilt[locationAnimation],
      ),
    ),
  );
}

Future<DocumentReference> writeToDb() async {
  var currentLocation = getCurrentLocation();
  GeoFirePoint point = geo.point(
      latitude: currentLocation.latitude, longitude: currentLocation.longitude);
  return firestore.collection('locations').add({
    'position': point.data,
  });
} // writes current location to firebase
