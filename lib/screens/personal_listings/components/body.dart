import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:location_geocoder/location_geocoder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter StreamBuilder Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
    final CollectionReference<Map<String, dynamic>> foodPostRef =
    FirebaseFirestore.instance.collection('food-posts');
    @override
    Widget build(BuildContext context) {
    const _apiKey = 'AIzaSyC0IIiLl6i89dT9IiieDhayF1xcWRJgHs4';
    final LocatitonGeocoder geocoder = LocatitonGeocoder(_apiKey);
    return Scaffold (
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: foodPostRef.snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else 
                return ListView(
                children: snapshot.data!.docs.map((doc) {
                Timestamp? time = doc.data()['timestamp'];
                DateTime timeDate = time!.toDate();
                String fdatetime = DateFormat('MM-dd-yyyy hh:mm a').format(timeDate);

                String? description = doc.data()['description'];
                String? place = doc.data()['place']; 
                
                String type = doc.data()['type']; 
                if(type == 'personal') {
                  return Card(
                  child: ListTile(
                    title: Text(doc.data()['title']),
                    subtitle: description != null ? Text('Description: $description\n' 'Time: $fdatetime\n' 'Address: $place') : null,
                  ),
                );
                } else {
                  return Card();
                }
              }).toList(),
            );
          } 
      )
    );
  } 
}




