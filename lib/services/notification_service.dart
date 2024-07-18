import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final notificationCollection = FirebaseFirestore.instance.collection('notification');


  Stream<DocumentSnapshot> getCurrentNotification() {
    return notificationCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  Future<DocumentSnapshot> getCurrentNotificationFuture(String id) {
    return notificationCollection.doc(id).get();
  }

  Future<void> addNotification(String id,List notification) async {
    
      await notificationCollection.doc(id).set({
        "isRead":false,
        "notification":notification
      });
    
  }
  Future<void> editNotification(String id, List notification,bool? readCheck) async {
    if (readCheck==null) {
      await notificationCollection.doc(id).update({
        "isRead":false,
        "notification":notification
      });
    }else{
      await notificationCollection.doc(id).update({
        "isRead":true,
        "notification":notification
      });
    }
      
    
  }
}

