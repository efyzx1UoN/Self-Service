// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapRoute _$MapRouteFromJson(Map<String, dynamic> json) {
  return MapRoute(
    m_routes: (json['m_routes'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$MapRouteToJson(MapRoute instance) => <String, dynamic>{
      'm_routes': instance.m_routes,
    };
