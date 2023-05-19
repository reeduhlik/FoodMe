import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsc2023_food_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final CollectionReference<Map<String, dynamic>> foodPostRef =
      FirebaseFirestore.instance.collection('food-posts');
  late final GoogleMapController mapController;
  late String interfaceType;

  @override
  void initState() {
    super.initState();
    interfaceType = "map";
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

        return Stack(
          children: [
            (interfaceType == "map")
                ? GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.hybrid,
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(38.9097, -77.0654),
                      zoom: 15,
                    ),
                    markers: Set<Marker>.of(markers),
                  )
                : Placeholder(),
            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
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
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 40,
                  child: Material(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: UnconstrainedBox(
                      child: Icon(Icons.add_rounded),
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

    if (time != null && type == "provider") {
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
      visible: type == "provider" ? true : false,
    );
  }
}
