import 'package:flutter/widgets.dart';
import 'package:gsc2023_food_app/screens/personal_listings/personal_listings_screen.dart';
import 'package:gsc2023_food_app/screens/provider_listings/provider_listings_screen.dart';
import './screens/forgot_password/forgot_password_screen.dart';
import 'screens/business_add/business_add.dart';
import 'screens/business_profile/profile_screen.dart';
import 'screens/impact/impact.dart';
import 'screens/personal_add/personal_add.dart';
import 'screens/personal_home/personal_home_screen.dart';
import 'screens/provider_add/provider_add.dart';
import 'screens/provider_home/provider_home_screen.dart';
import './screens/login_success/login_success_screen.dart';
import 'screens/personal_profile/profile_screen.dart';
import './screens/sign_in/sign_in_screen.dart';
import './screens/sign_up_provider/sign_up_screen.dart';
import './screens/splash/splash_screen.dart';
import './screens/user_types/user_types_screen.dart';
import 'screens/provider_profile/profile_screen.dart';
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
  PersonalAdd.routeName: (context) => PersonalAdd(),
  ProviderAdd.routeName: (context) => ProviderAdd(),
  BusinessAdd.routeName: (context) => BusinessAdd(),
  SignUpPersonal.routeName: (context) => SignUpPersonal(),
  SignUpProvider.routeName: (context) => SignUpProvider(),
  SignUpBusiness.routeName: (context) => SignUpBusiness(),
  PersonalHomeScreen.routeName: (context) => PersonalHomeScreen(),
  ProviderHomeScreen.routeName: (context) => ProviderHomeScreen(),
  PersonalProfileScreen.routeName: (context) => PersonalProfileScreen(),
  BusinessProfileScreen.routeName: (context) => BusinessProfileScreen(),
  ProviderProfileScreen.routeName: (context) => ProviderProfileScreen(),
  PersonalListings.routeName: (context) => PersonalListings(),
  ProviderListings.routeName: (context) => ProviderListings(),
  Impact.routeName: (context) => Impact(),
};
