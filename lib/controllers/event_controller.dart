import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:imtihon4/services/events_firebase_service.dart';

class EventController extends ChangeNotifier {
  EventsFirebaseService eventsFirebaseService = EventsFirebaseService();

  Stream<QuerySnapshot> getEvents() {
    return eventsFirebaseService.getEvents();
  }

  void addEvent(
    String title,
    String locationName,
    String date,
    String time,
    String description,
    File? imageFile,
    double? lat,
    double? lng,
  ) async {
    eventsFirebaseService.addEvent(
        title, locationName, date, time, description, imageFile, lat, lng);
  }

  void editEvent(
    String id,
    String title,
    String description,
    File? imageFile,
    double? lat,
    double? lng,
  ) {
    eventsFirebaseService.editEvent(
        id, title, description, imageFile, lat, lng);
  }

  Future<void> deleteEvent(String id) async {
    eventsFirebaseService.deleteEvent(id);
  }

  Future<void> addPerson(String id, int personCount) async {
    eventsFirebaseService.addPerson(id, personCount);
  }
}
