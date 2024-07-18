import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imtihon4/views/screens/home_screen.dart';

class MainSplashScreen extends StatefulWidget {
  const MainSplashScreen({super.key});

  @override
  State<MainSplashScreen> createState() => _MainSplashScreenState();
}

class _MainSplashScreenState extends State<MainSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff101011),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 240.h,
                width: 240.h,
                decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage("assets/logo.png"))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
