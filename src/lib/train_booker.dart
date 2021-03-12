import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/taxi/taxiAlbum.dart';
import 'package:flutter_app/taxi/taxiPlanner.dart';
import 'package:flutter_app/trainMapManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'main.dart';
import 'package:flutter_app/trainBookerForm.dart';
import 'package:flutter_app/SharedStringData.dart';


/// Class: TrainBookerPage
///
/// Description: Train Booker Page.
class Train_BookerPage extends StatefulWidget {
  Train_BookerPage({Key key, this.M_TITLE}) : super(key: key);

  final String M_TITLE;

  @override
  _Train_BookerPageState createState() => _Train_BookerPageState();

}

/// Class: TrainBookerPageState
///
/// Description: State containing all currently active widgets and how to
/// operate on them.
class _Train_BookerPageState extends State<Train_BookerPage> {
  String m_startingLocation;
  String m_destination;
  Future<Album> m_futureAlbum;

  @override
  void initState() {
    super.initState();
    //m_futureAlbum = fetchAlbum();
    TrainMapManager.instance; //Initialise train codes.
  }

  /// Function: pageHome
  /// Deprecated
  /// Description: Returns to the home page of the app.
  void _pageHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Train Plan"),
      ),
      body: new ListView(
          children: <Widget> [
            TrainBookerForm(),
            /*
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment(-1.0,-1.0),
              child: Row(
                children: <Widget>[
                  FutureBuilder<Album>(
                    future: m_futureAlbum,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data.m_title);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      // By default, show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),*/
          ]
      ),
    );
  }
}


/// Class: MyCustomForm
///
/// Description: Creates form for selecting travel times.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }

}

/// Class: MyCustomFormState
///
/// Description: State containing all currently active widgets and how to
/// operate on them.
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  Data data = new Data();
  String currentLocation = "";
  TimeOfDay _m_selectedTime = TimeOfDay.now();
  String _m_selectedTimeString = TimeOfDay.now().hour.toString()
      +":"+TimeOfDay.now().minute.toString().padLeft(1);
  DateTime _m_selectedDate = DateTime.now();
  String _m_selectedDateString = DateTime.now().day.toString()
      +"/"+DateTime.now().month.toString()+"/"+DateTime.now().year.toString();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  /// Function: getLocation
  ///
  /// Description: Receive Co-ordinates from Geolocator and update global state.
  void getLocation() async {
    double lat;
    double long;

    Position coords = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = coords.latitude;
      long = coords.longitude;
    });
    final coordinates = new Coordinates(lat, long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);

    setState(() {
      currentLocation = addresses.first.addressLine;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: new Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid address';
                }
                data.setStartingLocation(value);
                return null;
              },
              decoration: InputDecoration(
                hintText: currentLocation,
                labelText: 'From:',
                border: UnderlineInputBorder(
                ),
                fillColor: Colors.white60,
                filled: false,
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid address';
                }
                data.setDestination(value);
                return null;
              },
              decoration: InputDecoration(
                labelText: 'To:',
                hintText: 'Destination',
                border: UnderlineInputBorder(),
                alignLabelWithHint: true,
                fillColor: Colors.white60,
                filled: false,
              ),
            ),

            Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          ).then((date) {setState(() {
                            _m_selectedDateString = date.day.toString().padLeft(2,'0')
                                +"/"+date.month.toString().padLeft(2,'0')+"/"+date.year.toString();
                            _m_selectedDate = date;
                          });
                          });
                        },

                        child: Text("Depart at: ")
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          ).then((date) {setState(() {
                            _m_selectedDateString = date.day.toString().padLeft(2,'0')
                                +"/"+date.month.toString().padLeft(2,'0')+"/"+date.year.toString();
                            _m_selectedDate = date;
                          });
                          });
                        },

                        child: Text("Depart at: ")
                    ),
                  ),
                ]
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: SizedBox(
                // padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(
                          'Starting Location and Destination Saved.')));
                    }
                  },
                  child: Text('Update Route'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

