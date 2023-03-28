import 'package:flutter/material.dart';

import '../../components/personal_nav_bar.dart';
import '../../enums.dart';
import 'components/body.dart';

class PersonalAdd extends StatelessWidget {
  static String routeName = "/personal_add";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: PersonalNavBar(selectedMenu: PersonalMenuState.add),
    );
  }
}
