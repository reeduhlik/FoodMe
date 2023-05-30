import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gsc2023_food_app/login/loginscreen.dart';
import 'package:gsc2023_food_app/sizeconfig.dart';
import 'backend.dart';
import 'firebase_options.dart';
import 'constants.dart';
import 'mainview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FoodMe());
}

class FoodMe extends StatelessWidget {
  const FoodMe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const UserInitialization(),
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
      future: Backend.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == 0) {
            return const LoginScreen();
          } else {
            return const MainView();
          }
        } else {
          return const Placeholder();
        }
      },
    );
  }
}
