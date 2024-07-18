import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imtihon4/services/firebase_auth_services.dart';
import 'package:imtihon4/services/google_search_service.dart';
import 'package:imtihon4/services/location_services.dart';
import 'package:imtihon4/views/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  final _passwordConfirmController = TextEditingController();

  String? email, password, passwordConfirm, name;
  bool isLoading = false;
  File? imageFile;
  LatLng? currentLatLng;
  String? currentLocationName;

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      //? Register
      setState(() {
        isLoading = true;
      });
      try {
        await firebaseAuthServices.signUp(
            email!,
            password!,
            name!,
            currentLocationName,
            currentLatLng?.latitude,
            currentLatLng?.longitude,
            imageFile);

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return const LoginScreen();
            },
          ),
        );
      } catch (e) {
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

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    currentLatLng = await LocationServices.getCurrentLocation();
    currentLocationName = await GeocodingService.getAddressFromCoordinates(
        currentLatLng!.latitude, currentLatLng!.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff101011),
      resizeToAvoidBottomInset: false,
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
              size: 27.h,
            )),
        title: Text(
          "Register",
          style: TextStyle(
              color: Colors.white, fontSize: 25.h, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                Stack(
                  children: [
                    Container(
                      width: 150.w,
                      height: 150.h,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 218, 214, 214)),
                      clipBehavior: Clip.hardEdge,
                      child: imageFile == null
                          ? Image.asset("assets/profile_logo.png")
                          : Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 5,
                      child: IconButton(
                          onPressed: openGallery,
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.white,
                            size: 30.h,
                          )),
                    )
                  ],
                ),
                SizedBox(height: 50.h),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please input Name";
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    //? save email
                    name = newValue;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
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
                  controller: _passwordController,
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
                const SizedBox(height: 10),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _passwordConfirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Reset Password",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please input password";
                    }

                    if (_passwordController.text !=
                        _passwordConfirmController.text) {
                      return "Passwords are not similar";
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    //? save password confirm
                    passwordConfirm = newValue;
                  },
                ),
                SizedBox(height: 25.h),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : FilledButton(
                        style: FilledButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                        onPressed: submit,
                        child: Text(
                          "Register",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.h,
                              color: Colors.white),
                        ),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Log in",
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
      ),
    );
  }

}
