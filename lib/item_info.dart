import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gsc2023_food_app/sizeconfig.dart';
import '../../../constants.dart';

import 'package:gsc2023_food_app/backend.dart';

void displayItemInfo(
    BuildContext context,
    DocumentSnapshot<Map<String, dynamic>> doc,
    String distAway,
    String timeAgoPosted) async {
  String? id = doc.id;
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
        heightFactor: 0.6,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return PostItem(doc, distAway, timeAgoPosted);
          },
        ),
      );
    },
  );
}

class PostItem extends StatelessWidget {
  PostItem(this.doc, this.distAway, this.timeAgoPosted, {Key? key})
      : super(key: key);

  final DocumentSnapshot<Map<String, dynamic>> doc;
  final String distAway;
  final String timeAgoPosted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(children: [
        Row(
          children: [
            Container(
              width: getProportionateScreenWidth(187.5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Community Listing"),
                    Text(doc['title']),
                    Text(doc['description']),
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: kSecondaryColor, size: 16),
                            Text(distAway),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: kSecondaryColor, size: 16),
                            Text(timeAgoPosted),
                          ],
                        ),
                        //place the media image below here
                      ],
                    ),
                  ]),
            ),
            doc['imageUrl'] != ''
                ? Image.network(
                    doc['imageUrl'],
                    width: getProportionateScreenWidth(187.5),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/placeholder.png',
                    width: getProportionateScreenWidth(187.5),
                    fit: BoxFit.cover,
                  ),
          ],
        ),
        Row(children: [
          InkWell(
            onTap: () async {
              Backend.deleteItem(doc);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Item not here",
                style: TextStyle(color: white),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Backend.claimFullItem(doc);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Claim full item",
                style: TextStyle(color: white),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              Backend.claimPartialItem(doc);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Claim part of item",
                style: TextStyle(color: white),
              ),
            ),
          )
        ])
      ]),
    );
  }
}
