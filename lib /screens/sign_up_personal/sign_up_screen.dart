import 'package:flutter/material.dart';

import 'components/body.dart';

class SignUpPersonal extends StatelessWidget {
  static String routeName = "/sign_up_personal";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up Personal"),
      ),
      body: Body(),
    );
  }
}
