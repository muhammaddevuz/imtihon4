import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imtihon4/services/users_firibase_services.dart';

class UserController extends ChangeNotifier {
  final UsersFiribaseServices userFirebaseServices = UsersFiribaseServices();

  Stream<QuerySnapshot> getUsers() {
    return userFirebaseServices.getUsers();
  }

  void addUser(String id, String name, String email, String? curLocateName,
      double? lat, double? lng, File? imageUrl) {
    userFirebaseServices.addUser(
        id, name, email, curLocateName, lat, lng, imageUrl);
  }

  void editUser(String id, String name, String? imageUrl, File? imageFile) {
    userFirebaseServices.editUser(id, name, imageUrl, imageFile);
  }

  Stream<DocumentSnapshot> getCurrentUsers() {
    return userFirebaseServices.getCurrentUsers();
  }

  Future<DocumentSnapshot> getCurrentUsersFuture(String id) {
    return userFirebaseServices.getCurrentUsersFuture(id);
  }

  Stream<DocumentSnapshot> getUserById(String id) {
    return userFirebaseServices.getUsersById(id);
  }

  Future<void> isLiked(String id, List isLiked) async {
    userFirebaseServices.isLiked(id, isLiked);
    // notifyListeners();
  }

  Future<void> addBookingEvent(List events, List canceEvents) async {
    await userFirebaseServices.addBookingEvent(events, canceEvents);
  }

  Future<void> cancelEvent(List events, List cancelEvents) async {
    await userFirebaseServices.cancelBookingEvent(events, cancelEvents);
  }

  Future<void> editLocation(
      String curLocateName, double? lat, double? lng) async {
    await userFirebaseServices.editLocation(curLocateName, lat, lng);
  }
}
