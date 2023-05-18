import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:gsc2023_food_app/screens/provider_listings/components/body.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Provider Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {},
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.02), // 4%
          Text("My Listings", style: headingStyle),     
          //MyApp()  
          /*
           PLACE THE CODE FOR THE YOUR OWN PROFILE LISTINGS HERE
           */
        ],
      ),
    );
  }
}