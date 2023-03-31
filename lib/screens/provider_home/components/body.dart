
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter StreamBuilder Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference<Map<String, dynamic>> foodPostRef =
      FirebaseFirestore.instance.collection('food-posts');

  late GoogleMapController mapController;
  Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

          final markers = documents
              .map((doc) => _buildMarker(doc))
              .toList(growable: false);

          return Stack(
            children: [
              GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.hybrid,
                zoomGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(38.9097, -77.0654),
                  zoom: 15,
                ),
                markers: Set<Marker>.of(markers),
              ),
            ],
          );
        },
      ),
    );
  }

  Marker _buildMarker(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final MarkerId markerId = MarkerId(doc.id);

    final GeoPoint? location = data!['location'];
    String? title = data['title'];
    String? description = data['description'];
    Timestamp? time = data['timestamp'];
    String? type = data['type'];

    if (time != null && type == "provider") {
    DateTime timeDate = time.toDate();
    String fdatetime = DateFormat('MM-dd-yy hh:mm a').format(timeDate);

  if (location != null && title != null && description != null && type != null) {
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

// Return a marker with `visible: false` if type is not "provider"
return Marker(
    markerId: MarkerId(doc.id),
    visible: type == "provider" ? true : false,
    );
    
}

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  _animateToUser() async {
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(pos.latitude!, pos.longitude!),
zoom: 11.0,
)
)
);
}

}