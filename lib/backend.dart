import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Backend {
  static Future<void> firebaseFunction() async {
    //Talk to firebase
  }

  // Method for signing up a user with email and password
  static Future<void> signUpWithEmailAndPassword(
      String type,
      String email,
      String password,
      String firstName,
      String phoneNumber,
      String address,
      String userID) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final _auth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
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
        'userID': userID = userCredential.user!.uid,
      };
      await firestore.collection('users').add(data);
    } catch (e) {
      // Handle any errors that occur during sign-up
      print('Sign-up failed: $e');
    }
  }

  static Future<dynamic> signIn(String email, String password) async {
    try {
      final _auth = FirebaseAuth.instance;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }
}
