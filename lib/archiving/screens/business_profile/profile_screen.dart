import 'package:flutter/material.dart';
import '../../components/business_nav_bar.dart';
import '../../../enums.dart';

import 'components/body.dart';

class BusinessProfileScreen extends StatelessWidget {
  static String routeName = "/business_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Body(),
      bottomNavigationBar:
          BusinessNavBar(selectedMenu: BusinessMenuState.profile),
    );
  }
}
