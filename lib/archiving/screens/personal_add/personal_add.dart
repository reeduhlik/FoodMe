import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location_geocoder/location_geocoder.dart';
import '../../../constants.dart';
import '../../../sizeconfig.dart';

class PersonalAdd extends StatefulWidget {
  static String routeName = "/personal_add";
  const PersonalAdd({Key? key}) : super(key: key);

  @override
  State<PersonalAdd> createState() => _InsertDataState();
}

class _InsertDataState extends State<PersonalAdd> {
  final userNameController = TextEditingController();
  final userDescriptionController = TextEditingController();
  final userLocationController = TextEditingController();
  final userTimeController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late DatabaseReference dbRef;

  //Might Delete
  late double _height;
  late double _width;
  late String _setTime, _setDate;
  late String _hour, _minute, _time;
  late String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('food-posts');

    //DateTime Picker initialzeer
    _dateController.text = DateFormat.yMd().format(DateTime.now());
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Using Google Maps API Call to use Google GeoLocation
    const _apiKey = "AIzaSyC0IIiLl6i89dT9IiieDhayF1xcWRJgHs4";
    late LocatitonGeocoder geocoder = LocatitonGeocoder(_apiKey);

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(children: [
          SizedBox(height: SizeConfig.screenHeight * 0.09), // 4%
          Text("Add a listing", style: headingStyle),
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: userNameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
              hintText: 'Enter Your List Title',
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: userDescriptionController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
              hintText: 'Enter Your Event Description',
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: userLocationController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Location',
              hintText: 'Enter Where Your Food Event Is',
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            children: <Widget>[
              Text(
                'Choose Date',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  width: _width / 1.7,
                  height: _height / 10,
                  //margin: EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: TextFormField(
                    style: TextStyle(fontSize: 40),
                    textAlign: TextAlign.center,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _dateController,
                    onSaved: (String? val) {
                      _setDate = val ?? '';
                    },
                    decoration: InputDecoration(
                        disabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                        contentPadding: EdgeInsets.only(top: 0.0)),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'Choose Time',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
              InkWell(
                onTap: () {
                  _selectTime(context);
                },
                child: Container(
                  //margin: EdgeInsets.only(top: 30),
                  margin: EdgeInsets.only(bottom: 30),
                  width: _width / 1.7,
                  height: _height / 10,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: TextFormField(
                    style: TextStyle(fontSize: 40),
                    textAlign: TextAlign.center,
                    onSaved: (String? val) {
                      _setTime = val ?? '';
                    },
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _timeController,
                    decoration: InputDecoration(
                        disabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                        contentPadding: EdgeInsets.all(5)),
                  ),
                ),
              ),
/*
              MaterialButton(
                onPressed: () async {
                  GeoPoint geoPoint = GeoPoint(37.4219999, -122.0840575);

                  String cDate = _dateController.text + " " + _timeController.text; 
                  DateFormat formateDate = DateFormat('M/dd/yyyy hh:mm a');
                  DateTime inputDate = formateDate.parse(cDate);

                  final address = await geocoder.findAddressesFromQuery(userLocationController.text);
                  var place = address.first.coordinates;


                  if(place.latitude != null && place.longitude != null) {
                    double lat = place.latitude!;
                    double lng = place.longitude!;  
                  } else {
                    double lat = 0;
                    double lng = 0;
                  }

                  GeoPoint listing = GeoPoint(place.latitude!, place.longitude!); 
                  Map<String, dynamic> foodPost = {
                    'title': userNameController.text,
                    'description': userDescriptionController.text,
                    'location': listing,
                    'timestamp': inputDate, 
                    'type': 'personal',
                    'place': userLocationController.text, 
                  };
                  await firestore.collection('food-posts').add(foodPost);
                  Navigator.of(context).pop();
                },
                child: const Text('Submit Post'),
                color: Color.fromARGB(255, 252, 130, 0),
                textColor: Colors.white,
                minWidth: 300,
                height: 40,

              ),
*/
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Color.fromARGB(255, 252, 130, 0),
                ),
                child: MaterialButton(
                  onPressed: () async {
                    GeoPoint geoPoint = GeoPoint(37.4219999, -122.0840575);

                    String cDate =
                        _dateController.text + " " + _timeController.text;
                    DateFormat formateDate = DateFormat('M/dd/yyyy hh:mm a');
                    DateTime inputDate = formateDate.parse(cDate);

                    final address = await geocoder
                        .findAddressesFromQuery(userLocationController.text);
                    var place = address.first.coordinates;

                    if (place.latitude != null && place.longitude != null) {
                      double lat = place.latitude!;
                      double lng = place.longitude!;
                    } else {
                      double lat = 0;
                      double lng = 0;
                    }

                    GeoPoint listing =
                        GeoPoint(place.latitude!, place.longitude!);
                    Map<String, dynamic> foodPost = {
                      'title': userNameController.text,
                      'description': userDescriptionController.text,
                      'location': listing,
                      'timestamp': inputDate,
                      'type': 'personal',
                      'place': userLocationController.text,
                    };
                    await firestore.collection('food-posts').add(foodPost);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit Post'),
                  textColor: Colors.white,
                  minWidth: 300,
                  height: 40,
                ),
              ),
            ],
          ),
        ]),
      ),
    ));
  }
}
