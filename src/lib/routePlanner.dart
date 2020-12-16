import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
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
  final startAddressController = TextEditingController();
  final endAddressController = TextEditingController();
  final Geolocator _geolocator  = Geolocator();
  Position startCoordinates ;
  Position destinationCoordinates;
  Set<Marker> markers = {};
  List<LatLng> routeCoords;
  final Set<Polyline> polyline = {};
  List<Placemark> destinationPlacemark;
  String currentLocation = "";
  String startLocationStr = "";
  String endLocationStr = "";
  Location startLocation, endLocation;
  double lat = 0;
  double long = 0;
  Position _currentPosition;
  LatLng locationCoordinates;
  bool mapVisible = true;
  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  GoogleMapController mapController;
  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: "AIzaSyAjBVD5OeZbBKW0o_tOKfcOtuCPVIuyovE");
  GoogleMap map;

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

    lat = coords.latitude;
    long = coords.longitude;
    locationCoordinates = new LatLng(lat, long);

    final coordinates = new Coordinates(lat, long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    setState(() {
      currentLocation = addresses.first.addressLine;
      map = GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        polylines: polyline.toSet(),
        initialCameraPosition: CameraPosition(
          target: locationCoordinates,
          zoom: 11.0,
        ),
      );
    });

  }

  void setPolylines() async{
    print("start");
    List<Location> startLocations = await locationFromAddress(startLocationStr);
    startLocation = startLocations.first;

    List<Location> endLocations = await locationFromAddress(endLocationStr);
    endLocation = endLocations.first;

    routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(startLocation.latitude, startLocation.longitude),
        destination: LatLng(endLocation.latitude, endLocation.longitude),
        mode: RouteMode.driving);

    setState(() {
      polyline.add(Polyline(
        polylineId: PolylineId('Your route'),
        visible: true,
        width: 4,
        points: routeCoords,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,
      ));
    });

    setState(() {
      map = GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        polylines: polyline.toSet(),
        initialCameraPosition: CameraPosition(
          target: locationCoordinates,
          zoom: 11.0,
        ),
      );}
    );
    print("end");

  }

  void toggleMap(){
    setState(() {
      mapVisible = !mapVisible;
    });
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
            Visibility(
              maintainInteractivity: false,
              maintainSize: false,
              maintainState: true,
              maintainAnimation: true,
              visible: mapVisible,
              child: Column(
                children: <Widget>[
                TextFormField(
                  controller: startAddressController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid address';
                    }
                    data.startingLocation = value;
                    startAddressController.text = value;
                    startLocationStr = value;
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
                  controller: endAddressController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid address';
                    }
                    data.destination = value;
                    endAddressController.text = value;
                    endLocationStr = value;
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
                            setPolylines();
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
              child: locationCoordinates == null
                  ? Container()
                  : map,
              height: 400,
              width: 400,
              ),
            Visibility(
              maintainInteractivity: false,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              visible: !mapVisible,
              child: Column(
                children: [
                  SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                  onPressed: () async {toggleMap();},
                  child: Text('Find New Route'),
                    ),
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


