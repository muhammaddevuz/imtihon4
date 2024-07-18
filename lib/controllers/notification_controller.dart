import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imtihon4/services/notification_service.dart';

class NotificationController extends ChangeNotifier {
  NotificationService notificationService = NotificationService();

  Stream<DocumentSnapshot> getCurrentNotification() {
    return notificationService.getCurrentNotification();
  }

  Future<DocumentSnapshot> getCurrentNotificationFuture(String id) {
    return notificationService.getCurrentNotificationFuture(id);
  }

  Future<void> addNotification(String id, List notification) async {
    await notificationService.addNotification(id, notification);
  }

  Future<void> editNotification(String id, List notification,bool? isread) async {
    await notificationService.editNotification(id, notification,isread);
  }
}
