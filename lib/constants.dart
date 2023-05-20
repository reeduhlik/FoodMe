import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sizeconfig.dart';

//Color palette
const Color black = Colors.black;
const Color white = Colors.white;
const Color backgroundColor = Colors.white;
const Color kPrimaryColor = Color(0xFFFF7643);
const Color kPrimaryLightColor = Color(0xFFFFECDF);
const Color kSecondaryColor = Color(0xFF979797);
const Color kTextColor = Color(0xFF757575);
const LinearGradient GradientkPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);

//Other
const Duration kAnimationDuration = Duration(milliseconds: 200);
final TextStyle headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp websiteValidatorRegExp =
    RegExp(r'^(https?):\/\/[^\s\/$.?#].[^\s]*$');
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kWebsiteNullError = "Please Enter your website url";
const String kInvalidWebsiteError = "Please Enter valid url";

//Theme
final InputDecoration otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder,
  focusedBorder: outlineInputBorder,
  enabledBorder: outlineInputBorder,
);
final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
  borderSide: BorderSide(color: kTextColor),
);
final ThemeData theme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  fontFamily: "Muli",
  appBarTheme: appBarTheme,
  textTheme: textTheme,
  inputDecorationTheme: inputDecorationTheme(),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
final TextTheme textTheme = TextTheme(
  bodyLarge: TextStyle(color: kTextColor),
  bodyMedium: TextStyle(color: kTextColor),
);
final AppBarTheme appBarTheme = AppBarTheme(
  color: Colors.white,
  elevation: 0,
  iconTheme: IconThemeData(color: Colors.black),
  systemOverlayStyle: SystemUiOverlayStyle.dark,
  toolbarTextStyle: TextTheme(
    titleLarge: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
  ).bodyMedium,
  titleTextStyle: TextTheme(
    titleLarge: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
  ).titleLarge,
);
InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}
