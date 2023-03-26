import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../splash/splash_screen.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

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
            
          /*
           PLACE THE CODE FOR THE YOUR OWN PROFILE LISTINGS HERE
           */
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {Navigator.pushNamed(context, SplashScreen.routeName);},
          ),
        ],
      ),
    );
  }
}
