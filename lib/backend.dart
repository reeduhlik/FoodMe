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

  static Future<dynamic> getUserDoc() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    String check = user!.uid.toString();

    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('userID', isEqualTo: check)
        .get();

    // Get the first document from the query snapshot
    DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
    if (documentSnapshot.exists) {
      return documentSnapshot;
    }
  } // throw in a try catch block maybe?

  static Future<void> claimFullItem(DocumentSnapshot doc) async {
    if (doc.exists) {
      DocumentReference documentReference = doc.reference;
      await documentReference.update({'status': 'closed'});
      addTransaction(documentReference.id);
    }
  }

  static Future<void> claimPartialItem(DocumentSnapshot doc) async {
    if (doc.exists) {
      DocumentReference documentReference = doc.reference;
      addTransaction(documentReference.id);
    }
  }

  static Future<void> deleteItem(DocumentSnapshot doc) async {
    if (doc.exists) {
      DocumentReference documentReference = doc.reference;
      await documentReference.update({'status': 'not_found'});
    }
  }

  static Future<void> addTransaction(postID) async {
    User? user = FirebaseAuth.instance.currentUser;

    final userId = user!.uid;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, dynamic> event = {
      'user_id': userId,
      'timestamp': DateTime.now(),
      'post_id': postID
    };
    await firestore.collection('transactions').add(event);
  }

  static Future<void> getUserStatistics() async {
    //get the user statistics
    /*
    1. Return the amount of documents containing the ID of the user
    */
  }

//global methods

  static Future<int> amountOfUsers() async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot = await usersCollection.get();
      int count = querySnapshot.size;
      return count;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static Future<int> peopleImpacted() async {
    return 1;
    //just return the amount of documents in the transactions colelction
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

  static Future<int> signIn(String email, String password) async {
    try {
      final auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //figure out which type of user it is
      DocumentSnapshot doc = await getUserDoc();
      String type = doc.get('type');

      if (type == "personal") {
        return 1;
      } else if (type == "provider") {
        return 2;
      } else {
        return 3;
      }
    } on FirebaseAuthException catch (e) {
      return 0;
    }
  }
}
