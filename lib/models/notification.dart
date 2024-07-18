import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  String id;
  bool isRead;
  List notifications;

  Notifications({
    required this.id,
    required this.isRead,
    required this.notifications,
  });

  factory Notifications.fromJson(QueryDocumentSnapshot query) {
    final data = query.data() as Map<String, dynamic>;
    return Notifications(
      id: query.id,
      isRead: data.containsKey('isRead') ? data['isRead'] : true,
      notifications:
          data.containsKey('notification') ? data['notification'] : [],
    );
  }

  factory Notifications.fromJsons(DocumentSnapshot query) {
    final data = query.data() as Map<String, dynamic>;
    return Notifications(
      id: query.id,
      isRead: data.containsKey('isRead') ? data['isRead'] : true,
      notifications:
          data.containsKey('notification') ? data['notification'] : [],
    );
  }
}
