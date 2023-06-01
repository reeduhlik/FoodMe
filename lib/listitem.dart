import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsc2023_food_app/constants.dart';
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
          border: doc['type'] == "provider"
              ? Border.all(
                  color: kPrimaryColor,
                  width: 2,
                )
              : null,
        ),
        margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
        padding: const EdgeInsets.all(15),
        child: GestureDetector(
            onTap: () =>
                displayItemInfo(context, doc, distanceAway, timePostedAgo),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    doc['type'] == 'provider'
                        ? const Text('Provider Listing',
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 16))
                        : const Text(
                            "Community Listing",
                            style: TextStyle(color: kTextColor, fontSize: 16),
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
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: kSecondaryColor, size: 16),
                                Text(distanceAway),
                              ],
                            ),
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
                )),
                doc['imageUrl'] != ''
                    ? Image.network(
                        doc['imageUrl'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/placeholder.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ],
            )));
  }
}
