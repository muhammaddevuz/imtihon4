import 'package:flutter/material.dart';
import 'package:imtihon4/controllers/event_controller.dart';
import 'package:imtihon4/controllers/notification_controller.dart';
import 'package:imtihon4/controllers/user_controller.dart';
import 'package:imtihon4/models/event.dart';
import 'package:imtihon4/models/notification.dart';
import 'package:imtihon4/models/user.dart';
import 'package:imtihon4/views/screens/home_screen.dart';
import 'package:provider/provider.dart';

class ModalBottomSheet extends StatefulWidget {
  final Event event;
  const ModalBottomSheet({super.key, required this.event});
  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  int visitorCount = 1;

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final eventController = Provider.of<EventController>(context);
    final notificationController = Provider.of<NotificationController>(context);
    return Material(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade400,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.clear,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Select Number of Seats",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: IconButton(
                      onPressed: () {
                        if (visitorCount > 1) {
                          setState(() {
                            visitorCount -= 1;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.remove,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "$visitorCount",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          visitorCount += 1;
                        });
                      },
                      icon: const Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Select Payment Type",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Material(
                child: ListTile(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  tileColor: Colors.white,
                  minVerticalPadding: 10,
                  title: const Text(
                    "Click",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: selectedIndex == 0
                      ? const Icon(
                          Icons.check_circle_outline,
                          color: Colors.blue,
                        )
                      : const Icon(
                          Icons.circle_outlined,
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                tileColor: Colors.white,
                minVerticalPadding: 10,
                title: const Text(
                  "Payme",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                trailing: selectedIndex == 1
                    ? const Icon(
                        Icons.check_circle_outline,
                        color: Colors.blue,
                      )
                    : const Icon(
                        Icons.circle_outlined,
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                },
                tileColor: Colors.white,
                minVerticalPadding: 10,
                title: const Text(
                  "Naqd",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                trailing: selectedIndex == 2
                    ? const Icon(
                        Icons.check_circle_outline,
                        color: Colors.blue,
                      )
                    : const Icon(
                        Icons.circle_outlined,
                      ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final notificationBox = await notificationController
                          .getCurrentNotificationFuture(widget.event.id);
                      final userbox = await userController
                          .getCurrentUsersFuture(widget.event.creatorId);

                      Users user = Users.fromJsons(userbox);

                      DateTime dateTime = DateTime.now();
                      if (notificationBox.data() == null) {
                        notificationController
                            .addNotification(widget.event.creatorId, [
                          {
                            "name": user.name,
                            "imageUrl": user.imageUrl,
                            "eventTitle": widget.event.title,
                            "date":
                                "${dateTime.hour}:${dateTime.minute} ${dateTime.toString().split(" ")[0]}",
                            "isRead": false,
                          }
                        ]);
                      } else {
                        Notifications notifications =
                            Notifications.fromJsons(notificationBox);

                        List notificationsList = notifications.notifications;
                        notificationsList.add({
                          "name": user.name,
                          "imageUrl": user.imageUrl,
                          "eventTitle": widget.event.title,
                          "date":
                              "${dateTime.hour}:${dateTime.minute} ${dateTime.toString().split(" ")[0]}",
                          "isRead": false,
                        });
                        notificationController.editNotification(
                            widget.event.creatorId, notificationsList, null);
                      }

                      List eventBox = user.bookingEvent;
                      eventBox.add(widget.event.id);

                      List cancelEvents = user.cancelingEvent;
                      cancelEvents.removeWhere(
                        (element) => element == widget.event.id,
                      );
                      await userController.addBookingEvent(
                          eventBox, cancelEvents);
                      await eventController.addPerson(widget.event.id,
                          widget.event.participant + visitorCount);
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const HomeScreen();
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.orange.shade100,
                    ),
                    child: const Text(
                      "Keyingi",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
