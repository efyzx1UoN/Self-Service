import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/taxi/routeDirections_taxi.dart';
import 'package:flutter_app/taxi/taxiAlbum.dart';
import 'package:flutter_app/taxi/taxiPlanner.dart';
import '../SharedStringData.dart';
import '../geoTracker.dart';
import '../observerState.dart';

/// Class: TaxiPlannerPageState
///
/// Description: State containing all currently active widgets on page and how to
/// operate on them.
class TaxiPlannerPageState extends State<TaxiPlannerPage> {
  String m_startingLocation;
  String m_destination;
  Future<Album> m_futureAlbum;

  @override
  void initState() {
    super.initState();
   m_futureAlbum = fetchAlbum();

  }

  /// Function: PageHome()
  /// Deprecated
  /// Description: returns to home page of the app.
  void _pageHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Taxi Plan"),
      ),
      body: new ListView(
          children: <Widget> [
            RoutePlannerForm_taxi(),
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
            ),
          ]
      ),
    );
  }
}
// ignore: camel_case_types
class RoutePlannerForm_taxi extends StatefulWidget {

  @override
  RoutePlannerFormState_taxi createState() {
    return RoutePlannerFormState_taxi();
  }
}

// ignore: camel_case_types
class RoutePlannerFormState_taxi extends ObserverState {
  final _m_geoTracker = new geoTracker();
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  Data _m_data = new Data();
  final _m_startAddressController = TextEditingController();
  final _m_endAddressController = TextEditingController();
  bool _m_mapVisible = true;

  int m_selectedRouteIndex = 0;
  bool m_routeVisibility = false;
  bool m_stepsVisibility = false;
  bool m_trainVisibility = true;

  @override
  void initState(){
    super.initState();

    setState(() {
      _m_geoTracker.m_listener = this;
      _m_geoTracker.getLocation();
     // _m_travelModeRadio = TravelModeRadio_taxi(this);
    });

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
                        child: Text('Search'),
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
              height: MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width
              //geoTracker.CONTAINER_ONE_DIMENSION,
            ),
            Visibility(
              maintainInteractivity: false,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              visible: !_m_mapVisible,
              child: routeDirections_taxi(this),
            ),
          ],
        ),
      ),
    );
  }

  //TravelModeRadio get m_travelModeRadio_taxi => _m_travelModeRadio;

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

}
