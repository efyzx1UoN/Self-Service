
import 'package:json_annotation/json_annotation.dart';

part 'train2.g.dart';

@JsonSerializable()
class Results {
  List<Stop> stops;

  Results({this.stops});

  factory Results.fromJson(Map<String, dynamic> json) => _$ResultsFromJson(json);
}

@JsonSerializable()
class Stop {
  String station_name;

  Stop({this.station_name});

  factory Stop.fromJson(Map<String, dynamic> json) => _$StopFromJson(json);
}
