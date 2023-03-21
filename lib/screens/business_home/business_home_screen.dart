import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/components/business_nav_bar.dart';
import '../../components/personal_nav_bar.dart';
import '../../enums.dart';

import 'components/body.dart';

class BusinessHomeScreen extends StatelessWidget {
  static String routeName = "/business_home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: BusinessNavBar(selectedMenu: BusinessMenuState.home),
    );
  }
}
