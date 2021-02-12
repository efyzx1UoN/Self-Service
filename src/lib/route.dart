import 'package:json_annotation/json_annotation.dart';

part 'route.g.dart';

@JsonSerializable(explicitToJson: true)
class MapRoute {
  String route;
  final List<String> m_routes;

  MapRoute({this.m_routes});


  factory MapRoute.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  // Map<String, dynamic> toJson() => _$routeToJson(this);
}