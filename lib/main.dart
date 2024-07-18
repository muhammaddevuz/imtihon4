import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imtihon4/controllers/event_controller.dart';
import 'package:imtihon4/controllers/notification_controller.dart';
import 'package:imtihon4/controllers/theme_mode_controller.dart';
import 'package:imtihon4/controllers/user_controller.dart';
import 'package:imtihon4/firebase_options.dart';
import 'package:imtihon4/services/location_services.dart';
import 'package:imtihon4/views/screens/main_splash.dart';
import 'package:imtihon4/views/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await LocationServices.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return ThemeModeController();
          }),
          ChangeNotifierProvider(create: (context) {
            return UserController();
          }),
          ChangeNotifierProvider(create: (context) {
            return EventController();
          }),
          ChangeNotifierProvider(create: (context) {
            return NotificationController();
          })
        ],
        builder: (context, child) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
              theme: Provider.of<ThemeModeController>(context).nightMode
                  ? ThemeData.dark()
                  : ThemeData.light(),
              debugShowCheckedModeBanner: false,
              home: StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SplashScreen();
                    }
                    return const MainSplashScreen();
                  }),
            ),
          );
        });
  }
}
