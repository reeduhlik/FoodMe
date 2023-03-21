import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/components/provider_nav_bar.dart';
import '../../components/personal_nav_bar.dart';
import '../../enums.dart';

import 'components/body.dart';

class ProviderHomeScreen extends StatelessWidget {
  static String routeName = "/provider_home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: ProviderNavBar(selectedMenu: ProviderMenuState.home),
    );
  }
}
