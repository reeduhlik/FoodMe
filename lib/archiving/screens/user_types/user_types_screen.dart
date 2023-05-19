import 'package:flutter/material.dart';
import '../user_types/components/body.dart';
import '../../../sizeconfig.dart';

class UserTypes extends StatelessWidget {
  static String routeName = "/user_types";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Types"),
      ),
      body: Body(),
    );
  }
}
