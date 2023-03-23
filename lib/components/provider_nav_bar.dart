// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/impact/impact.dart';
import '../screens/provider_add/provider_add.dart';
import '../screens/provider_home/provider_home_screen.dart';
import '../screens/personal_profile/profile_screen.dart';

import '../constants.dart';
import '../enums.dart';
import '../screens/provider_profile/profile_screen.dart';

class ProviderNavBar extends StatelessWidget {
  const ProviderNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final ProviderMenuState selectedMenu;

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
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Discover.svg",
                  color: ProviderMenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, ProviderHomeScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Plus Icon.svg",
                  color: ProviderMenuState.add == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                      ),
                onPressed: () =>
                    Navigator.pushNamed(context, ProviderAdd.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  color: ProviderMenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, ProviderProfileScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Flash Icon.svg",
                   color: ProviderMenuState.impact == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                      ),
                onPressed: () =>
                    Navigator.pushNamed(context, Impact.routeName),
              ),
            ],
          )),
    );
  }
}