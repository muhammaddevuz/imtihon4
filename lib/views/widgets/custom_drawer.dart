import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imtihon4/controllers/theme_mode_controller.dart';
import 'package:imtihon4/controllers/user_controller.dart';
import 'package:imtihon4/models/user.dart';
import 'package:imtihon4/views/screens/home_screen.dart';
import 'package:imtihon4/views/screens/login_screen.dart';
import 'package:imtihon4/views/screens/my_event.dart';
import 'package:imtihon4/views/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeModeController = Provider.of<ThemeModeController>(context);
    final userController = Provider.of<UserController>(context);

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StreamBuilder(
                      stream: userController.getCurrentUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        Users user = Users.fromJsons(snapshot.data!);
                        return ListTile(
                          leading: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.yellow),
                            clipBehavior: Clip.hardEdge,
                            child: user.imageUrl != null
                                ? Image.network(user.imageUrl!)
                                : Image.asset("assets/profile_logo.png"),
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                        );
                      },
                    )
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ));
                },
                leading: const Icon(Icons.home),
                title: const Text(
                  "Bosh sahifa",
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyEvent(),
                      ));
                },
                leading: const Icon(CupertinoIcons.ticket),
                title: const Text(
                  "Mening Tadbirlarim",
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ));
                },
                leading: const Icon(CupertinoIcons.person),
                title: const Text(
                  "Profil Ma'lumotlari",
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                ),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.translate),
                title: const Text(
                  "Tilni O'zgartirish",
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                ),
              ),
              ListTile(
                onTap: () {
                  themeModeController.editMode();
                },
                leading: Icon(themeModeController.nightMode
                    ? Icons.dark_mode
                    : Icons.light_mode),
                title: const Text(
                  "Tunig/Kunduzgi rejim",
                ),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                ),
              ),
            ],
          ),
          ListTile(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
            },
            title: const Text(
              "Chiqish",
            ),
            trailing: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
    );
  }
}
