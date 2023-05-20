import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/constants.dart';
import 'texts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PrimaryText(
                      text: "Food Me",
                    ),
                    Container(
                      width: constraints.maxHeight * 0.125,
                      height: constraints.maxHeight * 0.125,
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        image: DecorationImage(
                            image:
                                AssetImage("assets/images/Profile Image.png")),
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        ProfileText(text: "John Doe"),
                        PrimaryText(text: "johndoe@gmail.com")
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.2,
                color: kPrimaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: constraints.maxWidth / 3,
                          child: Column(
                            children: [
                              ProfileText(
                                text: "25",
                                color: kPrimaryLightColor,
                              ),
                              SecondaryText(
                                text: "Items posted",
                                color: kPrimaryLightColor,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth / 3,
                          child: Column(
                            children: [
                              ProfileText(
                                text: "8",
                                color: kPrimaryLightColor,
                              ),
                              SecondaryText(
                                text: "Items collected",
                                color: kPrimaryLightColor,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth / 3,
                          child: Column(
                            children: [
                              ProfileText(
                                text: "42",
                                color: kPrimaryLightColor,
                              ),
                              SecondaryText(
                                text: "People Impacted",
                                color: kPrimaryLightColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.45,
                child: Padding(
                  padding: EdgeInsets.all(constraints.maxWidth * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(text: "Account Options"),
                      const Spacer(flex: 4),
                      AccountButton(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.05,
                          text: "Change password",
                          callback: () {}),
                      const Spacer(),
                      AccountButton(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.05,
                          text: "Change password",
                          callback: () {}),
                      const Spacer(),
                      AccountButton(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.05,
                          text: "Change password",
                          callback: () {}),
                      const Spacer(flex: 4),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AccountButton extends StatefulWidget {
  final double width;
  final double height;
  final String text;
  final Function callback;
  const AccountButton({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.callback,
  });

  @override
  State<AccountButton> createState() => _AccountButtonState();
}

class _AccountButtonState extends State<AccountButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Material(
        elevation: 5,
        color: kSecondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widget.width * 0.05, vertical: widget.height * 0.001),
          child: Container(
            color: black,
            child: Row(),
          ),
        ),
      ),
    );
  }
}
