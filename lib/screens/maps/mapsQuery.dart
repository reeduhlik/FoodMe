/*
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
  final DocumentReference<Map<String, dynamic>> foodPostRef =
      FirebaseFirestore.instance.collection('food-posts').doc('jOcjfZQli4c3bEV3vuBl');

  late GoogleMapController mapController;
  Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: foodPostRef.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!.data();

          final GeoPoint location = data!['location'];
          final MarkerId markerId = MarkerId(foodPostRef.id);
          GeoPoint geoPoint = data['location'];

          String title = data['title'];
          String description = data['description'];
          Timestamp time = data['timestamp']; 
          DateTime timeDate = time.toDate();

          String fdatetime = DateFormat('yyyy-MM-dd hh:mm').format(timeDate); //DateFormat() is from intl package
          print(fdatetime); //output: 04-Dec-2021
      
          final Marker marker = Marker(
            icon: BitmapDescriptor.defaultMarker,
            markerId: markerId,
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(
            title: data['title'],
            snippet:  'description: $description\n'
            'time: $timeDate',
            ),
          );

          return Stack(
            children: [
              GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.hybrid,
                zoomGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 20,
                ),
                markers: Set<Marker>.of([marker]),
              ),
            ],
          );
        },
      ),
    );
  }

    _animateToUser() async {
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(pos.latitude!, pos.longitude!),
zoom: 20.0,
)
)
);
}

}

//split

class FireMap extends StatefulWidget {
  @override
  State createState() => FireMapState();
}

class FireMapState extends State<FireMap> {
  late GoogleMapController mapController;
  Location location = Location();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GeoFlutterFire geo = GeoFlutterFire();
  BehaviorSubject<double> radius = BehaviorSubject.seeded(100.00);
  late Stream<dynamic> query;
  late StreamSubscription subscription;

  @override
  build(context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 10),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.hybrid,
          zoomGesturesEnabled: true,
        ),
      ],
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
zoom: 17.0,
)
)
);
}
}

*/

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

    final GeoPoint location = data!['location'];
    final MarkerId markerId = MarkerId(doc.id);
    GeoPoint geoPoint = data['location'];

    String title = data['title'];
    String description = data['description'];
    Timestamp time = data['timestamp'];
    DateTime timeDate = time.toDate();

    String fdatetime = DateFormat('yyyy-MM-dd hh:mm').format(timeDate);
    print(fdatetime);

    return Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: markerId,
      position: LatLng(location.latitude, location.longitude),
      infoWindow: InfoWindow(
        title: data['title'],
        snippet: 'description: $description\n' 'time: $timeDate',
      ),
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

