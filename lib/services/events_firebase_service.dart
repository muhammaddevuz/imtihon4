import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:imtihon4/controllers/user_controller.dart';

class EventsFirebaseService {
  UserController userController = UserController();
  final _eventsCollection = FirebaseFirestore.instance.collection("events");
  final _eventsImageStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getEvents() async* {
    yield* _eventsCollection.snapshots();
  }

  Future<void> addEvent(
    String title,
    String locationName,
    String date,
    String time,
    String description,
    File? imageFile,
    double? lat,
    double? lng,
  ) async {
    if (imageFile != null) {
      final imageReference = _eventsImageStorage
          .ref()
          .child("users")
          .child("images")
          .child("$title.jpg");

      final uploadTask = imageReference.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        final imageUrl = await imageReference.getDownloadURL();
        await _eventsCollection.add({
          "creatorId": FirebaseAuth.instance.currentUser!.uid,
          "title": title,
          "locationName": locationName,
          "date": date,
          "time": time,
          "description": description,
          "imageUrl": imageUrl,
          "lat": lat,
          "lng": lng,
          'participant': 0
        });
      });
    } else {
      await _eventsCollection.add({
        "creatorId": FirebaseAuth.instance.currentUser!.uid,
        "title": title,
        "locationName": locationName,
        "date": date,
        "time": time,
        "description": description,
        "lat": lat,
        "lng": lng,
        'participant': 0
      });
    }
  }

  Future<void> editEvent(
    String id,
    String title,
    String description,
    File? imageFile,
    double? lat,
    double? lng,
  ) async {
    if (imageFile != null) {
      final imageReference = _eventsImageStorage
          .ref()
          .child("users")
          .child("images")
          .child("$title.jpg");

      final uploadTask = imageReference.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        final imageUrl = await imageReference.getDownloadURL();
        await _eventsCollection.doc(id).update({
          "title": title,
          "description": description,
          "imageUrl": imageUrl,
          "lat": lat,
          "lng": lng,
        });
      });
    } else {
      await _eventsCollection.doc(id).update({
        "title": title,
        "description": description,
        "lat": lat,
        "lng": lng,
      });
    }
  }

  Future<void> deleteEvent(String id) async {
    _eventsCollection.doc(id).delete();
  }
  Future<void> addPerson(String id,int personCount) async {
    _eventsCollection.doc(id).update({
      "participant":personCount
    });
  }
}
