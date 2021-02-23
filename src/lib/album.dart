class Album {
  final List<String> m_routes;

  Album({this.m_routes, });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      m_routes: json['routes'],
    );
  }

  String get m_title => null;

}