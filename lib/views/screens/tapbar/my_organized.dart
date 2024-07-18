import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imtihon4/controllers/event_controller.dart';
import 'package:imtihon4/models/event.dart';
import 'package:imtihon4/views/widgets/add_event.dart';
import 'package:imtihon4/views/widgets/edit_event.dart';
import 'package:provider/provider.dart';

class MyOrganized extends StatefulWidget {
  const MyOrganized({super.key});

  @override
  State<MyOrganized> createState() => _MyOrganizedState();
}

class _MyOrganizedState extends State<MyOrganized> {
  @override
  Widget build(BuildContext context) {
    final eventsController = Provider.of<EventController>(context);
    return Scaffold(
      body: StreamBuilder(
        stream: eventsController.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final events = snapshot.data!.docs;
          if (events.isEmpty) {
            return const Center(child: Text("No Event"));
          }
          return ListView.builder(
            padding: EdgeInsets.all(15.h),
            itemCount: events.length,
            itemBuilder: (context, index) {
              Event event = Event.fromJson(events[index]);
              return event.creatorId == FirebaseAuth.instance.currentUser!.uid
                  ? Column(
                      children: [
                        Container(
                          height: 150.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey, width: 3)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          event.title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        PopupMenuButton<String>(
                                          onSelected: (String value) {
                                            if (value == 'delete') {
                                              eventsController
                                                  .deleteEvent(event.id);
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditEvent(event: event),
                                                  ));
                                            }
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return {'edit', 'delete'}
                                                .map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(choice),
                                              );
                                            }).toList();
                                          },
                                        )
                                      ],
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
                        SizedBox(height: 10.h)
                      ],
                    )
                  : const SizedBox();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.amber.shade200,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEvent(),
              ));
        },
        child: Icon(
          Icons.add,
          color: Colors.amber.shade900,
          size: 35,
        ),
      ),
    );
  }
}
