// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapRoute _$MapRouteFromJson(Map<String, dynamic> json) {
  return MapRoute(
    bounds: json['bounds'] == null
        ? null
        : Bound.fromJson(json['bounds'] as Map<String, dynamic>),
    copyrights: json['copyrights'] as String,
    legs: (json['legs'] as List)
        ?.map(
            (e) => e == null ? null : Legs.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MapRouteToJson(MapRoute instance) => <String, dynamic>{
      'bounds': instance.bounds,
      'copyrights': instance.copyrights,
      'legs': instance.legs,
    };

Bound _$BoundFromJson(Map<String, dynamic> json) {
  return Bound(
    northeast: json['northeast'] == null
        ? null
        : NorthEast.fromJson((json['northeast'] as Map<String, dynamic>)?.map(
            (k, e) => MapEntry(k, (e as num)?.toDouble()),
          )),
    southwest: json['southwest'] == null
        ? null
        : SouthWest.fromJson((json['southwest'] as Map<String, dynamic>)?.map(
            (k, e) => MapEntry(k, (e as num)?.toDouble()),
          )),
  );
}

Map<String, dynamic> _$BoundToJson(Bound instance) => <String, dynamic>{
      'northeast': instance.northeast,
      'southwest': instance.southwest,
    };

NorthEast _$NorthEastFromJson(Map<String, dynamic> json) {
  return NorthEast(
    lat: (json['lat'] as num)?.toDouble(),
    long: (json['long'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$NorthEastToJson(NorthEast instance) => <String, dynamic>{
      'lat': instance.lat,
      'long': instance.long,
    };

SouthWest _$SouthWestFromJson(Map<String, dynamic> json) {
  return SouthWest(
    lat: (json['lat'] as num)?.toDouble(),
    long: (json['long'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$SouthWestToJson(SouthWest instance) => <String, dynamic>{
      'lat': instance.lat,
      'long': instance.long,
    };

Legs _$LegsFromJson(Map<String, dynamic> json) {
  return Legs(
    distance: json['distance'] == null
        ? null
        : Distance.fromJson(json['distance'] as Map<String, dynamic>),
    duration: json['duration'] == null
        ? null
        : Duration.fromJson(json['duration'] as Map<String, dynamic>),
    end_address: json['end_address'] as String,
    end_location: json['end_location'] == null
        ? null
        : EndLocation.fromJson(
            (json['end_location'] as Map<String, dynamic>)?.map(
            (k, e) => MapEntry(k, (e as num)?.toDouble()),
          )),
    start_address: json['start_address'] as String,
    start_location: json['start_location'] == null
        ? null
        : StartLocation.fromJson(
            (json['start_location'] as Map<String, dynamic>)?.map(
            (k, e) => MapEntry(k, (e as num)?.toDouble()),
          )),
    steps: (json['steps'] as List)
        ?.map(
            (e) => e == null ? null : Steps.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LegsToJson(Legs instance) => <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'end_address': instance.end_address,
      'end_location': instance.end_location,
      'start_address': instance.start_address,
      'start_location': instance.start_location,
      'steps': instance.steps,
    };

Distance _$DistanceFromJson(Map<String, dynamic> json) {
  return Distance(
    text: json['text'] as String,
    value: json['value'] as int,
  );
}

Map<String, dynamic> _$DistanceToJson(Distance instance) => <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };

Duration _$DurationFromJson(Map<String, dynamic> json) {
  return Duration(
    text: json['text'] as String,
    value: json['value'] as int,
  );
}

Map<String, dynamic> _$DurationToJson(Duration instance) => <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
    };

EndLocation _$EndLocationFromJson(Map<String, dynamic> json) {
  return EndLocation(
    lat: (json['lat'] as num)?.toDouble(),
    long: (json['long'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$EndLocationToJson(EndLocation instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'long': instance.long,
    };

StartLocation _$StartLocationFromJson(Map<String, dynamic> json) {
  return StartLocation(
    lat: (json['lat'] as num)?.toDouble(),
    long: (json['long'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$StartLocationToJson(StartLocation instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'long': instance.long,
    };

Steps _$StepsFromJson(Map<String, dynamic> json) {
  return Steps(
    distance: json['distance'] == null
        ? null
        : Distance.fromJson(json['distance'] as Map<String, dynamic>),
    duration: json['duration'] == null
        ? null
        : Duration.fromJson(json['duration'] as Map<String, dynamic>),
    end_location: json['end_location'] == null
        ? null
        : EndLocation.fromJson(
            (json['end_location'] as Map<String, dynamic>)?.map(
            (k, e) => MapEntry(k, (e as num)?.toDouble()),
          )),
    html_instructions: json['html_instructions'] as String,
    maneuver: json['maneuver'] as String,
    polyline: json['polyline'] == null
        ? null
        : PolyLine.fromJson((json['polyline'] as Map<String, dynamic>)?.map(
            (k, e) => MapEntry(k, e as String),
          )),
    start_location: json['start_location'] == null
        ? null
        : StartLocation.fromJson(
            (json['start_location'] as Map<String, dynamic>)?.map(
            (k, e) => MapEntry(k, (e as num)?.toDouble()),
          )),
    travel_mode: json['travel_mode'] as String,
  );
}

Map<String, dynamic> _$StepsToJson(Steps instance) => <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'end_location': instance.end_location,
      'html_instructions': instance.html_instructions,
      'maneuver': instance.maneuver,
      'polyline': instance.polyline,
      'start_location': instance.start_location,
      'travel_mode': instance.travel_mode,
    };

PolyLine _$PolyLineFromJson(Map<String, dynamic> json) {
  return PolyLine(
    points: json['points'] as String,
  );
}

Map<String, dynamic> _$PolyLineToJson(PolyLine instance) => <String, dynamic>{
      'points': instance.points,
    };
