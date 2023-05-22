import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:date_format/date_format.dart';
import 'package:gsc2023_food_app/texts.dart';
import 'package:intl/intl.dart';
import 'package:location_geocoder/location_geocoder.dart';
import '../../../constants.dart';

Future<void> displayPostDialogue(BuildContext context) async {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    ),
    clipBehavior: Clip.hardEdge,
    context: context,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return BusinessAdd();
          },
        ),
      );
    },
  );
}

class BusinessAdd extends StatefulWidget {
  const BusinessAdd({Key? key}) : super(key: key);

  @override
  State<BusinessAdd> createState() => _InsertDataState();
}

class _InsertDataState extends State<BusinessAdd> {
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
    final LocatitonGeocoder geocoder = LocatitonGeocoder(_apiKey);

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              HeaderText(text: "Add a Listing"),
              const Spacer(),
              SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      controller: userNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                        hintText: 'Enter Your List Title',
                      ),
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
                    TextField(
                      controller: userLocationController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Location',
                        hintText: 'Enter Where Your Food Event Is',
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ItalicizedText(text: "Choose Time"),
              GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  width: constraints.maxWidth * 0.75,
                  height: constraints.maxHeight * 0.125,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    style: TextStyle(fontSize: 25),
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
                      contentPadding: EdgeInsets.only(top: 0.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ItalicizedText(text: "Choose Time"),
              GestureDetector(
                onTap: () {
                  _selectTime(context);
                },
                child: Container(
                  width: constraints.maxWidth * 0.75,
                  height: constraints.maxHeight * 0.125,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                    onSaved: (String? val) {
                      _setTime = val ?? '';
                    },
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _timeController,
                    decoration: InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(5),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  String cDate =
                      _dateController.text + " " + _timeController.text;
                  DateFormat formateDate = DateFormat('M/dd/yyyy hh:mm a');
                  DateTime inputDate = formateDate.parse(cDate);
                  final address = await geocoder
                      .findAddressesFromQuery(userLocationController.text);
                  var place = address.first.coordinates;
                  GeoPoint listing =
                      GeoPoint(place.latitude!, place.longitude!);
                  Map<String, dynamic> foodPost = {
                    'title': userNameController.text,
                    'description': userDescriptionController.text,
                    'location': listing,
                    'timestamp': inputDate,
                    'type': 'business', //TODO: GET WHAT TYPE OF USER
                    'place': userLocationController.text,
                  };
                  await firestore.collection('food-posts').add(foodPost);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: constraints.maxWidth * 0.9,
                  height: constraints.maxHeight * 0.075,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Color.fromARGB(255, 252, 130, 0),
                  ),
                  child: const PrimaryText(
                    text: "Submit Post",
                    color: white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
