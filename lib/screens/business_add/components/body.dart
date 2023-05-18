import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/screens/business_profile/components/businessOwn.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.02), // 4%
                Text("Add a listing", style: headingStyle),
                /*
                ADD CODE FOR ADDING A LISTING HERE
                */
                MyApp(), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}
