import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider/utils/functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider/services/firestore_crud.dart';

class MyMapViewPage extends StatefulWidget {
  @override
  _MyMapViewPageState createState() => _MyMapViewPageState();
}

class _MyMapViewPageState extends State<MyMapViewPage> {
  var currentLocation;
  var firestoreCrudObj = new FirestoreCrud();

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  var clients = [];

  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currLoc) {
      setState(() {
        currentLocation = currLoc;
        populateClients();
      });
    });
    firestoreCrudObj.getData().then((results){
    });
  } // gets current user location when the app loads

  populateClients() {
    clients = [];
    Firestore.instance.collection('markers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          clients.add(docs.documents[i].data);
//          initMarker(docs.documents[i].data);
        }
      }
    });
  } // gets client name and location from firestore

  zoomInMarker(client) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: null, zoom: 15.0, bearing: 90.0, tilt: 45.0),
      ),
    );
  } // cool animation when zooming into the user location

//  initMarker(client) {
//    mapController.clearMarkers().then((val) {
//      mapController.addMarker(
//        MarkerOptions(
//          position: LatLng(latitude,)
//        )
//
//      );
//    });
//  }

//Geolocator Function
//  void getLocation() async {
//    Position position = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    print(position);
//  }

//  static var pos;
//  var location = new Location();
//  var currentLocation = LocationData;
//  //To detect location - 13/8/19 (added)
//  _animateToUser() async {
//    currentLocation = await location.getLocation();
//    mapController.animateCamera(
//      CameraUpdate.newCameraPosition(
//        CameraPosition(
//          target: _center,
//          zoom: 15.0,
//        ),
//      ),
//    );
//  }

//  location.onLocationChanged().listen((LocationData currentLocation) {
//  print(currentLocation.latitude);
//  print(currentLocation.longitude);
//  });

//  LocationData currentLocation = new LocationData();
//  final double latitude = location.latitude;
//  final double longitude = location.long
//  final LatLng _center = const LatLng(18.9548, 72.7985); //malabar hill
//  final LatLng _center = LatLng(currentLocation['latitude'],
//      currentLocation['langitude']); //to detect current location

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
                    color: invertColorsMild(context),
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
                      color: invertColorsMild(context),
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
                    child: Text('Save Location'),
                    onPressed: doNothing,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(
                    child: Text('Button 2'),
                    onPressed: doNothing,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  RaisedButton(
                    child: Text('Button 3'),
                    onPressed: doNothing,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//          child: Icon(Icons.my_location),
//          foregroundColor: invertInvertColorsTheme(context),
//          backgroundColor: invertColorsTheme(context),
//          onPressed: doNothing),
    );
  }
}
