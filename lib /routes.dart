import 'package:flutter/widgets.dart';
import './screens/forgot_password/forgot_password_screen.dart';
import './screens/home/home_screen.dart';
import './screens/login_success/login_success_screen.dart';
import './screens/otp/otp_screen.dart';
import './screens/profile/profile_screen.dart';
import './screens/sign_in/sign_in_screen.dart';
import './screens/sign_up_provider/sign_up_screen.dart';
import './screens/splash/splash_screen.dart';
import './screens/user_types/user_types_screen.dart';
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
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
