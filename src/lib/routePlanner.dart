import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'SharedStringData.dart';
import 'routeDirections.dart';
import 'main.dart';
import 'geoTracker.dart';
import 'observerState.dart';
import 'travelModeRadio.dart';
import 'package:path/path.dart' as pth;

/// Class: RoutePlannerPage
///
/// Description: The Route Planner Page
class RoutePlannerPage extends StatefulWidget {
  RoutePlannerPage({Key key, this.m_title}) : super(key: key);
  final String m_title;

  @override
  _RoutePlannerPageState createState() => _RoutePlannerPageState();
}

/// Function: RoutePlannerPageState
///
/// Description: State containing all currently active widgets on page and how to
/// operate on them.
class _RoutePlannerPageState extends ObserverState {
  static const double SIDE_EDGE = 20;
  void _pageHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Route Plan"),
      ),
      body: new ListView(
          children: <Widget> [
            Container(
              margin: const EdgeInsets.fromLTRB(SIDE_EDGE, 0, SIDE_EDGE, 0),
              alignment: Alignment(-1.0,-1.0),
              child: Row(
                children: <Widget>[
                ],
              ),
            ),
            RoutePlannerForm(),
          ]
      ),
    );
  }
}

/// Class: RoutePlannerForm
///
/// Description: The input details form at the top of a RoutePlanner page.
class RoutePlannerForm extends StatefulWidget {
  @override
  RoutePlannerFormState createState() {
    return RoutePlannerFormState();
  }
}

/// Class: RoutePlannerFormState
///
/// Description: State containing all currently active widgets on the form and
/// how to operate on them.
class RoutePlannerFormState extends ObserverState {
  final _m_geoTracker = new geoTracker();
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  Data _m_data = new Data();
  final _m_startAddressController = TextEditingController();
  final _m_endAddressController = TextEditingController();
  bool _m_mapVisible = true;

  TimeOfDay _m_selectedTime = TimeOfDay.now();
  String _m_selectedTimeString = TimeOfDay.now().hour.toString()
      +":"+TimeOfDay.now().minute.toString().padLeft(1);
  DateTime _m_selectedDate = DateTime.now();
  String _m_selectedDateString = DateTime.now().day.toString()
      +"/"+DateTime.now().month.toString()+"/"+DateTime.now().year.toString();
  int m_selectedRouteIndex = 0;
  bool m_routeVisibility = false;
  bool m_stepsVisibility = false;
  bool m_trainVisibility = true;

  TravelModeRadio get m_travelModeRadio => _m_travelModeRadio;

  Data get m_data => _m_data;

  set m_data(Data value) {
    _m_data = value;
  }

  get m_startAddressController => _m_startAddressController;

  get m_endAddressController => _m_endAddressController;

  get m_geoTracker => _m_geoTracker;

  bool get m_mapVisible => _m_mapVisible;

  set m_mapVisible(bool value) {
    _m_mapVisible = value;
  }

  TravelModeRadio _m_travelModeRadio;

  set m_travelModeRadio(TravelModeRadio value) {
    _m_travelModeRadio = value;
  }

  @override
  void initState(){
    super.initState();
    _m_selectedTime = TimeOfDay.now();
    _m_selectedTimeString = TimeOfDay.now().hour.toString().padLeft(2,'0')
        +":"+TimeOfDay.now().minute.toString().padLeft(2,'0');
    _m_selectedDate = DateTime.now();
    _m_selectedDateString = DateTime.now().day.toString().padLeft(2,'0')
        +"/"+DateTime.now().month.toString().padLeft(2,'0')+"/"+DateTime.now().year.toString();
    setState(() {
      _m_geoTracker.m_listener = this;
      _m_geoTracker.getLocation();
      _m_travelModeRadio = TravelModeRadio(this);
    });
    /*
    Future.delayed(const Duration(milliseconds: 5000), () { //This eventually needs to be event driven.
      setState(() {
        print("Test2");
      });
    }
    );*/
  }

  void toggleMap(){
    setState(() {
      _m_mapVisible = !_m_mapVisible;
      if(_m_geoTracker.m_travelMode == 'transit' && _m_geoTracker.m_transitMode == 'train'){
        m_routeVisibility = false;
      }
      else{
        m_routeVisibility = true;
      }
      m_stepsVisibility = false;
      m_trainVisibility = !m_routeVisibility;
    });
  }

  void selectTime() async{
     setState(() async {
       TimeOfDay _m_selectedTime = await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
      );
     _m_selectedTimeString = _m_selectedTime.hour.toString()+":"+_m_selectedTime.minute.toString().padLeft(1);
    });
  }

  void selectDate() async{
    setState(() async {
      DateTime _m_selectedDate = await showDatePicker(
        initialDate: DateTime.now(),
        context: context,
      );
      _m_selectedDateString = _m_selectedDate.day.toString()+"/"+_m_selectedDate.month.toString()+"/"+_m_selectedDate.year.toString();
    });
  }

  void removeUnselectedRoutes(){
    print('Hi\n\n\n\n\n\n\n\n\n\n\n\n');
    m_geoTracker.removeUnselectedRoutes(m_selectedRouteIndex);
  }
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      margin: EdgeInsets.fromLTRB(geoTracker.SIDE_EDGE, 0, geoTracker.SIDE_EDGE, geoTracker.BOTTOM_EDGE),
      child: new Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Visibility(
              maintainInteractivity: false,
              maintainSize: false,
              maintainState: true,
              maintainAnimation: true,
              visible: _m_mapVisible,
              child: Column(
                children: <Widget>[
                TextFormField(
                  key: Key('StartingLocationInput'),
                  controller: _m_startAddressController,
                  validator: (value) {
                    if (value.isEmpty) {
                      print("FORM EMPTY");
                      return 'Please enter a valid address';
                    }
                    _m_data.m_startingLocation = value;
                    _m_startAddressController.text = value;
                    _m_geoTracker.m_startLocationStr = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: _m_geoTracker.m_currentLocation,
                    labelText: 'From:',
                    border: UnderlineInputBorder(
                    ),
                    fillColor: Colors.white60,
                    filled: false,
                  ),
                ),
                TextFormField(
                  key: Key('DestinationInput'),
                  controller: _m_endAddressController,
                  validator: (value) {
                    if (value.isEmpty) {
                      print("FORM EMPTY");
                      return 'Please enter a valid address';
                    }
                    _m_data.m_destination = value;
                    _m_endAddressController.text = value;
                    // _m_endLocationStr = value;
                    _m_geoTracker.setEndLocationStr(value);
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
                                if (date!=null) {
                                  _m_selectedDateString =
                                      date.day.toString().padLeft(2, '0')
                                          + "/" + date.month.toString().padLeft(
                                          2, '0') + "/" + date.year.toString();
                                  _m_selectedDate = date;
                                }
                              });
                              });
                            },
                            child: Text("Depart on: "+_m_selectedDateString)
                        ),
                        ),

                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((time) {setState(() {
                                  if (time!=null) {
                                    _m_selectedTimeString =
                                        time.hour.toString().padLeft(2, '0')
                                            + ":" +
                                            time.minute.toString().padLeft(
                                                2, '0');
                                    _m_selectedTime = time;
                                  }
                                });
                                });
                              },
                              child: Text("Depart at: "+_m_selectedTimeString)
                          ),
                        ),
                  ]
                  ),
                  _m_travelModeRadio,
                  Container(
                    // margin: EdgeInsets.fromLTRB(0, 50, 0, 100),
                    child: SizedBox(
                      // padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                      width: double.infinity,
                      child: ElevatedButton(
                        key: Key("LocationInputButton"),
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          if (_formKey.currentState.validate()) {
                            print("TESTING");
                            // If the form is valid, display a Snackbar.
                            setState(() {
                              _m_geoTracker.setPolylines();
                              // _m_geoTracker.getRoutes();
                            });
                            toggleMap();
                          }},
                        child: Text('Find Route'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: _m_geoTracker.m_locationCoordinates == null
                  ? Container()
                  : _m_geoTracker.m_map,
              height: geoTracker.CONTAINER_ONE_DIMENSION,
              width: geoTracker.CONTAINER_ONE_DIMENSION,
              ),
              Visibility(
              maintainInteractivity: false,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              visible: !_m_mapVisible,
              child: routeDirections(this),
            ),
          ],
        ),
      ),
    );
  }
}


