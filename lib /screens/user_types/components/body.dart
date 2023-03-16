import 'package:flutter/material.dart';
import 'constants.dart';
import 'screens/sign_up_business/sign_up_screen.dart';
import 'screens/sign_up_personal/sign_up_screen.dart';
import 'screens/sign_up_provider/sign_up_screen.dart';
import 'size_config.dart';

// This is the best practice
import 'user_types_content.dart';
import '../../../components/default_button.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> userData = [
    {
      "title": "FoodApp",
      "text": "Choose your profile type, swipe to see options!",
      "image": "assets/images/splash_1.png"
    },
    {
      "title": "Personal",
      "text":
          "You are looking to recieve food from other people or recieve food or attend events from providers",
      "image": "assets/images/splash_2.png"
    },
    {
      "title": "Provider",
      "text": "You are an establishment that is able to give food to others and can accept food from businesses",
      "image": "assets/images/splash_3.png"
    },
    {
      "title": "Business",
      "text": "You are looking to donate extra food you have to providers",
      "image": "assets/images/splash_3.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
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
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        userData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 10),
                    DefaultButton(
                      text: "Personal",
                      press: () {
                        Navigator.pushNamed(context, SignUpPersonal.routeName);
                      },
                    ),
                    Spacer(),
                    DefaultButton(
                      text: "Provider",
                      press: () {
                        Navigator.pushNamed(context, SignUpProvider.routeName);
                      },
                    ),
                    Spacer(),
                    DefaultButton(
                      text: "Business",
                      press: () {
                        Navigator.pushNamed(context, SignUpBusiness.routeName);
                      },
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
