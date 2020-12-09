import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'taxiPlanner.dart';
import 'main.dart';

class RoutePlannerPage extends StatefulWidget {
  RoutePlannerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RoutePlannerPageState createState() => _RoutePlannerPageState();

}

class _RoutePlannerPageState extends State<RoutePlannerPage> {
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
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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

  class MyCustomForm extends StatefulWidget {
    @override
    MyCustomFormState createState() {
      return MyCustomFormState();
    }

  }
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  Data data = new Data();
  String currentLocation = "";
  double lat = 0;
  double long = 0;
  LatLng locationCoordinates;
  bool mapVisible = false;

  GoogleMapController mapController;


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState(){
    super.initState();
    getLocation();
  }

  void getLocation() async {
    Position coords = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = coords.latitude;
      long = coords.longitude;
      locationCoordinates = new LatLng(lat, long);
    });
    final coordinates = new Coordinates(lat, long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    setState(() {
      currentLocation = addresses.first.addressLine;
    });
  }

  void toggleMap(){
    mapVisible = !mapVisible;
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
                  data.startingLocation = value;
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
                 data.destination = value;
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

          Visibility(
            maintainInteractivity: false,
            maintainSize: true,
            maintainState: true,
            maintainAnimation: true,
            visible: mapVisible,
            child: Stack(
                children: [
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
                            .showSnackBar(SnackBar(content: Text('Planning route...')));
                            toggleMap();
                            //Navigator.pop(context, data);
                      }
                    },
                    child: Text('Find Route'),
                  ),
                ),
                ),
                SizedBox(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: locationCoordinates,
                      zoom: 11.0,
                    ),
                  ),
                  height: 400,
                  width: 400,
                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }



