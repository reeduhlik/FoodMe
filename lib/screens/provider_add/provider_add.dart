import 'package:flutter/material.dart';

import '../../components/personal_nav_bar.dart';
import '../../components/provider_nav_bar.dart';
import '../../enums.dart';
import 'components/body.dart';

class ProviderAdd extends StatelessWidget {
  static String routeName = "/provider_add";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: ProviderNavBar(selectedMenu: ProviderMenuState.add),
    );
  }
}
