import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gsc2023_food_app/archiving/screens/sign_in/sign_in_screen.dart';
import 'package:gsc2023_food_app/archiving/screens/splash/splash_screen.dart';
import 'package:gsc2023_food_app/sizeconfig.dart';
import 'firebase_options.dart';
import 'constants.dart';
import 'login/login..dart';
import 'mainview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FoodMe());
}

class FoodMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: UserInitialization(),
    );
  }
}

class UserInitialization extends StatefulWidget {
  const UserInitialization({super.key});

  @override
  State<UserInitialization> createState() => _UserInitializationState();
}

class _UserInitializationState extends State<UserInitialization> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<dynamic>(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == 0) {
            return LogIn();
          } else {
            return MainView();
          }
        } else {
          return Placeholder();
        }
      },
    );
  }
}

Future<dynamic> getUser() async {
  //TODO: See if user logged in
  await Future.delayed(const Duration(seconds: 2));
  return 0;
}
