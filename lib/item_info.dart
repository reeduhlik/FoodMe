import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsc2023_food_app/sizeconfig.dart';
import '../../../constants.dart';

import 'package:gsc2023_food_app/backend.dart';

void displayItemInfo(
    BuildContext context,
    DocumentSnapshot<Map<String, dynamic>> doc,
    String distAway,
    String timeAgoPosted) async {
  //String? id = doc.id;
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Color.fromARGB(200, 255, 255, 255),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
    ),
    clipBehavior: Clip.hardEdge,
    context: context,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.5,
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
        color: Color.fromARGB(200, 255, 255, 255),
        borderRadius: BorderRadius.circular(5),
        border: doc['type'] == "provider"
            ? Border.all(
                color: kPrimaryColor,
                width: 2,
              )
            : null,
      ),
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Container(
                  width: getProportionateScreenWidth(177.5),
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          doc['title'],
                          style: TextStyle(fontSize: 20, color: kPrimaryColor),
                        ),
                        Text(
                          doc['description'],
                          style: TextStyle(fontSize: 14),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
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
                                  Text(timeAgoPosted + " ago"),
                                ],
                              ),
                              //place the media image below here
                            ],
                          ),
                        ),
                      ]),
                ),
                doc['imageUrl'] != ''
                    ? Image.network(
                        doc['imageUrl'],
                        width: getProportionateScreenWidth(177.5),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/placeholder.png',
                        width: getProportionateScreenWidth(177.5),
                        fit: BoxFit.cover,
                      ),
              ],
            )),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  Backend.deleteItem(doc);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(0),
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
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(0),
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
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: accentGreen,
                    borderRadius: BorderRadius.circular(0),
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
