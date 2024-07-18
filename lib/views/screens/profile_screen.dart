import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imtihon4/controllers/user_controller.dart';
import 'package:imtihon4/models/user.dart';
import 'package:imtihon4/services/google_search_service.dart';
import 'package:imtihon4/services/location_services.dart';
import 'package:imtihon4/views/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();

  String? name;
  bool isLoading = false;
  File? imageFile;
  LatLng? currentLatLng;
  String? currentLocationName;

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
      setState(() {});
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
    final userController = Provider.of<UserController>(context);
    return Scaffold(
      drawer: const CustomDrawer(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Profile Screen"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: userController.getCurrentUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            Users user = Users.fromJsons(snapshot.data!);
            return Form(
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
                            child: user.imageUrl == null
                                ? imageFile == null
                                    ? Image.asset("assets/profile_logo.png",
                                        fit: BoxFit.cover)
                                    : Image.file(
                                        imageFile!,
                                        fit: BoxFit.cover,
                                      )
                                : imageFile != null
                                    ? Image.file(
                                        imageFile!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        user.imageUrl!,
                                        fit: BoxFit.cover,
                                      )),
                        Positioned(
                          right: 0,
                          bottom: 5,
                          child: IconButton(
                              onPressed: openGallery,
                              icon: Icon(
                                Icons.edit_square,
                                color: Colors.black,
                                size: 30.h,
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: 50.h),
                    TextFormField(
                      initialValue: user.name,
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
                    SizedBox(height: 10.h),
                    ListTile(
                      title: Text(
                        user.curLocateName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            userController.editLocation(
                                currentLocationName!,
                                currentLatLng?.latitude,
                                currentLatLng?.longitude);
                          },
                          icon: Icon(
                            Icons.replay_outlined,
                            size: 25.h,
                          )),
                    ),
                    SizedBox(height: 20.h),
                    FilledButton(
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          userController.editUser(
                              user.id, name!, user.imageUrl, imageFile);
                        }
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text("Data saved successfully"),
                            );
                          },
                        );
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.h,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
