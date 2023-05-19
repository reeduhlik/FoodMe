import 'package:flutter/material.dart';

import 'components/body.dart';

class SignUpBusiness extends StatelessWidget {
  static String routeName = "/sign_up_business";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up Business"),
      ),
      body: Body(),
    );
  }
}
