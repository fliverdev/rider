import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider/utils/colors.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rider/utils/functions.dart';
import 'package:rider/utils/map_style.dart';

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
    _startQuery();
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

   void _updateMarkers(List<DocumentSnapshot> documentList) {
    print(documentList);
    //mapController.clearMarkers(); Change as per updated Marker API
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint pos = document.data['position']['geopoint'];
      //double distance = document.data['distance']; use after implementing driver app
      var marker = Marker(
          position:LatLng(pos.latitude, pos.longitude),
          icon:BitmapDescriptor.defaultMarkerWithHue(147.5),
         // infoWindow: InfoWindow('Taxi','$distance kilometers from taxi')  use after implementing driver app
      );
    });
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
              myLocationButtonEnabled: false, //replace with a custom button
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
            Positioned(
              bottom: 10.0,
              right: 15.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Add marker'),
                    onPressed: _addMarker,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(
                    child: Text('Get location'),
                    onPressed: _animateToCurrentLocation,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 60.0,
              right: 15.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Write to DB'),
                    onPressed: _writeGeoPointToDb,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(
                    child: Text('Dark mode'),
                    onPressed: () {
                      DynamicTheme.of(context).setBrightness(
                          Theme.of(context).brightness == Brightness.dark
                              ? Brightness.light
                              : Brightness.dark);
                      _onMapCreated(mapController); //buggy
                    },
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(
                    child: Text('Update Markers'),
                    onPressed:  _startQuery,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _startQuery() async {
    //Get user's location

    var pos = await LatLng(currentLocation.latitude, currentLocation.longitude);
    double lat = currentLocation.latitude;
    double lng = currentLocation.longitude;

    //Make a reference to firestore
    var ref = firestore.collection('locations');
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    //subscribe to query
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(center: center, radius: rad, field: 'position',strictMode: true);
    }).listen(_updateMarkers);
  }


  _updateQuery(value)
  {
    setState((){
      radius.add(value);
    });
  }


  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

}
