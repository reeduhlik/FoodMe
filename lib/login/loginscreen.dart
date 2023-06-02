import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/login/signinscreen.dart';
import 'package:gsc2023_food_app/login/signupscreen.dart';
import '../buttons.dart';
import '../constants.dart';
import '../sizeconfig.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Map<String, String> loginData = {
    "text":
        "We are on a mission to simultaneously eliminate food waste and food insecurity.",
    "image": "assets/images/udhome.png"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: getProportionateScreenWidth(50),
                  width: getProportionateScreenWidth(50),
                  child: Image.asset('assets/images/foodme.png'),
                ),
                const SizedBox(width: 5),
                Text(
                  "FoodMe",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(40),
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              loginData['text']!,
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 4),
            Image.asset(
              loginData["image"]!,
              height: getProportionateScreenHeight(295),
              width: getProportionateScreenWidth(265),
            ),
            const Spacer(flex: 10),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
              ),
              child: DefaultButton(
                text: "Sign In",
                press: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
              ),
              child: SecondaryButton(
                text: "Sign Up",
                press: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
              ),
            ),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
