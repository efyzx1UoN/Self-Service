
import 'package:json_annotation/json_annotation.dart';

part 'train.g.dart';

@JsonSerializable()
class Results {
  String station_name;
  String station_code;
  Departures departures;

  Results({this.station_name, this.station_code, this.departures});

  factory Results.fromJson(Map<String, dynamic> json) => _$ResultsFromJson(json);
}



@JsonSerializable()
class Departures {
  List<Train> all;

  Departures({this.all});

  factory Departures.fromJson(Map<String, dynamic> json) => _$DeparturesFromJson(json);
}

@JsonSerializable()
class Train {
  String aimed_departure_time;
  String destination_name;
  String service;
  String train_uid;
  StationDetail station_detail;


  Train({this.aimed_departure_time, this.destination_name, this.service, this.train_uid, this.station_detail});

  factory Train.fromJson(Map<String, dynamic> json) => _$TrainFromJson(json);

}

@JsonSerializable()
class StationDetail {
  List<Station> calling_at;

  StationDetail({this.calling_at});

  factory StationDetail.fromJson(Map<String, dynamic> json) => _$StationDetailFromJson(json);
}

@JsonSerializable()
class Station {
  String station_name;
  String platform;
  String station_code;
  String aimed_arrival_time;
  String aimed_departure_time;
  String aimed_pass_time;

  Station({this.station_name, this.platform, this.station_code, this.aimed_arrival_time,
  this.aimed_departure_time, this.aimed_pass_time});

  factory Station.fromJson(Map<String, dynamic> json) => _$StationFromJson(json);
}