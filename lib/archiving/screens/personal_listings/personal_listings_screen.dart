import 'package:flutter/material.dart';
import '../../components/personal_listings_bar.dart';
import '../../components/personal_nav_bar.dart';
import '../../../constants.dart';
import '../../../enums.dart';

import 'components/body.dart';

class PersonalListings extends StatelessWidget {
  static String routeName = "/personal_listings";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List View", style: headingStyle),
        automaticallyImplyLeading: false, // <--- This will remove the back button
        actions: <Widget>[
          PersonalListingsBar(selectedMenu: PersonalListingsMenuState.list)
        ],
      ), 
      body: MyApp(),
      bottomNavigationBar: PersonalNavBar(selectedMenu: PersonalMenuState.home),
    );
  }
}
