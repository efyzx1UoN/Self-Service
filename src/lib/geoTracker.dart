import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
  final double SIDE_EDGE = 20;
  final double BOTTOM_EDGE = 50;
  final double CONTAINER_ONE_DIMENSION = 400;
  String _m_currentLocation = "";
  String _m_startLocationStr = "";
  String _m_endLocationStr = "";
  Location _m_startLocation, _m_endLocation;
  final Geolocator _geolocator  = Geolocator();
  List<LatLng> _m_routeCoords;
  final Set<Polyline> _m_polyline = {};

  String getMap()

  String getCurrentLocation(){
    return _m_currentLocation;
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
  }
}