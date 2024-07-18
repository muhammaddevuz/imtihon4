import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imtihon4/controllers/event_controller.dart';
import 'package:imtihon4/models/event.dart';
import 'package:imtihon4/services/google_search_service.dart';
import 'package:imtihon4/services/location_services.dart';
import 'package:imtihon4/views/screens/my_event.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditEvent extends StatefulWidget {
  Event event;
  EditEvent({super.key, required this.event});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final formKey = GlobalKey<FormState>();

  late GoogleMapController myController;

  String? locationName;
  LatLng curPlace = const LatLng(41.2856806, 69.2034646);
  MapType mapType = MapType.normal;
  Set<Marker> marker = {};
  LatLng? latLng;

  String? description, title;
  bool isLoading = false;
  File? imageFile;
  TimeOfDay time =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  DateTime date = DateTime.now().add(const Duration(days: 1));

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (pickedTime != null && pickedTime != time) {
      setState(() {
        time = pickedTime;
      });
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(
        const Duration(days: 1000),
      ),
    );
    if (pickedDate != null && pickedDate != date) {
      setState(() {
        date = pickedDate;
      });
    }
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      //? Register
      setState(() {
        isLoading = true;
      });
      if (latLng != null) {
        try {
          await Future.delayed(const Duration(seconds: 3), () {
            Provider.of<EventController>(context, listen: false).editEvent(
                widget.event.id,
                title!,
                description!,
                imageFile,
                latLng?.latitude,
                latLng?.longitude);
          });
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (ctx) {
                  return const MyEvent();
                },
              ),
            );
          }
        } catch (e) {
          // ignore: avoid_print
          print("Failed to add event: $e");
          if (mounted) {
            setState(() {
              isLoading = false;
            });
            showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text("Error!"),
                  content: Text("Failed to add event: $e"),
                );
              },
            );
          }
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (ctx) {
              return const AlertDialog(
                title: Text("Warning!"),
                content: Text("Please input event location"),
              );
            },
          );
        }
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

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        requestFullMetadata: false,
        imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

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
          position: LatLng(widget.event.lat, widget.event.lng),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      locationName = widget.event.locationName;
      date = widget.event.date;
      time = TimeOfDay(
          hour: int.parse(widget.event.time.split(":")[0]),
          minute: int.parse(widget.event.time.split(":")[1]));
    });

    init();
  }

  void init() async {
    curPlace = await LocationServices.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Create Event",
          style: TextStyle(fontSize: 25.h, fontWeight: FontWeight.bold),
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
                TextFormField(
                  initialValue: widget.event.title,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Title",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please input Title";
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    //? save email
                    title = newValue;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: widget.event.description,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Description",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please input Description";
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    description = newValue;
                  },
                ),
                SizedBox(height: 10.h),
                ListTile(
                  title: Text(date.toString().split(" ")[0]),
                  trailing: IconButton(
                      onPressed: () {
                        selectDate(context);
                      },
                      icon: const Icon(Icons.calendar_month_rounded)),
                ),
                ListTile(
                  title: Text("${time.hour}: ${time.minute}"),
                  trailing: IconButton(
                      onPressed: () {
                        selectTime(context);
                      },
                      icon: const Icon(CupertinoIcons.clock)),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: openCamera,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 3),
                            borderRadius: BorderRadius.circular(20)),
                        height: 100.h,
                        width: 110.w,
                        child: Icon(
                          Icons.camera,
                          size: 50.h,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: openGallery,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 3),
                            borderRadius: BorderRadius.circular(20)),
                        height: 100.h,
                        width: 110.w,
                        child: Icon(
                          Icons.image,
                          size: 50.h,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                if (imageFile != null)
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    clipBehavior: Clip.hardEdge,
                    width: double.infinity,
                    height: 200.h,
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 10.h),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  height: 300.h,
                  child: GoogleMap(
                    onTap: (LatLng location) async {
                      String? locationNameLocal =
                          await GeocodingService.getAddressFromCoordinates(
                              location.latitude, location.longitude);
                      setState(() {
                        latLng = LatLng(location.latitude, location.longitude);
                        locationName = locationNameLocal;
                        marker.clear();
                        marker.add(
                          Marker(
                            markerId: const MarkerId("event"),
                            position:
                                LatLng(location.latitude, location.longitude),
                            icon: BitmapDescriptor.defaultMarker,
                          ),
                        );
                      });
                    },
                    markers: marker,
                    mapType: mapType,
                    initialCameraPosition:
                        CameraPosition(target: curPlace, zoom: 10),
                    onMapCreated: onMapCreated,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : FilledButton(
                style: FilledButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                onPressed: submit,
                child: Text(
                  "Create Event",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.h,
                      color: Colors.white),
                ),
              ),
      ),
    );
  }
}
