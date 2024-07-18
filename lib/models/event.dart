import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String title;
  String locationName;
  String? imageUrl;
  DateTime date;
  String time;
  String description;
  double lat;
  double lng;
  String creatorId;
  int participant;

  Event({
    required this.id,
    required this.title,
    required this.locationName,
    required this.imageUrl,
    required this.date,
    required this.time,
    required this.description,
    required this.lat,
    required this.lng,
    required this.creatorId,
    required this.participant,
  });

  factory Event.fromJson(QueryDocumentSnapshot query) {
    final data = query.data() as Map<String, dynamic>;
    return Event(
      id: query.id,
      title: data['title'],
      locationName: data['locationName'],
      imageUrl: data.containsKey('imageUrl') ? data['imageUrl'] : null,
      date: DateTime.parse(data['date']),
      time: data['time'],
      description: data['description'],
      lat: data['lat'].toDouble(), 
      lng: data['lng'].toDouble(),
      creatorId: data['creatorId'],
      participant: data['participant'], 
    );
  }
}
