import 'package:flutter/material.dart';

import '../../components/business_nav_bar.dart';
import '../../components/personal_nav_bar.dart';
import '../../enums.dart';
import 'components/body.dart';

class BusinessAdd extends StatelessWidget {
  static String routeName = "/business_add";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: BusinessNavBar(selectedMenu: BusinessMenuState.add),
    );
  }
}
