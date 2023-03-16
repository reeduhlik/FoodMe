import 'package:flutter/material.dart';

import 'components/body.dart';

class SignUpProvider extends StatelessWidget {
  static String routeName = "/sign_up_provider";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up Provider"),
      ),
      body: Body(),
    );
  }
}
