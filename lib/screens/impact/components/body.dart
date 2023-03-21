import 'package:flutter/material.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../screens/personal_home/personal_home_screen.dart';
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
                Text("Our Impact", style: headingStyle),
                /*
                ADD CODE FOR OUR IMPACT DATA HERE
                */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
