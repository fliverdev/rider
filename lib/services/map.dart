import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider/utils/variables.dart';

void animateToCurrentLocation(locationAnimation) async {
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
  var pos = await LatLng(currentLocation.latitude, currentLocation.longitude);
  GeoFirePoint point = geo.point(
      latitude: currentLocation.latitude, longitude: currentLocation.longitude);
  return firestore.collection('locations').add({
    'position': point.data,
  });
}

