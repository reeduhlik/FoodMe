import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsc2023_food_app/constants.dart';
import 'package:intl/intl.dart';
import 'package:gsc2023_food_app/item_info.dart';

class ListItem extends StatelessWidget {
  //doc received from firebase
  final DocumentSnapshot<Map<String, dynamic>> doc;
  final String distanceAway;
  final String timePostedAgo;

  const ListItem(this.doc, this.distanceAway, this.timePostedAgo, {Key? key})
      : super(key: key);

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
            onTap: () =>
                displayItemInfo(context, doc, distanceAway, timePostedAgo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                doc['imageUrl'] != ''
                    ? Image.network(
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
                          Text(distanceAway),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: kSecondaryColor, size: 16),
                          Text(timePostedAgo + " ago"),
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
