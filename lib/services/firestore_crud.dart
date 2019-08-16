import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider/utils/functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FirestoreCrud {
  Future<void> addData(data) async {
    Firestore.instance.collection('markers').add(data).catchError((error) {
      print(error);
    });
  }

  getData() async {
    return await Firestore.instance.collection('markers').getDocuments();
  }
}
