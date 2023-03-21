import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gsc2023_food_app/screens/impact/impact.dart';
import '../screens/personal_add/personal_add.dart';
import '../screens/personal_home/personal_home_screen.dart';
import '../screens/personal_profile/profile_screen.dart';



import '../constants.dart';
import '../enums.dart';

class PersonalNavBar extends StatelessWidget {
  const PersonalNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final PersonalMenuState selectedMenu;

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
                  color: PersonalMenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, PersonalHomeScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Plus Icon.svg",
                  color: PersonalMenuState.add == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                      ),
                onPressed: () =>
                    Navigator.pushNamed(context, PersonalAdd.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  color: PersonalMenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, PersonalProfileScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Flash Icon.svg",
                   color: PersonalMenuState.impact == selectedMenu
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
