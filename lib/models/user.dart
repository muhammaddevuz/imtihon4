import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String id;
  String name;
  String email;
  String? imageUrl;
  List isLiked;
  List bookingEvent;
  List cancelingEvent;
  String curLocateName;
  double lat;
  double lng;

  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.isLiked,
    required this.bookingEvent,
    required this.cancelingEvent,
    required this.curLocateName,
    required this.lat,
    required this.lng,
  });

  factory Users.fromJson(QueryDocumentSnapshot query) {
    final data = query.data() as Map<String, dynamic>;
    return Users(
      id: query.id,
      name: data['name'],
      email: data['email'],
      curLocateName: data['curLocateName'],
      lat: data['lat'].toDouble(),
      lng: data['lng'].toDouble(),
      imageUrl: data.containsKey('imageUrl') ? data['imageUrl'] : null,
      isLiked: data.containsKey('isLiked') ? data['isLiked'] : [],
      bookingEvent:
          data.containsKey('bookingEvent') ? data['bookingEvent'] : [],
      cancelingEvent:
          data.containsKey('cancelingEvent') ? data['cancelingEvent'] : [],
    );
  }

  factory Users.fromJsons(DocumentSnapshot query) {
    final data = query.data() as Map<String, dynamic>;
    return Users(
      id: query.id,
      name: data['name'],
      email: data['email'],
      curLocateName: data['curLocateName'],
      lat: data['lat'].toDouble(),
      lng: data['lng'].toDouble(),
      imageUrl: data.containsKey('imageUrl') ? data['imageUrl'] : null,
      isLiked: data.containsKey('isLiked') ? data['isLiked'] : [],
      bookingEvent:
          data.containsKey('bookingEvent') ? data['bookingEvent'] : [],
      cancelingEvent:
          data.containsKey('cancelingEvent') ? data['cancelingEvent'] : [],
    );
  }
}
