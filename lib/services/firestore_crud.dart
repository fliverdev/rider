import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCrud {
  Future<void> addDataVideo(data) async {
    Firestore.instance.collection('markers2').add(data).catchError((error) {
      print(error);
    });
  } //writes data to firestore

  addData(data) {
    try {
      Firestore.instance.runTransaction(
        (Transaction transaction) async {
          await Firestore.instance
              .collection('markers2')
              .document()
              .setData(data.toJson());
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  getData() async {
    return await Firestore.instance.collection('markers2').getDocuments();
  } //reads data from firestore
}
