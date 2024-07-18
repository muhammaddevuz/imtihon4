import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imtihon4/controllers/event_controller.dart';
import 'package:imtihon4/controllers/user_controller.dart';
import 'package:imtihon4/models/event.dart';
import 'package:imtihon4/models/user.dart';
import 'package:imtihon4/views/screens/event_detailes.dart';
import 'package:provider/provider.dart';

class NearEvent extends StatefulWidget {
  const NearEvent({super.key});

  @override
  State<NearEvent> createState() => _NearEventState();
}

class _NearEventState extends State<NearEvent> {
  @override
  Widget build(BuildContext context) {
    final eventsController = Provider.of<EventController>(context);
    final userController = Provider.of<UserController>(context);
    return StreamBuilder(
        stream: userController.getCurrentUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          Users user = Users.fromJsons(snapshot.data!);
          return StreamBuilder(
            stream: eventsController.getEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final events = snapshot.data!.docs;
              if (events.isEmpty) {
                return const Center(child: Text("No Near Event"));
              }
              return ListView.builder(
                padding: EdgeInsets.all(15.h),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  Event event = Event.fromJson(events[index]);
                  DateTime eventDate = event.date;
                  eventDate = DateTime(
                      eventDate.year,
                      eventDate.month,
                      eventDate.day,
                      int.parse(event.time.split(":")[0]),
                      int.parse(event.time.split(":")[1]));
                  return user.bookingEvent.contains(event.id) &&
                          eventDate.isAfter(DateTime.now())
                      ? Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EventDetailes(event: event),
                                    ));
                              },
                              child: Container(
                                height: 150.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.grey, width: 3)),
                                padding: EdgeInsets.all(10.h),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: Image.network(
                                        event.imageUrl ??
                                            "https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=612x612&w=0&k=20&c=_zOuJu755g2eEUioiOUdz_mHKJQJn-tDgIAhQzyeKUQ=",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10.h),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "${event.time}, ${event.date.toString().split(" ")[0]}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 16.h,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            event.locationName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h)
                          ],
                        )
                      : const SizedBox();
                },
              );
            },
          );
        });
  }
}
