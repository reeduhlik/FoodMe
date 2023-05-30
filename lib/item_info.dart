import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants.dart';

import 'package:gsc2023_food_app/backend.dart';

void displayItemInfo(
    BuildContext context, DocumentSnapshot<Map<String, dynamic>> doc) async {
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
            return PostItem(doc);
          },
        ),
      );
    },
  );
}

class PostItem extends StatelessWidget {
  const PostItem(this.doc, {Key? key}) : super(key: key);

  final DocumentSnapshot<Map<String, dynamic>> doc;

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
            Column(
              children: [
                Text("Community Listing"),
                Text(doc['title']),
                Text(doc['description']),
                IconButton(
                    icon: const Icon(Icons.location_on),
                    onPressed: () {},
                    tooltip: "Location"),
                IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () {},
                    tooltip: "Time"),
              ],
            ),
            doc['imageUrl'] != null
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
          ],
        ),
        Row(children: [
          InkWell(
            onTap: () {},
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
            onTap: () {},
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
            onTap: () {},
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
