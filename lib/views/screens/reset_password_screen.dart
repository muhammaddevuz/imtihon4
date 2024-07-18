import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imtihon4/services/firebase_auth_services.dart';
import 'package:imtihon4/views/screens/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final firebaseAuthServices = FirebaseAuthServices();
  String? emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff101011),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25.h,
            )),
        title: Text(
          "Reset Password",
          style: TextStyle(
              color: Colors.white, fontSize: 22.h, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h),
                Container(
                  height: 200.h,
                  width: 200.h,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/logo.png"))),
                ),
                SizedBox(height: 50.h),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: emailController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Email",
                      errorText: emailError),
                ),
                SizedBox(height: 30.h),
                FilledButton(
                  onPressed: () {
                    if (emailController.text.isEmpty) {
                      emailError = "Input Email";
                      setState(() {});
                    } else {
                      firebaseAuthServices.resetPasword(emailController.text);
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text(
                                "We have sent a link to reset your password to your email"),
                            content: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ));
                                },
                                child: const Text("Back")),
                          );
                        },
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.h,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
