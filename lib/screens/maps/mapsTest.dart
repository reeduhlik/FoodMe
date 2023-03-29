/*
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gsc2023_food_app/models/Product.dart';
import 'package:location/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:firebase_database/firebase_database.dart';


// Construct query for first 25 cities, ordered by population
final first = db.collection("cities").orderBy("population").limit(25);

first.get().then(
  (documentSnapshots) {
    // Get the last visible document
    final lastVisible = documentSnapshots.docs[documentSnapshots.size - 1];

    // Construct a new query starting at this document,
    // get the next 25 cities.
    final next = db
        .collection("cities")
        .orderBy("population")
        .startAfter([lastVisible]).limit(25);

    // Use the query for pagination
    // ...
  },
  onError: (e) => print("Error completing: $e"),
);
*/

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gsc2023_food_app/models/Product.dart';
import 'package:location/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  Map<MarkerId, Marker> markers = <MarkerId , Marker>{}; 

  void initMarker(specify, specifyId) async {
    var markerIdval = specifyId;
    final MarkerId markerId = MarkerId(markerIdval);
    final Marker marker = Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: markerId,
      position: LatLng(specify['location'].latitude, specify['location'].longitude), //check to see if I can algamate with just GeoPoint
      infoWindow: InfoWindow(title: 'Event', snippet: specify['Description']) //maybe use previous info widow
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  void getMarkerData() async {
    FirebaseFirestore.instance.collection('food-posts').get().then((myMockData) {
        if(myMockData.size > 0){
          for(int i = 0; i < myMockData.docs.length; i++) {
            initMarker(myMockData.docs[i].data, myMockData.docs[i].id); 
          }
        }
    }); 
  }

  void initState() {
    getMarkerData();
    super.initState(); 
  }

  void myMockData(QuerySnapshot querySnapshot) {
    // your implementation
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        body: GoogleMap(
          //markers: getMarkerData(),
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}

//nah like prayers 
/*
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter StreamBuilder Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollectionReference<Map<String, dynamic>> foodPosts =
        FirebaseFirestore.instance.collection('food-posts');
        //FirebaseFirestore.instance.doc('jOcjfZQli4c3bEV3vuBl');

    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: foodPosts.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          //if (snapshot.hasError) {
            //return const Text('Something went wrong');
          //}

          //if (!snapshot.hasData) {
            //return const Center(
              //child: CircularProgressIndicator(),
            //);
          //}

          final List<Marker> markers = snapshot.data!.docs.map((doc) {
            final GeoPoint location = doc.get('location');
            final MarkerId markerId = MarkerId(doc.id);

            return Marker(
              icon: BitmapDescriptor.defaultMarker, 
              markerId: markerId,
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(
                title: doc.get('name'),
                snippet: doc.get('description'),
              ),
            );
          }).toList();

          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(45.521563, -122.677433),
              zoom: 11,
            ),
            markers: Set<Marker>.of(markers),
          );
        },
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter StreamBuilder Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DocumentReference<Map<String, dynamic>> foodPostRef =
    FirebaseFirestore.instance.collection('food-posts').doc('jOcjfZQli4c3bEV3vuBl');

  return Scaffold(
  body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  stream: foodPostRef.snapshots(),
  builder: (BuildContext context,
      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.hasError) {
      return const Text('Something went wrong');
    }

    if (!snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final data = snapshot.data!.data();

    final GeoPoint location = data!['location'];
    final MarkerId markerId = MarkerId(foodPostRef.id);

    final Marker marker = Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: markerId,
      position: LatLng(location.latitude, location.longitude),
      infoWindow: InfoWindow(
        title: data['title'],
        snippet: data['description'],
      ),
    );

    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(0, 0),
        zoom: 11,
      ),
      markers: Set<Marker>.of([marker]),
    );
  },
  )
);
  }
}
*/
