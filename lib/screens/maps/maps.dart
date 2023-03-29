import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gsc2023_food_app/models/Product.dart';
import 'package:location/location.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
// ignore: unused_import
import 'firebase_options.dart';
//import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:firebase_database/firebase_database.dart';

class MyApp extends StatelessWidget {
   static String routeName = "/personal_maps";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: FireMap()
      )
    );
  }
}

class FireMap extends StatefulWidget {
  @override
  State createState() => FireMapState();
}

class FireMapState extends State<FireMap> {
  late GoogleMapController mapController; //late means the variable will be intialized later
  Location location = new Location(); 

  FirebaseFirestore firestore = FirebaseFirestore.instance; 
  GeoFlutterFire geo = GeoFlutterFire(); 

  //Stateful Data
  BehaviorSubject<double> radius = BehaviorSubject.seeded(100.00);
  late Stream<dynamic> query; 
  late StreamSubscription subscription;

  @override
  build(context) {
    //var pos = await location.getLocation();
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(24.150, -110.32), zoom: 10),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true, // Add little blue dot for device location, requires permission from user
          myLocationButtonEnabled: true,
          mapType: MapType.hybrid,
          zoomGesturesEnabled: true, 
          //trackCameraPosition: true,
        ),
      ]


    );
  }

   void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
   }

  // ignore: unused_element
  _animateToUser() async {
    // ignore: unused_element
    _animateToUser() async {
      var pos = await location.getLocation();
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(pos.latitude!, pos.longitude!),
            zoom: 17.0,
          )
        )
      );
    }
  }

/*
void _updateMarkers(List<DocumentSnapshot> documentList) {
    print(documentList);
    mapController.clearMarkers();
    documentList.forEach((DocumentSnapshot document) {
        GeoPoint pos = document.data['position']['geopoint'];
        double distance = document.data['distance'];
        var marker = MarkerOptions(
          position: LatLng(pos.latitude, pos.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindowText: InfoWindowText('Magic Marker', '$distance kilometers from query center')
        );
        mapController.addMarker(marker);
    });
}
*/

/*
void _updateMarkers(List<DocumentSnapshot> documentList) {
    print(documentList);
    Set<Marker> markers = Set<Marker>();
    documentList.forEach((DocumentSnapshot document) {

      // retrieve the GeoPoint data from the 'location' field
      GeoPoint geoPoint = document.get('location');
      String title = document.get('title');
      String description = document.get('description');
      Timestamp time = document.get('timestamp'); 


// retrieve the latitude and longitude values from the GeoPoint
        double latitude = geoPoint.latitude;
        double longitude = geoPoint.longitude;

        Marker marker = Marker(
          markerId: MarkerId(document.id),
          position: LatLng(geoPoint.latitude, geoPoint.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: title,
            snippet:
            'description: $description\n'
            'time: $time'
          )
        );
        markers.add(marker);
    });
    setState(() { 
        markers = {};
        markers.clear(); 
     });
    //mapController.addMarkers(markers);
}
*/

void _updateMarkers(List<DocumentSnapshot> documentList) {
  Set<Marker> markers = Set<Marker>();
  documentList.forEach((DocumentSnapshot document) {
    GeoPoint geoPoint = document.get('location');
    String title = document.get('title');
    String description = document.get('description');
    Timestamp time = document.get('timestamp'); 

    double latitude = geoPoint.latitude;
    double longitude = geoPoint.longitude;

    Marker marker = Marker(
      markerId: MarkerId(document.id),
      position: LatLng(geoPoint.latitude, geoPoint.longitude),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: title,
        snippet:
        'description: $description\n'
        'time: $time'
      )
    );
    markers.add(marker);
  });
  //mapController.addMarkers(markers);
}



 // ignore: unused_element
 _startQuery() async {
    // Get users location
    var pos = await location.getLocation();
    //LatLng(pos.latitude!, pos.longitude!);
    // Make a referece to firestore
    var ref = firestore.collection('food-posts');
    GeoFirePoint center = geo.point(latitude: pos.latitude!, longitude: pos.longitude!);

    // subscribe to query
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
        center: center, 
        radius: rad, 
        field: 'position', 
        strictMode: true
      );
    }).listen(_updateMarkers);
  }

  // ignore: unused_element
  _updateQuery(value) {
      final zoomMap = {
          100.0: 12.0,
          200.0: 10.0,
          300.0: 7.0,
          400.0: 6.0,
          500.0: 5.0 
      };
      final zoom = zoomMap[value];
      mapController.moveCamera(CameraUpdate.zoomTo(zoom!));

      setState(() {
        radius.add(value);
      });
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

}


//Trial for alternate inclusion of markers from Firebase



/*

// Class that parses the data from database.

class MapsDemo extends StatefulWidget {
  MapsDemo({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MapsDemoState createState() => _MapsDemoState();
}



class Marker {
  late String key; 
  late String title;
  late String description;
  late GeoPoint location; 
  late Timestamp timestamp; 
  late double latitude;
  late double longitude;

  Marker(
      {required this.key, required this.description, required this.title, required this.location, required this.timestamp, required this.latitude, required this.longitude});

  Marker.fromJson(this.key, Map data) {
    title = data['title'];
    description = data['description'];
    location = data['location'];
    latitude = location.latitude;
    longitude = location.latitude; ;

    }
}

class _MapsDemoState extends State<MapsDemo> {
  late MapShapeSource _dataSource;
  late List<Marker> _markers;

  @override
  void initState() {
    _markers = <Marker>[];
    //Load the data soucre
    _dataSource = MapShapeSource.asset(
      'assets/world_map.json',
    );

    super.initState();
  }
 
 // Get the markers from database for a local collection.
  Future<List<Marker>> getMarkers() async {
    _markers.clear();
    var _dbRef = FirebaseDatabase.instance.ref().once();
    await _dbRef.then(
      (DatabaseEvent) async {
        // Access the markers from database.
         Map<dynamic, dynamic> mapMarkers = DatabaseEvent.snapshot.value as Map<dynamic, dynamic>;
        // Get the markers in a local collection.
        mapMarkers.forEach(
          (key, value) {
            Marker marker = Marker.fromJson(key, value);
            _markers.add(Marker(
                key: key,
                latitude: marker.latitude,
                longitude: marker.longitude,
                description: marker.description,
                location: marker.location,
                timestamp: marker.timestamp,
                title: marker.title
              ));
          },
        );
      },
    );
    return _markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(8),
          //Get the markers as collection and update the Maps
          child: FutureBuilder(
            future: getMarkers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SfMaps(
                  layers: <MapLayer>[
                    MapShapeLayer(
                      source: _dataSource,
                      initialMarkersCount: _markers.length,
                      markerBuilder: (BuildContext context, int index) {
                        return MapMarker(
                          latitude: _markers[index].latitude,
                          longitude: _markers[index].longitude,
                        );
                      },
                    ),
                  ],
                );
              }
              return Text('Loading');
            },
          ),
        ),
      ),
    );
  }
}
*/

/*

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          elevation: 2,
        ),
        body: GoogleMap(
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

*/