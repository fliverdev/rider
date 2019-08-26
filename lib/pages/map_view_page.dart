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
import 'package:rider/utils/colors.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rider/utils/functions.dart';
import 'package:rider/utils/map_style.dart';
import 'package:random_string/random_string.dart';

class MyMapViewPage extends StatefulWidget {
  @override
  _MyMapViewPageState createState() => _MyMapViewPageState();

}

class _MyMapViewPageState extends State<MyMapViewPage> {
  var currentLocation;
  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final Set<Circle> _circle = {};
  var clients = [];
  GoogleMapController mapController;
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  //Stateful Data
  BehaviorSubject<double> radius = BehaviorSubject.seeded(100.0);
  Stream<dynamic> query;

  //Subscription
  StreamSubscription subscription;

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
        currentLocation =  currLoc;
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
      populateClients();
      });
    });
    return currentLocation;
  }

  void initMarker(client)
  {


  var markerIdVal = randomString(7); // TODO: don't use Random()
  final MarkerId markerId = MarkerId(markerIdVal);

  var marker = Marker(
  markerId: markerId,
  position: LatLng(client['position']['geopoint'].latitude, client['position']['geopoint'].longitude),
  icon: BitmapDescriptor.defaultMarkerWithHue(147.5), // closest color i
  // could get
  infoWindow: InfoWindow(title: 'Marker Title', snippet: 'Marker Snippet'),
  onTap: doNothing,
  );

  setState(() {
  markers[markerId] = marker;
  });
  }

  void populateClients(){
    clients = [];
    Firestore.instance.collection('locations').getDocuments().then((docs){
      print("did we get all the clients ? " + docs.documents.toString());
      if(docs.documents.isNotEmpty)
        {
          for(int i = 0;i<docs.documents.length;i++)
            {
              clients.add(docs.documents[i].data);
              initMarker(docs.documents[i].data);
            }
        }
    });
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
            Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                top: 40.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu),
                    tooltip: 'Menu',
                    color: invertColorsStrong(context),
                    iconSize: 22.0,
                    onPressed: doNothing,
                  ),
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
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

}
