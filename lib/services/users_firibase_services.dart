import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UsersFiribaseServices {
  final userCollection = FirebaseFirestore.instance.collection('users');
  final _userImageStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getUsers() async* {
    yield* userCollection.snapshots();
  }

  Stream<DocumentSnapshot> getCurrentUsers() {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  Future<DocumentSnapshot> getCurrentUsersFuture(String id) {
    return userCollection.doc(id).get();
  }

  Stream<DocumentSnapshot> getUsersById(String id) {
    return userCollection.doc(id).snapshots();
  }

  Future<void> addUser(String id, String name, String email,
      String? curLocateName, double? lat, double? lng, File? imageUrl) async {
    if (imageUrl != null) {
      final imageReference = _userImageStorage
          .ref()
          .child("users")
          .child("images")
          .child("$name.jpg");

      final uploadTask = imageReference.putFile(imageUrl);

      await uploadTask.whenComplete(() async {
        final imageUrl = await imageReference.getDownloadURL();
        await userCollection.doc(id).set({
          "name": name,
          "email": email,
          "curLocateName": curLocateName,
          "lat": lat,
          "lng": lng,
          "imageUrl": imageUrl,
        });
      });
    } else {
      await userCollection.doc(id).set({
        "name": name,
        "email": email,
        "curLocateName": curLocateName,
        "lat": lat,
        "lng": lng,
      });
    }
  }

  Future<void> editUser(
      String id, String name, String? imageUrl, File? imageFile) async {
    if (imageFile != null) {
      final imageReference = _userImageStorage
          .ref()
          .child("users")
          .child("images")
          .child("${UniqueKey()}.jpg");

      final uploadTask = imageReference.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        final imageUrl2 = await imageReference.getDownloadURL();
        await userCollection.doc(id).update({
          "name": name,
          "imageUrl": imageUrl2,
        });
      });
    } else if (imageUrl != null) {
      await userCollection.doc(id).update({
        "name": name,
        "imageUrl": imageUrl,
      });
    } else {
      await userCollection.doc(id).update({
        "name": name,
      });
    }
  }

  Future<void> isLiked(String id, List isLiked) async {
    if (isLiked.contains(id)) {
      isLiked.removeWhere(
        (element) => element == id,
      );
    } else {
      isLiked.add(id);
    }
    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"isLiked": isLiked});
  }

  Future<void> addBookingEvent(List events, List canceEvents) async {
    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"bookingEvent": events});
    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"cancelingEvent": canceEvents});
  }

  Future<void> cancelBookingEvent(List events, List canceEvents) async {
    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"bookingEvent": events});
    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"cancelingEvent": canceEvents});
  }

  Future<void> editLocation(
      String curLocateName, double? lat, double? lng) async {
    await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
      "curLocateName": curLocateName,
      "lat": lat,
      "lng": lng,
    });
  }
}
