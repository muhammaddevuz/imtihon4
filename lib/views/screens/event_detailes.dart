import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:imtihon4/controllers/user_controller.dart';
import 'package:imtihon4/models/event.dart';
import 'package:imtihon4/models/user.dart';
import 'package:imtihon4/views/widgets/booking_event.dart';
import 'package:provider/provider.dart';

class EventDetailes extends StatefulWidget {
  final Event event;
  const EventDetailes({super.key, required this.event});

  @override
  State<EventDetailes> createState() => _EventDetailesState();
}

class _EventDetailesState extends State<EventDetailes> {
  late GoogleMapController myController;
  MapType mapType = MapType.normal;
  Set<Marker> marker = {};
  LatLng latLng = const LatLng(41, 62);
  void onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      latLng = LatLng(widget.event.lat, widget.event.lng);
      marker.add(
        Marker(
          markerId: const MarkerId("event"),
          position: latLng,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    return Scaffold(
      body: StreamBuilder(
          stream: userController.getCurrentUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            Users user = Users.fromJsons(snapshot.data!);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 240.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.event.imageUrl != null
                          ? NetworkImage(widget.event.imageUrl!)
                          : const AssetImage("assets/notfound.jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                size: 25.h,
                                color: Colors.white,
                              )),
                          IconButton(
                            onPressed: () {
                              userController.isLiked(
                                  widget.event.id, user.isLiked);
                            },
                            icon: user.isLiked.contains(widget.event.id)
                                ? Icon(
                                    CupertinoIcons.heart_fill,
                                    size: 28.h,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    CupertinoIcons.heart,
                                    size: 28.h,
                                    color: Colors.white,
                                  ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.title,
                            style: TextStyle(
                                fontSize: 25.h, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15)),
                                padding: const EdgeInsets.all(15),
                                child: Icon(
                                  Icons.calendar_month,
                                  size: 25.h,
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.event.date.toString().split(" ")[0],
                                    style: TextStyle(
                                        fontSize: 18.h,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.event.time,
                                    style: TextStyle(
                                        fontSize: 18.h,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15)),
                                padding: const EdgeInsets.all(15),
                                child: Icon(
                                  Icons.location_on_sharp,
                                  size: 25.h,
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.event.locationName,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 18.h,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Lat: ${widget.event.lat}",
                                      style: TextStyle(
                                          fontSize: 15.h,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Lan: ${widget.event.lat}",
                                      style: TextStyle(
                                          fontSize: 15.h,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15)),
                                padding: const EdgeInsets.all(15),
                                child: Icon(
                                  Icons.person,
                                  size: 25.h,
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.event.participant} people are going",
                                    style: TextStyle(
                                        fontSize: 18.h,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Sign up too",
                                    style: TextStyle(
                                        fontSize: 18.h,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 15.h),
                          StreamBuilder(
                            stream: userController
                                .getUserById(widget.event.creatorId),
                            builder: (context, snapshott) {
                              if (snapshott.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              Users user = Users.fromJsons(snapshott.data!);
                              return ListTile(
                                leading: Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.yellow),
                                  clipBehavior: Clip.hardEdge,
                                  child: user.imageUrl != null
                                      ? Image.network(user.imageUrl!)
                                      : Image.asset("assets/profile_logo.png"),
                                ),
                                title: Text(
                                  user.name,
                                  style: TextStyle(
                                      fontSize: 18.h,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  "Event Creator",
                                  style: TextStyle(
                                      fontSize: 13.h,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Event Description",
                            style: TextStyle(
                                fontSize: 20.h, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            widget.event.description,
                            style: TextStyle(
                                fontSize: 15.h, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "Location",
                            style: TextStyle(
                                fontSize: 20.h, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            widget.event.locationName,
                            style: TextStyle(
                                fontSize: 15.h, fontWeight: FontWeight.w500),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            clipBehavior: Clip.hardEdge,
                            width: double.infinity,
                            height: 300.h,
                            child: GoogleMap(
                              markers: marker,
                              mapType: mapType,
                              initialCameraPosition:
                                  CameraPosition(target: latLng, zoom: 10),
                              onMapCreated: onMapCreated,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
      bottomNavigationBar: BottomAppBar(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: DateTime(
                      widget.event.date.year,
                      widget.event.date.month,
                      widget.event.date.day,
                      int.parse(widget.event.time.split(":")[0]),
                      int.parse(widget.event.time.split(":")[1]))
                  .isBefore(DateTime.now())
              ? FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                  onPressed: () {},
                  child: Text(
                    "Event is over",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.h,
                        color: Colors.white),
                  ),
                )
              : StreamBuilder(
                  stream: userController.getCurrentUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    Users user = Users.fromJsons(snapshot.data!);
                    if (user.bookingEvent.contains(widget.event.id)) {
                      return FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                        onPressed: () {
                          List box = user.bookingEvent;
                          box.removeWhere(
                            (element) => element == widget.event.id,
                          );
                          List cancelEventBox = user.cancelingEvent;
                          cancelEventBox.add(widget.event.id);
                          userController.cancelEvent(box, cancelEventBox);
                        },
                        child: Text(
                          "Cancel Event",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.h,
                              color: Colors.white),
                        ),
                      );
                    } else {
                      return FilledButton(
                        style: FilledButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) =>
                                ModalBottomSheet(event: widget.event),
                          );
                        },
                        child: Text(
                          "Sign Up Event",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.h,
                              color: Colors.white),
                        ),
                      );
                    }
                  })),
    );
  }
}
