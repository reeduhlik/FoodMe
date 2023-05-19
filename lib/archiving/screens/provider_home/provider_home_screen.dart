import 'package:flutter/material.dart';
import '../../components/provider_listings_bar.dart';
import '../../components/provider_nav_bar.dart';
import '../../../constants.dart';
import '../../../enums.dart';

import 'components/body.dart';

class ProviderHomeScreen extends StatelessWidget {
  static String routeName = "/provider_home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map View", style: headingStyle),
        automaticallyImplyLeading:
            false, // <--- This will remove the back button
        actions: <Widget>[
          ProviderListingsBar(selectedMenu: ProviderListingsMenuState.map)
        ],
      ),
      body: MyApp(),
      bottomNavigationBar: ProviderNavBar(selectedMenu: ProviderMenuState.home),
    );
  }
}
