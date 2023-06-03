import 'package:gsc2023_food_app/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/discoverpage_business.dart';
import 'package:gsc2023_food_app/profilepage.dart';
import 'package:gsc2023_food_app/profilepage_business.dart';
import 'package:gsc2023_food_app/texts.dart';
import 'impactpage.dart';
import 'discoverpage_provider.dart';
import 'profilepage_provider.dart';
import 'discoverpage.dart';

class MainView extends StatefulWidget {
  final int userType;
  const MainView({
    super.key,
    required this.userType,
  });

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late int pageIndex;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageIndex = 1;
    pageController = PageController(initialPage: pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const ImpactPage(),
                  (widget.userType == 1)
                      ? const DiscoverPage()
                      : (widget.userType == 2)
                          ? const DiscoverPageProvider()
                          : const DiscoverPageBusiness(),
                  (widget.userType == 1)
                      ? const ProfilePage()
                      : (widget.userType == 2)
                          ? const ProfilePageProvider()
                          : const ProfilePageBusiness(),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          pageController.jumpToPage(0);
                          pageIndex = 0;
                          setState(() {});
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Flash Icon.svg",
                                color: (pageIndex == 0)
                                    ? kPrimaryColor
                                    : kSecondaryColor,
                              ),
                              const PrimaryText(
                                text: "Impact",
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          pageController.jumpToPage(1);
                          pageIndex = 1;
                          setState(() {});
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Discover.svg",
                                color: (pageIndex == 1)
                                    ? kPrimaryColor
                                    : kSecondaryColor,
                              ),
                              const PrimaryText(
                                text: "Discover",
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          pageController.jumpToPage(2);
                          pageIndex = 2;
                          setState(() {});
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/User Icon.svg",
                                color: (pageIndex == 2)
                                    ? kPrimaryColor
                                    : kSecondaryColor,
                              ),
                              const PrimaryText(
                                text: "Profile",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
