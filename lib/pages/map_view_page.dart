import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider/pages/about_page.dart';
import 'package:rider/services/firebase_analytics.dart';
import 'package:rider/utils/colors.dart';
import 'package:rider/utils/map_styles.dart';
import 'package:rider/utils/text_styles.dart';
import 'package:rider/utils/ui_helpers.dart';
import 'package:rider/widgets/alerts.dart';
import 'package:rider/widgets/emergency_call.dart';
import 'package:rider/widgets/fetching_location.dart';
import 'package:rider/widgets/no_connection.dart';
import 'package:rider/widgets/swipe_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMapViewPage extends StatefulWidget {
  final SharedPreferences helper;
  final String identity;
  MyMapViewPage({Key key, @required this.helper, @required this.identity})
      : super(key: key);
  @override
  _MyMapViewPageState createState() => _MyMapViewPageState();
}

class _MyMapViewPageState extends State<MyMapViewPage> {
  var currentLocation;
  var myMarkerLocation;
  var markerColor;
  var locationAnimation = 0; // used to switch between 2 kinds of animations

  final zoom = [15.0, 17.5]; // zoom levels (0/1)
  final bearing = [0.0, 90.0]; // bearing level (0/1)
  final tilt = [0.0, 45.0]; // axis tilt (0/1)

  final hotspotRadius = 100.0; // radius that defines if a marker is 'nearby'
  final displayMarkersRadius = 5000.0; // radius up to which markers are loaded

  final showAlertDelay =
      Duration(seconds: 3); // wait time before displaying alerts
  final markerRefreshInterval =
      Duration(seconds: 5); // timeout to repopulate markers
  final markerExpireInterval =
      Duration(minutes: 15); // timeout to delete old markers

  bool isFirstLaunch = true; // for dark mode fix
  bool isFirstCycle = true; // don't display swipe button in first cycle
  bool isButtonSwiped = false; // for showing/hiding certain widgets
  bool isMoving = false; // to check if moving
  bool isMarkerDeleted = false; // to check if marker was deleted
  bool isMyMarkerPlotted = false; // if user has already marked location
  bool isMyMarkerFetched = false; // if user's marker has been fetched
  bool isMarkerWithinRadius = false; // to identify nearby markers

  GoogleMapController mapController;
  Future<Position> position;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Set<Circle> hotspots = {};
  GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(); // for snackbar

  @override
  void initState() {
    print('initState() called');
    super.initState();
    print('UUID is ${widget.identity}');
    position = _setCurrentLocation();
  } // gets current user location when the app launches

  void _onMapCreated(GoogleMapController controller) {
    print('_onMapCreated() called');
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

  Future<Position> _setCurrentLocation() async {
    print('_setCurrentLocation() called');
    currentLocation = await Geolocator().getCurrentPosition();
    myMarkerLocation = currentLocation;
    return currentLocation;
  }

  Future<void> _writeToDb() async {
    print('_writeToDb() called');
    myMarkerLocation = currentLocation;
    GeoFirePoint geoPoint = Geoflutterfire().point(
        latitude: myMarkerLocation.latitude,
        longitude: myMarkerLocation.longitude);

    Firestore.instance.collection('markers').document(widget.identity).setData({
      'position': geoPoint.data,
      'timestamp': DateTime.now(),
    });
  } // writes current location & time to firestore

  void _fetchMarkersFromDb() {
    print('_fetchMarkersFromDb() called');
    Firestore.instance.collection('markers').getDocuments().then((docs) async {
      var docLength = docs.documents.length;
      var clients = List(docLength);
      for (int i = 0; i < docLength; i++) {
        clients[i] = docs.documents[i];
      }
      if (!isFirstCycle && isMyMarkerFetched) {
        currentLocation = await Geolocator().getCurrentPosition();
      }
      _populateMarkers(clients);
    });
  } // fetches markers from firestore

  Future _populateMarkers(clients) async {
    print('_populateMarkers() called');
    bool isTipShown1 = widget.helper.getBool('isTipShown1') ?? false;
    bool isTipShown2 = widget.helper.getBool('isTipShown2') ?? false;

    var previousMarkersWithinRadius = 0;
    var currentMarkersWithinRadius = 0;

    hotspots.clear();
    markers.clear();
    // clearing lists needed to regenerate necessary markers

    for (int i = 0; i < clients.length; i++) {
      print('_populateMarkers() loop ${i + 1}/${clients.length}');
      var documentId = clients[i].documentID;
      var markerId = MarkerId(documentId);
      var markerData = clients[i].data;

      var markerPosition = LatLng(markerData['position']['geopoint'].latitude,
          markerData['position']['geopoint'].longitude);
      var markerTimestamp = markerData['timestamp'].toDate();

      var timeDiff = DateTime.now().difference(markerTimestamp);

      var myMarkerDistance = await Geolocator().distanceBetween(
        myMarkerLocation.latitude.toDouble(),
        myMarkerLocation.longitude.toDouble(),
        markerPosition.latitude.toDouble(),
        markerPosition.longitude.toDouble(),
      ); // distance between my marker and other markers

      isMarkerDeleted = false;

      if (timeDiff > markerExpireInterval) {
        // if the marker is expired, it gets deleted and doesn't continue
        print('Marker $markerId expired, deleting...');
        _deleteMarker(documentId);
        isMarkerDeleted = true;

        if (documentId == widget.identity && isButtonSwiped && !isMoving) {
          // only if you delete your own marker
          myMarkerLocation = currentLocation;
          showDialog(
            context: context,
            barrierDismissible: false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(
                'Marker Expired',
                style: isThemeCurrentlyDark(context)
                    ? TitleStyles.white
                    : TitleStyles.black,
              ),
              content: Text(
                'Markers get deleted automatically after 15 minutes.'
                '\n\nIf you\'re still looking for a Rickshaw, please mark '
                'your location again!',
                style: isThemeCurrentlyDark(context)
                    ? BodyStyles.white
                    : BodyStyles.black,
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
                    locationAnimation = 0;
                    _animateToLocation(currentLocation, locationAnimation);
                    setState(() {
                      isFirstCycle = true;
                      isButtonSwiped = false;
                      isMyMarkerPlotted = false;
                    });
                    logAnalyticsEvent('marker_expired');
                    // displays swipe button etc. again
                  },
                ),
              ],
            ),
          );
        }
      } else if (documentId == widget.identity) {
        // to check if user is moving
        var currentLocationDistance = await Geolocator().distanceBetween(
          currentLocation.latitude.toDouble(),
          currentLocation.longitude.toDouble(),
          markerPosition.latitude.toDouble(),
          markerPosition.longitude.toDouble(),
        ); // distance between current location and my marker

        if (currentLocationDistance >= hotspotRadius && !isMoving) {
          print('User moved outside hotspot, deleting...');
          _deleteMarker(documentId);
          myMarkerLocation = currentLocation;
          isMarkerDeleted = true;
          isMoving = true;

          showDialog(
            context: context,
            barrierDismissible: false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(
                'You\'re Moving!',
                style: isThemeCurrentlyDark(context)
                    ? TitleStyles.white
                    : TitleStyles.black,
              ),
              content: Text(
                'You moved outside your hotspot, so your marker has been deleted.'
                '\n\nDid you manage to find a Rickshaw?',
                style: isThemeCurrentlyDark(context)
                    ? BodyStyles.white
                    : BodyStyles.black,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  textColor: invertColorsStrong(context),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  onPressed: () {
                    Navigator.pop(context);
                    locationAnimation = 0;
                    _animateToLocation(currentLocation, locationAnimation);
                    setState(() {
                      isFirstCycle = true;
                      isButtonSwiped = false;
                      isMyMarkerPlotted = false;
                      isMoving = false;
                    });
                    logAnalyticsEvent('user_moved');
                    logAnalyticsEvent('rickshaw_not_found');
                  },
                ),
                RaisedButton(
                  child: Text('Yes'),
                  color: invertColorsTheme(context),
                  textColor: invertInvertColorsStrong(context),
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  onPressed: () {
                    Navigator.pop(context);
                    locationAnimation = 0;
                    _animateToLocation(currentLocation, locationAnimation);
                    setState(() {
                      isFirstCycle = true;
                      isButtonSwiped = false;
                      isMyMarkerPlotted = false;
                      isMoving = false;
                    });
                    logAnalyticsEvent('user_moved');
                    logAnalyticsEvent('rickshaw_found');
                  },
                ),
              ],
            ),
          );
        }
      }
      if (!isMarkerDeleted) {
        if (documentId == widget.identity) {
          // my marker
          isMyMarkerFetched = true;

          if (!isMyMarkerPlotted) {
            print('$documentId is plotted');
            isMyMarkerPlotted = true;
            isButtonSwiped = true;
            locationAnimation = 1;
            myMarkerLocation = markerPosition;
            _animateToLocation(myMarkerLocation, locationAnimation);
          }
        }

        if (hotspotRadius >= myMarkerDistance) {
          currentMarkersWithinRadius += 1; // no. of markers near my marker
          isMarkerWithinRadius = true;
        }

        if (isMarkerWithinRadius) {
          if (documentId == widget.identity) {
            markerColor = 218.0; // blue for own marker
          } else {
            markerColor = 165.0; // green for nearby markers
          }
        } else {
          markerColor = 34.0; //red for far away markers
        }

        var marker = Marker(
          markerId: markerId,
          position: markerPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
        );

        setState(() {
          if (displayMarkersRadius >= myMarkerDistance) {
            markers[markerId] = marker;
          } // adds markers within 5km of my marker
        });
      }
      isMarkerWithinRadius = false;
      isMarkerDeleted = false;
    }

    if (isFirstCycle) {
      setState(() {
        isFirstCycle = false;
      });
    }

    if (isButtonSwiped) {
      // do all this only after user swipes & r/w of markers occurs once
      if (currentMarkersWithinRadius != previousMarkersWithinRadius) {
        // if nearby markers increase/decrease
        print('Number of markers changed!');
        print('Current markers: $currentMarkersWithinRadius');
        if (currentMarkersWithinRadius >= 3) {
          // if a marker is added nearby
          scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                'There are $currentMarkersWithinRadius Riders in your area!',
                style: isThemeCurrentlyDark(context)
                    ? BodyStyles.primary
                    : BodyStyles.white,
              ),
              backgroundColor: MyColors.black,
            ),
          );
          if (!isTipShown2 && !isMoving) {
            // display a tip only once
            widget.helper.setBool('isTipShown2', true);
            await Future.delayed(showAlertDelay);
            showNearbyRidersAlert(context);
          }
        } else {
          // if less than 3 markers are nearby
          scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                'Waiting for ${3 - currentMarkersWithinRadius} more Riders',
                style: isThemeCurrentlyDark(context)
                    ? BodyStyles.primary
                    : BodyStyles.white,
              ),
              backgroundColor: MyColors.black,
            ),
          );
          if (!isTipShown1 && !isMoving) {
            // display a tip only once
            widget.helper.setBool('isTipShown1', true);
            await Future.delayed(showAlertDelay);
            showNotEnoughRidersAlert(context, currentMarkersWithinRadius);
          }
        }
      }
    }

    if (currentMarkersWithinRadius >= 3 && isButtonSwiped) {
      _generateHotspot();
    }
    print('Previous markers: $previousMarkersWithinRadius');
    print('Cycle complete');
    previousMarkersWithinRadius = currentMarkersWithinRadius;
  } // populates & manages markers within 5km

  void _generateHotspot() {
    print('Generating hotspot...');
    setState(() {
      hotspots.add(Circle(
        circleId: CircleId(widget.identity),
        center: LatLng(myMarkerLocation.latitude, myMarkerLocation.longitude),
        radius: hotspotRadius,
        fillColor: MyColors.translucent,
        strokeColor: MyColors.primary,
        strokeWidth: isIOS(context) ? 8 : 20,
      ));
    });
  } // creates and displays a hotspot

  void _deleteMarker(documentId) {
    print('_deleteMarker() called');
    print('Deleting marker $documentId...');
    isMyMarkerFetched = false;
    Firestore.instance.collection('markers').document(documentId).delete();
    setState(() {
      markers.remove(MarkerId(documentId));
    });
  } // deletes markers from firestore

  void _animateToLocation(location, animation) {
    print('_animateToLocation called');
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: zoom[animation],
          bearing: bearing[animation],
          tilt: tilt[animation],
        ),
      ),
    );
  } // dat cool animation tho

  @override
  Widget build(BuildContext context) {
    print('Widget build() called');
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
      return FutureBuilder(
          future: position,
          builder: (context, data) {
            if (!data.hasData) {
              return FetchingLocation();
            } else {
              // when current location is obtained
              return Scaffold(
                key: scaffoldKey,
                body: Container(
                  child: Stack(
                    children: <Widget>[
                      GoogleMap(
                        onMapCreated: _onMapCreated,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        compassEnabled: false,
                        mapToolbarEnabled: false,
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
                        top: 45.0,
                        left: 20.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 95.0,
                              height: 30.0,
                              child: isThemeCurrentlyDark(context)
                                  ? Image.asset(
                                      'assets/logo/text-green.png',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/logo/text-black.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !isFirstCycle &&
                            !isButtonSwiped &&
                            !isMyMarkerPlotted,
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
                            foregroundColor: MyColors.primary,
                            backgroundColor: MyColors.accent,
                            elevation: 5.0,
                            onPressed: () {
                              showEmergencyPopup(context);
                            },
                          ),
                        ),
                      ), // displays emergency button before swipe
                      Visibility(
                        visible: !isFirstCycle &&
                            !isButtonSwiped &&
                            !isMyMarkerPlotted,
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
                                style: BodyStyles.white,
                              ),
                            ),
                            onChanged: (result) {
                              if (result == SwipePosition.SwipeRight) {
                                setState(() {
                                  isButtonSwiped = true;
                                });
                                locationAnimation = 1;
                                _writeToDb();
                                logAnalyticsEvent('location_marked');
                                _fetchMarkersFromDb();
                                _animateToLocation(
                                    currentLocation, locationAnimation);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: Visibility(
                  visible: isButtonSwiped || isMyMarkerPlotted,
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
                        labelStyle: LabelStyles.black,
                        onTap: () async {
                          locationAnimation == 0
                              ? locationAnimation = 1
                              : locationAnimation = 0;
                          _animateToLocation(
                              currentLocation, locationAnimation);
                        },
                      ),
                      SpeedDialChild(
                        child: toggleLightsIcon,
                        foregroundColor: invertColorsTheme(context),
                        backgroundColor: invertInvertColorsTheme(context),
                        label: toggleLightsText,
                        labelStyle: LabelStyles.black,
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
                        label: 'About',
                        labelStyle: LabelStyles.black,
                        onTap: () async {
                          bool isTipShown3 =
                              widget.helper.getBool('isTipShown3') ?? false;
                          logAnalyticsEvent('about_click');

                          if (isTipShown3) {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) {
                              return MyAboutPage();
                            }));
                          } else {
                            // display a tip only once
                            widget.helper.setBool('isTipShown3', true);
                            showDialog(
                              context: context,
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                title: Text(
                                  'About',
                                  style: isThemeCurrentlyDark(context)
                                      ? TitleStyles.white
                                      : TitleStyles.black,
                                ),
                                content: Text(
                                  'Fliver was developed by three Computer Engineering students from MPSTME, NMIMS.'
                                  '\n\nTap anyone\'s name to open up their profile!',
                                  style: isThemeCurrentlyDark(context)
                                      ? BodyStyles.white
                                      : BodyStyles.black,
                                ),
                                actions: <Widget>[
                                  RaisedButton(
                                    child: Text('Okay'),
                                    color: invertColorsTheme(context),
                                    textColor:
                                        invertInvertColorsStrong(context),
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(context,
                                          CupertinoPageRoute(
                                              builder: (context) {
                                        return MyAboutPage();
                                      }));
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.warning),
                        foregroundColor: MyColors.white,
                        backgroundColor: MaterialColors.red,
                        label: 'Emergency',
                        labelStyle: LabelStyles.black,
                        onTap: () {
                          showEmergencyPopup(context);
                        },
                      ),
                    ],
                  ),
                ), // shows fab only after swipe
              );
            }
          });
    });
  }
}
