import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsc2023_food_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/listitem.dart';
import 'package:gsc2023_food_app/post.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:time_elapsed/time_elapsed.dart';
import 'package:gsc2023_food_app/item_info.dart';
import 'package:flutter/services.dart' show rootBundle;

class DiscoverPageBusiness extends StatefulWidget {
  const DiscoverPageBusiness({super.key});

  @override
  State<DiscoverPageBusiness> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPageBusiness> {
  final CollectionReference<Map<String, dynamic>> foodPostRef =
      FirebaseFirestore.instance.collection('food-posts');
  late final GoogleMapController mapController;
  bool mapHasBeenInitialized = false;
  late String interfaceType = "map";
  late LatLng _initialPosition = const LatLng(37.7749, -122.4194);

  String _mapStyle = "";

  BitmapDescriptor customMarker = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      rootBundle.loadString('assets/map_style.txt').then((string) {
        _mapStyle = string;
      });
      interfaceType = "map";

      _getUserLocation();
      getCustomMarker();
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  void getCustomMarker() async {
    BitmapDescriptor customMarkerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/custom-icon.png");
    setState(() {
      customMarker = customMarkerIcon;
    });
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
                (doc) => doc['status'] == 'open' && doc['type'] == 'business')
            .toList();
        documents.sort((a, b) {
          GeoPoint aLocation = a['location'];
          GeoPoint bLocation = b['location'];
          double aDistance = Geolocator.distanceBetween(
              aLocation.latitude,
              aLocation.longitude,
              _initialPosition.latitude,
              _initialPosition.longitude);
          double bDistance = Geolocator.distanceBetween(
              bLocation.latitude,
              bLocation.longitude,
              _initialPosition.latitude,
              _initialPosition.longitude);
          return aDistance.compareTo(bDistance);
        });

        //generates the markers to use to pass to the googlemap constructor
        final markers =
            documents.map((doc) => buildMarker(doc)).toList(growable: false);

        //get user current location using geolocator

        return Stack(
          children: [
            (interfaceType == "map")
                ? GoogleMap(
                    onMapCreated: (controller) => {
                      mapController = controller,
                      mapController.setMapStyle(_mapStyle),
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 16,
                    ),
                    markers: Set<Marker>.of(markers),
                  )
                : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding:
                              EdgeInsets.only(top: 70, left: 20, bottom: 10),
                          child: const Text(
                            "See what other businesses are posting...",
                            style:
                                TextStyle(fontSize: 24, color: kPrimaryColor),
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
                            return ListItem(
                                doc,
                                getDistanceFromPoint(doc["location"]),
                                getTimeElapsed(doc["timestamp"]));
                          },
                        ),
                      ),
                    ),
                  ]),

            //the toggle buttons
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
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 150,
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

  Marker buildMarker(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final MarkerId markerId = MarkerId(doc.id);

    final GeoPoint? location = data!['location'];
    String? title = data['title'];
    String? description = data['description'];
    Timestamp? time = data['timestamp'];
    String? type = data['type'];
    String? imageUrl = data['imageUrl'];

    if (time != null && imageUrl != null) {
      //was && imageUrl == 'provider'
      DateTime timeDate = time.toDate();
      String fdatetime = DateFormat('MM-dd-yy hh:mm a').format(timeDate);

      if (location != null &&
          title != null &&
          description != null &&
          type != null) {
        return Marker(
          icon: customMarker,
          markerId: markerId,
          onTap: () => displayItemInfo(context, doc,
              getDistanceFromPoint(location), getTimeElapsed(time)),
          position: LatLng(location.latitude, location.longitude),
        );
      }
    }

    return Marker(
      markerId: MarkerId(doc.id),
      //visible: type == "provider" ? true : false,
    );
  }
}
