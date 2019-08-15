import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider/utils/functions.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyMapViewPage extends StatefulWidget {
  @override
  _MyMapViewPageState createState() => _MyMapViewPageState();
}

class _MyMapViewPageState extends State<MyMapViewPage> {

  var currentLocation;

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Marker marker = Marker(marker.clearMarkers())
  setState(() {
  markers[markerId] = marker;
  });


  var clients = [];

  void initState()
  {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc){
      setState(() {
        currentLocation = currloc;
        populateClients();
      }
      );
    });
  }


  populateClients() {
    clients=[];
    Firestore.instance.collection('markers').getDocuments().then((docs){
      if(docs.documents.isNotEmpty){
        for(int i = 0;i<docs.documents.length;++i){
          clients.add(docs.documents[i].data);
          initMarker(docs.documents[i].data);
      }
      }
    });

  }

  initMarker(client) {
    mapController.clearMarkers().then((val) {
      mapController.addMarker(
        MarkerOptions(
          position: LatLng(latitude,)
        )

      );
    });
  }

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
                target: LatLng(currentLocation.latitude,currentLocation.longitude),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.my_location),
          foregroundColor: invertInvertColorsTheme(context),
          backgroundColor: invertColorsTheme(context),
          onPressed: requestPermissions),
    );
  }
}
