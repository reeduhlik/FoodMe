import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/buttons.dart';
import 'package:gsc2023_food_app/constants.dart';
import 'package:gsc2023_food_app/listitem_profile.dart';
import 'package:gsc2023_food_app/login/loginscreen.dart';
import 'texts.dart';
import 'backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePageBusiness extends StatefulWidget {
  const ProfilePageBusiness({super.key});

  @override
  State<ProfilePageBusiness> createState() => _ProfilePageBusinessState();
}

class _ProfilePageBusinessState extends State<ProfilePageBusiness> {
  late String firstName = 'Company Name';
  late String email = 'example@example.com';
  late int itemsPosted = 0;
  late int itemsCollected = 0;
  late int peopleImpacted = 0;
  late DocumentSnapshot<Map<String, dynamic>>? doc;

  late List<DocumentSnapshot<Map<String, dynamic>>>? localItemsPosted = null;

  Future<void> fetchUserDetails() async {
    doc = await Backend.getUserDoc();
    String id = doc!.id;
    if (mounted) {
      setState(() {
        firstName = doc!['firstName'];
        email = doc!['email'];
      });
    }
  }

  Future<void> fetchPosted() async {
    var newItemsPosted = await Backend.localItemsPosted();

    setState(() {
      itemsPosted = newItemsPosted;
    });
  }

  Future<void> fetchCollected() async {
    var newItemsCollected = await Backend.localItemsCollected();

    setState(() {
      itemsCollected = newItemsCollected;
    });
  }

  Future<void> fetchImpacted() async {
    var newPeopleImpacted = await Backend.localPeopleImpacted();

    setState(() {
      peopleImpacted = newPeopleImpacted;
    });
  }

  Future<void> getLocalItems() async {
    var newLocalItemsPosted = await Backend.getLocalItems();

    setState(() {
      localItemsPosted = newLocalItemsPosted;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    fetchPosted();
    fetchCollected();
    fetchImpacted();
    getLocalItems();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Business Profile",
                style: TextStyle(fontSize: 16, color: black),
              ),
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 7),
                    Container(
                      width: constraints.maxHeight * 0.175,
                      height: constraints.maxHeight * 0.175,
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        image: const DecorationImage(
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
                        ProfileText(text: firstName),
                        PrimaryText(
                          text: email,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.15,
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
                                text: itemsPosted.toString(),
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
                                text: itemsCollected.toString(),
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
                                text: peopleImpacted.toString(),
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
                height: constraints.maxHeight * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      "Your Current Listings",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 7),
                    //list view to display current listings
                    Expanded(
                      child: localItemsPosted != null &&
                              localItemsPosted!.isNotEmpty
                          ? ListView.builder(
                              itemCount: localItemsPosted!.length,
                              itemBuilder: (context, index) {
                                return ListItemProfile(
                                    localItemsPosted![index]);
                              },
                            )
                          : Text(
                              "No active items posted :(",
                              style: TextStyle(color: kTextColor, fontSize: 16),
                            ),
                    ),
                    const Text(
                      "Account Options",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: SecondaryButton(
                        text: 'Logout',
                        press: () async {
                          await Backend.logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
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
