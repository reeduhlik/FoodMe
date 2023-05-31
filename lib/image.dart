import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsc2023_food_app/texts.dart';
import 'package:location_geocoder/location_geocoder.dart';
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
        heightFactor: 0.8,
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
  final userLocationController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //File? _photo;
  //final ImagePicker _picker = ImagePicker();
  String imageUrl = '';

  DateTime selectedDate = DateTime.now();

  //final TextEditingController _dateController = TextEditingController();
  //final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Using Google Maps API Call to use Google GeoLocation
    const apiKey = "AIzaSyC0IIiLl6i89dT9IiieDhayF1xcWRJgHs4";
    final LocatitonGeocoder geocoder = LocatitonGeocoder(apiKey);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              const HeaderText(text: "Add a Listing"),
              const Spacer(),
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      controller: userNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                        hintText: 'Enter Your List Title',
                      ),
                    ),
                    TextField(
                      controller: userDescriptionController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                        hintText: 'Enter Your Event Description',
                      ),
                    ),
                    TextField(
                      controller: userLocationController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Location',
                        hintText: 'Enter Where Your Food Event Is',
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.camera);

                          if (file == null) {
                            return; //throw an error here, maybe like "no image added"
                          }

                          String fileID =
                              DateTime.now().microsecondsSinceEpoch.toString();

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
                        icon: const Icon(Icons.camera_alt)),
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
              GestureDetector(
                onTap: () async {
                  if (imageUrl.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please upload an image'),
                      ),
                    );
                    return;
                  }

                  final address = await geocoder
                      .findAddressesFromQuery(userLocationController.text);
                  var place = address.first.coordinates;
                  GeoPoint listing =
                      GeoPoint(place.latitude!, place.longitude!);
                  Map<String, dynamic> foodPost = {
                    'title': userNameController.text,
                    'description': userDescriptionController.text,
                    'location': listing,
                    'type': 'business', //TODO: GET WHAT TYPE OF USER
                    'place': userLocationController.text,
                    'imageUrl': imageUrl,
                  };
                  await firestore.collection('food-posts').add(foodPost);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: constraints.maxWidth * 0.9,
                  height: constraints.maxHeight * 0.075,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: const Color(0xFF1E5631),
                  ),
                  child: const PrimaryText(
                    text: "Submit Post",
                    color: Colors.blueGrey,
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
