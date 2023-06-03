import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:gsc2023_food_app/login/loginscreen.dart';
import 'package:gsc2023_food_app/mainview.dart';
import 'package:gsc2023_food_app/sizeconfig.dart';
import 'backend.dart';
import 'firebase_options.dart';
import 'constants.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Phoenix(child: const FoodMe()));
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
  int userStatus = -1;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    var returnedVal = await Backend.getUser();
    setState(() {
      userStatus = returnedVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    if (userStatus == -1) {
      return const Placeholder();
    } else if (userStatus > 0) {
      return MainView(userType: userStatus);
    } else {
      return const LoginScreen();
    }
  }
}
