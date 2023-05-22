import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/login/signupform.dart';
import '../buttons.dart';
import '../constants.dart';
import '../sizeconfig.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int currentPage = 0;
  final List<Map<String, String>> userData = [
    {
      "title": "FoodMe",
      "text":
          "Swipe to see the different profile options and choose the one in which you resonate the most.",
      "image": "assets/images/udsignup.png",
    },
    {
      "title": "Personal",
      "text":
          "I want to view all food listings and events around me or post my own community food listings.",
      "image": "assets/images/udpeople.png",
      "button": "Sign up for Personal"
    },
    {
      "title": "Provider",
      "text":
          "I organize food donations to people and also recieve food donations from local businesses.",
      "image": "assets/images/udprovidor.png",
      "button": "Sign up for Provider"
    },
    {
      "title": "Business",
      "text":
          "I own a business and want to donate leftover food to local food banks, soup kitchens, etc.",
      "image": "assets/images/udbusiness.png",
      "button": "Sign up for Business"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                itemCount: userData.length,
                itemBuilder: (context, index) => UserTypes(
                  title: userData[index]['title'],
                  image: userData[index]["image"],
                  text: userData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: [
                    Spacer(),
                    if (currentPage > 0)
                      DefaultButton(
                        text: userData[currentPage]['button'],
                        press: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpForm(
                                type: (currentPage == 1)
                                    ? "personal"
                                    : (currentPage == 2)
                                        ? "provider"
                                        : "business",
                              ),
                            ),
                          );
                        },
                      )
                    else
                      Text(
                        "How will you use FoodMe...",
                        style: TextStyle(
                          color: Color.fromRGBO(30, 86, 49, 1),
                          fontSize: getProportionateScreenWidth(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        userData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class UserTypes extends StatelessWidget {
  const UserTypes({
    Key? key,
    this.title,
    this.text,
    this.image,
    this.button,
  }) : super(key: key);
  final String? title, text, image, button;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Text(
          title!,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            text!,
            textAlign: TextAlign.center,
          ),
        ),
        Spacer(flex: 2),
        Image.asset(
          image!,
          height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(235),
        ),
      ],
    );
  }
}
