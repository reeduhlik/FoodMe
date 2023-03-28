import 'package:gsc2023_food_app/screens/maps/mapsQuery.dart';
import 'package:flutter/material.dart';
import '../../components/personal_listings_bar.dart';
import '../../components/personal_nav_bar.dart';
import '../../constants.dart';
import '../../enums.dart';
import 'components/body.dart';


class PersonalHomeScreen extends StatelessWidget {
  static String routeName = "/personal_home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map View", style: headingStyle),
        automaticallyImplyLeading: false, // <--- This will remove the back button
        actions: <Widget>[
          PersonalListingsBar(selectedMenu: PersonalListingsMenuState.map)
        ],
      ), 
      body: MyApp(),
      bottomNavigationBar: PersonalNavBar(selectedMenu: PersonalMenuState.home),
    );
  }
}

