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
  String currentAddress = "";
  String destAddress = "";
  double lat = 0;
  double long = 0;
  LatLng currentCoords = new LatLng(0,0);
  LatLng destCoords;
  GoogleMap map;
  bool mapVisible = true;
  GoogleMapController mapController;
  bool validDest = false;

  MyCustomFormState() {
    getLocation();
    // while(currentCoords == LatLng(0,0)){
    //   print("waiting");
    // }
    map = new GoogleMap(
      key: _formKey,
      onMapCreated: _onMapCreated,
      initialCameraPosition:
      CameraPosition(
        target: currentCoords,
        zoom: 11.0,
      ),
    );
  }


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState(){
    super.initState();
    // getLocation();
  }

  void getLocation() async {
    Position coords = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // setState(() {
    //   lat = coords.latitude;
    //   long = coords.longitude;
    //   currentCoords = new LatLng(lat, long);
    // });

    lat = coords.latitude;
    long = coords.longitude;
    currentCoords = new LatLng(lat, long);
    final coordinates = new Coordinates(lat, long);
    print(lat.toString());
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    currentAddress = addresses.first.addressLine;

    // setState(() {
    //   currentAddress = addresses.first.addressLine;
    // });
  }

  void toggleMap(){
    setState(() {
      mapVisible = !mapVisible;
    });
  }

  void getRouteButtonPressed(){
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Planning route...')));
    // toggleMap();

    Set<LatLng> points = new Set<LatLng>();
    points.add(currentCoords);
    Polyline line = new Polyline(polylineId: new PolylineId("route"), );
    map.polylines.add(line);



  }

  void translateDestination() async{
    try{
      var dest = await Geocoder.local.findAddressesFromQuery(destAddress);
      Coordinates coords = dest.first.coordinates;
      double destLat = coords.latitude;
      double destLong = coords.longitude;
      destCoords = new LatLng(destLat, destLong);
      validDest = true;
      print("valid return");
    } catch(e){
      print("Error occurred $e");
      validDest = false;
    }


  }

    @override
    Widget build(BuildContext context) {
      // Build a Form widget using the _formKey created above.
      return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 50),
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
                  currentAddress = value;
                  return null;
                },
                decoration: InputDecoration(
                  hintText: currentAddress,
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
                 destAddress = value;
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
            child: Column(
                children: [
                Container(
                  // margin: EdgeInsets.fromLTRB(0, 50, 0, 100),
                  child: SizedBox(
                  // padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      translateDestination();
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
                  child: map,
                  //   (
                  //   onMapCreated: _onMapCreated,
                  //   initialCameraPosition: CameraPosition(
                  //     target: currentCoords,
                  //     zoom: 11.0,
                  //   ),
                  // ),
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



