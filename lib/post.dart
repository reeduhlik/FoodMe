import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gsc2023_food_app/backend.dart';
import 'package:gsc2023_food_app/texts.dart';
import '../../../constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:core';

Future<void> displayPostDialogue(BuildContext context) async {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    ),
    clipBehavior: Clip.hardEdge,
    context: context,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.5,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return const BusinessAdd();
          },
        ),
      );
    },
  );
}

class BusinessAdd extends StatefulWidget {
  const BusinessAdd({Key? key}) : super(key: key);

  @override
  State<BusinessAdd> createState() => _InsertDataState();
}

class _InsertDataState extends State<BusinessAdd> {
  final userNameController = TextEditingController();
  final userDescriptionController = TextEditingController();
  final userTimeController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String imageUrl = '';

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    //Using Google Maps API Call to use Google GeoLocation

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              const HeaderText(text: "Add a Listing"),
              //const Spacer(), /* this spacer is a problem all of a sudden, not sure why*/
              const SizedBox(height: 30),
              SizedBox(
                width: constraints.maxWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      controller: userNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                        hintText: 'Food Item',
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: userDescriptionController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                        hintText: 'Extra details to help find your item',
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: constraints.maxWidth,
                      height: 60,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.camera,
                                imageQuality: 80,
                                maxWidth: 400,
                                maxHeight: 400);

                            if (file == null)
                              return; //throw an error here, maybe like "no image added"

                            String fileID = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();

                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child('images');

                            Reference referenceImageToUpload =
                                referenceDirImages.child(fileID);

                            try {
                              await referenceImageToUpload
                                  .putFile(File(file.path));
                              //success: now get the download URL
                              imageUrl =
                                  await referenceImageToUpload.getDownloadURL();
                            } catch (e) {
                              //some error occured
                            }
                          },
                          icon: Icon(Icons.camera_alt),
                          label: Text("Upload Image")),
                    ),
                    /*
                    1. Pick image
                    2. Upload image
                    3. Get the URL of the uploaded image
                    4. Store the image inside the corresponding document
                    5. Display image on the list
                    */
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  String id = await Backend.getUserId();
                  DateTime dateTime = DateTime.now();
                  //get the user's device current location
                  final userLoc = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  dynamic check = Timestamp.fromDate(dateTime);
                  print(
                      "For debugging, the timestamp is: $check , and the imageUrl is: $imageUrl");
                  GeoPoint listing =
                      GeoPoint(userLoc.latitude, userLoc.longitude);
                  Map<String, dynamic> foodPost = {
                    'title': userNameController.text,
                    'description': userDescriptionController.text,
                    'location': listing,
                    'type': 'business', //TODO: GET WHAT TYPE OF USER
                    'timestamp': Timestamp.fromDate(dateTime),
                    'imageUrl': imageUrl,
                    'userID': id,
                    'status': 'open',
                  };
                  await firestore.collection('food-posts').add(foodPost);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: constraints.maxWidth,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(
                      width: 2.0,
                      color: const Color(0xFF1E5631),
                    ),
                  ),
                  child: const PrimaryText(
                    text: "Submit Post",
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
