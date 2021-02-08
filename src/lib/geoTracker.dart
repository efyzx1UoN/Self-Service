import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'Album.dart';

class geoTracker {
  PolylinePoints _m_polylinePoints;
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
  String _m_currentLocation = "";
  String _m_startLocationStr = "";
  LatLng _m_locationCoordinates;

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
  Location _m_startLocation, _m_endLocation;
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

  void _onMapCreated(GoogleMapController controller) {
    _m_mapController = controller;
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

    _m_polyline.add(Polyline(
      polylineId: PolylineId('Your route'),
      visible: true,
      width: POLYLINE_WIDTH,
      points: _m_routeCoords,
      color: Colors.blue,
      startCap: Cap.roundCap,
      endCap: Cap.buttCap,
    ));

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

    getDirection();
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