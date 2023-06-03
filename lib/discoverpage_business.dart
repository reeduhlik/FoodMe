import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsc2023_food_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/listitem_business.dart';
import 'package:gsc2023_food_app/post_business.dart';

import 'package:geolocator/geolocator.dart';
import 'package:time_elapsed/time_elapsed.dart';

class DiscoverPageBusiness extends StatefulWidget {
  const DiscoverPageBusiness({super.key});

  @override
  State<DiscoverPageBusiness> createState() => _DiscoverPageBusinessState();
}

class _DiscoverPageBusinessState extends State<DiscoverPageBusiness> {
  final CollectionReference<Map<String, dynamic>> foodPostRef =
      FirebaseFirestore.instance.collection('food-posts');

  late LatLng _initialPosition = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _getUserLocation();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  String getDistanceFromPoint(postPosition) {
    double distance = Geolocator.distanceBetween(
        postPosition.latitude,
        postPosition.longitude,
        _initialPosition.latitude,
        _initialPosition.longitude);

    if (distance < 20) {
      return "Right by you";
    } else if (distance < 1000000) {
      return (distance * 3.28084).toStringAsFixed(1) + "ft away";
    } else if (distance < 1000000) {
      return (distance * .00062137).toStringAsFixed(1) + "mi away";
    } else {
      return (distance * .00000062137).toStringAsFixed(1) + "k miles away";
    }
  }

  String getTimeElapsed(timestamp) {
    return TimeElapsed.elapsedTimeDynamic(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: foodPostRef.snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<DocumentSnapshot<Map<String, dynamic>>>
            unfiltered_documents = snapshot.data!.docs;

        //sorts the documents based on how close they are to the user
        final documents = unfiltered_documents
            .where(
                (doc) => (doc['status'] == 'open' && doc['type'] == 'business'))
            .toList();
        //generates the markers to use to pass to the googlemap constructo

        print(documents.length); //get user current location using geolocator

        return Stack(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.only(top: 70, left: 20, bottom: 10),
                    child: const Text(
                      "See what other businesses are posting...",
                      style: TextStyle(fontSize: 24, color: kPrimaryColor),
                    )),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    if (mounted) {
                      _getUserLocation();
                    }
                  },
                  child: ListView.builder(
                    //iterate through all documents and create ListItems
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final doc = documents[index];
                      return ListItemBusiness(
                          doc, getDistanceFromPoint(doc["location"]));
                    },
                  ),
                ),
              ),
            ]),

            //the toggle button

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: GestureDetector(
                    onTap: () {
                      displayPostBusinessDialogue(context);
                    },
                    child: Material(
                      elevation: 5,
                      color: Color.fromRGBO(207, 255, 199, 1).withOpacity(.85),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const UnconstrainedBox(
                        child:
                            Icon(Icons.add_rounded, color: Color(0xFF1E5631)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
