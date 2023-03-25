import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

class MyApp extends StatelessWidget {
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
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(24.150, -110.32), zoom: 10),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true, // Add little blue dot for device location, requires permission from user
          myLocationButtonEnabled: true,
          mapType: MapType.hybrid, 
          //trackCameraPosition: true
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

void _updateMarkers(List<DocumentSnapshot> documentList) {
    print(documentList);
    Set<Marker> markers = Set<Marker>();
    documentList.forEach((DocumentSnapshot document) {
        /* GeoPoint pos = document.data()['location']['geopoint'];
        double distance = document.data()['distance'];
        String title= document.data()*/

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
            snippet: 'Event: $title'
            'description: $description'
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


 // ignore: unused_element
 _startQuery() async {
    // Get users location
    var pos = await location.getLocation();
    //LatLng(pos.latitude!, pos.longitude!);
    // Make a referece to firestore
    var ref = firestore.collection('locations');
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