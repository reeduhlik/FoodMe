import 'dart:io'; 

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gsc2023_food_app/login/signupform.dart'; 
import 'package:gsc2023_food_app/login/signinscreen.dart'; 

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'post.dart'; 



class Backend {
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
      String address,) 
      async {
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

  /*static Future<dynamic> uploadFile(File? _photo) async {
      firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

    if (_photo == null) return null;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      final uploadTask = ref.putFile(_photo);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('error occured');
      return null;
    }
  }*/
}
