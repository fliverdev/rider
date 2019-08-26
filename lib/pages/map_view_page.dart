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
import 'package:rider/pages/about_page.dart';
import 'package:rider/services/rto_complaint.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/map_style.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:rider/widgets/swipe_button.dart';

class MyMapViewPage extends StatefulWidget {
  @override
  _MyMapViewPageState createState() => _MyMapViewPageState();
}

class _MyMapViewPageState extends State<MyMapViewPage> {
  var currentLocation;
  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final Set<Circle> _circle = {};

  GoogleMapController mapController;
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  void initState() {
    super.initState();
    _getCurrentLocation();
  } // gets current user location when the app loads

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController
        .setMapStyle(isThemeCurrentlyDark(context) ? retro : aubergine); //buggy
  }

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
      });
    });
    return currentLocation;
  }

  void _addMarker() {
    var markerIdVal = Random().toString(); // TODO: don't use Random()
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
  }

  void _animateToCurrentLocation() async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 17.5,
          bearing: 90.0,
          tilt: 45.0,
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
                zoom: 15.0,
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
//                    fontFamily: '',
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0,
                      fontStyle: FontStyle.italic,
                      color: invertColorsStrong(context),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 100.0, // 15.0 to align with the fab
              child: SwipeButton(
                thumb: Icon(Icons.arrow_forward_ios),
                content: Center(
                  child: Text('Swipe to mark location'),
                ),
                onChanged: (result) {
                  print('Button swiped: $result');
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        heroTag: 'speedDial',
        closeManually: false,
        foregroundColor: invertInvertColorsTheme(context),
        backgroundColor: invertColorsTheme(context),
        animatedIcon: AnimatedIcons.menu_close,
        elevation: 5.0,
        children: [
          SpeedDialChild(
            child: Icon(Icons.location_on),
            foregroundColor: invertColorsTheme(context),
            backgroundColor: invertInvertColorsTheme(context),
            label: 'Mark location',
            labelStyle: TextStyle(
                color: MyColors.accentColor, fontWeight: FontWeight.w500),
            onTap: () {
              _animateToCurrentLocation();
              _addMarker();
              _writeGeoPointToDb();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.phone),
            foregroundColor: invertColorsTheme(context),
            backgroundColor: invertInvertColorsTheme(context),
            label: 'RTO Complaint',
            labelStyle: TextStyle(
                color: MyColors.accentColor, fontWeight: FontWeight.w500),
            onTap: () {
              showRtoPopup(context);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.lightbulb_outline),
            foregroundColor: invertColorsTheme(context),
            backgroundColor: invertInvertColorsTheme(context),
            label: 'Toggle lights',
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
    );
  }
}
