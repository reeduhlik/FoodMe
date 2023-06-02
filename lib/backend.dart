import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Backend {
  static Future<int> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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

      DocumentSnapshot<Map<String, dynamic>> updatedDoc =
          await documentReference.get()
              as DocumentSnapshot<Map<String, dynamic>>;
      String userID = updatedDoc['userID'];
      addTransaction(userID);
    }
  }

  //return list of all documents in food-posts collection posted by user
  static Future<List<DocumentSnapshot<Map<String, dynamic>>>>
      getLocalItems() async {
    String userID = await getUserId();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('food-posts')
        .where('userID', isEqualTo: userID)
        .get();

    List<DocumentSnapshot<Map<String, dynamic>>> docs =
        querySnapshot.docs.where((doc) => doc['status'] != 'closed').toList();
    return docs;
  }

  static Future<void> claimPartialItem(DocumentSnapshot doc) async {
    if (doc.exists) {
      DocumentReference documentReference = doc.reference;

      DocumentSnapshot<Map<String, dynamic>> updatedDoc =
          await documentReference.get()
              as DocumentSnapshot<Map<String, dynamic>>;
      String userID = updatedDoc['userID'];
      addTransaction(userID);
    }
  }

  static Future<void> notFoundItem(DocumentSnapshot doc) async {
    if (doc.exists) {
      DocumentReference documentReference = doc.reference;
      await documentReference.update({'status': 'not_found'});
    }
  }

  static Future<void> deleteItem(DocumentSnapshot doc) async {
    if (doc.exists) {
      DocumentReference documentReference = doc.reference;
      await documentReference.delete();
    }
  }

  static Future<void> addTransaction(String senderID) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      String recipientID = await getUserId();
      Map<String, dynamic> transaction = {
        'senderID': senderID,
        'recipientID': recipientID,
        'timestamp': DateTime.now()
      };
      await firestore.collection('transactions').add(transaction);
    } catch (e) {}
  }

  static Future<int> localItemsPosted() async {
    String userID = await getUserId();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('food-posts')
        .where('userID', isEqualTo: userID)
        .get();

    int count = querySnapshot.size;
    return count;
  }

  static Future<int> localItemsCollected() async {
    String userID = await getUserId();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('transactions')
        .where('recipientID', isEqualTo: userID)
        .get();

    int count = querySnapshot.size;
    return count;
  }

  static Future<int> localPeopleImpacted() async {
    String userID = await getUserId();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('transactions')
        .where('senderID', isEqualTo: userID)
        .get();

    int count = querySnapshot.size;
    return count;
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

  static Future<int> amountOfPosts() async {
    try {
      CollectionReference postsCollection =
          FirebaseFirestore.instance.collection('food-posts');
      QuerySnapshot querySnapshot = await postsCollection.get();
      int count = querySnapshot.size;
      return count;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static Future<int> amountOfTransactions() async {
    try {
      CollectionReference transactionsCollection =
          FirebaseFirestore.instance.collection('transactions');
      QuerySnapshot querySnapshot = await transactionsCollection.get();
      int count = querySnapshot.size;
      return count;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  /*static Future<int> globalPeopleImpacted() async {
    return 1;
    //just return the amount of documents in the transactions colelction
  }*/

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

  //get the email associated from a business userID
  static Future<String> getBusinessEmail(String userID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('users')
          .where('userID', isEqualTo: userID)
          .get()
          .then((value) => value.docs.first);
      return doc['email'];
    } catch (e) {
      return "";
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
