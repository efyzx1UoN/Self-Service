import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'taxiPlanner.dart';
import 'routeDirections.dart';
import 'main.dart';
import 'geoTracker.dart';

class RoutePlannerPage extends StatefulWidget {
  RoutePlannerPage({Key key, this.m_title}) : super(key: key);

  final String m_title;

  @override
  _RoutePlannerPageState createState() => _RoutePlannerPageState();

}

class _RoutePlannerPageState extends State<RoutePlannerPage> {
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
            MyCustomForm(),
          ]
      ),
    );
  }
}

class RoutePlannerForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class RoutePlannerFormState extends State<MyCustomForm> {
  final _m_geoTracker = new geoTracker();
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  Data _m_data = new Data();
  final _m_startAddressController = TextEditingController();
  final _m_endAddressController = TextEditingController();
  LatLng _m_locationCoordinates;
  bool _m_mapVisible = true;


  @override
  void initState(){
    super.initState();
    _m_geoTracker.getLocation();
  }

  void toggleMap(){
    setState(() {
      _m_mapVisible = !_m_mapVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      margin: EdgeInsets.fromLTRB(SIDE_EDGE, 0, SIDE_EDGE, BOTTOM_EDGE),
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
                  controller: _m_startAddressController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid address';
                    }
                    _m_data.startingLocation = value;
                    _m_startAddressController.text = value;
                    _m_startLocationStr = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: _m_geoTracker.getCurrentLocation(),
                    labelText: 'From:',
                    border: UnderlineInputBorder(
                    ),
                    fillColor: Colors.white60,
                    filled: false,
                  ),
                ),
                TextFormField(
                  controller: _m_endAddressController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid address';
                    }
                    _m_data.destination = value;
                    _m_endAddressController.text = value;
                    _m_endLocationStr = value;
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
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a Snackbar.
                            _m_geoTracker.setPolylines();
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
              child: _m_locationCoordinates == null
                  ? Container()
                  : _m_geoTracker.getMap(),
              height: CONTAINER_ONE_DIMENSION,
              width: CONTAINER_ONE_DIMENSION,
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

