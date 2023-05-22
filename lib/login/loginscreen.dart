import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/login/signinscreen.dart';
import '../buttons.dart';
import '../constants.dart';
import '../sizeconfig.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int currentPage = 0;
  final List<Map<String, String>> splashData = [
    {
      "text":
          "We are on a mission to simultaneously eliminate food waste and food insecurity.",
      "image": "assets/images/udhome.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => Column(
                    children: <Widget>[
                      Spacer(),
                      Text(
                        "FoodMe",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(36),
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        splashData[index]['text']!,
                        textAlign: TextAlign.center,
                      ),
                      Spacer(flex: 2),
                      Image.asset(
                        splashData[index]["image"]!,
                        height: getProportionateScreenHeight(295),
                        width: getProportionateScreenWidth(265),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Spacer(flex: 10),
                      DefaultButton(
                        text: "Login",
                        press: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        },
                      ),
                      Spacer(),
                      DefaultButton(
                        text: "Sign Up",
                        press: () {
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => SignUpScreen(),
                          //   ),
                          // );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
