import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants.dart';

Future<void> displayItemInfo(BuildContext context) async {
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
            return const PostItem();
          },
        ),
      );
    },
  );
}

class PostItem extends StatelessWidget {
  const PostItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
