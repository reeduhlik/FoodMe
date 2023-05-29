import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants.dart';

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
      child: Text(doc['title']),
    );
  }
}
