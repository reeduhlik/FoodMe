import 'package:flutter/material.dart';
import 'package:gsc2023_food_app/screens/personal_listings/personal_listings_screen.dart';

import '../../components/custom_surfix_icon.dart';
import '../../components/default_button.dart';
import '../../components/personal_nav_bar.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/body.dart';

class PersonalAdd extends StatefulWidget {
  static String routeName = "/personal_add";

  @override
  _AddPersonalState createState() => _AddPersonalState();
}

class _AddPersonalState extends State<PersonalAdd> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? descript;
  String? address;

  bool remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
}

Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(40)),
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.09), // 4%
                  Text("Add a listing", style: headingStyle),
                  SizedBox(height: getProportionateScreenHeight(40)),
                  buildTitleFormField(),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  buildDescriptFormField(),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  buildAddressFormField(),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  DefaultButton(
                    text: "Add Listing",
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // if all are valid then go to success screen
                        Navigator.pushNamed(context, PersonalListings.routeName);
                      }
                    },
                  ),
                ],
              ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: PersonalNavBar(selectedMenu: PersonalMenuState.add),
  );
}



 

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter your address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildTitleFormField() {
    return TextFormField(
      onSaved: (newValue) => title = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Title",
        hintText: "Enter the name of the food",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildDescriptFormField() {
    return TextFormField(
      onSaved: (newValue) => descript = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Description",
        hintText: "Enter description",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
