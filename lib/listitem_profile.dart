import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gsc2023_food_app/constants.dart';
import 'backend.dart';

class ListItemProfile extends StatelessWidget {
  //doc received from firebase
  final DocumentSnapshot<Map<String, dynamic>> doc;

  const ListItemProfile(this.doc, {Key? key}) : super(key: key);

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
            child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                Text(doc['title'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                Text(doc['description']),
                Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        Backend.deleteItem(doc);
                      },
                      child: const Text('Delete Item'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFB80000),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    )),
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
