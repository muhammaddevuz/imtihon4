import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imtihon4/services/firebase_auth_services.dart';
import 'package:imtihon4/views/screens/home_screen.dart';
import 'package:imtihon4/views/screens/register_screen.dart';
import 'package:imtihon4/views/screens/reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  bool isLoading = false;

  String? email;
  String? password;

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      try {
        await firebaseAuthServices.signIn(email!, password!);

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return const HomeScreen();
            },
          ),
        );
      } on Exception catch (e) {
        String message = e.toString();
        if (e.toString().contains("EMAIL_EXISTS")) {
          message = "Email mavjud";
        }
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(message),
            );
          },
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff101011),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Login",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200.h,
                width: 200.h,
                decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage("assets/logo.png"))),
              ),
              SizedBox(height: 40.h),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "email",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please input email";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  //? save email
                  email = newValue;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please input password";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  //? save password
                  password = newValue;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPasswordScreen(),
                          ));
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : FilledButton(
                      onPressed: submit,
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                      child: Text(
                        "Log in",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.h,
                            color: Colors.white),
                      ),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return const RegisterScreen();
                      },
                    ),
                  );
                },
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
