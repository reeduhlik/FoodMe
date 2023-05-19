import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/archiving/components/personal_listings_bar.dart';
import '../../components/personal_nav_bar.dart';
import '../../components/provider_nav_bar.dart';
import '../../../enums.dart';

import 'components/body.dart';

class ProviderProfileScreen extends StatelessWidget {
  static String routeName = "/provider_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Body(),
      bottomNavigationBar:
          ProviderNavBar(selectedMenu: ProviderMenuState.profile),
    );
  }
}
