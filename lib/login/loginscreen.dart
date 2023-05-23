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
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "FoodMe",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(36),
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 7),
                SizedBox(
                  height: getProportionateScreenWidth(40),
                  width: getProportionateScreenWidth(40),
                  child: Image.asset('assets/images/foodme.png'),
                ),
              ],
            ),
            Text(
              loginData['text']!,
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 2),
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
              child: DefaultButton(
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
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
