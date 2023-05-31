import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Backend {
  static Future<int> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print(user.uid.toString()); //might remove toString method
      return 1;
    } else {
      return 0;
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<String> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid.toString();
    } else {
      return '';
    }
  }

  static Future<DocumentSnapshot?> getUserDoc() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    String check = user!.uid.toString();

    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('userId', isEqualTo: check)
        .get();

    // Get the first document from the query snapshot
    DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

    if (documentSnapshot.exists) {
      return documentSnapshot;
    } else {
      return null;
    }
  }

  static Future<void> claimFullItem(DocumentSnapshot doc) async {
    if (doc.exists) {
      DocumentReference documentReference = doc.reference;
      await documentReference.set({'status': 'closed'});
      addTransaction();
    }
  }

  static Future<void> claimPartialItem(DocumentSnapshot doc) async {
    if (doc.exists) {
      DocumentReference documentReference = doc.reference;
      await documentReference.set({'status': 'partial'});
      addTransaction();
    }
  }

  static Future<void> deleteItem(DocumentSnapshot doc) async {
    if (doc.exists) {
      DocumentReference documentReference = doc.reference;
      await documentReference.delete();
    }
  }

  static Future<void> addTransaction() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, dynamic> event = {
      'String': 'test',
    };
    await firestore.collection('transactions').add(event);
  }

  static Future<void> getUserStatistics() async {
    //get the user statistics
    /*
    1. Return the amount of documents containing the ID of the user
    */
  }

  static Future<void> getGlobalStatistics() async {
    //get the food post statistics
    /*
    1. Return the amount of documents and transactions
    */
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

  static Future<bool> signIn(String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }
}
