import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gsc2023_food_app/login/signupform.dart';
import 'package:gsc2023_food_app/login/signinscreen.dart';

class Backend {
  static Future<int> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return 1;
    } else {
      return 0;
    }
  }

  static Future<void> claimFullItem() async {
    //update the firebase document where the doc id matched so status is complete
  }

  static Future<void> claimPartialItem() async {
    //update the firebase document where the doc id matched so status is partial
  }

  static Future<void> deleteItem() async {
    //delete the firebase document where the doc id matched
  }

  static Future<void> addTransaction() async {
    //add a transaction to the firebase collection "Transactions" where the doc id matched
  }

  static Future<void> getUserStatistics() async {
    //get the user statistics
  }

  static Future<void> getGlobalStatistics() async {
    //get the food post statistics
  }

  static Future<void> firebaseFunction() async {
    await Firebase.initializeApp();
  }

  // Method for signing up a user with email and password
  static Future<void> signUpWithEmailAndPassword(
    String type,
    String email,
    String password,
    String firstName,
    String phoneNumber,
    String address,
  ) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Access the user details using userCredential.user
      // You can save additional user data to the database here if needed

      Map<String, dynamic> data = {
        'type': type,
        'email': email,
        'password': password,
        'firstName': firstName,
        'phoneNumber': phoneNumber,
        'address': address,
        'userID': userCredential.user!.uid,
      };
      await firestore.collection('users').add(data);
    } catch (e) {
      // Handle any errors that occur during sign-up
      print('Sign-up failed: $e');
    }
  }

  static Future<dynamic> signIn(String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }
}
