import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/distant_google.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_util/google_maps_util.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'Album.dart';
import 'observerState.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/route.dart';

/// Class: geoTracker
///
/// Description: Receive user start location and end location and setup the data
/// needed for displaying the results to user
class geoTracker {
  List<MapRoute> m_routes;
  PolylinePoints _m_polylinePoints;
  // List<LatLng> m_routeCoords2 = [];
  Map<PolylineId, Polyline> _m_polylines = {};
  List<LatLng> _m_polylineCoordinates = [];
  Position _m_startCoordinates ;
  Position _m_destinationCoordinates;
  Set<Marker> _m_markers = {};
  GoogleMapController _m_mapController;
  List<Album> _m_directions;
  double _m_lat = 0;
  double _m_long = 0;
  String _m_responseBody = "";
  List<Placemark> _m_destinationPlacemark;
  GoogleMapPolyline _m_googleMapPolyline = new GoogleMapPolyline(apiKey: "AIzaSyAjBVD5OeZbBKW0o_tOKfcOtuCPVIuyovE");
  GoogleMap _m_map;
  final double ZOOM_DEPTH = 11.0;
  final int POLYLINE_WIDTH = 4;
  static final double SIDE_EDGE = 20;
  static final double BOTTOM_EDGE = 50;
  static final double CONTAINER_ONE_DIMENSION = 400;
  static final double PIXELS_PER_MILE = 156543.03392;
  static final double ZOOM_BASE = 14.2;
  static final double ZOOM_COEFFICIENT = 8;
  static final double ZOOM_OFFSET = 8;
  static final int HTTP_OKAY = 200;
  static final int COLOR_GRADIANT = 200;
  String _m_currentLocation = "";
  String _m_startLocationStr = "";
  LatLng _m_locationCoordinates;
  ObserverState _m_listener;

  // travel mode corresponds to driving, transit, walking
  String m_travelMode = "transit";
  // If the travel mode is transit, transit mode corresponds to train, bus
  String m_transitMode = "train";

  int m_numOfRoutes;

  State get m_listener => _m_listener;

  set m_listener(State value) {
    _m_listener = value;
  }

  LatLng get m_locationCoordinates => _m_locationCoordinates;

  set m_locationCoordinates(LatLng value) {
    _m_locationCoordinates = value;
  }

  String get m_startLocationStr => _m_startLocationStr;

  set m_startLocationStr(String value) {
    _m_startLocationStr = value;
  }

  PolylinePoints get m_polylinePoints => _m_polylinePoints;

  set m_polylinePoints(PolylinePoints value) {
    _m_polylinePoints = value;
  }

  String _m_endLocationStr = "";
  Location _m_startLocation = new Location(longitude: 0, latitude: 0), _m_endLocation = new Location(longitude: 0, latitude: 0);
  final Geolocator _geolocator  = Geolocator();
  List<LatLng> _m_routeCoords;
  final Set<Polyline> _m_polyline = {};

  String get m_endLocationStr => _m_endLocationStr;

  void setEndLocationStr(endLocationStr){
    _m_endLocationStr = endLocationStr;
  }

  void setCurrentLocation(String location){
    _m_currentLocation = location;
  }

  /// Function: getLocation()
  ///
  /// Description: Get user's current location from Geolocator
  void getLocation() async {
      Position coords = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _m_lat = coords.latitude;
      _m_long = coords.longitude;
      _m_locationCoordinates = new LatLng(_m_lat, _m_long);

      final coordinates = new Coordinates(_m_lat, _m_long);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

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

      _m_listener.update();
    }

  void _onMapCreated(GoogleMapController controller) {
    _m_mapController = controller;
    _m_listener.update();
  }

  /// Function: setPolylines()
  ///
  /// Description: Display the polylines on google map after calling getRoutes()
  void setPolylines() async{
    print("start");
    _m_polyline.clear();
    List<Location> startLocations = await locationFromAddress(_m_startLocationStr);
    _m_startLocation = startLocations.first;

    List<Location> endLocations = await locationFromAddress(_m_endLocationStr);
    _m_endLocation = endLocations.first;

    /*
    _m_routeCoords = await _m_googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(_m_startLocation.latitude, _m_startLocation.longitude),
        destination: LatLng(_m_endLocation.latitude, _m_endLocation.longitude),
        mode: RouteMode.driving);
     */

    // m_routeCoords2.add(LatLng(37.368851,-122.0363436));
    // m_routeCoords2.add(LatLng(37.3784344,-122.0307968));
    // m_routeCoords2.add(LatLng(37.3784344,-122.0307968));
    // m_routeCoords2.add(LatLng(37.42937000000001,-122.14193));
    // m_routeCoords2.add(LatLng(37.4291335,-122.1419519 ));
    // m_routeCoords2.add(LatLng(37.4419482,-122.1429522));
    // print(_m_startLocation.latitude);
    // print(_m_startLocation.longitude);
    // print(_m_endLocation.latitude);
    // print(_m_endLocation.longitude);
    print('Hello\n');

    /*
    _m_polyline.add(Polyline(
      polylineId: PolylineId('Your routeX'),
      visible: true,
      width: POLYLINE_WIDTH,
      points: _m_routeCoords,
      color: Colors.pink,
      startCap: Cap.roundCap,
      endCap: Cap.buttCap,
    ));
    */

    m_routes = await getRoutes();
    print("Hi\n\n");
    for(MapRoute route in m_routes){
      for(Legs leg in route.legs){
        for(Steps step in leg.steps){
          print("This\n");
          print(step.polyline.points+"\n");
        }
      }
    }

    _m_map = GoogleMap(
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
      mapType: MapType.normal,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      scrollGesturesEnabled: true,
      polylines: _m_polyline.toSet(),
      initialCameraPosition: CameraPosition(
        target: _m_locationCoordinates,
        zoom: ZOOM_DEPTH,
      ),
    );
    
    LatLng middlePoint = new LatLng((_m_startLocation.latitude+_m_endLocation.latitude)/2, (_m_startLocation.longitude+_m_endLocation.longitude)/2);
    double x = (_m_startLocation.latitude-_m_endLocation.latitude).abs()*(_m_startLocation.latitude-_m_endLocation.latitude).abs();
    double y = (_m_startLocation.longitude-_m_endLocation.longitude).abs()*(_m_startLocation.longitude-_m_endLocation.longitude).abs();
    double zoom = PIXELS_PER_MILE * cos(ZOOM_COEFFICIENT*sqrt(x+y)*pi/180)/pow(2, ZOOM_BASE);
    print("x:"+x.toString()+" y:"+y.toString()+" zoom: "+zoom.toString());

    await _m_mapController.animateCamera(CameraUpdate.newLatLngZoom(middlePoint, zoom));

    _m_listener.update();

  }

    /// Function: getRoutes()
    ///
    /// Description: Parse json data, set up corresponding polylines and return the
    /// json response in a list
    Future<List<MapRoute>> getRoutes() async {
    double originLong = _m_startLocation.longitude;
    double originLat = _m_startLocation.latitude;
    double destinationLong = _m_endLocation.longitude;
    double destinationLat = _m_endLocation.latitude;
    //request the json response for different routes
    http.Response response = await get(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$originLat,$originLong&destination=$destinationLat,$destinationLong&region=uk&key=AIzaSyAjBVD5OeZbBKW0o_tOKfcOtuCPVIuyovE&alternatives=true&mode=$m_travelMode&transit_mode=$m_transitMode');
    print("$m_travelMode&transit_mode=$m_transitMode");
    // if the data is valid
    if (response.statusCode == HTTP_OKAY){
        Map routesData = jsonDecode(response.body);
        print("Length of body:" + response.body.length.toString());
        List<dynamic> routesList = routesData["routes"];
        print(routesData);
        print(routesList);
        // sort the response in order of travel duration (shortest to longest)
        routesList.sort((a,b) => a['legs'][0]['duration']['value'].toString().compareTo(b['legs'][0]['duration']['value'].toString()));
        print(" ");
        m_numOfRoutes = routesList.length;
        print("number of routes: " + m_numOfRoutes.toString());
        //for each route
        for(int i=0;i<m_numOfRoutes;i++){
          print("STRING: "+routesList[i]['legs'][0]['duration']['value'].toString());
          List<dynamic> steps = routesList[i]['legs'][0]['steps'];
          int num_steps = steps.length;
          List<LatLng> coords = List<LatLng> ();
          //print("Route "+i.toString()+" has " + num_steps.toString()+'steps\n');

          //add the coords of start and end of each step into the list
          for(int j = 0;j<num_steps;j++){

            PolyUtil points = PolyUtil();
            List<LatLng> pointList = points.decode(steps[j]['polyline']['points']);

            double sLat = steps[j]['start_location']['lat'];
            double sLng = steps[j]['start_location']['lng'];

            coords.add(LatLng(sLat, sLng));
            double dLat = steps[j]['end_location']['lat'];
            double dLng = steps[j]['end_location']['lng'];

            for (int k=0; k < pointList.length ; k++){
              coords.add(pointList[k]);
            }

            coords.add(LatLng(dLat, dLng));
            print("Step "+j.toString()+": from " + coords[2*j].latitude.toString()+coords[2*j].longitude.toString()+" to "+dLat.toString()+dLng.toString()+'\n');
          }
          double dLat = steps[num_steps-1]['end_location']['lat'];
          double dLng = steps[num_steps-1]['end_location']['lng'];
          coords.add(LatLng(dLat, dLng));
          for(LatLng coord in coords){
            print(coord.latitude.toString() + '   ' + coord.longitude.toString()+"\n");
          }
          if (i==0) {
            _m_polyline.add(Polyline(
              polylineId: PolylineId('Your route ' + 0.toString()),
              visible: true,
              width: POLYLINE_WIDTH,
              points: coords,
              color: Colors.red,
              startCap: Cap.roundCap,
              endCap: Cap.buttCap,
            ));
          }

          //print(coords.length.toString()+"\n");
          _m_polyline.add(Polyline(
            polylineId: PolylineId('Your route '+i.toString()),
            visible: true,
            width: (i==0) ? POLYLINE_WIDTH*2 : POLYLINE_WIDTH,
            points: coords,
            color: (i==0) ? Colors.pink : Colors.blue[COLOR_GRADIANT+i*COLOR_GRADIANT],
            startCap: Cap.roundCap,
            endCap: Cap.buttCap,
          ));
          print("End of steps loop\n");
        }



        List<MapRoute> mapper = routesList.map((json) => MapRoute.fromJson(json)).toList();

        return routesList.map((json) => MapRoute.fromJson(json)).toList();
    }else{
      //throw Exception("Something went wrong, ${response.statusCode}");
    }
  }

  Map<PolylineId, Polyline> get m_polylines => _m_polylines;

  set m_polylines(Map<PolylineId, Polyline> value) {
    _m_polylines = value;
  }

  List<LatLng> get m_polylineCoordinates => _m_polylineCoordinates;

  set m_polylineCoordinates(List<LatLng> value) {
    _m_polylineCoordinates = value;
  }

  Position get m_startCoordinates => _m_startCoordinates;

  set m_startCoordinates(Position value) {
    _m_startCoordinates = value;
  }

  Position get m_destinationCoordinates => _m_destinationCoordinates;

  set m_destinationCoordinates(Position value) {
    _m_destinationCoordinates = value;
  }

  Set<Marker> get m_markers => _m_markers;

  set m_markers(Set<Marker> value) {
    _m_markers = value;
  }

  GoogleMapController get m_mapController => _m_mapController;

  set m_mapController(GoogleMapController value) {
    _m_mapController = value;
  }

  List<Album> get m_directions => _m_directions;

  set m_directions(List<Album> value) {
    _m_directions = value;
  }

  double get m_lat => _m_lat;

  set m_lat(double value) {
    _m_lat = value;
  }

  double get m_long => _m_long;

  set m_long(double value) {
    _m_long = value;
  }

  String get m_responseBody => _m_responseBody;

  set m_responseBody(String value) {
    _m_responseBody = value;
  }

  List<Placemark> get m_destinationPlacemark => _m_destinationPlacemark;

  set m_destinationPlacemark(List<Placemark> value) {
    _m_destinationPlacemark = value;
  }

  GoogleMapPolyline get m_googleMapPolyline => _m_googleMapPolyline;

  set m_googleMapPolyline(GoogleMapPolyline value) {
    _m_googleMapPolyline = value;
  }

  GoogleMap get m_map => _m_map;

  set m_map(GoogleMap value) {
    _m_map = value;
  }

  String get m_currentLocation => _m_currentLocation;

  set m_currentLocation(String value) {
    _m_currentLocation = value;
  }

  Location get m_startLocation => _m_startLocation;

  set m_startLocation(Location value) {
    _m_startLocation = value;
  }

  get m_endLocation => _m_endLocation;

  set m_endLocation(value) {
    _m_endLocation = value;
  }

  Geolocator get geolocator => _geolocator;

  List<LatLng> get m_routeCoords => _m_routeCoords;

  set m_routeCoords(List<LatLng> value) {
    _m_routeCoords = value;
  }

  Set<Polyline> get m_polyline => _m_polyline;
}