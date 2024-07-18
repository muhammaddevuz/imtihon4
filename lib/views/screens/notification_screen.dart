import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imtihon4/controllers/notification_controller.dart';
import 'package:imtihon4/models/notification.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool readCheck = false;
  @override
  Widget build(BuildContext context) {
    final notificationController = Provider.of<NotificationController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(fontSize: 23.h, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: notificationController.getCurrentNotification(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          Notifications notifications = Notifications.fromJsons(snapshot.data!);
          return ListView.builder(
            itemCount: notifications.notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                  onTap: () {
                    List box = notifications.notifications;
                    box[index]["isRead"] = true;
                    for (var element in box) {
                      if (element['isRead'] == false) {
                        readCheck = true;
                      }
                    }
                    if (readCheck) {
                      notificationController.editNotification(
                          FirebaseAuth.instance.currentUser!.uid, box, null);
                    } else {
                      notificationController.editNotification(
                          FirebaseAuth.instance.currentUser!.uid, box, true);
                    }
                  },
                  leading: Container(
                    decoration: const BoxDecoration(
                        color: Colors.amber, shape: BoxShape.circle),
                    clipBehavior: Clip.hardEdge,
                    child:
                        notifications.notifications[index]['imageUrl'] == null
                            ? Image.asset("assets/profile_logo.png")
                            : Image.network(
                                notifications.notifications[index]['imageUrl']),
                  ),
                  title: Text(
                      "${notifications.notifications[index]['name']} - ${notifications.notifications[index]['date']}"),
                  subtitle: Text(
                      "${notifications.notifications[index]['name']} ${notifications.notifications[index]['eventTitle']} ga qo'shildi"),
                  trailing:
                      notifications.notifications[index]['isRead'] == false
                          ? const CircleAvatar(
                              radius: 3,
                              backgroundColor: Colors.red,
                            )
                          : null);
            },
          );
        },
      ),
    );
  }
}
