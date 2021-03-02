
import 'package:json_annotation/json_annotation.dart';

part 'train.g.dart';

@JsonSerializable()
class Train {
  String aimed_departure_time;
  String destination_name;
  Map<String, dynamic> station_detail;

  Train({this.aimed_departure_time, this.destination_name, this.station_detail});

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