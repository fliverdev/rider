import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:random_string/random_string.dart';
import 'package:rider/pages/about_page.dart';
import 'package:rider/services/rto_complaint.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/map_style.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:rider/widgets/swipe_button.dart';
import 'package:rxdart/rxdart.dart';

class MyMapViewPage extends StatefulWidget {
  @override
  _MyMapViewPageState createState() => _MyMapViewPageState();
}

class _MyMapViewPageState extends State<MyMapViewPage> {
  var currentLocation;
  var clients = [];
  var zoom = [15.0, 17.5];
  var bearing = [0.0, 90.0];
  var tilt = [0.0, 45.0];
  var locationAnimation = 0;

  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Set<Circle> _circle = {};

  bool isFirstLaunch = true;
  bool isSwipeButtonVisible = true;
  bool isFabVisible = false;

  GoogleMapController mapController;
  Firestore firestore = Firestore.instance;
  StreamSubscription subscription;
  Geoflutterfire geo = Geoflutterfire();

  BehaviorSubject<double> radius = BehaviorSubject.seeded(100.0);
  Stream<dynamic> query;

  void initState() {
    super.initState();
    _getCurrentLocation();
  } // gets current user location when the app loads

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (isFirstLaunch) {
      mapController.setMapStyle(isThemeCurrentlyDark(context)
          ? aubergine
          : retro); // TODO: improve this
      isFirstLaunch = false;
    } else {
      mapController
          .setMapStyle(isThemeCurrentlyDark(context) ? retro : aubergine);
    }
  } // recreates map

  void _getCurrentLocation() {
    Geolocator().getCurrentPosition().then((currLoc) {
      setState(() {
        currentLocation = currLoc;
        _circle.add(Circle(
          circleId: CircleId(
              LatLng(currentLocation.latitude, currentLocation.longitude)
                  .toString()),
          center: LatLng(currentLocation.latitude, currentLocation.longitude),
          radius: 75,
          fillColor: MyColors.translucentColor,
          strokeColor: MyColors.primaryColor,
          visible: true,
        ));
        _populateClients();
      });
    });
    return currentLocation;
  }

  void _initMarkersFromFirestore(client) {
    var markerIdVal = randomString(7); // TODO: don't use Random()
    final MarkerId markerId = MarkerId(markerIdVal);

    var marker = Marker(
      markerId: markerId,
      position: LatLng(client['position']['geopoint'].latitude,
          client['position']['geopoint'].longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(147.5), // closest color i
      // could get
      infoWindow: InfoWindow(title: 'Marker Title', snippet: 'Marker Snippet'),
      onTap: doNothing,
    );

    setState(() {
      markers[markerId] = marker;
    });
  } // creates markers from firestore on the map

  void _addCurrentLocationMarker() {
    var markerIdVal = Random().toString();
    final MarkerId markerId = MarkerId(markerIdVal);

    var marker = Marker(
      markerId: markerId,
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(147.5), // closest color i
      // could get
      infoWindow: InfoWindow(title: 'Marker Title', snippet: 'Marker Snippet'),
      onTap: doNothing,
    );

    setState(() {
      markers[markerId] = marker;
    });
  } //adds current location as a marker to map and db

  void _populateClients() {
    clients = [];
    Firestore.instance.collection('locations').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          clients.add(docs.documents[i].data);
          _initMarkersFromFirestore(docs.documents[i].data);
        }
      }
    });
  } // renders markers from firestore on the map

  void _animateToCurrentLocation(locationAnimation) async {
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

  Future<DocumentReference> _writeGeoPointToDb() async {
    var pos = await LatLng(currentLocation.latitude, currentLocation.longitude);
    GeoFirePoint point = geo.point(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude);
    return firestore.collection('locations').add({
      'position': point.data,
    });
  }

  @override
  Widget build(BuildContext context) {
    Icon toggleLightsIcon = isThemeCurrentlyDark(context)
        ? Icon(Icons.brightness_7)
        : Icon(Icons.brightness_2);
    String toggleLightsText =
        isThemeCurrentlyDark(context) ? 'Light mode' : 'Dark mode';
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              mapToolbarEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(currentLocation.latitude, currentLocation.longitude),
                zoom: zoom[0],
                bearing: bearing[0],
                tilt: tilt[0],
              ),
              markers: Set<Marker>.of(markers.values),
              circles: _circle,
            ),
            Positioned(
              top: 40.0,
              left: 20.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Fliver Rider',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0,
                      fontStyle: FontStyle.italic,
                      color: invertColorsStrong(context),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isSwipeButtonVisible,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SwipeButton(
                  thumb: Icon(Icons.arrow_forward_ios),
                  content: Center(
                    child: Text('Swipe to mark location'),
                  ),
                  onChanged: (result) {
                    if (result == SwipePosition.SwipeRight) {
                      setState(() {
                        isSwipeButtonVisible = false;
                        isFabVisible = true;
                      });
                      locationAnimation = 1;
                      _animateToCurrentLocation(locationAnimation);
                      _addCurrentLocationMarker();
                      _writeGeoPointToDb();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: isFabVisible,
        child: SpeedDial(
          heroTag: 'fab',
          closeManually: false,
          foregroundColor: invertInvertColorsTheme(context),
          backgroundColor: invertColorsTheme(context),
          animatedIcon: AnimatedIcons.menu_close,
          elevation: 5.0,
          children: [
            SpeedDialChild(
              child: Icon(Icons.my_location),
              foregroundColor: invertColorsTheme(context),
              backgroundColor: invertInvertColorsTheme(context),
              label: 'Recenter',
              labelStyle: TextStyle(
                  color: MyColors.accentColor, fontWeight: FontWeight.w500),
              onTap: () {
                if (locationAnimation == 0) {
                  locationAnimation = 1;
                } else if (locationAnimation == 1) {
                  locationAnimation = 0;
                }
                _animateToCurrentLocation(locationAnimation);
              },
            ),
            SpeedDialChild(
              child: toggleLightsIcon,
              foregroundColor: invertColorsTheme(context),
              backgroundColor: invertInvertColorsTheme(context),
              label: toggleLightsText,
              labelStyle: TextStyle(
                  color: MyColors.accentColor, fontWeight: FontWeight.w500),
              onTap: () {
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark);
                _onMapCreated(mapController); //buggy
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.phone),
              foregroundColor: invertColorsTheme(context),
              backgroundColor: invertInvertColorsTheme(context),
              label: 'RTO complaint',
              labelStyle: TextStyle(
                  color: MyColors.accentColor, fontWeight: FontWeight.w500),
              onTap: () {
                showRtoPopup(context);
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.info_outline),
              foregroundColor: invertColorsTheme(context),
              backgroundColor: invertInvertColorsTheme(context),
              label: 'About',
              labelStyle: TextStyle(
                  color: MyColors.accentColor, fontWeight: FontWeight.w500),
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return MyAboutPage();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
