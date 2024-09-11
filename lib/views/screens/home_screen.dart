

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imtihon4/controllers/event_controller.dart';
import 'package:imtihon4/controllers/notification_controller.dart';
import 'package:imtihon4/controllers/user_controller.dart';
import 'package:imtihon4/models/event.dart';
import 'package:imtihon4/models/notification.dart';
import 'package:imtihon4/models/user.dart';
import 'package:imtihon4/views/screens/event_detailes.dart';
import 'package:imtihon4/views/screens/login_screen.dart';
import 'package:imtihon4/views/screens/notification_screen.dart';
import 'package:imtihon4/views/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> caruselBox = [];
  Timer? debounce;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  void onSearchChanged(String query) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkTokenValidity();
  }

  void checkTokenValidity() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final idTokenResult = await user.getIdTokenResult();
        final now = DateTime.now().millisecondsSinceEpoch;
        if (idTokenResult.expirationTime!.millisecondsSinceEpoch < now) {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } catch (e) {
        // ignore: avoid_print
        print('Error checking token validity: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsController = Provider.of<EventController>(context);
    final userController = Provider.of<UserController>(context);
    final notificationController = Provider.of<NotificationController>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Text(
          "Bosh Sahifa",
          style: TextStyle(fontSize: 23.h, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          StreamBuilder(
            stream: notificationController.getCurrentNotification(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data!.data() == null) {
                return Icon(
                  Icons.notifications,
                  size: 23.h,
                );
              }
              Notifications notifications =
                  Notifications.fromJsons(snapshot.data!);
              return IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ));
                  },
                  icon: notifications.isRead
                      ? Icon(
                          Icons.notifications,
                          size: 23.h,
                        )
                      : Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.red,
                          size: 23.h,
                        ));
            },
          ),
          SizedBox(width: 10.h),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                border: const OutlineInputBorder(),
                hintText: "Tadbirlarni izlash...",
                hintStyle:
                    TextStyle(fontWeight: FontWeight.w400, fontSize: 16.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12.5)),
                  borderSide: BorderSide(
                    width: 3.w,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12.5)),
                  borderSide: BorderSide(
                    width: 3.w,
                  ),
                ),
                suffixIcon: PopupMenuButton(
                  // onSelected: (value) {
                  //   print(value);
                  //   print("-----------------------------");
                  // },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(child: Text("Tadbir nomi bo'yicha")),
                      const PopupMenuItem(child: Text("Manzil bo'yicha")),
                    ];
                  },
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "All Events",
              style: TextStyle(fontSize: 18.h, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: StreamBuilder(
                  stream: userController.getCurrentUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Xatolik bor'),
                      );
                    }

                    Users user = Users.fromJsons(snapshot.data!);
                    return StreamBuilder(
                      stream: eventsController.getEvents(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Xatolik bor'),
                          );
                        }
                        final events = snapshot.data?.docs ?? [];
                        final filteredEvents = events
                            .map((doc) => Event.fromJson(doc))
                            .where((event) {
                          return event.title
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()) ||
                              event.locationName
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase());
                        }).toList();
                        return ListView.builder(
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            EventDetailes(event: event)));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                height: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 3),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.network(
                                        event.imageUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  event.title,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  userController.isLiked(
                                                      event.id, user.isLiked);
                                                },
                                                icon: user.isLiked
                                                        .contains(event.id)
                                                    ? Icon(
                                                        CupertinoIcons
                                                            .heart_fill,
                                                        size: 28.h,
                                                        color: Colors.red,
                                                      )
                                                    : Icon(
                                                        CupertinoIcons.heart,
                                                        size: 28.h,
                                                      ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            "${event.time}  ${event.date.toString().split(" ")[0]}",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              event.locationName,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
