// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'train.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Results _$ResultsFromJson(Map<String, dynamic> json) {
  return Results(
    station_name: json['station_name'] as String,
    station_code: json['station_code'] as String,
    departures: json['departures'] == null
        ? null
        : Departures.fromJson(json['departures'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ResultsToJson(Results instance) => <String, dynamic>{
      'station_name': instance.station_name,
      'station_code': instance.station_code,
      'departures': instance.departures,
    };

Departures _$DeparturesFromJson(Map<String, dynamic> json) {
  return Departures(
    all: (json['all'] as List)
        ?.map(
            (e) => e == null ? null : Train.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DeparturesToJson(Departures instance) =>
    <String, dynamic>{
      'all': instance.all,
    };

Train _$TrainFromJson(Map<String, dynamic> json) {
  return Train(
    aimed_departure_time: json['aimed_departure_time'] as String,
    destination_name: json['destination_name'] as String,
    station_detail: json['station_detail'] == null
        ? null
        : StationDetail.fromJson(
            json['station_detail'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TrainToJson(Train instance) => <String, dynamic>{
      'aimed_departure_time': instance.aimed_departure_time,
      'destination_name': instance.destination_name,
      'station_detail': instance.station_detail,
    };

StationDetail _$StationDetailFromJson(Map<String, dynamic> json) {
  return StationDetail(
    calling_at: (json['calling_at'] as List)
        ?.map((e) =>
            e == null ? null : Station.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$StationDetailToJson(StationDetail instance) =>
    <String, dynamic>{
      'calling_at': instance.calling_at,
    };

Station _$StationFromJson(Map<String, dynamic> json) {
  return Station(
    station_name: json['station_name'] as String,
    platform: json['platform'] as String,
    station_code: json['station_code'] as String,
    aimed_arrival_time: json['aimed_arrival_time'] as String,
    aimed_departure_time: json['aimed_departure_time'] as String,
    aimed_pass_time: json['aimed_pass_time'] as String,
  );
}

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'station_name': instance.station_name,
      'platform': instance.platform,
      'station_code': instance.station_code,
      'aimed_arrival_time': instance.aimed_arrival_time,
      'aimed_departure_time': instance.aimed_departure_time,
      'aimed_pass_time': instance.aimed_pass_time,
    };
