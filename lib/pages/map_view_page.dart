import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_circle_distance/great_circle_distance.dart';
import 'package:rider/bloc/map_bloc.dart';
import 'package:rider/bloc/map_event.dart';
import 'package:rider/bloc/map_state.dart';
import 'package:rider/pages/about_page.dart';
import 'package:rider/services/emergency_call.dart';
import 'package:rider/services/map.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/map_style.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:rider/utils/variables.dart';
import 'package:rider/widgets/fetching_location.dart';
import 'package:rider/widgets/no_connection.dart';
import 'package:rider/widgets/swipe_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMapViewPage extends StatefulWidget {
  @override
  _MyMapViewPageState createState() => _MyMapViewPageState();
}

class _MyMapViewPageState extends State<MyMapViewPage> {
  MapBloc _mapBloc = MapBloc();

  @override
  void initState() {
    _mapBloc = BlocProvider.of<MapBloc>(context);
    super.initState();
    position = _setCurrentLocation();
  } // gets current user location when the app launches

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (isFirstLaunch) {
      _fetchMarkersFromDb();
      mapController
          .setMapStyle(isThemeCurrentlyDark(context) ? darkMap : lightMap);
      isFirstLaunch = false;
    } else {
      mapController
          .setMapStyle(isThemeCurrentlyDark(context) ? lightMap : darkMap);
    } // weird fix for broken dark mode

    Timer.periodic(markerRefreshInterval, (Timer t) {
      print('$markerRefreshInterval seconds over, refreshing...');
      _fetchMarkersFromDb(); // updates markers every 10 seconds
    });
  }

  //
  // So i thought about getting data via stream for position variable, but didn't manage to do it without changing code to much, so changes reverted
  //
  Future<Position> _setCurrentLocation() async {
    var cor = await Geolocator().getCurrentPosition();
    return cor;
  }

  //
  // Those functions were not mentioned in that article the issue provided, so i haven't added them.
  //
  Future _populateMarkers(clients) async {
    currentLocation = getCurrentLocation();
    currentMarkersWithinRadius = allMarkersWithinRadius.length;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isTipShown = prefs.getBool('isTipShown') ?? false;

    hotspots.clear();
    markers.clear();
    allMarkersWithinRadius.clear();
    // clearing lists needed to regenerate necessary markers

    for (int i = 0; i < clients.length; i++) {
      var documentId = clients[i].documentID;
      var markerId = MarkerId(documentId);
      var markerData = clients[i].data;
      var markerPosition = LatLng(markerData['position']['geopoint'].latitude,
          markerData['position']['geopoint'].longitude);

      var hotspotGcd = GreatCircleDistance.fromDegrees(
        latitude1: currentLocation.latitude.toDouble(),
        longitude1: currentLocation.longitude.toDouble(),
        latitude2: markerPosition.latitude.toDouble(),
        longitude2: markerPosition.longitude.toDouble(),
      ); // display hotspot for 100m radius

      var displayMarkersGcd = GreatCircleDistance.fromDegrees(
        latitude1: currentLocation.latitude.toDouble(),
        longitude1: currentLocation.longitude.toDouble(),
        latitude2: markerPosition.latitude.toDouble(),
        longitude2: markerPosition.longitude.toDouble(),
      ); // display only markers within 5km

      if (hotspotRadius >= hotspotGcd.haversineDistance()) {
        allMarkersWithinRadius
            .add(markerId); // contains nearby markers within 100m
        isMarkerWithinRadius = true;
      }

      var marker = Marker(
          markerId: markerId,
          position: markerPosition,
          icon: isMarkerWithinRadius
              ? BitmapDescriptor.defaultMarkerWithHue(147.5)
              : BitmapDescriptor.defaultMarkerWithHue(25.0),
          infoWindow: InfoWindow(
              title: 'ID: $documentId', snippet: 'Data: $markerData'),
          onTap: () {
            _deleteMarker(documentId); // debug
          });

      setState(() {
        if (displayMarkersRadius >= displayMarkersGcd.haversineDistance()) {
          markers[markerId] = marker;
        } // adds markers within 5km only, rest aren't considered at all
      });

      isMarkerWithinRadius = false;
    }

    if (isSnackbarEnabled) {
      // do all this only after user swipes
      if (currentMarkersWithinRadius != previousMarkersWithinRadius) {
        // if nearby markers increase/decrease
        if (currentMarkersWithinRadius >= 3) {
          // if a marker is added nearby
          scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                'There are $currentMarkersWithinRadius Riders in your area!',
                style: isThemeCurrentlyDark(context)
                    ? MyTextStyles.bodyStylePrimaryItalic
                    : MyTextStyles.bodyStyleLightItalic,
              ),
              backgroundColor: MyColors.black,
            ),
          );
          if (!isTipShown) {
            // display a tip only once
            prefs.setBool('isTipShown', true);
            showDialog(
              context: context,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: Text(
                  'Nearby Riders',
                  style: isThemeCurrentlyDark(context)
                      ? MyTextStyles.titleStyleLight
                      : MyTextStyles.titleStyleDark,
                ),
                content: Text(
                  'Congratulations! Looks like there are 3 or more Fliver Riders in your area.'
                  '\n\nEach time this threshold is reached, we create a '
                  'hotspot to notify Drivers of demand so that they can'
                  ' come to pick you and your friends up.',
                  style: isThemeCurrentlyDark(context)
                      ? MyTextStyles.bodyStyleLight
                      : MyTextStyles.bodyStyleDark,
                ),
                actions: <Widget>[
                  RaisedButton(
                    child: Text('Okay'),
                    color: invertColorsTheme(context),
                    textColor: invertInvertColorsStrong(context),
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          }
        } else if (isMyMarkerPlotted) {
          // when more markers are needed to create a hotspot
          scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                'Waiting for ${3 - currentMarkersWithinRadius} more Riders',
                style: isThemeCurrentlyDark(context)
                    ? MyTextStyles.bodyStylePrimaryItalic
                    : MyTextStyles.bodyStyleLightItalic,
              ),
              backgroundColor: MyColors.black,
            ),
          );
        }
      }
    }

    if (currentMarkersWithinRadius >= 3) {
      print('Generating hotspot...');

      setState(() {
        hotspots.add(Circle(
          circleId: CircleId(currentLocation.toString()),
          center: LatLng(currentLocation.latitude, currentLocation.longitude),
          radius: hotspotRadius,
          fillColor: MyColors.translucentColor,
          strokeColor: MyColors.primaryColor,
          strokeWidth: 15,
        ));
      });
    }
    isMyMarkerPlotted = true;
    previousMarkersWithinRadius = currentMarkersWithinRadius;
  } // works with markers within 5km

  void _fetchMarkersFromDb() {
    Firestore.instance.collection('locations').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        var docLength = docs.documents.length;
        var clients = List(docLength);
        for (int i = 0; i < docLength; i++) {
          clients[i] = docs.documents[i];
        }
        _populateMarkers(clients);
      }
    });
  } // fetches markers from firestore

  void _deleteMarker(documentId) {
    print('Deleting marker $documentId...');
    Firestore.instance.collection('locations').document(documentId).delete();
    setState(() {
      markers.remove(MarkerId(documentId));
    });
  } // deletes markers from firestore

  @override
  Widget build(BuildContext context) {
    Icon toggleLightsIcon = isThemeCurrentlyDark(context)
        ? Icon(Icons.brightness_7)
        : Icon(Icons.brightness_2);
    String toggleLightsText =
        isThemeCurrentlyDark(context) ? 'Light mode' : 'Dark mode';

    return OfflineBuilder(connectivityBuilder: (
      BuildContext context,
      ConnectivityResult connectivity,
      Widget child,
    ) {
      if (connectivity == ConnectivityResult.none) {
        return NoConnection();
      } else {
        return child;
      }
    }, builder: (BuildContext context) {
      // when there is proper internet
      return BlocListener(
        //
        // Listen to changes in bloc, if Location was found then set currentLocation value to value from LocationFound(curLoc)
        //
        bloc: _mapBloc,
        listener: (BuildContext context, MapState state) {
          if (state is LocationFound) {
            currentLocation = state.curLoc;
          }
        },
        child: FutureBuilder(
            future: position,
            builder: (context, data) {
              if (!data.hasData) {
                return FetchingLocation();
              } else {
                // when current location is obtained
                return Scaffold(
                  key: scaffoldKey,
                  body: BlocBuilder(
                      //
                      // Using data acquired from _getLocationToState()
                      //
                      bloc: BlocProvider.of<MapBloc>(context),
                      builder: (BuildContext context, MapState state) {
                        return Container(
                          child: Stack(
                            children: <Widget>[
                              GoogleMap(
                                onMapCreated: _onMapCreated,
                                mapToolbarEnabled: true,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                                compassEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(currentLocation.latitude,
                                      currentLocation.longitude),
                                  zoom: zoom[0],
                                  bearing: bearing[0],
                                  tilt: tilt[0],
                                ),
                                markers: Set<Marker>.of(markers.values),
                                circles: hotspots,
                              ),
                              Positioned(
                                top: 10.0,
                                left: 20.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 90.0,
                                      height: 90.0,
                                      child: isThemeCurrentlyDark(context)
                                          ? Image.asset(
                                              'assets/logo/fliver-green.png',
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/logo/fliver-black.png',
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: isSwipeButtonVisible,
                                child: Positioned(
                                  top: 40.0,
                                  right: 20.0,
                                  child: FloatingActionButton(
                                    mini: true,
                                    child: Icon(
                                      Icons.warning,
                                      size: 20.0,
                                    ),
                                    tooltip: 'Emergency',
                                    foregroundColor: MyColors.primaryColor,
                                    backgroundColor: MyColors.accentColor,
                                    elevation: 5.0,
                                    onPressed: () {
                                      showEmergencyPopup(context);
                                    },
                                  ),
                                ),
                              ), // displays emergency button before swipe
                              Visibility(
                                visible: isSwipeButtonVisible,
                                child: Positioned(
                                  left: 15.0,
                                  right: 15.0,
                                  bottom: 15.0,
                                  child: SwipeButton(
                                    thumb: Icon(
                                      Icons.arrow_forward_ios,
                                      color: MyColors.black,
                                    ),
                                    content: Center(
                                      child: Text(
                                        'Swipe to mark location       ',
                                        style: MyTextStyles.bodyStyleLight,
                                      ),
                                    ),
                                    onChanged: (result) {
                                      if (result == SwipePosition.SwipeRight) {
                                        setState(() {
                                          isSwipeButtonVisible = false;
                                          isFabVisible = true;
                                          isSnackbarEnabled = true;
                                        });
                                        locationAnimation = 1;
                                        writeToDb();
                                        _fetchMarkersFromDb();
                                        animateToCurrentLocation(
                                            locationAnimation);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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
                          labelStyle: MyTextStyles.labelStyle,
                          onTap: () {
                            if (locationAnimation == 0) {
                              locationAnimation = 1;
                            } else if (locationAnimation == 1) {
                              locationAnimation = 0;
                            }
                            animateToCurrentLocation(locationAnimation);
                          },
                        ),
                        SpeedDialChild(
                          child: toggleLightsIcon,
                          foregroundColor: invertColorsTheme(context),
                          backgroundColor: invertInvertColorsTheme(context),
                          label: toggleLightsText,
                          labelStyle: MyTextStyles.labelStyle,
                          onTap: () {
                            DynamicTheme.of(context).setBrightness(
                                Theme.of(context).brightness == Brightness.dark
                                    ? Brightness.light
                                    : Brightness.dark);
                            _onMapCreated(mapController);
                          },
                        ),
                        SpeedDialChild(
                          child: Icon(Icons.info),
                          foregroundColor: invertColorsTheme(context),
                          backgroundColor: invertInvertColorsTheme(context),
                          label: 'Credits',
                          labelStyle: MyTextStyles.labelStyle,
                          onTap: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) {
                              return MyAboutPage();
                            }));
                          },
                        ),
                        SpeedDialChild(
                          child: Icon(Icons.warning),
                          foregroundColor: MyColors.white,
                          backgroundColor: MaterialColors.red,
                          label: 'Emergency',
                          labelStyle: MyTextStyles.labelStyle,
                          onTap: () {
                            showEmergencyPopup(context);
                          },
                        ),
                      ],
                    ),
                  ), // shows fab only after swipe
                );
              }
            }),
      );
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    _mapBloc.close();
    super.dispose();
  }
}
