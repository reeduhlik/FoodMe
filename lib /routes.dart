import 'package:flutter/widgets.dart';
import 'package:gsc2023_food_app/screens/cart/cart_screen.dart';
import 'package:gsc2023_food_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:gsc2023_food_app/screens/details/details_screen.dart';
import 'package:gsc2023_food_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:gsc2023_food_app/screens/home/home_screen.dart';
import 'package:gsc2023_food_app/screens/login_success/login_success_screen.dart';
import 'package:gsc2023_food_app/screens/otp/otp_screen.dart';
import 'package:gsc2023_food_app/screens/profile/profile_screen.dart';
import 'package:gsc2023_food_app/screens/sign_in/sign_in_screen.dart';
import 'package:gsc2023_food_app/screens/sign_up_provider/sign_up_screen.dart';
import 'package:gsc2023_food_app/screens/splash/splash_screen.dart';
import 'package:gsc2023_food_app/screens/user_types/user_types_screen.dart';
import 'screens/sign_up_personal/sign_up_screen.dart';
import 'screens/sign_up_business/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  UserTypes.routeName: (context) => UserTypes(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpPersonal.routeName: (context) => SignUpPersonal(),
  SignUpProvider.routeName: (context) => SignUpProvider(),
  SignUpBusiness.routeName: (context) => SignUpBusiness(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(), 
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
