import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imtihon4/views/screens/tapbar/canceled.dart';
import 'package:imtihon4/views/screens/tapbar/my_organized.dart';
import 'package:imtihon4/views/screens/tapbar/near_event.dart';
import 'package:imtihon4/views/screens/tapbar/participated.dart';
import 'package:imtihon4/views/widgets/custom_drawer.dart';

class MyEvent extends StatefulWidget {
  const MyEvent({super.key});

  @override
  State<MyEvent> createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Mening tadbirlarim',
            style: TextStyle(fontSize: 20.h),
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Tashkil qilinganlar'),
              Tab(text: 'Yaqinda'),
              Tab(text: 'Ishtirok etganlarim'),
              Tab(text: 'Bekor qilinganlar'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyOrganized(),
            NearEvent(),
            Participated(),
            Canceled(),
          ],
        ),
      ),
    );
  }
}
