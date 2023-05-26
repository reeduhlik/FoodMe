import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gsc2023_food_app/login/loginscreen.dart';
import 'package:gsc2023_food_app/login/signupscreen.dart';
import 'package:gsc2023_food_app/mainview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../backend.dart';
import '../buttons.dart';
import 'formerror.dart';
import '../constants.dart';
import '../sizeconfig.dart';

class SignUpForm extends StatefulWidget {
  final String type;
  const SignUpForm({
    super.key,
    required this.type,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? conformPassword;
  String? firstName;
  String? phoneNumber;
  String? address;
  String? userID;
  final _auth = FirebaseAuth.instance;
  bool remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text; // Return empty string if input is empty
    }

    String firstLetter = text[0].toUpperCase();
    String remainingLetters = text.substring(1);

    return '$firstLetter$remainingLetters';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E5631)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              Text(
                "Create a ${capitalizeFirstLetter(widget.type)} Profile",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(24),
                  color: const Color.fromRGBO(30, 86, 49, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Complete your details",
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              //Right now all the same
              if (widget.type == "business" ||
                  widget.type == "provider" ||
                  widget.type == "personal")
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildFirstNameFormField(),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      buildPhoneNumberFormField(),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      buildAddressFormField(),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      buildEmailFormField(),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      buildPasswordFormField(),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      buildConformPassFormField(),
                      FormError(errors: errors),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      DefaultButton(
                        text: "Continue",
                        press: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (errors.isEmpty) {
                              await Backend.signUpWithEmailAndPassword(
                                widget.type,
                                email!,
                                password!,
                                firstName!,
                                phoneNumber!,
                                address!,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainView(),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Text(
                'By continuing your confirm that you agree \nwith our Term and Condition',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conformPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conformPassword) {
          removeError(error: kMatchPassError);
        }
        conformPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
      if (value.isNotEmpty) {
        removeError(error: kEmailNullError);
        checkEmailExists(value); // Check if email already exists
      } else if (emailValidatorRegExp.hasMatch(value)) {
        removeError(error: kInvalidEmailError);
      }
      setState(() {}); // Trigger a rebuild
      return null;
    },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

void checkEmailExists(String email) async {
  try {
    final existingUser = await _auth.fetchSignInMethodsForEmail(email);
    if (existingUser.isNotEmpty) {
      addError(error: 'Email is already in use.');
    } else {
      removeError(error: 'Email is already in use.');
    }
  } catch (e) {
    //print('Error checking email existence: $e');
  }
}

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Address",
        hintText: "Enter your address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}

class CustomSurffixIcon extends StatelessWidget {
  final String svgIcon;
  const CustomSurffixIcon({
    super.key,
    required this.svgIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: getProportionateScreenWidth(18),
      ),
    );
  }
}
