import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/login/loginscreen.dart';
import 'package:gsc2023_food_app/login/signupform.dart';
import '../buttons.dart';
import '../constants.dart';
import '../sizeconfig.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int currentPage = 0;
  final List<Map<String, String>> userData = [
    {
      "title": "How will you use FoodMe?",
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E5631)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
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
                    const Spacer(),
                    (currentPage > 0)
                        ? DefaultButton(
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
                        : const AnimatedArrow(),
                    const Spacer(),
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
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : const Color(0xFFD8D8D8),
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
        Text(
          title!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text!,
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(flex: 2),
        Image.asset(
          image!,
          height: getProportionateScreenHeight(235),
          width: getProportionateScreenWidth(205),
        ),
      ],
    );
  }
}

class AnimatedArrow extends StatefulWidget {
  const AnimatedArrow({super.key});

  @override
  State<AnimatedArrow> createState() => _AnimatedArrowState();
}

class _AnimatedArrowState extends State<AnimatedArrow> {
  late Alignment alignment;

  @override
  void initState() {
    super.initState();
    alignment = Alignment.centerLeft;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      alignment = Alignment.centerRight;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(70),
      height: getProportionateScreenWidth(40),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedAlign(
            duration: const Duration(
              milliseconds: 500,
            ),
            curve: Curves.decelerate,
            alignment: alignment,
            onEnd: () {
              if (alignment == Alignment.centerLeft) {
                alignment = Alignment.centerRight;
              } else {
                alignment = Alignment.centerLeft;
              }
              setState(() {});
            },
            child: Icon(
              Icons.arrow_forward_rounded,
              color: kPrimaryColor,
              size: getProportionateScreenWidth(40),
            ),
          ),
        ],
      ),
    );
  }
}
