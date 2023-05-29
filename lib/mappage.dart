import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsc2023_food_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/item_info.dart';
import 'package:gsc2023_food_app/post.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:cached_network_image/cached_network_image.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class ListItem extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> doc;
  const ListItem(this.doc);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
        padding: const EdgeInsets.all(15),
        child: GestureDetector(
            onTap: () => displayItemInfo(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                doc['imageUrl'] != ''
                  ?   Image.network(
                      doc['imageUrl'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      )
                  : Image.asset(
                      'assets/images/placeholder.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                  ),
                SizedBox(width: 20),
                Text(doc['title'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                Text(doc['description']),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: kSecondaryColor, size: 16),
                          Text(
                            " 0.1 mile away      ",
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                            color: kSecondaryColor, size: 16),
                          Text(DateFormat(' kk:mm EEE')
                            .format(doc['timestamp'].toDate())),
                        ],
                      ),
                      //place the media image below here
                    ],
                  ),
                )
              ],
            )));
  }
}

class _MapPageState extends State<MapPage> {
  final CollectionReference<Map<String, dynamic>> foodPostRef =
      FirebaseFirestore.instance.collection('food-posts');
  late final GoogleMapController mapController;
  late String interfaceType;
  late Stream<QuerySnapshot> _stream; 
  late LatLng _initialPosition = LatLng(37.7749, -122.4194);

  @override
  void initState() {
    super.initState();
    interfaceType = "map";
    _getUserLocation();
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
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

        final List<DocumentSnapshot<Map<String, dynamic>>> documents =
            snapshot.data!.docs;

        final markers =
            documents.map((doc) => buildMarker(doc)).toList(growable: false);

        //get user current location using geolocator

        return Stack(
          children: [
            (interfaceType == "map")
                ? GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapType: MapType.hybrid,
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 15,
                    ),
                    markers: Set<Marker>.of(markers),
                  )
                : ListView.builder(
                    //iterate through all documents and create ListItems
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final doc = documents[index];
                      return ListItem(doc);
                    },
                  ),
            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 40,
                    child: Material(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: backgroundColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Stack(
                          children: [
                            AnimatedAlign(
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.decelerate,
                              alignment: (interfaceType == "map")
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: 40,
                                color: black.withOpacity(0.05),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      interfaceType = "map";
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.place_rounded,
                                      color: (interfaceType == "map")
                                          ? kPrimaryColor
                                          : kSecondaryColor,
                                      size: 24,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      interfaceType = "list";
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.list_rounded,
                                      color: (interfaceType == "list")
                                          ? kPrimaryColor
                                          : kSecondaryColor,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: GestureDetector(
                    onTap: () {
                      displayPostDialogue(context);
                    },
                    child: Material(
                      elevation: 5,
                      color: Color.fromRGBO(207, 255, 199, 1).withOpacity(.85),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const UnconstrainedBox(
                        child: Icon(Icons.add_rounded, color:  Color(0xFF1E5631)),
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

  Marker buildMarker(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final MarkerId markerId = MarkerId(doc.id);

    final GeoPoint? location = data!['location'];
    String? title = data['title'];
    String? description = data['description'];
    Timestamp? time = data['timestamp'];
    String? type = data['type'];
    String? imageUrl = data['imageUrl'];

    if (time != null && imageUrl != null) { //was && imageUrl == 'provider'
      DateTime timeDate = time.toDate();
      String fdatetime = DateFormat('MM-dd-yy hh:mm a').format(timeDate);

      if (location != null &&
          title != null &&
          description != null &&
          type != null) {
        return Marker(
          icon: BitmapDescriptor.defaultMarker,
          markerId: markerId,
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: data['title'],
            snippet: 'Description: $description\n' 'Time: $fdatetime',
          ), 
        );
      }
    }

    return Marker(
      markerId: MarkerId(doc.id),
      //visible: type == "provider" ? true : false,
    );
  }
}
