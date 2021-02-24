import 'package:json_annotation/json_annotation.dart';

part 'route.g.dart';

@JsonSerializable()
class MapRoute {
  final Bound bounds;
  final String copyrights;
  final List<Legs> legs;

  MapRoute({this.bounds, this.copyrights, this.legs});

  factory MapRoute.fromJson(Map<String, dynamic> json) => _$MapRouteFromJson(json);

  Map<String, dynamic> toJson() => _$MapRouteToJson(this);
}

@JsonSerializable()
class Bound{
  final NorthEast northeast;
  final SouthWest southwest;

  Bound({this.northeast, this.southwest});
  factory Bound.fromJson(Map<String, dynamic> json) => _$BoundFromJson(json);
  Map<String, dynamic> toJson() => _$BoundToJson(this);
}

@JsonSerializable()
class NorthEast {
  double lat;
  double long;

  NorthEast({this.lat, this.long});
  factory NorthEast.fromJson(Map<String, double> json) => _$NorthEastFromJson(json);
}

@JsonSerializable()
class SouthWest {
  double lat;
  double long;

  SouthWest({this.lat, this.long});
  factory SouthWest.fromJson(Map<String, double> json) => _$SouthWestFromJson(json);
}

@JsonSerializable()
class Legs {
  final Distance distance;
  final Duration duration;
  final String end_address;
  final EndLocation end_location;
  final String start_address;
  final StartLocation start_location;
  final TransitDetails transit_details;
  final List<Steps> steps;

  Legs({this.distance, this.duration, this.end_address, this.end_location, this.start_address,
      this.start_location, this.transit_details, this.steps});
  factory Legs.fromJson(Map<String, dynamic> json) => _$LegsFromJson(json);
}

// @JsonSerializable()
// class LegsList{
//   final List<Legs> legList;
//
//   LegsList({this.legList});
//   factory LegsList.fromJson(Map<String, dynamic> json) => _$LegsListFromJson(json);
// }

@JsonSerializable()
class Distance {
  String text;
  int value;

  Distance({this.text, this.value});
  factory Distance.fromJson(Map<String, dynamic> json) => _$DistanceFromJson(json);
}

@JsonSerializable()
class Duration {
  String text;
  int value;

  Duration({this.text, this.value});
  factory Duration.fromJson(Map<String, dynamic> json) => _$DurationFromJson(json);
}

@JsonSerializable()
class EndLocation {
  double lat;
  double long;

  EndLocation({this.lat, this.long});
  factory EndLocation.fromJson(Map<String, double> json) => _$EndLocationFromJson(json);

}

@JsonSerializable()
class StartLocation {
  double lat;
  double long;

  StartLocation({this.lat, this.long});
  factory StartLocation.fromJson(Map<String, double> json) => _$StartLocationFromJson(json);
}

@JsonSerializable()
class Steps {
  Distance distance;
  Duration duration;
  EndLocation end_location;
  String html_instructions;
  String maneuver;
  PolyLine polyline;
  StartLocation start_location;
  String travel_mode;

  Steps({this.distance, this.duration, this.end_location, this.html_instructions, this.maneuver, this.polyline, this.start_location, this.travel_mode});
  factory Steps.fromJson(Map<String, dynamic> json) => _$StepsFromJson(json);
}

@JsonSerializable()
class PolyLine {
  String points;

  PolyLine({this.points});
  factory PolyLine.fromJson(Map<String, String> json) => _$PolyLineFromJson(json);
}

@JsonSerializable()
class ArrivalTime {
  String text;
  String time_zone;
  double value;

  ArrivalTime({this.text, this.time_zone, this.value});
  factory ArrivalTime.fromJson(Map<String, dynamic> json) => _$ArrivalTimeFromJson(json);
}

@JsonSerializable()
class DepartureTime {
  String text;
  String time_zone;
  double value;

  DepartureTime({this.text, this.time_zone, this.value});
  factory DepartureTime.fromJson(Map<String, dynamic> json) => _$DepartureTimeFromJson(json);
}

@JsonSerializable()
class Agency {
  String name;
  String phone;
  String url;

  Agency({this.name, this.phone, this.url});
  factory Agency.fromJson(Map<String, dynamic> json) => _$AgencyFromJson(json);
}

@JsonSerializable()
class Vehicle {
  String icon;
  String local_icon;
  String name;
  String type;

  Vehicle({this.icon, this.local_icon, this.name, this.type});
  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
}

@JsonSerializable()
class Line {
  List<Agency> agencies;
  String color;
  String name;
  String short_name;
  String text_color;
  Vehicle vehicle;

  Line({this.agencies, this.color, this.name, this.short_name, this.text_color, this.vehicle});
  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);
}


@JsonSerializable()
class ArrivalStop {
  double lat;
  double long;

  ArrivalStop({this.lat, this.long});
  factory ArrivalStop.fromJson(Map<String, double> json) => _$ArrivalStopFromJson(json);

}

@JsonSerializable()
class DepartureStop {
  double lat;
  double long;

  DepartureStop({this.lat, this.long});
  factory DepartureStop.fromJson(Map<String, double> json) => _$DepartureStopFromJson(json);
}

@JsonSerializable()
class TransitDetails {
  ArrivalStop arrival_stop = ArrivalStop();
  ArrivalTime arrival_time = ArrivalTime();
  DepartureStop departure_stop = DepartureStop();
  DepartureTime departure_time = DepartureTime();
  String headsign;
  Line line = Line();

  TransitDetails({this.arrival_stop, this.arrival_time, this.departure_stop, this.departure_time, this.headsign, this.line});
  factory TransitDetails.fromJson(Map<String, dynamic> json) => _$TransitDetailsFromJson(json);
}

