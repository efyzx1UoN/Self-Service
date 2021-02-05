import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'taxiPlanner.dart';
import 'main.dart';

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

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  Data _m_data = new Data();
  final _m_startAddressController = TextEditingController();
  final _m_endAddressController = TextEditingController();
  final Geolocator _geolocator  = Geolocator();
  Position _m_startCoordinates ;
  Position _m_destinationCoordinates;
  Set<Marker> _m_markers = {};
  List<LatLng> _m_routeCoords;
  final Set<Polyline> _m_polyline = {};
  List<Placemark> _m_destinationPlacemark;
  String _m_currentLocation = "";
  String _m_startLocationStr = "";
  String _m_endLocationStr = "";
  Location _m_startLocation, _m_endLocation;
  List<Album> _m_directions;
  double _m_lat = 0;
  double _m_long = 0;
  String _m_responseBody = "";
  LatLng _m_locationCoordinates;
  bool _m_mapVisible = true;
  PolylinePoints _m_polylinePoints;
  Map<PolylineId, Polyline> _m_polylines = {};
  List<LatLng> _m_polylineCoordinates = [];
  GoogleMapController _m_mapController;
  GoogleMapPolyline _m_googleMapPolyline = new GoogleMapPolyline(apiKey: "AIzaSyAjBVD5OeZbBKW0o_tOKfcOtuCPVIuyovE");
  GoogleMap _m_map;
  final double ZOOM_DEPTH = 11.0;
  final int POLYLINE_WIDTH = 4;
  final double SIDE_EDGE = 20;
  final double BOTTOM_EDGE = 50;
  final double CONTAINER_ONE_DIMENSION = 400;
  void _onMapCreated(GoogleMapController controller) {
    _m_mapController = controller;
  }

  @override
  void initState(){
    super.initState();
    getLocation();
  }

  void getDirection() async {
    double originLong = _m_startLocation.longitude;
    double originLat = _m_startLocation.latitude;
    double destinationLong = _m_endLocation.longitude;
    double destinationLat = _m_endLocation.latitude;
    final Response response = await get(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$originLong,$originLat&destination=$destinationLong,$destinationLat&key=AIzaSyAjBVD5OeZbBKW0o_tOKfcOtuCPVIuyovE');
    //jsonDecode(response.body);
    _m_responseBody = response.body;
  }

  void getLocation() async {
    Position coords = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _m_lat = coords.latitude;
    _m_long = coords.longitude;
    _m_locationCoordinates = new LatLng(_m_lat, _m_long);

    final coordinates = new Coordinates(_m_lat, _m_long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    setState(() {
      _m_currentLocation = addresses.first.addressLine;
      _m_map = GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        polylines: _m_polyline.toSet(),
        initialCameraPosition: CameraPosition(
          target: _m_locationCoordinates,
          zoom: ZOOM_DEPTH,
        ),
      );
    });
  }

  void setPolylines() async{

    print("start");
    List<Location> startLocations = await locationFromAddress(_m_startLocationStr);
    _m_startLocation = startLocations.first;

    List<Location> endLocations = await locationFromAddress(_m_endLocationStr);
    _m_endLocation = endLocations.first;

    _m_routeCoords = await _m_googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(_m_startLocation.latitude, _m_startLocation.longitude),
        destination: LatLng(_m_endLocation.latitude, _m_endLocation.longitude),
        mode: RouteMode.driving);

    setState(() {
      _m_polyline.add(Polyline(
        polylineId: PolylineId('Your route'),
        visible: true,
        width: POLYLINE_WIDTH,
        points: _m_routeCoords,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,
      ));
    });

    setState(() {
      _m_map = GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        polylines: _m_polyline.toSet(),
        initialCameraPosition: CameraPosition(
          target: _m_locationCoordinates,
          zoom: ZOOM_DEPTH,
        ),
      );

      getDirection();}
    );
    print("end");
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
                      hintText: _m_currentLocation,
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
              child: _m_locationCoordinates == null
                  ? Container()
                  : _m_map,
              height: CONTAINER_ONE_DIMENSION,
              width: CONTAINER_ONE_DIMENSION,
            ),
            Visibility(
                maintainInteractivity: false,
                maintainSize: true,
                maintainState: true,
                maintainAnimation: true,
                visible: !_m_mapVisible,
                child: routeDirections();
            ),
          ],
        ),
      ),
    );
  }
}

