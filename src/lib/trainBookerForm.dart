import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/taxi/taxiPlanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'main.dart';
import 'package:flutter_app/SharedStringData.dart';


class TrainBookerForm extends StatefulWidget {
  @override
  TrainBookerFormState createState() {
    return TrainBookerFormState();
  }

}

class TrainBookerFormState extends State<TrainBookerForm> {
  final M_FORMKEY = GlobalKey<FormState>();
  Data m_data = new Data();
  String m_currentLocation = "";
  bool _hidden = false;
  List<bool> _selections = List.generate(2, (_) => false);
  TimeOfDay _m_selectedTime = TimeOfDay.now();
  String _m_selectedTimeString = TimeOfDay.now().hour.toString()
      +":"+TimeOfDay.now().minute.toString().padLeft(2,'0');
  DateTime _m_selectedDate = DateTime.now();
  String _m_selectedDateString = DateTime.now().day.toString().padLeft(2,'0')
      +"/"+DateTime.now().month.toString()+"/"+DateTime.now().year.toString();
  String _m_selectedTimeStringReturn = TimeOfDay.now().hour.toString()
      +":"+TimeOfDay.now().minute.toString().padLeft(2,'0');
  DateTime _m_selectedDateReturn = DateTime.now();
  String _m_selectedDateStringReturn = DateTime.now().day.toString().padLeft(2,'0')
      +"/"+DateTime.now().month.toString()+"/"+DateTime.now().year.toString();


  @override
  void initState(){
    super.initState();
    getLocation();
  }

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
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    setState(() {
      m_currentLocation = addresses.first.addressLine;
    });

  }
  void showReturn() {
    setState(() {
      _hidden = !_hidden;
    });
  }

  void hiddenReturn() {
    setState(() {
      _hidden = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: new Form(
        key: M_FORMKEY,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid address';
                }
                m_data.setStartingLocation(value);
                return null;
              },
              decoration: InputDecoration(
                hintText: m_currentLocation,
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
                m_data.setDestination(value);
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

                                                 child: Text("Depart at: " + _m_selectedDateString)
                                                        ),
                                                  ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((time) {setState(() {
                                _m_selectedTimeString = time.hour.toString().padLeft(2,'0')
                                    +":"+time.minute.toString().padLeft(2,'0');
                                _m_selectedTime = time;
                              });
                              });
                            },
                            child: Text("Depart at: "+_m_selectedTimeString)
                        ),
                      ),
                       ]
                      ),
            Visibility(
              maintainInteractivity: false,
              maintainSize: false,
              maintainState: true,
              maintainAnimation: true,
              visible: _hidden == true,
                child: Row(
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
                          _m_selectedDateStringReturn = date.day.toString().padLeft(2,'0')
                              +"/"+date.month.toString().padLeft(2,'0')+"/"+date.year.toString();
                          _m_selectedDateReturn = date;
                        });
                        });
                      },

                      child: Text("Return by: " + _m_selectedDateStringReturn)
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((time) {setState(() {
                          _m_selectedTimeStringReturn = time.hour.toString().padLeft(2,'0')
                              +":"+time.minute.toString().padLeft(2,'0');
                          _m_selectedTimeStringReturn = time as String;
                        });
                        });
                      },
                      child: Text("Depart at: "+_m_selectedTimeStringReturn)
                  ),
                ),
              ]
            ),
    ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                child: FlatButton(
                    onPressed: hiddenReturn,
                    color: Colors.black12,
                    padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget> [
                      Text("Single"),
                      Icon(Icons.arrow_forward_outlined),

                    ],
                  ),
                ),
                ),
                Expanded(
                child: FlatButton(
                    onPressed: showReturn,
                    color: Colors.black12,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget> [
                        Text("Return"),
                        Icon(Icons.compare_arrows_outlined),
                      ],
                    )
                ),
                ),
              ],
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
                    if (M_FORMKEY.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Starting Location and Destination Saved.')));
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