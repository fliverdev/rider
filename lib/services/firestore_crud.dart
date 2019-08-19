import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCrud {
  Future<void> addData(data) async {
    Firestore.instance.collection('markers').add(data).catchError((error) {
      print(error);
    });
  } //writes data to firestore

  getData() async {
    return await Firestore.instance.collection('markers').getDocuments();
  } //reads data from firestore
}
