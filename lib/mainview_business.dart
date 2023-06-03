import 'package:gsc2023_food_app/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/discoverpage_business.dart';
import 'package:gsc2023_food_app/texts.dart';
import 'impactpage.dart';
import 'discoverpage_business.dart';
import 'profilepage_business.dart';

class MainViewBusiness extends StatefulWidget {
  const MainViewBusiness({super.key});

  @override
  State<MainViewBusiness> createState() => _MainViewBusinessState();
}

class _MainViewBusinessState extends State<MainViewBusiness> {
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
                children: const [
                  ImpactPage(),
                  DiscoverPageBusiness(),
                  ProfilePageBusiness(),
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                pageController.jumpToPage(0);
                              },
                              child: SvgPicture.asset(
                                "assets/icons/Flash Icon.svg",
                                color: (pageIndex == 0)
                                    ? kPrimaryColor
                                    : kSecondaryColor,
                              ),
                            ),
                            const PrimaryText(
                              text: "Impact",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                pageController.jumpToPage(1);
                              },
                              child: SvgPicture.asset(
                                "assets/icons/Discover.svg",
                                color: (pageIndex == 1)
                                    ? kPrimaryColor
                                    : kSecondaryColor,
                              ),
                            ),
                            const PrimaryText(
                              text: "Discover",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                pageController.jumpToPage(2);
                              },
                              child: SvgPicture.asset(
                                "assets/icons/User Icon.svg",
                                color: (pageIndex == 2)
                                    ? kPrimaryColor
                                    : kSecondaryColor,
                              ),
                            ),
                            const PrimaryText(
                              text: "Profile",
                            ),
                          ],
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

  void animateToPage(int index) {
    pageIndex = index;
    pageController.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
    setState(() {});
  }
}
