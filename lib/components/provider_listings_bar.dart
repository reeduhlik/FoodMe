// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gsc2023_food_app/screens/impact/impact.dart';
import 'package:gsc2023_food_app/screens/personal_listings/personal_listings_screen.dart';
import '../screens/personal_add/personal_add.dart';
import '../screens/personal_home/personal_home_screen.dart';
import '../screens/personal_profile/profile_screen.dart';



import '../constants.dart';
import '../enums.dart';
import '../screens/provider_listings/provider_listings_screen.dart';

class ProviderListingsBar extends StatelessWidget {
  const ProviderListingsBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final ProviderListingsMenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Transform.scale(
                  scale: 2, // adjust this value to make the icon larger or smaller
                  child: SvgPicture.asset(
                    "assets/icons/Location point.svg",
                    color: ProviderListingsMenuState.map == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, PersonalHomeScreen.routeName),
              ),
              IconButton(
                icon: Transform.scale(
                  scale: 2, // adjust this value to make the icon larger or smaller
                  child: SvgPicture.asset(
                    "assets/icons/receipt.svg",
                    color: ProviderListingsMenuState.list == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                ),
                onPressed: () => Navigator.pushNamed(context, ProviderListings.routeName),
              ),
            ],
          )),
    );
  }
}
